//
//  Tabacchi.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 16/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Sigarette : NSObject {
    
    @objc var speed:    Int
    @objc var cc:       Int
          var fama:     Int
          var prezzo:   Int
    @objc var nome:     String
    
    init(
        _ speed:    Int,
        _ cc:       Int,
        _ fama:     Int,
        _ prezzo:   Int,
        _ nome:     String
    ) {
        self.speed    = speed
        self.cc       = cc
        self.fama     = fama
        self.prezzo   = prezzo
        self.nome     = nome
    }
    
}

class Tabacchi : NSObject {
    
    private(set) var siga = 0
    
    enum HoFumato : Int {
        case normale      = 0
        case stanFindendo = 1
        case finite       = 2
    }
    
    func nuovoPacchetto() {
        siga += 20
    }
    
    func fuma() -> HoFumato {
        siga -= 1
        
        switch siga {
        case 0 :      return .finite
        case 1 ..< 3: return .stanFindendo
        default:      return .normale
        }
    }
    
    @objc static let sigarette = [
        Sigarette( 5,  5, 2, 6, "Barclay"                  ),
        Sigarette( 8,  7, 1, 6, "Camel"                    ),
        Sigarette( 7,  6, 2, 6, "Davidoff Superior Lights" ),
        Sigarette( 7,  6, 2, 6, "Davidoff Mildnes"         ),
        Sigarette(13,  9, 2, 6, "Davidoff Classic"         ),
        Sigarette( 9,  7, 1, 5, "Diana Blu"                ),
        Sigarette(12,  9, 1, 5, "Diana Rosse"              ),
        Sigarette( 8,  7, 0, 6, "Dunhill Lights"           ),
        Sigarette( 7,  5, 0, 6, "Merit"                    ),
        Sigarette(14, 10, 0, 6, "Gauloises Blu"            ),
        Sigarette( 7,  6, 0, 6, "Gauloises Rosse"          ),
        Sigarette(13, 10, 1, 6, "Unlucky Strike"           ),
        Sigarette( 9,  7, 1, 6, "Unlucky Strike Lights"    ),
        Sigarette( 8,  6, 2, 6, "Malborro Medium"          ), // dovrebbero essere come le lights 4 Marzo 1999
        Sigarette(12,  9, 2, 6, "Malborro Rosse"           ),
        Sigarette( 8,  6, 2, 6, "Malborro Lights"          ),
        Sigarette(11, 10, 0, 5, "NS Rosse"                 ),
        Sigarette( 9,  8, 0, 5, "NS Mild"                  ),
        Sigarette( 9,  7, 1, 5, "Poll Mon Blu"             ),
        Sigarette(12,  9, 1, 5, "Poll Mon Rosse"           ),
        Sigarette(12, 10, 2, 6, "Philip Morris"            ),
        Sigarette( 4,  4, 2, 6, "Philip Morris Super Light"),
        Sigarette(10,  9, 1, 5, "Armadis"                  ),
        Sigarette(11,  9, 0, 5, "Winston"                  ),
        //        |   |
        //        |   \__ nicotina * 10 (7 = nicotina 0.7, 10 = nicotina 1)
        //        \______ condensato
    ]
}
