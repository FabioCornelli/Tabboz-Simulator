//
//  AppDelegate.swift
//  Tabboz macOS
//
//  Created by Antonio Malara on 16/08/2020.
//  Copyright © 2020 Antonio Malara. All rights reserved.
//

import Cocoa

func tabboz_random(_ x: Int) -> Int {
    return Int(tabboz_random(Int32(x)))
}


func template_title(template: DLGTEMPLATE) -> String {
    switch template.title.value {
    case .zero:
        return ""
    case .numeric(let x):
        return "NUMERIC WINDOW TITLE \(x)"
    case .string(let s):
        return s
    }
}

let WIN32_FRAME_SCALING = 2

func template_rect(template: DLGTEMPLATE) -> NSRect {
    let X = Int(template.x.value) * WIN32_FRAME_SCALING
    let Y = Int(template.y.value) * WIN32_FRAME_SCALING
    let W = Int(template.width.value) * WIN32_FRAME_SCALING
    let H = Int(template.height.value) * WIN32_FRAME_SCALING
    return NSRect(x: X, y: Y, width: W, height: H)
}

func template_item_title(item: DialogItemTemplate) -> String {
    switch item.title.value {
    case .numeric(let n):
        return "NUMERIC DIALOG TITLE \(n)"
    case .string(let s):
        return s
    }
}

func template_item_rect(dialog: Dialog, item: DialogItemTemplate) -> NSRect {
    let X = Int(item.itemTemplate.x.value) * WIN32_FRAME_SCALING
    let Y = (
        Int(dialog.template.height.value) -
        Int(item.itemTemplate.y.value) -
        Int(item.itemTemplate.height.value) + 1
    ) * 2
    let W = Int(item.itemTemplate.width.value) * WIN32_FRAME_SCALING
    let H = Int(item.itemTemplate.height.value) * WIN32_FRAME_SCALING
    return NSRect(x: X, y: Y, width: W, height: H)
}


func dataToImage(data: Data) throws -> CGImage {
    enum Errors : Error {
        case moreThanOnePlane
        case unsupportedCompression
        case unsupportedBitCount
    }
    
    let header = BITMAPINFOHEADER()
    let reader = Reader(data: data)
    try header.read(reader: reader)
    
    guard header.planes.value == 1 else {
        throw Errors.moreThanOnePlane
    }
    
    guard BITMAPINFOHEADER.Compression(rawValue: header.compression.value) == .BI_RGB else {
        throw Errors.unsupportedCompression
    }
    
    guard header.bitCount.value == 8 else {
        throw Errors.unsupportedBitCount
    }

    let paletteCount = header.clrUsed.value == 0 ? 256 : Int(header.clrUsed.value)
    
    let (w, h)   = (Int(header.width.value), Int(header.height.value))
    let srcWidth = (w & 3) != 0 ? w + 4 - (w & 3) : w
    let palette  = try reader.data(size: 4 * paletteCount)
    let src      = try reader.data(size: srcWidth * h)

    let c = CGContext(
        data: nil,
        width: w,
        height: h,
        bitsPerComponent: 8,
        bytesPerRow: w * 4,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    )!
    
    let dst = UnsafeMutableRawBufferPointer(start: c.data, count: w * h * 4)
    
    for y in 0 ..< h {
        for x in 0 ..< w {
            let off = y * w + x
            let pix = Int(src[(h - y - 1) * srcWidth + x])
            
            dst[off * 4 + 0] = palette[(pix * 4) + 2]
            dst[off * 4 + 1] = palette[(pix * 4) + 1]
            dst[off * 4 + 2] = palette[(pix * 4) + 0]
            dst[off * 4 + 3] = 0
        }
    }
    
    return c.makeImage()!
}

class DialogNSWindow : NSWindow {
    
    typealias WndProc = (HWND?, Int32, Int32, Int32) -> Bool
    
    let wndProc : WndProc
    
