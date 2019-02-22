//
//  Scuola.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 18/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Materie {
    
    var xxx:      Int    // [future espansioni]
    var nome:     String // nome dello scooter
    
    init(
        _ xxx:      Int,
        _ nome:     String
    ) {
        self.xxx      = xxx
        self.nome     = nome
    }
    
}

class Scuole {
    
    /// Quanto vai bene a scuola (1 - 100)
    var studio: Int {
        
        // Calcola Studio
        
        var i2 = 0
        
        for materia in materie {
            i2 += materia.xxx
        }
        
        return (i2 * 10) / 9
    }


    /// Azzera le materie...
    func azzeraMaterie() {
        for materia in materie {
            materia.xxx = 0
        }
    }

    var promosso: Bool {
        var k = 0
        
        for i in 1 ..< 10 {
            if (materie[i].xxx < 4) { k += 1 }
            if (materie[i].xxx < 6) { k += 1 }
        }
        
        return k > 4
    }
    
    let materie = [
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
