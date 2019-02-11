//
//  main.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 10/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

var shouldEndDialog = false

class Tabboz : NSObject {
    
    
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
        
        print("Available commands: \(commands.keys.joined(separator: ", "))")

        while (true) {
            if let line = readLine() {
                if let command = commands[line] {
                    _ = command()
                    if shouldEndDialog {
                        shouldEndDialog = false
                        break
                    }
                }
                else {
                    print("Di nuovo!")
                    continue
                }
            }
            else {
                break
            }
        }
    }

}

WinMain(nil, nil, nil, 0)


