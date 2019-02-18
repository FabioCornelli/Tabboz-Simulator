//
//  Tipa.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 18/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Fiddhiola : NSObject {

    @objc private(set) var nome = ""        // Nome della tipa
    @objc              var currentTipa = 0
    @objc private(set) var figTipa = 0
    @objc              var rapporto = 0
 
    @objc func nuovaTipa(nome: String, figosita: Int, rapporto: Int) {
        self.nome = nome
        self.figTipa = figosita
        self.rapporto = rapporto
        self.currentTipa = 0
    }
    
    @objc func molla() {
        self.rapporto = 0
        self.figTipa = 0
    }
    
}
