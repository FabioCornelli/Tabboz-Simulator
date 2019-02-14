//
//  Tempo.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 14/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class STMESI : NSObject {
    
    @objc let nome:       String // nome del mese
    @objc let num_giorni: Int32  // giorni del mese
    
    init(_ nome: String, _ num_giorni: Int) {
        self.nome = nome
        self.num_giorni = Int32(num_giorni)
        super.init()
    }
    
    @objc static let mesi = [
        STMESI("Gennaio",   31),
        STMESI("Febbraio",  28),
        STMESI("Marzo",     31),
        STMESI("Aprile",    30),
        STMESI("Maggio",    31),
        STMESI("Giugno",    30),
        STMESI("Luglio",    31),
        STMESI("Agosto",    31),
        STMESI("Settembre", 30),
        STMESI("Ottobre",   31),
        STMESI("Novembre",  30),
        STMESI("Dicembre",  31),
    ]
    
    @objc static let settimane = [
        STMESI("Lunedi'",    0),
        STMESI("Martedi'",   0),
        STMESI("Mercoledi'", 0),
        STMESI("Giovedi'",   0),
        STMESI("Venerdi'",   0),
        STMESI("Sabato",     0),
        STMESI("Domenica",   1),
    ]
    
}


@objc class Calendario : NSObject {
    
    @objc private(set) var giorno                 = Int32(30)
    @objc private(set) var mese                   = Int32(9)
    @objc private(set) var annoBisesto            = Int32(0) // Anno Bisestile - 12 Giugno 1999
    @objc private(set) var giornoSettimana        = Int32(1)
    
    @objc              var vacanza                = Int32(0) // Se e' un giorno di vacanza, e' uguale ad 1 o 2 altrimenti a 0

    @objc              var compleannoGiorno       = Int32(0) // giorno & mese del compleanno
    @objc              var compleannoMese         = Int32(0)
    
    @objc              var scadenzaPalestraGiorno = Int32(0) // Giorno e mese in cui scadra' l' abbonamento alla palestra.
    @objc              var scadenzaPalestraMese   = Int32(0)
    
}

@objc extension Calendario {
    
    func nuovoGiorno() {
        giorno += 1
        
        if (giorno > STMESI.mesi[Int(mese) - 1].num_giorni) {
            if !(mese == 2 && annoBisesto == 1 && giorno == 29) {
                giorno = 1;
                mese += 1;
            }
        }
        
        if mese > 12 {
            mese = 1
            annoBisesto = (annoBisesto + 1) % 4
        }
        
        giornoSettimana = (giornoSettimana + 1) % 7
    }
    
}