    private var tagToView = [Int : NSView]()
    private var viewToTag = [NSView : Int]()

    var handle = HANDLE.allocate(capacity: 1)
    
    init(
        dialog: Dialog,
        wndProc: @escaping WndProc,
        resources: ResourceFile
    ) {
        self.wndProc = wndProc
        
        super.init(
            contentRect: template_rect(template: dialog.template),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        handle.pointee.impl = Unmanaged.passUnretained(self).toOpaque()
        
        title = template_title(template: dialog.template)
        
        for i in dialog.items {
            
            let label = template_item_title(item: i).replacingOccurrences(of: "&", with: "")
            let frame = template_item_rect(dialog: dialog, item: i)
            let tag = Int(Int16(bitPattern: i.itemTemplate.id.value))
            let enabled = !i.itemTemplate.style.value.contains(.WS_DISABLED)
            
            let view : NSView
            
            switch i.windowClass {
            case .standard(let x):
                switch x {
                case .button:
                    if i.itemTemplate.style.value.contains(.BS_GROUPBOX) {
                        let b = NSBox(frame: frame)
                        b.title = i.title.value.asString()
                        view = b
                    }
                    else {
                        let b = NSButton(frame: frame)
                        b.title = label
                        b.target = self
                        b.action = #selector(dialogButtonAction)

                        if i.itemTemplate.style.value.contains(.BS_AUTORADIOBUTTON) {
                            b.setButtonType(.radio)
                        }
                        else if i.itemTemplate.style.value.contains(.BS_CHECKBOX) {
                            b.setButtonType(.switch)
                        }
                        
                        b.isEnabled = enabled
                        view = b
                    }
                    
                case .edit:
                    let e = NSTextField(frame: frame)
                    e.stringValue = label
                    e.isEnabled = enabled
                    view = e
                    
                case .statictext:
                    let l = NSTextField(labelWithString: label)
                    l.lineBreakMode = .byWordWrapping
                    l.frame = frame
                    l.isEnabled = enabled
                    view = l
                    
                case .combobox:
                    let container = NSView(frame: frame)
                    
                    let c = NSPopUpButton(frame: frame)
                    c.isEnabled = enabled
                    c.translatesAutoresizingMaskIntoConstraints = false
                    
                    container.addSubview(c)
                    
                    container.addConstraints([
                        NSLayoutConstraint(item: container,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: c,
                                           attribute: .top,
                                           multiplier: 1,
                                           constant: 0),
                        NSLayoutConstraint(item: container,
                                           attribute: .leading,
                                           relatedBy: .equal,
                                           toItem: c,
                                           attribute: .leading,
                                           multiplier: 1,
                                           constant: 0),
                        NSLayoutConstraint(item: container,
                                           attribute: .trailing,
                                           relatedBy: .equal,
                                           toItem: c,
                                           attribute: .trailing,
                                           multiplier: 1,
                                           constant: 0),
                        NSLayoutConstraint(item: container,
                                           attribute: .bottom,
                                           relatedBy: .greaterThanOrEqual,
                                           toItem: c,
                                           attribute: .bottom,
                                           multiplier: 1,
                                           constant: 0),
                    ])

                    view = container
                    
                case .listbox:
                    fallthrough
                    
                case .scrollbar:
                    print(x)
                    
                    let b = NSBox(frame: frame)
                    b.boxType = .custom
                    b.borderColor = NSColor.yellow
                    view = b
                }
                
            case .custom(let name):
                switch name {
                
                // Borland documentation: http://labs.icb.ufmg.br/lbcd/prodabi5/homepages/hugo/Hugo/TPB/DOC/BWCCAPI.RW
                
                case "BorBtn":
                    let b = NSButton(frame: frame)
                    b.title = label
                    b.target = self
                    b.action = #selector(dialogButtonAction)
                    b.isEnabled = enabled
                    view = b
                    
                    // chapter 3.3 BWCCAPI.RW
                    if let bitmap = resources.bitmaps[.numeric(Int(i.itemTemplate.id.value) + 1000)] {
                        let cgimate = try! dataToImage(data: bitmap)
                        
                        b.image = NSImage(cgImage: cgimate, size: NSSize(width: cgimate.width, height: cgimate.height))
                        b.imageScaling = .scaleProportionallyUpOrDown
                    }

                    break
                    
                case "BorCheck": fallthrough
                case "BorRadio":
                    let b = NSButton(frame: frame)
                    b.title = label
                    b.target = self
                    b.action = #selector(dialogButtonAction)

                    if name == "BorRadio" {
                        b.setButtonType(.radio)
                    }
                    else {
                        b.setButtonType(.switch)
                    }
                    
                    b.isEnabled = enabled
                    view = b

                case "BorStatic":
                    let l = NSTextField(labelWithString: label)
                    l.lineBreakMode = .byWordWrapping
                    l.frame = frame
                    l.isEnabled = enabled
                    view = l

                case "msctls_progress":
                    let x = NSLevelIndicator(frame: frame)
                    x.isEnabled = enabled
                    view = x
                    
                default:
                    print("DIOCANE \(name) \(frame)")
                    let b = NSBox(frame: frame)
                    b.boxType = .custom
                    b.borderColor = NSColor.gray
                    view = b
                }
            }
            
            contentView?.addSubview(view)
            
            if tag != -1 {
                viewToTag[view] = tag
                tagToView[tag] = view
            }
        }
        
        _ = wndProc(handle, WM_INITDIALOG, 0, 0)
    }
    
    @objc func dialogButtonAction(sender: AnyObject) {
        if let tag = viewToTag[sender as! NSView] {
            _ = wndProc(handle, WM_COMMAND, Int32(tag), 0)
        }
    }
    
    @objc func setDlgItemText(dlg: Int, text: String) {
        let view = tagToView[dlg]
        
        if let button = view as? NSButton {
            button.title = text
        }
        else if let textField = view as? NSControl {
            textField.stringValue = text
        }
        else {
            print("\(dlg) not an NSControl -- setting >\(text)<")
        }
    }

}


class ApplicationHandle : NSObject {
    static let url = Bundle.main.url(forResource: "ZARRO32.RES", withExtension: nil)!
    
