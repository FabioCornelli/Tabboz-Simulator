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
    @objc var scooter = NEWSTSCOOTER(0, 0, 0, 0, 0, 0, 0, 0, "", 0)
    @objc var cellulare = STCEL(0, 0, 0, 0, "")
    @objc var abbonamento = STABB(0, 0, 0, 0, 0, "")
    
    @objc var compleanno       = GiornoDellAnno(giorno: 1, mese: .gennaio)
    @objc var scadenzaPalestra = GiornoDellAnno(giorno: 1, mese: .gennaio)
    
    @objc var compleannoGiorno       : Int32 { return Int32(compleanno.giorno) }
    @objc var compleannoMese         : Mese  { return compleanno.mese          }
    
    @objc var scadenzaPalestraGiorno : Int32 {
        get { return Int32(scadenzaPalestra.giorno)   }
        set { scadenzaPalestra.giorno = Int(newValue) }
    }
    
    @objc var scadenzaPalestraMese   : Mese  {
        get { return scadenzaPalestra.mese     }
        set { scadenzaPalestra.mese = newValue }
    }

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
    
}

func Tabboz_Log(_ s: String) {
    print(s)
}
