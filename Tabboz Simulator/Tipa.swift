//
//  Tipa.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 18/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Fiddhiola {

    private(set) var nome        = "" // Nome della tipa
                 var currentTipa =  0 // 6  Maggio  1999
    private(set) var figTipa     =  0
                 var rapporto    =  0
 
    func nuovaTipa(nome: String, figosita: Int, rapporto: Int) {
        self.nome = nome
        self.figTipa = figosita
        self.rapporto = rapporto
        self.currentTipa = 0
    }
    
    func molla() {
        self.rapporto = 0
        self.figTipa = 0
    }
    
}