    var res = try! ResourceFile(url: url)

    var handle = HANDLE.allocate(capacity: 1)
    
    func main() {
        try! res.load()

        handle.pointee.impl = Unmanaged.passUnretained(self).toOpaque()
        WinMain(handle, nil, nil, 0)
    }
    
    func dialogBox(dlg: INTRESOURCE, parentHandle: HANDLE?, farproc: @escaping FARPROC) {
        
        let dialogName : StringOrNumeric.StringOrNumeric
        if dlg.number != -1 {
            dialogName = .numeric(Int(dlg.number))
        }
        else {
            dialogName = .string(String(cString: dlg.n))
        }
        
        let dialog = res.dialogs[dialogName]!
                
        let window = DialogNSWindow(dialog: dialog, wndProc: farproc, resources: res)
        
        NSApplication.shared.runModal(for: window)
    }
    
    @objc static func dialogBox(hInst: HANDLE, dlg: INTRESOURCE, parentHandle: HANDLE?, farproc: @escaping FARPROC) {

        Unmanaged<ApplicationHandle>
            .fromOpaque(hInst.pointee.impl)
            .takeUnretainedValue()
            .dialogBox(
                dlg: dlg,
                parentHandle: parentHandle,
                farproc: farproc
            )
    }
    
    @objc static func endDialog(dlg: HANDLE, result: Bool) {
        Unmanaged<DialogNSWindow>
            .fromOpaque(dlg.pointee.impl)
            .takeUnretainedValue()
            .orderOut(nil)
        
        NSApplication.shared.stopModal(withCode: result ? .OK : .abort)
    }

}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window : NSWindow?

    let applicationHandle = ApplicationHandle()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        applicationHandle.main()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

