//
//  Tabboz.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

class Tabboz : NSObject {
    
    @objc static let global = Tabboz()
    
    @objc var attesa : Int = 0 // Tempo prima che ti diano altri soldi...
    
}
