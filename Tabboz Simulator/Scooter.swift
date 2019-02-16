//
//  Scooter.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

// Structure Definitions
// -

// INFORMAZIONI SUGLI SCOOTER  (ora usato solo per cose generiche...)
class STSCOOTER : NSObject {
    
    @objc var speed:    Int    // velocita' massima
    @objc var cc:       Int    // cilindrata
    @objc var xxx:      Int    // [future espansioni]
    @objc var fama:     Int    // figosita' scooter
    @objc var mass:     Int    // massa sooter
    @objc var maneuver: Int    // manovrabilita'
    @objc var prezzo:   Int    // costo dello scooter (modifiche incluse)
    @objc var stato:    Int    // quanto e' intero (in percuntuale); -1 nessuno scooter
    @objc var nome:     String // nome dello scooter
    
    init(
        _ speed:    Int,
        _ cc:       Int,
        _ xxx:      Int,
        _ fama:     Int,
        _ mass:     Int,
        _ maneuver: Int,
        _ prezzo:   Int,
        _ stato:    Int,
        _ nome:     String
    ) {
        self.speed    = speed
        self.cc       = cc
        self.xxx      = xxx
        self.fama     = fama
        self.mass     = mass
        self.maneuver = maneuver
        self.prezzo   = prezzo
        self.stato    = stato
        self.nome     = nome
        super.init()
    }
    
}

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

    @objc private(set) var speed:       Int         // 01  Velocita'
    @objc var marmitta:    Marmitta    // 02  Marmitta            ( +0, +7, +12, +15)
    @objc var carburatore: Carburatore // 03  Carburatore         ( 0 - 4 )
    @objc var cc:          Cilindrata  // 04  Cilindrata          ( 0 - 4 )
    @objc var filtro:      Filtro      // 05  Filtro dell' aria   ( +0, +5, +10, +15)
    @objc var prezzo:      Int         // 06  Costo dello scooter (modifiche incluse)
    @objc var nome:        String      // 09  Nome dello scooter
    @objc var fama:        Int         // 10  Figosita' scooter
    
    init(
        _ speed:       Int,
        _ marmitta:    Int,
        _ carburatore: Int,
        _ cc:          Int,
        _ filtro:      Int,
        _ prezzo:      Int,
        _ attivita:    Int,
        _ stato:       Int,
        _ nome:        String,
        _ fama:        Int
    ) {
        self.speed       = speed
        self.marmitta    = Marmitta(rawValue: marmitta)!
        self.carburatore = Carburatore(rawValue: carburatore)!
        self.cc          = Cilindrata(rawValue: cc)!
        self.filtro      = Filtro(rawValue: filtro)!
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

@objc extension STSCOOTER {

    // Materie -----------------------------------------------------------------------------------------

    // Per una questione di svogliatezza del programmatore, viene usata STSCOOTER anche x i vestiti,
    // le materie scolastiche e qualche altra cosa che adesso non mi viene in mente...
    
    static let materie = [
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "---"                  ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Agraria"              ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Fisica"               ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Attivita' culturali"  ), // fine alla 0.6.3 era "culurali..."
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Attivita' matematiche"),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Scienze industriali"  ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Elettrochimica"       ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Petrolchimica"        ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Filosofia aziendale"  ), // fino alla 0.5.3 "aziendale" aveva due zeta...
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Metallurgia"          ),
        /*               |                       */
        /*               \__ voto in una materia */
    ]
    
    // Vestiti -----------------------------------------------------------------------------------------
    
    // Per una questione di svogliatezza del programmatore, viene usata STSCOOTER anche x i vestiti.
    
    static let vestiti = [
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0,"---" ),
        STSCOOTER(0,  0, 0, 8, 0, 0, 348,  0,""    ), // -- Giubbotto "Fatiscenza"
        STSCOOTER(0,  0, 0, 9, 0, 0, 378,  0,""    ), //
        STSCOOTER(0,  0, 0, 7, 0, 0, 298,  0,""    ), //
        STSCOOTER(0,  0, 0, 8, 0, 0, 248,  0,""    ), //    Giacca di pelle (3 Nuovi Giubbotti)
        STSCOOTER(0,  0, 0, 9, 0, 0, 378,  0,""    ), //    Fatiscenza verde
        STSCOOTER(0,  0, 0,10, 0, 0, 418,  0,""    ), //    Fatiscenza bianco
        
        STSCOOTER(0,  0, 0, 3, 0, 0,  90,  0,""    ), // -- Pantaloni gessati
        STSCOOTER(0,  0, 0, 5, 0, 0, 170,  0,""    ), //    Pantaloni tuta
        STSCOOTER(0,  0, 0, 6, 0, 0, 248,  0,""    ), //    Pantaloni in plastika
        STSCOOTER(0,  0, 0, 5, 0, 0, 190,  0,""    ), //    Pantaloni scacchiera 21 giugno 1999
        
        STSCOOTER(0,  0, 0, 4, 0, 0, 122,  0,""    ), // -- Scarpe da tabbozzi...
        STSCOOTER(0,  0, 0, 6, 0, 0, 220,  0,""    ), //    Buffalo
        STSCOOTER(0,  0, 0, 2, 0, 0,  58,  0,""    ), //    Scarpe da tabbozzi...
        STSCOOTER(0,  0, 0, 4, 0, 0, 142,  0,""    ), //    NUOVE Scarpe da tabbozzi...   23 Aprile 1998
        STSCOOTER(0,  0, 0, 4, 0, 0, 142,  0,""    ), //    ""        ""
        STSCOOTER(0,  0, 0, 5, 0, 0, 166,  0,""    ), //    ""        ""
        STSCOOTER(0,  0, 0, 6, 0, 0, 230,  0,""    ), //    Nuove Buffalo
    ]
    
    // Sigarette ---------------------------------------------------------------------------------------
    
    static let sigarette = [
        STSCOOTER( 5,  5, 0, 2, 0, 0,   6,  0, "Barclay"                  ),
        STSCOOTER( 8,  7, 0, 1, 0, 0,   6,  0, "Camel"                    ),
        STSCOOTER( 7,  6, 0, 2, 0, 0,   6,  0, "Davidoff Superior Lights" ),
        STSCOOTER( 7,  6, 0, 2, 0, 0,   6,  0, "Davidoff Mildnes"         ),
        STSCOOTER(13,  9, 0, 2, 0, 0,   6,  0, "Davidoff Classic"         ),
        STSCOOTER( 9,  7, 0, 1, 0, 0,   5,  0, "Diana Blu"                ),
        STSCOOTER(12,  9, 0, 1, 0, 0,   5,  0, "Diana Rosse"              ),
        STSCOOTER( 8,  7, 0, 0, 0, 0,   6,  0, "Dunhill Lights"           ),
        STSCOOTER( 7,  5, 0, 0, 0, 0,   6,  0, "Merit"                    ),
        STSCOOTER(14, 10, 0, 0, 0, 0,   6,  0, "Gauloises Blu"            ),
        STSCOOTER( 7,  6, 0, 0, 0, 0,   6,  0, "Gauloises Rosse"          ),
        STSCOOTER(13, 10, 0, 1, 0, 0,   6,  0, "Unlucky Strike"           ),
        STSCOOTER( 9,  7, 0, 1, 0, 0,   6,  0, "Unlucky Strike Lights"    ),
        STSCOOTER( 8,  6, 0, 2, 0, 0,   6,  0, "Malborro Medium"          ), // dovrebbero essere come le lights 4 Marzo 1999
        STSCOOTER(12,  9, 0, 2, 0, 0,   6,  0, "Malborro Rosse"           ),
        STSCOOTER( 8,  6, 0, 2, 0, 0,   6,  0, "Malborro Lights"          ),
        STSCOOTER(11, 10, 0, 0, 0, 0,   5,  0, "NS Rosse"                 ),
        STSCOOTER( 9,  8, 0, 0, 0, 0,   5,  0, "NS Mild"                  ),
        STSCOOTER( 9,  7, 0, 1, 0, 0,   5,  0, "Poll Mon Blu"             ),
        STSCOOTER(12,  9, 0, 1, 0, 0,   5,  0, "Poll Mon Rosse"           ),
        STSCOOTER(12, 10, 0, 2, 0, 0,   6,  0, "Philip Morris"            ),
        STSCOOTER( 4,  4, 0, 2, 0, 0,   6,  0, "Philip Morris Super Light"),
        STSCOOTER(10,  9, 0, 1, 0, 0,   5,  0, "Armadis"                  ),
        STSCOOTER(11,  9, 0, 0, 0, 0,   5,  0, "Winston"                  ),
        //        |   |
        //        |   \__ nicotina * 10 (7 = nicotina 0.7, 10 = nicotina 1)
        //        \______ condensato
    ]

    // Lavoro ------------------------------------------------------------------------------------------

    static let lavoro = [
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "---"                      ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Magneti Budelli"          ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Diamine"                  ),
        STSCOOTER(1,  0, 0, 0, 0, 0,   0,  0, "Testmec"                  ),
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "Ti Impalo Bene Bene"      ),
        STSCOOTER(1,  0, 0, 0, 0, 0,   0,  0, "October"                  ),
        STSCOOTER(1,  0, 0, 0, 0, 0,   0,  0, "Arlond's"                 ),
        STSCOOTER(1,  0, 0, 0, 0, 0,   0,  0, "286 - Computer d' annata" ), // 14/01/2000
        STSCOOTER(1,  0, 0, 0, 0, 0,   0,  0, "Ricopio"                  ), // 14/01/2000
        //        |
        //        \__ lavoro fuori porta (solo con lo scooter puoi arrivarci...)
    ]

    // Disco -------------------------------------------------------------------------------------------

    // Per una questione di svogliatezza del programmatore, viene usata STSCOOTER
    // anche x i vestiti e per le discoteche.
    
    static let disco = [
        STSCOOTER(0,  0, 0, 0, 0, 0,   0,  0, "---"),
        STSCOOTER(0, 30, 2,15, 1, 0,  36,  0, ""   ),
        STSCOOTER(0,  0, 1, 7, 4, 0,  26,  0, ""   ),
        STSCOOTER(0,  0, 1, 8, 1, 0,  30,  0, ""   ),
        STSCOOTER(0, 35, 3,15, 1, 0,  36,  0, ""   ),
        STSCOOTER(0,  0, 2, 6, 3, 0,  26,  0, ""   ),
        STSCOOTER(0,  0, 2, 5, 2, 0,  22,  0, ""   ),
        STSCOOTER(0,  0, 3, 8, 1, 0,  30,  0, ""   ),
        STSCOOTER(1,  0, 2, 9, 7, 0,  36,  0, ""   ),
        //        |   |  |  |  |       |
        //        |   |  |  |  |       \__ costo
        //        |   |  |  |  \__________ giorno di chiusura (1=lunedi',etc... - 0=nessuno) [24 marzo 1998]
        //        |   |  |  \_____________ incremento fama
        //        |   |  \________________ incremento reputazione
        //        |   \___________________ figosita' minima x entrare (selezione all' ingresso)
        //         \______________________ 1=disco fuori porta - ci puoi arrivare solo se hai lo scooter...
    ]
    
}

@objc extension NEWSTSCOOTER {
    
    static let scooter = [
        NEWSTSCOOTER(  0,  0, 0, 0, 0,     0, 0,  -1, "Nessuno scooter",            0),
        NEWSTSCOOTER( 65,  0, 0, 0, 0,  2498, 1, 100, "Magutty Firecow",            5),
        NEWSTSCOOTER( 75,  0, 1, 1, 1,  4348, 1, 100, "Honda F98",                 10),
        NEWSTSCOOTER(105,  1, 1, 2, 1,  6498, 1, 100, "Mizzubisci R200 Millenium", 15),
        
        NEWSTSCOOTER( 75,  0, 0, 1, 1,  4298, 1, 100, "Magutty Firecow+",           7),
        NEWSTSCOOTER(100,  0, 1, 2, 1,  5998, 1, 100, "Magutty Firecow II",        10),
        NEWSTSCOOTER(100,  0, 1, 2, 1,  6348, 1, 100, "Honda F98s",                13),
        
        NEWSTSCOOTER(250,  0, 5, 5, 0,  1450, 1, 100, "Lexux LS400 ",               6),
    ]
    
}
