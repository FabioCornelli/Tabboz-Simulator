//
//  Lavoro.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 16/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Lavori : NSObject {
    
    @objc var speed:    Int    // lavoro fuori porta (solo con lo scooter puoi arrivarci...)
    @objc var nome:     String // nome del lavoro
    
    init(
        _ speed:    Int,
        _ nome:     String
    ) {
        self.speed    = speed
        self.nome     = nome
        super.init()
    }
    
}

class Carceri : NSObject {
    
    private(set) var ditta          : Int = 0
    
                 var impegno_       : Int = 0
                 var stipendio_     : Int = 0
    private(set) var giorniDiLavoro : Int = 0 // Serve x calcolare lo stipendio SOLO per il primo mese...

    func impegnati() {
        impegno_ -= 1
    }
    
    func disimpegnati() {
        impegno_ = 0
        giorniDiLavoro = 0
        stipendio_ = 0
        ditta = 0
    }
    
    func lavoraGiorno() {
        giorniDiLavoro += 1
    }
    
    func prendiStipendioMese() -> Int {
        guard giorniDiLavoro > 3 else {
            return -1
        }
        
        let stipendio = giorniDiLavoro > 29
            ? stipendio_
            : stipendio_ * giorniDiLavoro / 30
        
        giorniDiLavoro = 0
        
        return stipendio
    }
    
    func assumi(presso: Int, impegnoDelta: Int, stipendioDelta: Int) {
        ditta = presso
        giorniDiLavoro = 1
        stipendio_ = 1000 + stipendioDelta
        impegno_ = 10 + impegnoDelta
    }
    
    @objc static let lavoro = [
        Lavori(0, "---"                      ),
        Lavori(0, "Magneti Budelli"          ),
        Lavori(0, "Diamine"                  ),
        Lavori(1, "Testmec"                  ),
        Lavori(0, "Ti Impalo Bene Bene"      ),
        Lavori(1, "October"                  ),
        Lavori(1, "Arlond's"                 ),
        Lavori(1, "286 - Computer d' annata" ), // 14/01/2000
        Lavori(1, "Ricopio"                  ), // 14/01/2000
    ]

}
