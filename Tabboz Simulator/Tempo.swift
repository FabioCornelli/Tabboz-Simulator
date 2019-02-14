//
//  Tempo.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 14/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc enum Mese : Int {
    
    case gennaio   = 1
    case febbraio  = 2
    case marzo     = 3
    case aprile    = 4
    case maggio    = 5
    case giugno    = 6
    case luglio    = 7
    case agosto    = 8
    case settembre = 9
    case ottobre   = 10
    case novembre  = 11
    case dicembre  = 12
    
    var nome: String {
        switch self {
        case .gennaio:   return "Gennaio"
        case .febbraio:  return "Febbraio"
        case .marzo:     return "Marzo"
        case .aprile:    return "Aprile"
        case .maggio:    return "Maggio"
        case .giugno:    return "Giugno"
        case .luglio:    return "Luglio"
        case .agosto:    return "Agosto"
        case .settembre: return "Settembre"
        case .ottobre:   return "Ottobre"
        case .novembre:  return "Novembre"
        case .dicembre:  return "Dicembre"
        }
    }
    
    var giorni: Int {
        switch self {
        case .gennaio:   return 31
        case .febbraio:  return 28
        case .marzo:     return 31
        case .aprile:    return 30
        case .maggio:    return 31
        case .giugno:    return 30
        case .luglio:    return 31
        case .agosto:    return 31
        case .settembre: return 30
        case .ottobre:   return 31
        case .novembre:  return 30
        case .dicembre:  return 31
        }
    }
    
}

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
    @objc private(set) var mese                   = Mese.settembre
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
        
        if (giorno > STMESI.mesi[mese.rawValue - 1].num_giorni) {
            if !(mese == .febbraio && annoBisesto == 1 && giorno == 29) {
                giorno = 1;
                mese = Mese(rawValue: mese.rawValue + 1) ?? .gennaio;
            }
        }
        
        if mese == .gennaio {
            annoBisesto = (annoBisesto + 1) % 4
        }
        
        giornoSettimana = (giornoSettimana + 1) % 7
    }
    
}
