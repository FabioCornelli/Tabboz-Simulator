//
//  Cheats.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 21/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc extension Tabboz {

    func cheatDino() {
        fama       .resetta(a: tabboz_random(40))
        reputazione.resetta(a: tabboz_random(4))
        danaro     .deposita(1000)
    }
    
    func cheatFratelloDiDino() {
        fama       .resetta(a: tabboz_random(5))
        reputazione.resetta(a: tabboz_random(30))
        danaro     .deposita(1000)
    }
    
    func cheatDaniele() {
        reputazione.resetta(a: 100)
        scooter    .regalaMacchinina()
    }
    
    func cheatCaccia() {
        fama       .resetta(a: 100)
        danaro     .deposita(1000)
    }
    
    func cheatAndrea() {
        scuola.materie.dropFirst().forEach { $0.xxx = 10 }
        
        if tipa.rapporto > 1 {
            tipa.rapporto.resetta(a: 100)
        }
        
        lavoro.assumi(presso: 1,
                      impegnoDelta: 90,
                      stipendioDelta: 4000)
    }
    
}
