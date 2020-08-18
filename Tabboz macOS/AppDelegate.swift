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

func template_rect(template: DLGTEMPLATE) -> NSRect {
    let X = Int(template.x.value) * 2
    let Y = Int(template.y.value) * 2
    let W = Int(template.width.value) * 2
    let H = Int(template.height.value) * 2
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
    let X = Int(item.itemTemplate.x.value) * 2
    let Y = Int(
        dialog.template.height.value -
        item.itemTemplate.y.value -
        item.itemTemplate.height.value + 1
    ) * 2
    let W = Int(item.itemTemplate.width.value) * 2
    let H = Int(item.itemTemplate.height.value) * 2
    return NSRect(x: X, y: Y, width: W, height: H)
}

class DialogNSWindow : NSWindow {
    
    typealias WndProc = (HWND?, Int32, Int32, Int32) -> Bool
    
    let wndProc : WndProc
    
    private var tagToView = [Int : NSView]()
    private var viewToTag = [NSView : Int]()

    var handle = HANDLE.allocate(capacity: 1)
    
    init(
        dialog: Dialog,
        wndProc: @escaping WndProc
    ) {
        self.wndProc = wndProc
        
        super.init(
            contentRect: template_rect(template: dialog.template),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        handle.pointee.impl = Unmanaged.passUnretained(self).toOpaque()
        
        title = template_title(template: dialog.template)
        
        for i in dialog.items {
            
            let label = template_item_title(item: i)
            let frame = template_item_rect(dialog: dialog, item: i)
            let tag = Int(Int16(bitPattern: i.itemTemplate.id.value))
            
            let view : NSView
            
            switch i.windowClass {
            case .standard(let x):
                switch x {
                case .button:
                    let b = NSButton(frame: frame)
                    b.title = label
                    b.target = self
                    b.action = #selector(dialogButtonAction)
                    view = b
                    
                case .edit:
                    let e = NSTextField(frame: frame)
                    e.stringValue = label
                    view = e
                    print("\(label) is edit!!")
                    
                case .statictext:
                    let l = NSTextField(labelWithString: label)
                    l.frame = frame
                    view = l
                    
                case .listbox:
                    fallthrough
                    
                case .scrollbar:
                    fallthrough
                    
                case .combobox:
                    print(x)
                    
                    let b = NSBox(frame: frame)
                    b.boxType = .custom
                    b.borderColor = NSColor.yellow
                    view = b
                }
                
            case .custom(let name):
                switch name {
                case "BorBtn":
                    let b = NSButton(frame: frame)
                    b.title = label
                    b.target = self
                    b.action = #selector(dialogButtonAction)
                    view = b
                    break
                    
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
                
        let window = DialogNSWindow(dialog: dialog, wndProc: farproc)
        
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

