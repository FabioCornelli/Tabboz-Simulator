//
//  main.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 10/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

func prompt(
    availableCommands: String,
    test: String?,
    commands: (String)->((()->Bool)?)
) {
    while (true) {
        print("Available commands: \(availableCommands)")
        print("> ", terminator: "")

        if let line = test ?? readLine() {
            if let command = commands(line) {
                _ = command()
                if shouldEndDialog {
                    shouldEndDialog = false
                    break
                }
                if test != nil {
                    return
                }
            }
            else {
                if test != nil {
                    print("Default not in commands")
                    return
                }
                print("Di nuovo!")
                continue
            }
        }
        else {
            break
        }
    }
}

var shouldEndDialog = false

class Tabboz : NSObject {
    
    @objc static func dialog(from handle: HANDLE, dialog: Int32, callback: DialogProc) {
        print("dialog")
        _ = callback(handle, WM_INITDIALOG, 0, 0)
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
        FormatTabboz(nil, WM_INITDIALOG, 0, 0)
        
        let commands = [
            "maschio" : { FormatTabboz(nil, WM_COMMAND, 100,      0) },
            "femmina" : { FormatTabboz(nil, WM_COMMAND, 101,      0) },
            "random"  : { FormatTabboz(nil, WM_COMMAND, 102,      0) },
            "ok"      : { FormatTabboz(nil, WM_COMMAND, IDOK,     0) },
            "annulla" : { FormatTabboz(nil, WM_COMMAND, IDCANCEL, 0) },
        ]
        
        prompt(
            availableCommands: commands.keys.joined(separator: ", "),
            test: "ok"
        ) {
            commands[$0]
        }
    }

}

WinMain(nil, nil, nil, 0)


