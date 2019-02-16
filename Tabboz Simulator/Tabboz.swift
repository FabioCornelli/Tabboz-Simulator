//
//  Tabboz.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc class Motorino : NSObject {
    
    @objc enum Attivita : Int {
        case mancante     = 0
        case funzionante  = 1
        case ingrippato   = 2
        case invasato     = 3
        case parcheggiato = 4
        case sequestrato  = 5
        case aSecco       = 6
    }

    @objc enum Marmitta : Int {
        case standard     = 0
        case silenziosa   = 1
        case rumorosa     = 2
        case rumorosisima = 3
    }
    
    @objc enum Carburatore : Int {
        case _12_10 = 0
        case _16_16 = 1
        case _19_19 = 2
        case _20_20 = 3
        case _24_24 = 4
        case custom = 5
    }
    
    @objc enum CC : Int {
        case _50cc   = 0
        case _70cc   = 1
        case _90cc   = 2
        case _120cc  = 3
        case _150cc  = 4
        case _3969cc = 5
    }
    
    @objc enum Filtro : Int {
        case standard  = 0
        case P1        = 1
        case P2        = 2
        case P2Plus    = 3
        case extreme   = 4
    }
    
          var speed = 0
    @objc var marmitta = Marmitta.standard
    @objc var carburatore = Carburatore._12_10
    @objc var cc = CC._50cc
    @objc var filtro = Filtro.standard
    @objc var prezzo = 0
    @objc var attivita = Attivita.mancante
    @objc var stato = -1
          var nome = ""
    
    @objc var speedString : String {
        switch attivita {
        case .mancante:    return ""
        case .funzionante: return "\(speed)Km/h"
        default:           return "\(attivita.string)"
        }
    }
    
    @objc func gareggia(con tipo: NEWSTSCOOTER) -> Bool {
        let fortunaDelTipo = tipo.speed + 80 + Int(tabboz_random(40))
        let fortunaMia     = speed + stato + Int(Fortuna)
        return fortunaDelTipo > fortunaMia
    }
    
    @objc func ripara() {
        stato = 100
    }
    
    @objc func danneggia(_ danno: Int) {
        stato -= danno
    }
    
    @objc func distruggi() {
        stato = -1
        attivita = .mancante
    }
    
}

extension Motorino.Attivita {
    
    var string : String {
        switch self {
        case .mancante:     return "mancante"
        case .funzionante:  return "funzionante"
        case .ingrippato:   return "ingrippato"
        case .invasato:     return "invasato"
        case .parcheggiato: return "parcheggiato"
        case .sequestrato:  return "sequestrato"
        case .aSecco:       return "a secco"
        }
    }

}

extension Motorino.Marmitta {
    
    var string : String {
        switch self {
        case .standard:     return "standard"
        case .silenziosa:   return "silenziosa"
        case .rumorosa:     return "rumorosa"
        case .rumorosisima: return "rumorosisima"
        }
    }
    
}

extension Motorino.Carburatore {
    
    var string : String {
        switch self {
        case ._12_10: return "12/10"
        case ._16_16: return "16/16"
        case ._19_19: return "19/19"
        case ._20_20: return "20/20"
        case ._24_24: return "24/24"
        case .custom: return "custom"
        }
    }
    
}

extension Motorino.CC {
    
    var string : String {
        switch self {
        case ._50cc:   return "50cc"
        case ._70cc:   return "70cc"
        case ._90cc:   return "90cc"
        case ._120cc:  return "120cc"
        case ._150cc:  return "150cc"
        case ._3969cc: return "3969cc"
        }
    }
    
}

extension Motorino.Filtro {
    
    var string : String {
        switch self {
        case .standard:  return "standard"
        case .P1:        return "P1"
        case .P2:        return "P2"
        case .P2Plus:    return "P2+"
        case .extreme:   return "Extreme"
        }
    }
    
}

class Tabboz : NSObject {
    
    @objc static private(set) var global = Tabboz()
    
    @objc private(set) var attesa : Int // Tempo prima che ti diano altri soldi...
    @objc private(set) var studio : Int // Quanto vai bene a scuola (1 - 100)
    
    @objc var calendario  = Calendario()

          var palestra    = Palestra()
          var compleanno  = GiornoDellAnno(giorno: 1, mese: .gennaio)
    
    @objc private(set) var scooter     = Motorino() // NEWSTSCOOTER.scooter[0]
    @objc var cellulare   = Telefono()
    
    @objc private(set) var abbonamento = AbbonamentoCorrente(0, "")
    
    @objc static func initGlobalTabboz() {
        global = Tabboz()
    }
    
    override init() {
        attesa = ATTESAMAX
        studio = 0
        super.init()
    }
    
}

@objc extension Tabboz {
    
