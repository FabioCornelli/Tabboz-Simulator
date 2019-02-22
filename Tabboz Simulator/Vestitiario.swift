//
//  Vestiti.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 16/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Vestiario {
    
                 var giubbotto : Int = 0
                 var pantaloni : Int = 0
    private(set) var scarpe    : Int = 0
    
    @objc func indossa(_ vestito: Int) {
        /* 25 Febbraio 1999 */
        switch (vestito) {
        case  1 ..<  7: giubbotto = vestito;      break
        case  7 ..< 11: pantaloni = vestito - 6;  break
        case 11 ..< 17: scarpe    = vestito - 10; break
        default: break
        }
    }
    
    static let vestiti : [(fama: Int, prezzo: Int)] = [
        ( 8, 348), // -- Giubbotto "Fatiscenza"
        ( 9, 378), //
        ( 7, 298), //
        ( 8, 248), //    Giacca di pelle (3 Nuovi Giubbotti)
        ( 9, 378), //    Fatiscenza verde
        (10, 418), //    Fatiscenza bianco
        
        ( 3,  90), // -- Pantaloni gessati
        ( 5, 170), //    Pantaloni tuta
        ( 6, 248), //    Pantaloni in plastika
        ( 5, 190), //    Pantaloni scacchiera 21 giugno 1999
        
        ( 4, 122), // -- Scarpe da tabbozzi...
        ( 6, 220), //    Buffalo
        ( 2,  58), //    Scarpe da tabbozzi...
        ( 4, 142), //    NUOVE Scarpe da tabbozzi...   23 Aprile 1998
        ( 4, 142), //    ""        ""
        ( 5, 166), //    ""        ""
        ( 6, 230), //    Nuove Buffalo
    ]
    
}

