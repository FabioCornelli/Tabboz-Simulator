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

    var benzina = 0
    @objc private(set) var prezzo = 0
    @objc private(set) var attivita = Attivita.mancante
    @objc private(set) var stato = -1
    @objc private(set) var nome = ""
    
    @objc var scooter = NEWSTSCOOTER.scooter[0]
    
    @objc var speedString : String {
        switch attivita {
        case .mancante:    return ""
        case .funzionante: return "\(scooter.speedCalcolata)Km/h"
        default:           return "\(attivita.string)"
        }
    }
    
    @objc var benzinaString : String {
        return String(format: "%1.1f", Double(benzina) / 10.0)
    }
    
    @objc func gareggia(con tipo: NEWSTSCOOTER) -> Bool {
        let fortunaDelTipo = tipo.speed + 80 + Int(tabboz_random(40))
        let fortunaMia     = scooter.speedCalcolata + stato + Int(Fortuna)
        return fortunaDelTipo > fortunaMia
    }
    
    var attivitaCalcolataEx : Attivita? {
        var attivita = Attivita.funzionante
        
        if scooter.speedCalcolata <= -500  {
            attivita = .invasato
        }
        else if scooter.speedCalcolata <= -1 {
            attivita = .ingrippato
        }
        
        if benzina < 1 {
            attivita = .aSecco
        }
        
        return attivita
    }

    @objc var attivitaCalcolata : Attivita {
        return attivitaCalcolataEx ?? .funzionante
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
    
    @objc func consuma(benza: Int) {
        benzina -= benza
        
        if benzina < 1 {
            benzina = 0
        }
    }
    
    @objc func faiIlPieno() {
        benzina = scooter.cc != ._3969cc
            ? 50    /* 5 litri,  il massimo che puo' contenere... */
            : 850   /* 85 litri, x la macchinina un po' figa...   */
    }
    
    @objc func usaOParcheggia() -> Bool {
        switch attivitaCalcolataEx ?? attivita {
        case .funzionante:
            attivita = .parcheggiato
            return true
        case .parcheggiato:
            attivita = .funzionante
            return true
        default:
            return false
        }
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

    func setScooter(_ newValue: NEWSTSCOOTER, benzin b: Int) {
        scooter.scooter = newValue
        scooter.benzina = b
    }
    
    
    
}

@objc extension Tabboz {
    
    var scadenzaPalestraString : String { return palestra.scadenzaString            }
    var calendarioString:        String { return calendario.giornoSettimana.string
                                               + " "
                                               + calendario.giornoDellAnno.string   }
    var compleannoString:        String { return compleanno.string                  }
    var compleannoGiorno:        Int32  { return Int32(compleanno.giorno)           }
    var compleannoMese:          Mese   { return compleanno.mese                    }
    var documento:               Int    { return (compleanno.giorno * 13)
                                               + (compleanno.mese.rawValue * 3)
                                               + 6070                               }
    var nomeScooter:             String { return scooter.nome                       }
    var speedString:             String { return scooter.speedString                }
    var marmittaString:          String { return scooter.scooter.marmitta.string    }
    var carburatoreString:       String { return scooter.scooter.cc.string          }
    var ccString:                String { return scooter.scooter.carburatore.string }
    var filtroString:            String { return scooter.scooter.filtro.string      }

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
