//
//  Scooter.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

// NUOVE INFORMAZIONI SUGLI SCOOTER - 28 Aprile 1998

class NEWSTSCOOTER : NSObject {
    
    @objc enum Marmitta : Int {
        case standard     = 0
        case silenziosa   = 1
        case rumorosa     = 2
        case rumorosisima = 3
    }
    
    @objc enum Carburatore : Int {
        case _12_10 = 0
        case _16_16 = 1
        case _19_19 = 2
        case _20_20 = 3
        case _24_24 = 4
        case custom = 5
    }
    
    @objc enum Cilindrata : Int {
        case _50cc   = 0
        case _70cc   = 1
        case _90cc   = 2
        case _120cc  = 3
        case _150cc  = 4
        case _3969cc = 5
    }
    
    @objc enum Filtro : Int {
        case standard  = 0
        case P1        = 1
        case P2        = 2
        case P2Plus    = 3
        case extreme   = 4
    }

    @objc var speed:       Int         // 01  Velocita'
    @objc var marmitta:    Marmitta    // 02  Marmitta            ( +0, +7, +12, +15)
    @objc var carburatore: Carburatore // 03  Carburatore         ( 0 - 4 )
    @objc var cc:          Cilindrata  // 04  Cilindrata          ( 0 - 4 )
    @objc var filtro:      Filtro      // 05  Filtro dell' aria   ( +0, +5, +10, +15)
    @objc var prezzo:      Int         // 06  Costo dello scooter (modifiche incluse)
    @objc var nome:        String      // 09  Nome dello scooter
    @objc var fama:        Int         // 10  Figosita' scooter
    
    init(
        _ speed:       Int,
        _ marmitta:    Marmitta,
        _ carburatore: Carburatore,
        _ cc:          Cilindrata,
        _ filtro:      Filtro,
        _ prezzo:      Int,
        _ nome:        String,
        _ fama:        Int
    ) {
        self.speed       = speed
        self.marmitta    = marmitta
        self.carburatore = carburatore
        self.cc          = cc
        self.filtro      = filtro
        self.prezzo      = prezzo
        self.nome        = nome
        self.fama        = fama
        
        super.init()
    }
    
    /// Calcola la velocita' massima dello scooter, sencodo il tipo di marmitta,
    /// carburatore, etc...
    @objc var speedCalcolata : Int {
        let tabella = [
               65,     70,   -100,   -100,   -100,   -100,
               70,     80,     95,   -100,   -100,   -100,
            -1000,     90,    100,    115,   -100,   -100,
            -1000,  -1000,    110,    125,    135,   -100,
            -1000,  -1000,  -1000,    130,    150,   -100,
            -1000,  -1000,  -1000,  -1000,  -1000,    250,
        ]
        
        /* 28 Novembre 1998 0.81pr Bug ! Se lo scooter era ingrippato, cambiando il filtro
         dell' aria o la marmitta la velocita' diventava un numero negativo... */
        
        return  (marmitta.rawValue * 5) +
                (filtro.rawValue * 5) +
                tabella[cc.rawValue +
                        (carburatore.rawValue * 6)];
    }
    
}

@objc class Motorino : NSObject {
    
    @objc enum Attivita : Int {
        case mancante     = 0
        case funzionante  = 1
        case ingrippato   = 2
        case invasato     = 3
        case parcheggiato = 4
        case sequestrato  = 5
        case aSecco       = 6
    }
    
    var benzina = 0
    
    @objc private(set) var prezzo = 0
    @objc private(set) var attivita = Attivita.mancante
    @objc private(set) var stato = -1
    @objc private(set) var nome = ""
    
    @objc var scooter = NEWSTSCOOTER.scooter[0]
    
    @objc var speedString : String {
        switch attivita {
        case .mancante:    return ""
        case .funzionante: return "\(scooter.speedCalcolata)Km/h"
        default:           return "\(attivita.string)"
        }
    }
    
    @objc var benzinaString : String {
        return String(format: "%1.1f", Double(benzina) / 10.0)
    }
        
    var attivitaCalcolataEx : Attivita? {
        var attivita = Attivita.funzionante
        
        if scooter.speedCalcolata <= -500  {
            attivita = .invasato
        }
        else if scooter.speedCalcolata <= -1 {
            attivita = .ingrippato
        }
        
        if benzina < 1 {
            attivita = .aSecco
        }
        
        return attivita
    }
    
