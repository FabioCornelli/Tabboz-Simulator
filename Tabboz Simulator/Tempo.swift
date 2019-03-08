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
}

enum Giorni : Int {
    case lunedi    = 1
    case martedi   = 2
    case mercoledi = 3
    case giovedi   = 4
    case venerdi   = 5
    case sabato    = 6
    case domenica  = 7
}

struct GiornoDellAnno : Equatable, Hashable {
    var giorno : Int
    var mese   : Mese
}

struct Vacanza {
    
    static let vacanze = [
        GiornoDellAnno( 1, .gennaio ): Vacanza("Capodanno",                "Oggi e' capodanno !"),
        GiornoDellAnno( 6, .gennaio ): Vacanza("Epifania",                 "Epifania..."),
        GiornoDellAnno( 1, .aprile  ): Vacanza("Anniversario Liberazione", "Oggi mi sento liberato"),
        GiornoDellAnno( 1, .maggio  ): Vacanza("Festa dei lavoratori",     "Nonostante nella tua vita, tu non faccia nulla, oggi fai festa anche tu..."),
        GiornoDellAnno( 1, .agosto  ): Vacanza("Ferragosto",               "Oggi e' ferragosto..."),
        GiornoDellAnno( 1, .novembre): Vacanza("Tutti i Santi",            "Figata, oggi e' vacanza..."),
        GiornoDellAnno( 7, .dicembre): Vacanza("Sant' Ambrogio",           "Visto che siamo a Milano, oggi facciamo festa."),
        GiornoDellAnno( 8, .dicembre): Vacanza("Immacolata Concezione",    "Oggi e' festa..."),
        GiornoDellAnno(25, .dicembre): Vacanza("Natale",                   "Buon Natale !!!"),
        GiornoDellAnno(26, .dicembre): Vacanza("Santo Stefano",            "Buon Santo Stefano..."),
        ]
    
    let nome:        String
    let descrizione: String
    
}

// - //

extension GiornoDellAnno {
    
    init(_ giorno: Int, _ mese: Mese) {
        (self.giorno, self.mese) = (giorno, mese)
    }

    var string : String {
        return "\(giorno) \(mese.nome)"
    }
    
    func fraUnMese() -> GiornoDellAnno {
        var fraUnMese = GiornoDellAnno(
            giorno,
            Mese(rawValue: mese.rawValue + 1) ?? .gennaio
        )
        
        // Quello che segue evita che la palestra scada un giorno tipo il 31 Febbraio
        if fraUnMese.giorno > fraUnMese.mese.giorni {
            fraUnMese.giorno = fraUnMese.mese.giorni
        }
        
        return fraUnMese
    }

    func fraSeiMesi() -> GiornoDellAnno {
        var fraSeiMesi = GiornoDellAnno(
            giorno,
            Mese(rawValue: ((mese.rawValue + 6 - 1) % 12) + 1) ?? .gennaio
        )
        
        // Quello che segue evita che la palestra scada un giorno tipo il 31 Febbraio
        if fraSeiMesi.giorno > fraSeiMesi.mese.giorni {
            fraSeiMesi.giorno = fraSeiMesi.mese.giorni
        }
        
        return fraSeiMesi
    }

    func fraUnAnno() -> GiornoDellAnno {
        var fraUnAnno = GiornoDellAnno(giorno - 1, mese)
        
        if fraUnAnno.giorno < 1 {
            fraUnAnno.mese = Mese(rawValue: mese.rawValue - 1) ?? .dicembre
            fraUnAnno.giorno = fraUnAnno.mese.giorni
        }
        
        return fraUnAnno
    }

    static func random() -> GiornoDellAnno {
        let mese = Mese(rawValue: tabboz_random(12) + 1) ?? .gennaio
        return GiornoDellAnno(tabboz_random(mese.giorni) + 1, mese)
    }
    
}

// - //

struct Calendario {
    
    private(set) var giornoDellAnno : GiornoDellAnno
    
    private(set) var annoBisesto     = Int32(0) // Anno Bisestile - 12 Giugno 1999
    private(set) var giornoSettimana = Giorni.lunedi
    
    private(set) var vacanza         = Int32(0) // Se e' un giorno di vacanza, e' uguale ad 1 o 2 altrimenti a 0
    
    init(oggi: GiornoDellAnno) {
        giornoDellAnno = oggi
    }
    
    mutating func nuovoGiorno() {
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
            if Vacanza.vacanze[giornoDellAnno] != nil {
                vacanza = 2 /* 2 = sono chiusi anche i negozi... */
            }
        }

    }
    
}

// - //

extension Mese {
    
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

extension Giorni {
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

extension Vacanza {
    
    init(
        _ nome:        String,
        _ descrizione: String
    ) {
        self.nome        = nome
        self.descrizione = descrizione
    }

}
