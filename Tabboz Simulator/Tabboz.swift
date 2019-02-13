//
//  Tabboz.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Tabboz : NSObject {
    
    @objc static private(set) var global = Tabboz()
    
    @objc private(set) var attesa : Int // Tempo prima che ti diano altri soldi...
    
    @objc static func initGlobalTabboz() {
        global = Tabboz()
    }
    
    override init() {
        attesa = ATTESAMAX
        super.init()
    }

    @objc func chiediPaghettaExtra(_ hDlg: HANDLE) {
        if (Studio >= 40) {
            if attesa == 0 {
                attesa = ATTESAMAX
                Soldi += 10

                Tabboz_Log("famiglia: paghetta extra (\(String(cString: MostraSoldi(10))))")
                Evento(hDlg)
            }
            else {
                MessageBox_NonPuoiContinuamenteChiedereSoldi(hDlg)
                Evento(hDlg)
            }
        }
        else {
            MessageBox_QuandoAndraiMeglioAScuolaPotrai(hDlg)
        }

        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi))
    }
}

func Tabboz_Log(_ s: String) {
    print(s)
}
