//
//  Eventi.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 18/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc extension Tabboz {
    
    func eventiSigarette(hDlg: HANDLE) {
        guard tabacchi.siga > 0 else {
            return
        }
        
        if tabacchi.siga > 0 {
            switch tabacchi.fuma() {
            case .normale:
                break
                
            case .stanFindendo:
                MessageBox_TiAccorgiCheStaiPerFinireLeSizze(hDlg)
                
            case .finite:
                MessageBox_ApriIlPacchettoDisperatameneteVuoto(hDlg)
                if Reputazione > 10 {
                    Reputazione -= 3
                }
            }
        }
    }
    
    func eventiCellulare(hDlg: HANDLE) {
        if abbonamento.creditorest > 0 && cellulare.attivo {
            abbonamento.addebita(1)
            
            if Fama < 55 {
                Fama += 0
            }
            
            if abbonamento.creditorest == 0 {
                MessageBox_CerchiDiTelefonareMaHaiFinitoISoldi(hDlg)
            }
            else if abbonamento.creditorest < 3 {
                MessageBox_StaiPerFinireLaRicarica(hDlg)
            }
        }
        
        if cellulare.morente {
            cellulare.invalidate()
            MessageBox_IlTuoCellulareSiSpacca(hDlg)
        }
    }
    
    func eventiLavoro(hDlg: HANDLE) {
        if lavoro.impegno_ > 3 {
            if tabboz_random(7) - 3 > 0 {
                lavoro.impegnati()
            }
        }
        
        if lavoro.ditta > 0 {
            if tabboz_random(lavoro.impegno_ * 2 + Int(Fortuna) * 3) < 2 {
                /* perdi il lavoro */
                lavoro.disimpegnati()
                
                if sound_active != 0 {
                    TabbozPlaySound(504)
                }
                
                
            }
        }
    }
    
    func eventiPaghetta(hDlg: HANDLE) {
        /* Il Sabato c'e' la paghetta... */
        
        guard calendario.giornoSettimana == .sabato else {
            return
        }
        
        if scuola.studio >= 45 {
            danaro.deposita(Int(Paghetta))
            
            if scuola.studio >= 80 {
                if sound_active != 0 {
                    TabbozPlaySound(1100)
                }
                
                danaro.deposita(Int(Paghetta))
                MessageBox_DoppiaPaghetta(hDlg)
            }
        }
        else {
            if sound_active != 0 {
                TabbozPlaySound(1200)
            }

            danaro.deposita(Int(Paghetta) / 2)
            MessageBox_MetaPaghetta(hDlg)
        }
    }
}
