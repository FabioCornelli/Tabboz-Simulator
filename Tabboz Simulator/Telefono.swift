//
//  Telefono.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 14/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

// INFORMAZIONI SUI TELEFONINI  31 Marzo 1999

class STCEL : NSObject {

    @objc var dual:   Int    // Dual Band ?
    @objc var fama:   Int    // figosita'
    @objc var stato:  Int    // quanto e' intero (in percuntuale)
    @objc var prezzo: Int
    @objc var nome:   String // nome del telefono

    init(
        _ dual:   Int,
        _ fama:   Int,
        _ stato:  Int,
        _ prezzo: Int,
        _ nome:   String
    ) {
        self.dual   = dual
        self.fama   = fama
        self.stato  = stato
        self.prezzo = prezzo
        self.nome   = nome
        
        super.init()
    }
    
    @objc static let cellulari = [
        STCEL(0,  2, 100,    290,     "Motorolo d170"),
        STCEL(0,  7, 100,    590,     "Motorolo 8700"),
        STCEL(1, 10, 100,    990,     "Macro TAC 8900"),
    ]
}

/* INFORMAZIONI SULLE COMPAGNIE DEI TELEFONINI */

class STABB : NSObject {

    @objc var abbonamento: Int    // 0 = Ricarica, 1 = Abbonamento
    @objc var dualonly:    Int    // Dual Band Only ?
    @objc var creditorest: Int    // Credito Restante...
    @objc var fama:        Int    // figosita'
    @objc var prezzo:      Int
    @objc var nome:        String // nome del telefono
    
    init(
        _ abbonamento: Int,
        _ dualonly:    Int,
        _ creditorest: Int,
        _ fama:        Int,
        _ prezzo:      Int,
        _ nome:        String
    ) {
        self.abbonamento = abbonamento
        self.dualonly    = dualonly
        self.creditorest = creditorest
        self.fama        = fama
        self.prezzo      = prezzo
        self.nome        = nome
        super.init()
    }
    
    @objc static let abbonamenti = [
        STABB(1,  0,     50, 1,    100,  "Onmitel" ), // Abbonamenti
        STABB(1,  0,     50, 1,    100,  "DIM"     ),
        STABB(1,  1,    100, 1,    100,  "Vind"    ),
        
        STABB(0,  0,     50, 1,     60,  "Onmitel" ), // Ricariche
        STABB(0,  0,    100, 1,    110,  "Onmitel" ),
        
        STABB(0,  0,     50, 1,     60,  "DIM"     ), // Ricariche
        STABB(0,  0,    100, 1,    110,  "DIM"     ),
        
        STABB(0,  1,     50, 1,     50,  "Vind"    ), // Ricariche
        STABB(0,  1,    100, 1,    100,  "Vind"    ),
    ]

}

class AbbonamentoCorrente : NSObject {

    @objc var creditorest: Int    // Credito Restante...
    @objc var fama:        Int    // figosita'
    @objc var nome:        String // nome del telefono
    
    init(
        _ creditorest: Int,
        _ fama:        Int,
        _ nome:        String
    ) {
        self.creditorest = creditorest
        self.fama        = fama
        self.nome        = nome
        super.init()
    }
    
}
