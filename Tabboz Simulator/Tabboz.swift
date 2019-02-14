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
    @objc private(set) var studio : Int // Quanto vai bene a scuola (1 - 100)
    
    @objc var calendario = Calendario()

    var palestra = Palestra()
    
    @objc var scooter = NEWSTSCOOTER(0, 0, 0, 0, 0, 0, 0, 0, "", 0)
    @objc var cellulare = STCEL(0, 0, 0, 0, "")
    @objc var abbonamento = STABB(0, 0, 0, 0, 0, "")
    
    @objc var compleanno       = GiornoDellAnno(giorno: 1, mese: .gennaio)
    @objc var compleannoGiorno       : Int32 { return Int32(compleanno.giorno) }
    @objc var compleannoMese         : Mese  { return compleanno.mese          }
    
    @objc var documento : Int {
        return (compleanno.giorno * 13) + (compleanno.mese.rawValue * 3) + 6070;
    }
    
    @objc static func initGlobalTabboz() {
        global = Tabboz()
    }
    
    override init() {
        attesa = ATTESAMAX
        studio = 0
        super.init()
    }
}

@objc extension Tabboz {
    func chiediPaghettaExtra(_ hDlg: HANDLE) {
        if (studio >= 40) {
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
    
    func calcolaStudio() {
        var i2 = 0
        
        for materia in STSCOOTER.materie {
            i2 += materia.xxx
        }

        studio = (i2 * 10) / 9
    }
    
    /// Azzera le materie...
    func azzeraMaterie() {
        studio = 0
        
        for materia in STSCOOTER.materie {
            materia.xxx = 0
        }
    }
    
    func resetCalendario() {
        calendario = Calendario()
    }

    func randomCompleanno() {
        let mese = Mese(rawValue: tabboz_random(12) + 1) ?? .gennaio
        compleanno = GiornoDellAnno(giorno: tabboz_random(mese.giorni) + 1, mese: mese)
    }
    
    // -
    
    @objc static func PalestraCostoLampada() -> Int { return 14 }
    @objc static func PalestraCostoAbbonamento(_ a: AbbonamentiPalestra) -> Int { return a.prezzo}
    
    var scadenzaAbbonamentoPalestraString : String {
        return palestra.scadenzaString
    }
    
    var abbonamentoPalestraScadeOggi: Bool {
        if let scadenza = palestra.scadenza {
            return scadenza.giorno == calendario.giornoDellAnno.giorno
                && scadenza.mese   == calendario.giornoDellAnno.mese
        }
        else {
            return false
        }
    }
    
    func controllaScadenzaAbbonamentoPalestra(hInstance: HANDLE) {
        if abbonamentoPalestraScadeOggi {
            palestra.cancellaAbbonamento()
            MessageBox_AppenaScadutoAbbonamentoPalestra(hInstance);
        }
    }
    
    func compraAbbonamento(_ abbonamento: AbbonamentiPalestra, hDlg: HANDLE) {
        if palestra.scadenza != nil {
            MessageBox_HaiGiaUnAbbonamento(hDlg);
            return
        }
        
        if (abbonamento.prezzo > Soldi) {
            nomoney(hDlg, Int32(PALESTRA))
            return
        }
        else {
            Soldi -= UInt(abbonamento.prezzo)
        }

        palestra.abbonati(a: abbonamento, aPartireDa: calendario.giornoDellAnno)
        
        Evento(hDlg);
    }

    func vaiInPalestra(_ hDlg: HANDLE) {
        if palestra.scadenza == nil {
            MessageBox_PrimaDiVenireInPalestraFaiUnAbbonamento(hDlg);
        } else {
            if sound_active != 0 {
                TabbozPlaySound(201)
            }
            
            if Fama < 82 {
                Fama += 1
            }
            
            EventiPalestra(hDlg)
            AggiornaPalestra(hDlg)
        }
    }
    
    func faiLaLampada(_ hDlg: HANDLE) {
        if Tabboz.PalestraCostoLampada() > Soldi {
            nomoney(hDlg, Int32(PALESTRA))
        }
        else {
            if (current_testa < 3) {
                // Grado di abbronzatura
                current_testa += 1
                if Fama < 20 { Fama += 1 }    // Da 0 a 3 punti in piu' di fama
                if Fama < 45 { Fama += 1 }    // ( secondo quanta se ne ha gia')
                if Fama < 96 { Fama += 1 }
            }
            else {
                // Carbonizzato...
                current_testa = 4;
                if Fama > 8        { Fama -= 8 }
                if Reputazione > 5 { Reputazione -= 5 }
                
                MessageBox_EccessivaEsposizioneAiRaggiUltravioletti(hDlg)
            }
            
            TabbozRedraw = 1;    // E' necessario ridisegnare l' immagine del Tabbozzo...
            
            if sound_active != 0 { TabbozPlaySound(202) }
            Soldi -= UInt(Tabboz.PalestraCostoLampada())
        }
        
        if tabboz_random(5 + Fortuna) == 0 { Evento(hDlg) }
        AggiornaPalestra(hDlg)
    }
    
}

func Tabboz_Log(_ s: String) {
    print(s)
}
