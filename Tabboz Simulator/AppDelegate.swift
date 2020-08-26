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


func dataToImage(data: Data, hasMask: Bool = false) throws -> CGImage {
    enum Errors : Error {
        case moreThanOnePlane
        case unsupportedCompression(UInt32)
        case unsupportedBitCount(UInt16)
    }
    
    let header = BITMAPINFOHEADER()
    let reader = Reader(data: data)
    try header.read(reader: reader)
    
    guard header.planes.value == 1 else {
        throw Errors.moreThanOnePlane
    }
    
    guard BITMAPINFOHEADER.Compression(rawValue: header.compression.value) == .BI_RGB else {
        throw Errors.unsupportedCompression(header.compression.value)
    }
    
    guard
        header.bitCount.value == 8 ||
        header.bitCount.value == 4 ||
        header.bitCount.value == 1
    else {
        throw Errors.unsupportedBitCount(header.bitCount.value)
    }
    
    let bitCount = Int(header.bitCount.value)
    let defaultPaletteCount = bitCount == 8 ? 256 : bitCount == 4 ? 16 : 2
    let paletteCount = header.clrUsed.value == 0 ? defaultPaletteCount : Int(header.clrUsed.value)
    
    let (w, h)   = (
        Int(header.width.value),
        hasMask == false ? Int(header.height.value) : Int(header.height.value) / 2
    )
    
    let srcStride  = (w * bitCount + 31) / 32 * 4
    let maskStride = (w  + 31) / 32 * 4
    let palette    = try reader.data(size: 4 * paletteCount)
    let src        = try reader.data(size: srcStride * h)

    let mask = hasMask ? try reader.data(size: maskStride * h) : nil
    
    let c = CGContext(
        data: nil,
        width: w,
        height: h,
        bitsPerComponent: 8,
        bytesPerRow: w * 4,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    
    let dst = UnsafeMutableRawBufferPointer(start: c.data, count: w * h * 4)
    
    for y in 0 ..< h {
        for x in 0 ..< w {
            let srcY = h - y - 1
            let off = y * w + x
            
            let pix : Int
            let maskBit : Bool
            
            if bitCount == 8 {
                pix = Int(src[srcY * srcStride + x])
            }
            else if bitCount == 4 {
                let pixByte = src[srcY * srcStride + (x / 2)]
                pix = (x % 2) == 0 ? Int(pixByte & 0xf0) >> 4 : Int(pixByte & 0x0f)
            }
            else {
                // bitCount == 1
                let pixByte = Int(src[(srcY * srcStride) + (x / 8)])
                pix = (pixByte & (0x80 >> (x % 8))) >> (7 - (x % 8))
            }
            
            if let mask = mask {
                let maskByte = mask[(srcY * maskStride) + (x / 8)]
                maskBit  = (maskByte & (0x80 >> (x % 8))) != 0
            }
            else {
                maskBit = false
            }
            
            dst[off * 4 + 0] = palette[(pix * 4) + 2]
            dst[off * 4 + 1] = palette[(pix * 4) + 1]
            dst[off * 4 + 2] = palette[(pix * 4) + 0]
            dst[off * 4 + 3] = maskBit == false ? 0xff : 0x00
        }
    }
    
    return c.makeImage()!
}

class DialogNSWindow : NSWindow {
    
    typealias WndProc = (HWND?, Int32, Int32, Int32) -> Bool
    
    let applicationHandle : ApplicationHandle
    let wndProc : WndProc
    
    private var tagToView = [Int : NSView]()
    private var viewToTag = [NSView : Int]()

    let handle = HANDLE.allocate(capacity: 1)
    
    init(
        dialog: Dialog,
        wndProc: @escaping WndProc,
        applicationHandle: ApplicationHandle
    ) {
        self.applicationHandle = applicationHandle
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
                    if i.itemTemplate.style.value.contains(.SS_ICON) {
                        let i = NSImageView(frame: frame)
                        let icon = applicationHandle.res.iconData(named: label)!
                        let cgimage = try! dataToImage(data: icon, hasMask: true)
                        
                        i.image = NSImage(cgImage: cgimage, size: NSSize(width: cgimage.width, height: cgimage.height))
                        i.imageScaling = .scaleProportionallyUpOrDown
                        
                        view = i
                    }
                    else {
                        let l = NSTextField(labelWithString: label)
                        l.lineBreakMode = .byWordWrapping
                        l.frame = frame
                        l.isEnabled = enabled
                        view = l
                    }
                    
                    
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
                // IDOK & IDCANCEL icons from the lazarus-ide project
                
                case "BorBtn":
                    let b = NSButton(frame: frame)
                    b.title = label
                    b.target = self
                    b.action = #selector(dialogButtonAction)
                    b.isEnabled = enabled
                    view = b
                    
                    if i.itemTemplate.id.value == IDOK {
                        b.title = "OK"
                        b.image = NSImage(named: "IDOK_Icon")
                        b.imagePosition = .imageLeading
                    }
                    else if i.itemTemplate.id.value == IDCANCEL  {
                        b.title = "Close" // "Cancel" is too big for this ui but "Close" generally fits
                        b.image = NSImage(named: "IDCANCEL_Icon")
                        b.imagePosition = .imageLeading
                    }
                    else if let bitmap = applicationHandle.res.bitmaps[.numeric(Int(i.itemTemplate.id.value) + 1000)] {
                        // chapter 3.3 BWCCAPI.RW
                        
                        let cgimage = try! dataToImage(data: bitmap)
                        
                        b.image = NSImage(cgImage: cgimage, size: NSSize(width: cgimage.width, height: cgimage.height))
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

                case "BorShade":
                    enum ShadeTypes : UInt32 {
                        case  BSS_GROUP  = 0x0001 // recessed group box
                        case  BSS_HDIP   = 0x0002 // horizontal border
                        case  BSS_VDIP   = 0x0003 // vertical border
                        case  BSS_HBUMP  = 0x0004 // horizontal speed bump
                        case  BSS_VBUMP  = 0x0005 // vertical speed bump
                        case  BSS_RGROUP = 0x0006 // raised group box
                    }

                    let type = ShadeTypes(rawValue: i.itemTemplate.style.value.rawValue & 0xf) ?? ShadeTypes.BSS_GROUP
                    
                    let b = NSBox(frame: frame)
                    
                    switch type {
                    case .BSS_GROUP: fallthrough
                    case .BSS_RGROUP:
                        b.boxType = .custom
                        
                    case .BSS_HDIP: fallthrough
                    case .BSS_HBUMP: fallthrough
                    case .BSS_VDIP: fallthrough
                    case .BSS_VBUMP:
                        b.boxType = .separator
                    }
                    
                    b.borderColor = .gray
                    b.cornerRadius = 2
                    view = b

                    
                case "msctls_progress":
                    let x = NSLevelIndicator(frame: frame)
                    x.isEnabled = enabled
                    view = x
                    
                default:
                    if let custom = applicationHandle.customControlClasses[name] {
                        view = CustomControlView(frame: frame, wndclass: custom)
                    }
                    else {
                        print("DIOCANE \(name) \(frame)")
                        let b = NSBox(frame: frame)
                        b.boxType = .custom
                        b.borderColor = NSColor.gray
                        view = b
                    }
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

class CustomControlView : NSView {
    
    let wndclass : WNDCLASS
    
    let handle = HANDLE.allocate(capacity: 1)
    var props = [String : Win32HBITMAP]()
    
    var isPainting = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: NSRect, wndclass: WNDCLASS) {
        self.wndclass = wndclass
        
        super.init(frame: frame)
        
        handle.pointee.impl = Unmanaged.passUnretained(self).toOpaque()

        _ = wndclass.lpfnWndProc(handle, WM_CREATE, 0, 0 /* create struct, unused now? */) 
    }
    
    override var isFlipped : Bool { true }
    
    override func draw(_ dirtyRect: NSRect) {
        let c = NSGraphicsContext.current?.cgContext
        c?.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        c?.fill(dirtyRect)
        
        isPainting = true
        print("> begin paint")
        _ = wndclass.lpfnWndProc(handle, WM_PAINT, 0, 0)
        print("> end paint")
        isPainting = false
    }
    
    @objc func setProp(name: String, bitmap: Win32HBITMAP) {
        props[name] = bitmap
    }

    @objc func getProp(name: String) -> Win32HBITMAP? {
        return props[name]
    }

    @objc func beginPaint() -> Win32HDC? {
        guard isPainting else {
            print("begin paint not in a -draw")
            return nil
        }
        
        let hdc = Win32HDC()
        hdc.cgContext = NSGraphicsContext.current?.cgContext
        return hdc
    }
    
}

class Win32HBITMAP : NSObject {
    var image: CGImage?
}

class Win32HDC : NSObject {
    var cgContext : CGContext?
    var selectedBitmap : Win32HBITMAP?
    
    @objc func selectObject(_ object: Win32HBITMAP) -> Win32HBITMAP? {
        let old = selectedBitmap
        selectedBitmap = object
        return old
    }
    
    @objc func bitBlt(destinationRect: CGRect,
                      srcHDC: Win32HDC?,
                      sourcePoint: CGPoint,
                      flags: Int32)
    {
        guard let context = cgContext else {
            print("don't have a context to blit to")
            return
        }
        
        guard let image = srcHDC?.selectedBitmap?.image else {
            print("can't get the srchdc selected bitmap")
            return
        }
        
        if sourcePoint != .zero {
            print("warning: drawing offset image not supported")
        }
        
        var rect = destinationRect
        rect.size = CGSize(width: image.width, height: image.height)
                
        context.saveGState()
        context.translateBy(x: 0, y: rect.minY + rect.maxY)
        context.scaleBy(x: 1, y: -1)
        context.setAlpha(0.2)
        context.draw(image, in: rect)
        context.restoreGState()
    }
}

extension INTRESOURCE {
    func toStringOrNumeric() -> StringOrNumeric.StringOrNumeric {
        if number != -1 {
            return .numeric(Int(number))
        }
        else {
            return .string(String(cString: n))
        }
    }
}

class ApplicationHandle : NSObject {
    static let url = Bundle.main.url(forResource: "ZARRO32.RES", withExtension: nil)!
    
    var res = try! ResourceFile(url: url)
    var customControlClasses = [String : WNDCLASS]()
    
    var handle = HANDLE.allocate(capacity: 1)
    
    func main() {
        try! res.load()

        handle.pointee.impl = Unmanaged.passUnretained(self).toOpaque()
        WinMain(handle, nil, nil, 0)
    }
    
    @objc func dialogBox(dlg: INTRESOURCE, parentHandle: HANDLE?, farproc: @escaping FARPROC) {
        
        let dialogName = dlg.toStringOrNumeric()
        let dialog = res.dialogs[dialogName]!
        
        let window = DialogNSWindow(dialog: dialog, wndProc: farproc, applicationHandle: self)
        
        NSApplication.shared.runModal(for: window)
    }
        
    @objc static func endDialog(dlg: HANDLE, result: Bool) {
        Unmanaged<DialogNSWindow>
            .fromOpaque(dlg.pointee.impl)
            .takeUnretainedValue()
            .orderOut(nil)
        
        NSApplication.shared.stopModal(withCode: result ? .OK : .abort)
    }
    
    @objc static func messageBox(hInst: HANDLE, message: String, title: String, flags: Int32) -> Int32 {
        let buttonFlags = flags & 0x0f
        let iconFlags = flags & 0xf0

        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        
        if buttonFlags == MB_OK {
            alert.addButton(withTitle: "OK")
        }
        else if buttonFlags == MB_YESNO {
            alert.addButton(withTitle: "Yes")
            alert.addButton(withTitle: "No")
        }

        if
            iconFlags == MB_ICONINFORMATION
        {
            alert.alertStyle = .informational
        }
        else if
            iconFlags == MB_ICONQUESTION ||
            iconFlags == MB_ICONCONFIRMATION
        {
            alert.alertStyle = .warning
        }
        else if
            iconFlags == MB_ICONSTOP ||
            iconFlags == MB_ICONHAND
        {
            alert.alertStyle = .critical
        }

        let response = alert.runModal()
        
        if buttonFlags == MB_OK {
            return IDOK
        }
        else if buttonFlags == MB_YESNO {
            if response == .alertFirstButtonReturn {
                return IDYES
            }
            else if response == .alertSecondButtonReturn {
                return IDNO
            }
            else {
                return IDNO
            }
        }
        else {
            return 0
        }
    }
    
    @objc func registerClass(class aClass: WNDCLASS) {
        let className = String(cString: aClass.lpszClassName)
        customControlClasses[className] = aClass
    }
    
    @objc func loadBitmap(resource: INTRESOURCE) -> HBITMAP {
        let bitmap = res.bitmaps[resource.toStringOrNumeric()]
        let image = bitmap.flatMap { try! dataToImage(data: $0) }
        let hbitmap = Win32HBITMAP()
        hbitmap.image = image
        return hbitmap
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

