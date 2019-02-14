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
