//
//  Disco.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 16/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class DaClub : NSObject {
    
    @objc var speed:    Int // 1=disco fuori porta - ci puoi arrivare solo se hai lo scooter...
    @objc var cc:       Int // figosita' minima x entrare (selezione all' ingresso)
    @objc var xxx:      Int // incremento reputazione
    @objc var fama:     Int // incremento fama
    @objc var mass:     Int // giorno di chiusura (1=lunedi',etc... - 0=nessuno) [24 marzo 1998]
    @objc var prezzo:   Int // costo
    
    init(
        _ speed:    Int,
        _ cc:       Int,
        _ xxx:      Int,
        _ fama:     Int,
        _ mass:     Int,
        _ prezzo:   Int
    ) {
        self.speed    = speed
        self.cc       = cc
        self.xxx      = xxx
        self.fama     = fama
        self.mass     = mass
        self.prezzo   = prezzo
        super.init()
    }
    
}

class Club : NSObject {
    
    @objc static let disco = [
        DaClub(0,  0, 0, 0, 0,  0),
        DaClub(0, 30, 2,15, 1, 36),
        DaClub(0,  0, 1, 7, 4, 26),
        DaClub(0,  0, 1, 8, 1, 30),
        DaClub(0, 35, 3,15, 1, 36),
        DaClub(0,  0, 2, 6, 3, 26),
        DaClub(0,  0, 2, 5, 2, 22),
        DaClub(0,  0, 3, 8, 1, 30),
        DaClub(1,  0, 2, 9, 7, 36),
    ]

}
