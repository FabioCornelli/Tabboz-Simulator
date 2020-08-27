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
            
            switch i.windowClass.value {
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
                        
                        do {
                            let cgimage = try dataToImage(data: icon, hasMask: true)
                            i.image = NSImage(cgImage: cgimage, size: NSSize(width: cgimage.width, height: cgimage.height))
                        }
                        catch {
                            print("cannot parse image because \(error)")
                        }
                        
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
                        
                        do {
                            let cgimage = try dataToImage(data: bitmap)
                        
                            b.image = NSImage(cgImage: cgimage, size: NSSize(width: cgimage.width, height: cgimage.height))
                            b.imageScaling = .scaleProportionallyUpOrDown
                        }
                        catch {
                            print("cannot open image because \(error)")
                        }
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
        isPainting = true
        _ = wndclass.lpfnWndProc(handle, WM_PAINT, 0, 0)
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
    
    @objc func getObject() -> BITMAP {
        if let image = image {
            return BITMAP(bmWidth: Int32(image.width),
                          bmHeight: Int32(image.height))
        }
        else {
            print("no bitmap!")
            return BITMAP(bmWidth: 0, bmHeight: 0)
        }
    }
}

class Win32HDC : NSObject {
    var cgContext : CGContext?
    var selectedBitmap : Win32HBITMAP?
    var bkColor : COLORREF?
    
    @objc func selectObject(_ object: Win32HBITMAP) -> Win32HBITMAP? {
        let old = selectedBitmap
        selectedBitmap = object
        return old
    }
    
    func normalBitBlt(context: CGContext,
                      destinationRect: CGRect,
                      srcHDC: Win32HDC?,
                      sourcePoint: CGPoint,
                      flags: Int32)
    {
        guard let image = srcHDC?.selectedBitmap?.image else {
            print("can't get the srchdc selected bitmap")
            return
        }
        
        var rect = destinationRect
        rect.size = CGSize(width: image.width, height: image.height)
                
        context.saveGState()
        context.translateBy(x: 0, y: rect.minY + rect.maxY)
        context.scaleBy(x: 1, y: -1)
        context.draw(image, in: rect)
        context.restoreGState()
    }

    
    @objc func bitBlt(destinationRect: CGRect,
                      srcHDC: Win32HDC?,
                      sourcePoint: CGPoint,
                      flags: Int32)
    {
        if sourcePoint != .zero {
            print("warning: drawing offset image not supported")
        }
        
        if let context = cgContext {
            // self is an HDC created to draw on an NSView
            normalBitBlt(context: context,
                         destinationRect: destinationRect,
                         srcHDC: srcHDC,
                         sourcePoint: sourcePoint,
                         flags: flags)
        }
        else if let bkColor = srcHDC?.bkColor {
            // app is trying to create a mask for the bitmap,
            // bkcolor is the transparency
            
            let (r, g, b) = bkColor.toRGB()
            
            guard let image = srcHDC?.selectedBitmap?.image else {
                print("can't get image to mask")
                return
            }

            let masked = image.copy(maskingColorComponents: [r - 1, r, g - 1, g, b - 1, b])
            
            // overwrite the original bitmap with the masked one and hope
            srcHDC?.selectedBitmap?.image = masked
        }
    }
    
    @objc func setBkColor(_ color: COLORREF) -> COLORREF {
        let old = bkColor ?? 0
        bkColor = color
        return old
    }
}

extension COLORREF {
    func toRGB() -> (CGFloat, CGFloat, CGFloat) {
        return (
            CGFloat((self & 0xff000000) >> 24),
            CGFloat((self & 0x00ff0000) >> 16),
            CGFloat((self & 0x0000ff00) >>  8)
        )
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
    
    var res = ResourceFile()
    var customControlClasses = [String : WNDCLASS]()
    
    var handle = HANDLE.allocate(capacity: 1)
    
    func main() {
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
    
    @objc func loadString(stringId: Int) -> String {
        return res.strings[stringId] ?? ""
    }
    
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window : NSWindow?

    let applicationHandle = ApplicationHandle()
    
    static let zarroResources = Bundle.main.url(forResource: "ZARRO32.RES", withExtension: nil)!
    static let textReources   = Bundle.main.url(forResource: "TEXT.RES"   , withExtension: nil)!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        try! applicationHandle.res.load(url: Self.zarroResources)
        try! applicationHandle.res.load(url: Self.textReources)
        applicationHandle.main()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

