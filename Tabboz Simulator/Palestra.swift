//
//  Palestra.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 14/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc enum AbbonamentiPalestra : Int {
    
    case unMese  = 0
    case seiMesi = 1
    case unAnno  = 2
    
    var prezzo : Int {
        switch self {
        case .unMese:  return 50
        case .seiMesi: return 270
        case .unAnno:  return 500
        }
    }
    
    func scadenza(da inizio: GiornoDellAnno) -> GiornoDellAnno {
        switch self {
        case .unMese:  return inizio.fraUnMese()
        case .seiMesi: return inizio.fraSeiMesi()
        case .unAnno:  return inizio.fraUnAnno()
        }
    }
    
}

struct Palestra {
    
    private(set) var scadenza : GiornoDellAnno?
    
    var scadenzaString : String {
        return (scadenza.map { "Scadenza abbonamento \($0)" })
            ?? "Nessun Abbonamento"
    }
    
    mutating func abbonati(a abbonamento: AbbonamentiPalestra, aPartireDa giornoDellAbbonamento: GiornoDellAnno) {
        scadenza = abbonamento.scadenza(da: giornoDellAbbonamento)
    }
    
    mutating func cancellaAbbonamento() {
        scadenza = nil
    }
    
}
