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
    
    @objc var speed:       Int     // 01  Velocita'
    @objc var marmitta:    Int     // 02  Marmitta            ( +0, +7, +12, +15)
    @objc var carburatore: Int     // 03  Carburatore         ( 0 - 4 )
    @objc var cc:          Int     // 04  Cilindrata          ( 0 - 4 )
    @objc var filtro:      Int     // 05  Filtro dell' aria   ( +0, +5, +10, +15)
    @objc var prezzo:      Int     // 06  Costo dello scooter (modifiche incluse)
    @objc var attivita:    Int     // 07  Attivita' scooter
    @objc var stato:       Int     // 08  Quanto e' intero (in percuntuale); -1 nessuno scooter
    @objc var nome:        String  // 09  Nome dello scooter
    @objc var fama:        Int     // 10  Figosita' scooter
    
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
        self.marmitta    = marmitta
        self.carburatore = carburatore
        self.cc          = cc
        self.filtro      = filtro
        self.prezzo      = prezzo
        self.attivita    = attivita
        self.stato       = stato
        self.nome        = nome
        self.fama        = fama
        
        super.init()
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
    
    
    // Abbonamenti Palestra ----------------------------------------------------------------------------
    
    static let palestra = [
        STSCOOTER(0,  0, 0, 0, 0, 0,  50,  0, ""), // Un mese    21 Apr 1998
        STSCOOTER(0,  0, 0, 8, 0, 0, 270,  0, ""), // Sei mesi
        STSCOOTER(0,  0, 0, 9, 0, 0, 500,  0, ""), // Un anno
        STSCOOTER(0,  0, 0, 9, 0, 0,  14,  0, ""), // Una lampada
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
