//
//  Scuola.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 18/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Materie : NSObject {
    
    @objc var xxx:      Int    // [future espansioni]
    @objc var nome:     String // nome dello scooter
    
    init(
        _ xxx:      Int,
        _ nome:     String
    ) {
        self.xxx      = xxx
        self.nome     = nome
        super.init()
    }
    
}

class Scuole : NSObject {
    
    @objc private(set) var studio: Int  = 0 // Quanto vai bene a scuola (1 - 100)

    @objc func calcolaStudio() {
        var i2 = 0
        
        for materia in materie {
            i2 += materia.xxx
        }
        
        studio = (i2 * 10) / 9
    }
    
    /// Azzera le materie...
    @objc func azzeraMaterie() {
        studio = 0
        
        for materia in materie {
            materia.xxx = 0
        }
    }

    @objc var promosso: Bool {
        var k = 0
        
        for i in 1 ..< 10 {
            if (materie[i].xxx < 4) { k += 1 }
            if (materie[i].xxx < 6) { k += 1 }
        }
        
        return k > 4
    }
    
    @objc let materie = [
        Materie(0, "---"                  ),
        Materie(0, "Agraria"              ),
        Materie(0, "Fisica"               ),
        Materie(0, "Attivita' culturali"  ), // fine alla 0.6.3 era "culurali..."
        Materie(0, "Attivita' matematiche"),
        Materie(0, "Scienze industriali"  ),
        Materie(0, "Elettrochimica"       ),
        Materie(0, "Petrolchimica"        ),
        Materie(0, "Filosofia aziendale"  ), // fino alla 0.5.3 "aziendale" aveva due zeta...
        Materie(0, "Metallurgia"          ),
    ]
    
}
