//
//  Eventi.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 18/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc extension Tabboz {
    
    func Evento(_ hDlg: HANDLE) {
        didLog = ObjCBool(true)
        
        Giorno(hDlg)
        
        [
            eventiPestaggio,
            eventiSigarette,
            eventiCellulare,
            eventiTipa,
            eventiLavoro,
            eventiPaghetta,
        ]
            .forEach {
                $0(hDlg)
            }
        
        let caso = tabboz_random(100 + fortuna * 2)
        
        [
            ( 1...10): eventiCasualiMetalloniEManovali,
            (11...20): eventiCasualiScooter,
            (21...30): eventiCasualiFigosita,
            (31...40): eventiCasualiScuola,
            (41...42): eventiCasualiTipaCiProva,
            (43...44): eventiCasualiDomandeInutili,
            (50...50): eventiCasualiTelefonino,
        ]
            .first(where: { (range, _) in range.contains(caso) })?
            .value(caso, hDlg)
        
    }
    
    func eventiPestaggio(hDlg: HANDLE) {
        if Tempo_trascorso_dal_pestaggio > 0 {
            Tempo_trascorso_dal_pestaggio -= 1
        }
    }
    
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
                reputazione.decrementa(di: 3, seMaggioreDi: 10)
            }
        }
    }
    
    func eventiCellulare(hDlg: HANDLE) {
        if abbonamento.creditorest > 0 && cellulare.attivo {
            abbonamento.addebita(1)
            
            fama.incrementa(di: 1, seMinoreDi: 55)
            
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
    
    func eventiTipa(hDlg: HANDLE) {
        if (tabboz_random(5) - 3) > 0 {
            tipa.rapporto.decrementa(di: 1, seMaggioreDi: 3)
        }
        
        if tipa.rapporto > 0 && tipa.rapporto < 98 {
            let i = tabboz_random(tipa.rapporto + fortuna + fama) + 1
            if i < 11 {
                /* da 1 a 10, la donna ti molla... */
                if sound_active != 0 {
                    TabbozPlaySound(603)
                }
                
                MessageBox_LaTipaTiMolla(hDlg, Int32(i))
                reputazione.decrementa(di: 11 - i)
            }
        }
    }
    
    func eventiLavoro(hDlg: HANDLE) {
        if lavoro.impegno > 3 {
            if tabboz_random(7) - 3 > 0 {
                lavoro.impegno.incrementa(di: 1)
            }
        }
        
        if lavoro.ditta > 0 {
            if tabboz_random(lavoro.impegno * 2 + fortuna * 3) < 2 {
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
    
    func eventiCasualiMetalloniEManovali(caso: Int, hDlg: HANDLE) {
        guard sesso != Int8("F") else {
            // Se sei una tipa non vieni pestata...
            return
        }
        
        reputazione.decrementa(di: caso)
        
        let i = 100 + tabboz_random(100)
        
        MetalloEMagutto(i, hDlg: hDlg)
        Tempo_trascorso_dal_pestaggio = 5
    }
 
    func eventiCasualiScooter(caso: Int, hDlg: HANDLE) {
        if (scooter.stato != -1) && (scooter.attivita == .funzionante) {
            cellulare.danneggia(tabboz_random(8));
            
            if caso < 17 {
                scooter.danneggia(tabboz_random(35));

                MetalloEMagutto(106, hDlg: hDlg)
            } else {
                MetalloEMagutto(107, hDlg: hDlg)
            }

            reputazione.decrementa(di: 2)

            if scooter.stato <= 0 {
                MessageBox_ScooterRidottoAdUnAmmassoDiRottami(hDlg)
            }
        }
    }
    
    func eventiCasualiFigosita(caso: Int, hDlg: HANDLE) {
        switch caso {
            
        case 21:                         fallthrough  // + gravi
        case 22:                         fallthrough  //  |
        case 23: fama.decrementa(di: 5); fallthrough  //  |
        case 24:                         fallthrough  //  |
        case 25: fama.decrementa(di: 5); fallthrough  //  |
        case 26:                         fallthrough  //  |
        case 27: fama.decrementa(di: 5); fallthrough  //  |
        case 28:                         fallthrough  // \|/
        case 29:                         fallthrough  // - gravi
        case 30:
            MessageBox_SeiFortunato(hDlg, Int32(caso))
            
        default:
            return
        }
    }
    
    func eventiCasualiScuola(caso: Int, hDlg: HANDLE) {
        // Durante i giorni di vacanza non ci sono eventi riguardanti la scuola
        
        guard calendario.vacanza != 0 else {
            return
        }
        
        let i = tabboz_random(9) + 1; // Fino alla versione 0.5 c'era scritto 10 ed era un bug...
        
        MessageBox_Scuola(hDlg, Int32(caso), scuola.materie[i].nome)
        
        if scuola.materie[i].xxx >= 2 {
            scuola.materie[i].xxx -= 2
        }
        
        ScuolaRedraw = 1 /* E' necessario ridisegnare la finestra della scuola... */
    }
    
    func eventiCasualiTipaCiProva(caso: Int, hDlg: HANDLE) {
        // Una tipa/o ci prova... 7 Maggio 1999
        
        guard fama >= 35 else {
            // Figosita' < 35 = nessuna speranza...
            return
        }
        
        figTemp = Int32(tabboz_random(fama - 30) + 30) // Figosita' minima tipa = 30...
        if MessageBox_QualcunoTiCaga(hDlg, tabboz_random(20), figTemp) == IDNO {
            
            // Se non hai gia' una tipa e rifiuti una figona...
            if figTemp >= 79 && tipa.rapporto < 1 && sesso == Int8("M") {
                MessageBox_RifiutiUnaFigona(hDlg)
                reputazione.decrementa(di: 4)
                return
            }
            
            // Controlla che tu non abbia gia' una tipa -------------------------
            if tipa.rapporto > 0 {
                // hai gia' una tipa..<<<<<<<<<<<<<<<<<<<<<<<<<<<
                LeDueDonne(hDlg: hDlg)
            }
            else {
                // bravo, no hai una tipa...<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                
                tipa.nuovaTipa(
                    nome:     String(utf8String: figNomTemp)!,
                    figosita: Int(figTemp),
                    rapporto: 45 + tabboz_random(15)
                )
                
                fama       .incrementa(di: tipa.figTipa / 10)
                reputazione.incrementa(di: tipa.figTipa / 13)
            }
        }
    }
    
    func eventiCasualiDomandeInutili(caso: Int, hDlg: HANDLE) {
        // Domande inutili... 11 Giugno 1999
        
        guard tipa.rapporto > 0 && sesso == Int8("M") else {
            return
        }
        
        if caso == 43 {
            if MessageBox_MiAmi(hDlg) != IDYES {
                MessageBox_SeiIlSolitoStronzo(hDlg)
                tipa.rapporto.decrementa(di: 45, minimo: 5)
            }
        }
        else {
            if MessageBox_MaSonoIngrassata(hDlg) != IDNO {
                MessageBox_SeiUnBastardo(hDlg)
                tipa.rapporto.decrementa(di: 20, minimo: 5)
            }
        }
    }
    
    func eventiCasualiTelefonino(caso: Int, hDlg: HANDLE) {
        guard cellulare.attivo else {
            return
        }
        
        cellulare.danneggia(tabboz_random(8))
        MessageBox_IlTelefoninoCadeDiTasca(hDlg)
    }
}
