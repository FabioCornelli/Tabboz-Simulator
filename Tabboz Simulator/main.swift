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
                if shouldEndDialog.boolValue {
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

struct CalledDialogs {
    let handle : TabbozHANDLE
    let resourceId : INTRESOURCE
    let farproc : FARPROC
}

extension INTRESOURCE {
    var string : String? {
        return n.flatMap { String(cString: $0) }
    }
}

var t = [CalledDialogs]()

var KnownDialogs : [Int : [String : Int]] = [
    1: [
        "vestiti": 131,
        "famiglia": 135,
        "personalinfo": 139,
        "scuola": 136,
        "compagnia": 134,
        "190": 133,
        "palestra": 142,
        "logo": 121,
        "scooter": 130,
        "tabaccaio": 141,
        "cellular": 155,
        "lavoro": 137,
        "about": 120,
        "configuration": 140,
        "disco": 132,
        "spegnimi": 108
    ]
]

class Tabboz : NSObject {
    
    @objc static func dialog(from handle: HANDLE, dialog: INTRESOURCE, callback: FARPROC) {
        if !enableDialogTrace.boolValue {
            print("    handle: \(handle) - dialog: \(dialog.string ?? "no name")")
            
            _ = callback.proc(handle, WM_INITDIALOG, 0, 0)
            
            let dialogs = KnownDialogs[Int(dialog.number)] ?? [:]
            
            prompt(
                availableCommands: dialogs.keys.joined(separator: ", "),
                test: nil
            ) {
                let cmd = dialogs[$0]
                return {
                    if let c = cmd {
                        callback.proc(handle, WM_COMMAND, Int32(c), Int32(0))
                    }
                    return true
                }
            }
        }
            
        else {
            t.append(CalledDialogs(handle: handle.pointee, resourceId: dialog, farproc: callback))
        }
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

/// Tries to recover a list of outgoing dialogs
func CommandsInWindowProc(_ p: (HWND?, WORD, WORD, LONG) -> Bool) -> [(String?, Int32)] {
    var r = [(String?, Int32)]()
    
    enableDialogTrace = true
    log_window = false
    
    for cmd in 0 ..< 500  {
        _ = p(nil, WM_COMMAND, Int32(cmd), 0)
        
        for d in t {
            r.append((d.resourceId.string?.lowercased(), Int32(cmd)))
        }
        
        t.removeAll()
    }
    
    return r
}

/// Creates an array of known dialogs ready to copypaste
func CalledDialogsToKnownDialogs(cmd: [(String?, Int32)]) -> [String:Int32] {
    var x = [String:Int32]()
    for i in cmd {
        if let name = i.0?.lowercased() {
            x[name] = i.1
        }
    }
    
    return x
}
    
var test = false

if !test {
    let handle = HANDLE.allocate(capacity: 1)
    WinMain(handle, nil, nil, 0)
}
else {
    print(CalledDialogsToKnownDialogs(cmd: CommandsInWindowProc(TabbozWndProc)))
}