    @objc var attivitaCalcolata : Attivita {
        return attivitaCalcolataEx ?? .funzionante
    }
    
    var costoRiparazioni : Int {
        return prezzo / 100 * (100 - stato) + 10
    }
    
    @objc func compraScooter(_ scooterId: Int) {
        scooter = NEWSTSCOOTER.scooter[scooterId]
    }
    
    @objc func ripara() {
        stato = 100
    }
    
    @objc func danneggia(_ danno: Int) {
        stato -= danno
    }
    
    @objc func distruggi() {
        stato = -1
        attivita = .mancante
        
        scooter = NEWSTSCOOTER.scooter[0] /* nessuno scooter                     */
        benzina = 0                       /* serbatoio vuoto    7 Maggio 1998    */
    }
    
    @objc func consuma(benza: Int) {
        benzina -= benza
        
        if benzina < 1 {
            benzina = 0
        }
    }
    
    @objc func faiIlPieno() {
        benzina = scooter.cc != ._3969cc
            ? 50    /* 5 litri,  il massimo che puo' contenere... */
            : 850   /* 85 litri, x la macchinina un po' figa...   */
    }
    
    @objc func usaOParcheggia() -> Bool {
        switch attivitaCalcolataEx ?? attivita {
        case .funzionante:
            attivita = .parcheggiato
            return true
        case .parcheggiato:
            attivita = .funzionante
            return true
        default:
            return false
        }
    }
    
    @objc func regalaMacchinina() {
        scooter = NEWSTSCOOTER.scooter[7]
        benzina = 850
    }
    
}

extension Motorino.Attivita {
    
    var string : String {
        switch self {
        case .mancante:     return "mancante"
        case .funzionante:  return "funzionante"
        case .ingrippato:   return "ingrippato"
        case .invasato:     return "invasato"
        case .parcheggiato: return "parcheggiato"
        case .sequestrato:  return "sequestrato"
        case .aSecco:       return "a secco"
        }
    }
    
}

extension NEWSTSCOOTER.Marmitta {
    
    var string : String {
        switch self {
        case .standard:     return "standard"
        case .silenziosa:   return "silenziosa"
        case .rumorosa:     return "rumorosa"
        case .rumorosisima: return "rumorosisima"
        }
    }
    
}

extension NEWSTSCOOTER.Carburatore {
    
    var string : String {
        switch self {
        case ._12_10: return "12/10"
        case ._16_16: return "16/16"
        case ._19_19: return "19/19"
        case ._20_20: return "20/20"
        case ._24_24: return "24/24"
        case .custom: return "custom"
        }
    }
    
}

extension NEWSTSCOOTER.Cilindrata {
    
    var string : String {
        switch self {
        case ._50cc:   return "50cc"
        case ._70cc:   return "70cc"
        case ._90cc:   return "90cc"
        case ._120cc:  return "120cc"
        case ._150cc:  return "150cc"
        case ._3969cc: return "3969cc"
        }
    }
    
}

extension NEWSTSCOOTER.Filtro {
    
    var string : String {
        switch self {
        case .standard:  return "standard"
        case .P1:        return "P1"
        case .P2:        return "P2"
        case .P2Plus:    return "P2+"
        case .extreme:   return "Extreme"
        }
    }
    
}

// -
// Static Data
// -

@objc extension NEWSTSCOOTER {
    
    static let scooter = [
        NEWSTSCOOTER(  0, .standard,   ._12_10, ._50cc,   .standard,    0, "Nessuno scooter",            0),
        NEWSTSCOOTER( 65, .standard,   ._12_10, ._50cc,   .standard, 2498, "Magutty Firecow",            5),
        NEWSTSCOOTER( 75, .standard,   ._16_16, ._70cc,   .P1,       4348, "Honda F98",                 10),
        NEWSTSCOOTER(105, .silenziosa, ._16_16, ._90cc,   .P1,       6498, "Mizzubisci R200 Millenium", 15),
        
        NEWSTSCOOTER( 75, .standard,   ._12_10, ._70cc,   .P1,       4298, "Magutty Firecow+",           7),
        NEWSTSCOOTER(100, .standard,   ._16_16, ._90cc,   .P1,       5998, "Magutty Firecow II",        10),
        NEWSTSCOOTER(100, .standard,   ._16_16, ._90cc,   .P1,       6348, "Honda F98s",                13),
        
        NEWSTSCOOTER(250, .standard,   .custom, ._3969cc, .standard, 1450, "Lexux LS400 ",               6),
    ]
    
}
