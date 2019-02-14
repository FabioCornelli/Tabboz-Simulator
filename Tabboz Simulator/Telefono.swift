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

    let fama:   Int    // figosita'
    private var stato:  Int    // quanto e' intero (in percuntuale)
    
    @objc private(set) var prezzo: Int
    @objc var nome:   String // nome del telefono
    
    @objc var attivo  : Bool { return stato > -1 }
    @objc var morente : Bool { return stato == 1 }
    
    init(
        _ fama:   Int,
        _ prezzo: Int,
        _ nome:   String
    ) {
        self.fama   = fama
        self.stato  = 100
        self.prezzo = prezzo
        self.nome   = nome
        
        super.init()
    }
    
    @objc func invalidate() {
        stato = -1
    }
    
    @objc func danneggia(_ danno: Int) {
        if stato > -1 {
            // A furia di prendere botte, il cellulare si spacca...
            stato -= danno;
            
            // 0 = 'morente', -1 = 'morto'
            if stato < 0 {
              stato = 0
            }
        }
    }
    
    static let cellulari = [
        STCEL( 2, 290, "Motorolo d170"),
        STCEL( 7, 590, "Motorolo 8700"),
        STCEL(10, 990, "Macro TAC 8900"),
    ]
    
    @objc var displayName : String? { return attivo ? nome : nil }
}

/* INFORMAZIONI SULLE COMPAGNIE DEI TELEFONINI */

struct STABB {

    enum Tipo {
        case ricarica
        case abbonamento
    }

    enum Bands {
        case singleBand
        case dualBand
    }
    
    var abbonamento:     Tipo   // 0 = Ricarica, 1 = Abbonamento
    var dualBandOnly:    Bands  // Dual Band Only ?
    var creditoRestante: Int    // Credito Restante...
    var prezzo:          Int
    var nome:            String // nome del telefono
    
    init(
        _ abbonamento: Tipo,
        _ dualonly:    Bands,
        _ creditorest: Int,
        _ prezzo:      Int,
        _ nome:        String
    ) {
        self.abbonamento     = abbonamento
        self.dualBandOnly    = dualonly
        self.creditoRestante = creditorest
        self.prezzo          = prezzo
        self.nome            = nome
    }
    
    static let abbonamenti = [
        STABB(.abbonamento,  .singleBand,  50, 100,  "Onmitel" ), // Abbonamenti
        STABB(.abbonamento,  .singleBand,  50, 100,  "DIM"     ),
        STABB(.abbonamento,  .dualBand,   100, 100,  "Vind"    ),
        
        STABB(.ricarica,     .singleBand,  50,  60,  "Onmitel" ), // Ricariche
        STABB(.ricarica,     .singleBand, 100, 110,  "Onmitel" ),
        
        STABB(.ricarica,     .singleBand,  50,  60,  "DIM"     ), // Ricariche
        STABB(.ricarica,     .singleBand, 100, 110,  "DIM"     ),
        
        STABB(.ricarica,     .dualBand,    50,  50,  "Vind"    ), // Ricariche
        STABB(.ricarica,     .dualBand,   100, 100,  "Vind"    ),
    ]

}

class AbbonamentoCorrente : NSObject {

    @objc private(set) var creditorest: Int    // Credito Restante...
                       var nome:        String // nome del telefono
    
    init(
        _ creditorest: Int,
        _ nome:        String
    ) {
        self.creditorest = creditorest
        self.nome        = nome
        super.init()
    }
    
    func accredita(_ nuovoAbbonamento: STABB) -> Bool {
        switch nuovoAbbonamento.abbonamento {
            
        case .abbonamento:
            // Abbonamento, no problem...
            
            Soldi -= UInt(nuovoAbbonamento.prezzo)
            
            creditorest = nuovoAbbonamento.creditoRestante
            nome        = String(nuovoAbbonamento.nome)
            
            return true
            
        case .ricarica:
            // Ricarica...
            
            if ((creditorest > -1) &&
                (nome == nuovoAbbonamento.nome))
            {
                Soldi -= UInt(nuovoAbbonamento.prezzo)
                creditorest += nuovoAbbonamento.creditoRestante
                
                return true
            }
            else {
                return false
            }
        }
    }
    
    @objc func addebita(_ soldi: Int) {
        creditorest -= soldi
    }
    
    @objc var nomeDisplay : String {
        return creditorest > -1 ? nome : ""
    }
    
    @objc var creditoDisplay : String {
        let credito = String(cString: MostraSoldi(UInt(creditorest)))
        return creditorest > -1 ? credito : ""
        
    }
    
}