    func chiediPaghettaExtra(_ hDlg: HANDLE) {
        if (studio >= 40) {
            if attesa == 0 {
                attesa = ATTESAMAX
                Soldi += 10
                Evento(hDlg)
            }
            else {
                MessageBox_NonPuoiContinuamenteChiedereSoldi(hDlg)
                Evento(hDlg)
            }
        }
        else {
            MessageBox_QuandoAndraiMeglioAScuolaPotrai(hDlg)
        }

        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi))
    }
    
    func calcolaStudio() {
        var i2 = 0
        
        for materia in STSCOOTER.materie {
            i2 += materia.xxx
        }

        studio = (i2 * 10) / 9
    }
    
    /// Azzera le materie...
    func azzeraMaterie() {
        studio = 0
        
        for materia in STSCOOTER.materie {
            materia.xxx = 0
        }
    }
    
    func resetMe() {
        calendario = Calendario()
        compleanno = .random()
        cellulare.invalidate()
        abbonamento = AbbonamentoCorrente(-1, "")
    }

    // -
    // Palestra
    // -
    
    func controllaScadenzaAbbonamentoPalestra(hInstance: HANDLE) {
        if calendario.giornoDellAnno == palestra.scadenza {
            palestra.cancellaAbbonamento()
            MessageBox_AppenaScadutoAbbonamentoPalestra(hInstance);
        }
    }
    
    func compraAbbonamento(_ abbonamento: AbbonamentiPalestra, hDlg: HANDLE) {
        if palestra.scadenza != nil {
            MessageBox_HaiGiaUnAbbonamento(hDlg);
            return
        }
        
        if (abbonamento.prezzo > Soldi) {
            nomoney(hDlg, Int32(PALESTRA))
            return
        }
        else {
            Soldi -= UInt(abbonamento.prezzo)
        }

        palestra.abbonati(a: abbonamento, aPartireDa: calendario.giornoDellAnno)
        
        Evento(hDlg);
    }

    func vaiInPalestra(_ hDlg: HANDLE) {
        if palestra.scadenza == nil {
            MessageBox_PrimaDiVenireInPalestraFaiUnAbbonamento(hDlg);
        } else {
            if sound_active != 0 {
                TabbozPlaySound(201)
            }
            
            if Fama < 82 {
                Fama += 1
            }
            
            EventiPalestra(hDlg)
            AggiornaPalestra(hDlg)
        }
    }
    
    func faiLaLampada(_ hDlg: HANDLE) {
        if Tabboz.palestraCostoLampada > Soldi {
            nomoney(hDlg, Int32(PALESTRA))
        }
        else {
            if (current_testa < 3) {
                // Grado di abbronzatura
                current_testa += 1
                if Fama < 20 { Fama += 1 }    // Da 0 a 3 punti in piu' di fama
                if Fama < 45 { Fama += 1 }    // ( secondo quanta se ne ha gia')
                if Fama < 96 { Fama += 1 }
            }
            else {
                // Carbonizzato...
                current_testa = 4;
                if Fama > 8        { Fama -= 8 }
                if Reputazione > 5 { Reputazione -= 5 }
                
                MessageBox_EccessivaEsposizioneAiRaggiUltravioletti(hDlg)
            }
            
            TabbozRedraw = 1;    // E' necessario ridisegnare l' immagine del Tabbozzo...
            
            if sound_active != 0 {
                TabbozPlaySound(202)
            }
            
            Soldi -= UInt(Tabboz.palestraCostoLampada)
        }
        
        if tabboz_random(5 + Fortuna) == 0 {
            Evento(hDlg)
        }
        
        AggiornaPalestra(hDlg)
    }
    
    // -
    // Telefono
    // -

    func compraCellulare(_ scelta: Int, hDlg: HANDLE) {
        let nuovoCellulare = Telefono.cellulari[scelta]
        
        if (Soldi < nuovoCellulare.prezzo) {
            // Controlla se ha abbastanza soldi...
            nomoney(hDlg, Int32(CELLULRABBONAM))
            EndDialog(hDlg, true);
        }
        
        Soldi -= UInt(nuovoCellulare.prezzo)
        cellulare.prendiCellulare(nuovoCellulare)
        
        Fama += Int32(nuovoCellulare.fama)
        
        if Fama > 100 {
            Fama = 100
        }
        
        EndDialog(hDlg, true);
    }
    
    func compraAbbonamento(_ scelta: Int, _ hDlg: HANDLE) {
        let nuovoAbbonamento = STABB.abbonamenti[scelta]
        
        if (Soldi < STABB.abbonamenti[scelta].prezzo) {
            // Controlla se ha abbastanza soldi...
            
            nomoney(hDlg, Int32(CELLULRABBONAM));
            EndDialog(hDlg, true);
        }

        if abbonamento.accredita(nuovoAbbonamento) {
            if sound_active != 0 && cellulare.attivo {
                TabbozPlaySound(602)
            }
            
            EndDialog(hDlg, true)
        }
        else {
            MessageBox_CheTeNeFaiDiRicaricaSenzaSim(hDlg)
        }
    }
    
    // -
    // Scooter
    // -

    func setScooter(_ newValue: NEWSTSCOOTER, benzina b: Int) {
//        scooter = newValue
        benzina = Int32(b)
    }
    
    
    
}

@objc extension Tabboz {
    
    var scadenzaPalestraString : String { return palestra.scadenzaString }
    var calendarioString:        String { return calendario.giornoSettimana.string
                                               + " "
                                               + calendario.giornoDellAnno.string }
    var compleannoString:        String { return compleanno.string                }
    var compleannoGiorno:        Int32  { return Int32(compleanno.giorno)         }
    var compleannoMese:          Mese   { return compleanno.mese                  }
    var documento:               Int    { return (compleanno.giorno * 13)
                                               + (compleanno.mese.rawValue * 3)
                                               + 6070                             }
    var nomeScooter:             String { return scooter.nome                     }
    var marmittaString:          String { return scooter.marmitta.string          }
    var carburatoreString:       String { return scooter.cc.string                }
    var ccString:                String { return scooter.carburatore.string       }
    var filtroString:            String { return scooter.filtro.string            }

    static let palestraCostoLampada = 14
    
    static func palestraCostoAbbonamento(_ a: AbbonamentiPalestra) -> Int {
        return a.prezzo
    }
    
    static func enumerateCellulari(_ iteration: (Int, Int) -> Void) {
        Telefono
            .cellulari
            .enumerated()
            .map { ($0.offset, $0.element.prezzo) }
            .forEach(iteration)
    }

    static func enumerateAbbonamenti(_ iteration: (Int, Int) -> Void) {
        STABB
            .abbonamenti
            .enumerated()
            .map { ($0.offset, $0.element.prezzo) }
            .forEach(iteration)
    }
    
}
