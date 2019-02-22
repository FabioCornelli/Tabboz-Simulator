//
//  Danaro.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 16/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Danaro {
    
    private(set) var soldi = 5
    
    init(quanti: Int) {
        soldi = quanti
    }
    
    func deposita(_ daPosare: Int) {
        soldi += daPosare
    }
    
    func paga(_ daPagare: Int) -> Bool {
        // Controlla se ha abbastanza soldi...
        guard soldi >= daPagare else { return false }
        soldi -= daPagare
        return true
    }
    
}
