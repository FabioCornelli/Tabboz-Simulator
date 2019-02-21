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
        danaro.deposita(1000)
        reputazione = tabboz_random(4)
        fama = tabboz_random(40)
    }
    
    func cheatFratelloDiDino() {
        danaro.deposita(1000)
        reputazione = tabboz_random(30)
        fama = tabboz_random(5)
    }
    
    func cheatDaniele() {
        scooter.regalaMacchinina()
        reputazione = 100
    }
    
    func cheatCaccia() {
        danaro.deposita(1000)
        fama = 100
    }
    
    func cheatAndrea() {
        scuola.materie.dropFirst().forEach { $0.xxx = 10 }
        CalcolaStudio()
        
        if tipa.rapporto > 1 {
            tipa.rapporto = 100
        }
        
        lavoro.assumi(presso: 1,
                      impegnoDelta: 90,
                      stipendioDelta: 4000)
    }
    
}
