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

func template_item_rect(item: DialogItemTemplate) -> NSRect {
    let X = Int(item.itemTemplate.x.value) * 2
    let Y = Int(item.itemTemplate.y.value) * 2
    let W = Int(item.itemTemplate.width.value) * 2
    let H = Int(item.itemTemplate.height.value) * 2
    return NSRect(x: X, y: Y, width: W, height: H)
}

func dialog_to_win(dialog: Dialog) -> NSWindow {
    
    let window = NSWindow(
        contentRect: template_rect(template: dialog.template),
        styleMask: [.titled, .closable],
        backing: .buffered,
        defer: false
    )

    window.title = template_title(template: dialog.template)

    for i in dialog.items {
        
        let label = template_item_title(item: i)
        let frame = template_item_rect(item: i)
        
        let view : NSView
        
        switch i.windowClass {
        case .standard(let x):
            switch x {
            case .button:
                let b = NSButton(frame: frame)
                b.title = label
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
                continue
            }
            
        case .custom(let x):
            print("DIOCANE \(x)")
            continue
        }
        
        window.contentView?.addSubview(view)
    }
    
    return window
}

extension Tabboz {
    
    @objc static func dialog(from handle: HANDLE, dialog: INTRESOURCE, callback: FARPROC) {
        
    }
    
    @objc static func endDialog() {
        shouldEndDialog = true
    }
    
    @objc static func showLogo() {
        print("Tabboz Logo")
        
        // The original window procedure at
        // DialogBox(hInst, MAKEINTRESOURCE(LOGO), NULL, Logo);
        // is showing a splash screen with a timer
    }
    
    @objc static func showFormatTabboz() {
        // DialogBox(hInst, MAKEINTRESOURCE(15), hInst, FormatTabboz);
        
        print("Format Tabboz")
    }

}


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    static let url = Bundle.main.url(forResource: "ZARRO32.RES", withExtension: nil)!
    
    var res = try! ResourceFile(url: url)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        try! res.load()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

