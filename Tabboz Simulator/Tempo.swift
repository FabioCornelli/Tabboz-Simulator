//
//  Tempo.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 14/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

enum Mese : Int {
    
    case gennaio   = 1
    case febbraio  = 2
    case marzo     = 3
    case aprile    = 4
    case maggio    = 5
    case giugno    = 6
    case luglio    = 7
    case agosto    = 8
    case settembre = 9
    case ottobre   = 10
    case novembre  = 11
    case dicembre  = 12
    
    var nome: String {
        switch self {
        case .gennaio:   return "Gennaio"
        case .febbraio:  return "Febbraio"
        case .marzo:     return "Marzo"
        case .aprile:    return "Aprile"
        case .maggio:    return "Maggio"
        case .giugno:    return "Giugno"
        case .luglio:    return "Luglio"
        case .agosto:    return "Agosto"
        case .settembre: return "Settembre"
        case .ottobre:   return "Ottobre"
        case .novembre:  return "Novembre"
        case .dicembre:  return "Dicembre"
        }
    }
    
    var giorni: Int {
        switch self {
        case .gennaio:   return 31
        case .febbraio:  return 28
        case .marzo:     return 31
        case .aprile:    return 30
        case .maggio:    return 31
        case .giugno:    return 30
        case .luglio:    return 31
        case .agosto:    return 31
        case .settembre: return 30
        case .ottobre:   return 31
        case .novembre:  return 30
        case .dicembre:  return 31
        }
    }
    
}

enum Giorni : Int {
    
    case lunedi    = 1
    case martedi   = 2
    case mercoledi = 3
    case giovedi   = 4
    case venerdi   = 5
    case sabato    = 6
    case domenica  = 7
    
    var string: String {
        switch self {
        case .lunedi:    return "Lunedi'"
        case .martedi:   return "Martedi'"
        case .mercoledi: return "Mercoledi'"
        case .giovedi:   return "Giovedi'"
        case .venerdi:   return "Venerdi'"
        case .sabato:    return "Sabato"
        case .domenica:  return "Domenica"
        }
    }
    
}

struct GiornoDellAnno : Equatable {
    
    var giorno : Int
    var mese   : Mese
    
    var string : String {
        return "\(giorno) \(mese.nome)"
    }
    
    func fraUnMese() -> GiornoDellAnno {
        var fraUnMese = GiornoDellAnno(
            giorno: giorno,
            mese: Mese(rawValue: mese.rawValue + 1) ?? .gennaio
        )
        
        // Quello che segue evita che la palestra scada un giorno tipo il 31 Febbraio
        if fraUnMese.giorno > fraUnMese.mese.giorni {
            fraUnMese.giorno = fraUnMese.mese.giorni
        }
        
        return fraUnMese
    }

    func fraSeiMesi() -> GiornoDellAnno {
        var fraSeiMesi = GiornoDellAnno(
            giorno: giorno,
            mese: Mese(rawValue: ((mese.rawValue + 6 - 1) % 12) + 1) ?? .gennaio
        )
        
        // Quello che segue evita che la palestra scada un giorno tipo il 31 Febbraio
        if fraSeiMesi.giorno > fraSeiMesi.mese.giorni {
            fraSeiMesi.giorno = fraSeiMesi.mese.giorni
        }
        
        return fraSeiMesi
    }

    func fraUnAnno() -> GiornoDellAnno {
        var fraUnAnno = GiornoDellAnno(giorno: giorno - 1, mese: mese)
        
        if fraUnAnno.giorno < 1 {
            fraUnAnno.mese = Mese(rawValue: mese.rawValue - 1) ?? .dicembre
            fraUnAnno.giorno = fraUnAnno.mese.giorni
        }
        
        return fraUnAnno
    }

    static func random() -> GiornoDellAnno {
        let mese = Mese(rawValue: tabboz_random(12) + 1) ?? .gennaio
        return GiornoDellAnno(giorno: tabboz_random(mese.giorni) + 1, mese: mese)
    }
    
}

class Calendario {
    
    private(set) var giornoDellAnno  = GiornoDellAnno(giorno: 30, mese: .settembre)
    
    private(set) var annoBisesto     = Int32(0) // Anno Bisestile - 12 Giugno 1999
    private(set) var giornoSettimana = Giorni.lunedi
    
    private(set) var vacanza         = Int32(0) // Se e' un giorno di vacanza, e' uguale ad 1 o 2 altrimenti a 0
    
    func nuovoGiorno() {
        giornoDellAnno.giorno += 1
        
        if (giornoDellAnno.giorno > giornoDellAnno.mese.giorni) {
            if !(giornoDellAnno.mese == .febbraio && annoBisesto == 1 && giornoDellAnno.giorno == 29) {
                giornoDellAnno.giorno = 1
                giornoDellAnno.mese = Mese(rawValue: giornoDellAnno.mese.rawValue + 1) ?? .gennaio
            }
        }
        
        if giornoDellAnno.mese == .gennaio {
            annoBisesto = (annoBisesto + 1) % 4
        }
        
        giornoSettimana = Giorni(rawValue: (giornoSettimana.rawValue + 1) % 7) ?? .lunedi
        
        vacanza = 0
        
        switch giornoDellAnno.mese {
        case .gennaio:                   /* Gennaio --------------------------------------------------------- */
            if giornoDellAnno.giorno < 7 {
                vacanza = 1
            }
            break                        /* Vacanze di Natale */
            
        case .giugno:                    /* Giugno ---------------------------------------------------------- */
            if giornoDellAnno.giorno > 15 {
                vacanza = 1
            }
            
            break
            
        case .luglio: fallthrough        /* Luglio e */
        case .agosto:                    /* Agosto   */
            vacanza = 1
            break
            
        case .settembre:                 /* Settembre ------------------------------------------------------- */
            if giornoDellAnno.giorno < 15 {
               vacanza = 1
            }
            break
            
        case .dicembre:                  /* Dicembre -------------------------------------------------------- */
            if giornoDellAnno.giorno > 22  {
                vacanza = 1
            }
            break /* Vacanze di Natale */

        default:
            break
        }
        
        if giornoSettimana == .domenica {
            /* Domenica */
            vacanza = 2
        }

        if (natale2 == 0) {
            let oggiVacanza = Vacanza
                .vacanze
                .filter { vacanza in
                    vacanza.mese   == giornoDellAnno.mese.rawValue &&
                    vacanza.giorno == giornoDellAnno.giorno
                }
                .isEmpty
                
            if oggiVacanza {
                vacanza = 2 /* 2 = sono chiusi anche i negozi... */
            }
        }

    }
    
}
