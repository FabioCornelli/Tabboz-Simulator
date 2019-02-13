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

var KnownDialogs : [Int : [String : Int]] =
    [101: ["vendiscooter": 103,
           "wparam - 101 + 78": 102],
     140: ["15": 203],
     110: ["95": 101],
     133: ["cercatipa + spostamento": 110],
     131: ["tabaccaio": 110,
           "cmd_101": 101,
           "cmd_102": 102,
           "cellular": 112,
           "cmd_103": 103,
           "cmd_104": 104,
           "palestra": 111,
           "cmd_105": 105],
     130: ["acquistascooter": 101,
           "riparascooter": 103],
     137: ["210": 114],
     114: ["wparam+190": 109],
     112: ["compracellular": 110,
           "cellulrabbonam": 112],
     001: ["cmd_146": 146,
           "personalinfo": 139,
           "cmd_144": 144,
           "cellular": 155,
           "tabaccaio": 141,
           "vestiti": 131,
           "disco": 132,
           "cmd_145": 145,
           "palestra": 142,
           "logo": 121,
           "compagnia": 134,
           "scooter": 130,
           "190": 133,
           "spegnimi": 108,
           "cmd_143": 143,
           "cmd_147": 147,
           "configuration": 140,
           "about": 120,
           "lavoro": 137,
           "famiglia": 135,
           "scuola": 136]]

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
                let cmd = dialogs[$0] ?? (
                    ($0 == "ok"     ) ? Int(IDOK    ) :
                    ($0 == "annulla") ? Int(IDCANCEL) :
                    nil
                );
                
                return {
                    if let c = cmd {
                        _ = callback.proc(handle, WM_COMMAND, Int32(c), Int32(0))
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
func CommandsInWindowProc(_ p: (HWND?, WORD, WORD, LONG) -> Bool) -> [(String?, Int32, FARPROC)] {
    var r = [(String?, Int32, FARPROC)]()
    
    enableDialogTrace = true
    log_window = false
    
    for cmd in 0 ..< 500  {
        _ = p(nil, WM_COMMAND, Int32(cmd), 0)
        
        for d in t {
            r.append((d.resourceId.string?.lowercased(), Int32(cmd), d.farproc))
        }
        
        t.removeAll()
    }
    
    return r
}

func RecursiveCalledDialogsToKnownDialogs() {
    
    var things = [Int32 : [String : Int32]]()
    
    func inner(dialog: Int32, proc: (HWND?, WORD, WORD, LONG) -> Bool) {
        
        let cmd = CommandsInWindowProc(proc)
        var x = [String:Int32]()
        
        for (name, command, proc) in cmd {
            x[name ?? "cmd_\(command)"] = command
            inner(dialog: command) { (a, b, c, d) -> Bool in
                proc.proc(a, b, c, d).boolValue
            }
        }
        
        if !x.isEmpty {
            things[dialog] = x
        }
    }
    
    inner(dialog: Int32(1), proc: TabbozWndProc)
    
    print(things)
}

/// Creates an array of known dialogs ready to copypaste
func CalledDialogsToKnownDialogs(cmd: [(String?, Int32, FARPROC)]) -> [String:Int32] {
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
    RecursiveCalledDialogsToKnownDialogs()
}
