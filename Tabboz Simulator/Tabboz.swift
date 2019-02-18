//
//  Tabboz.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation


class Tabboz : NSObject {
    
    @objc static private(set) var global = Tabboz()
    
    @objc private(set) var attesa : Int // Tempo prima che ti diano altri soldi...
    @objc private(set) var studio : Int // Quanto vai bene a scuola (1 - 100)
    
    @objc private(set) var danaro      = Danaro()
    @objc private(set) var calendario  = Calendario()
    @objc private(set) var vestiti     = Vestiario()
    @objc private(set) var tabacchi    = Tabacchi()
          private      var palestra    = Palestra()
          private      var compleanno  = GiornoDellAnno(giorno: 1, mese: .gennaio)
    @objc private(set) var scooter     = Motorino()
    @objc private(set) var cellulare   = Telefono()
    @objc private(set) var abbonamento = AbbonamentoCorrente()
    @objc private(set) var lavoro      = Carceri()

    
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
                danaro.deposita(10)
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

        SetDlgItemText(hDlg, 104, MostraSoldi(UInt(danaro.soldi)))
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
        danaro.setta(5)
        calendario = Calendario()
        compleanno = .random()
        cellulare.invalidate()
        abbonamento = AbbonamentoCorrente()
        vestiti = Vestiario()
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
        
        if danaro.paga(abbonamento.prezzo) {
            palestra.abbonati(a: abbonamento, aPartireDa: calendario.giornoDellAnno)
            Evento(hDlg);
        }
        else {
            nomoney(hDlg, Int32(PALESTRA))
        }
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
        if danaro.paga(Tabboz.palestraCostoLampada) {
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
        }
        else {
            nomoney(hDlg, Int32(PALESTRA))
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
        
        if danaro.paga(nuovoCellulare.prezzo) {
            cellulare.prendiCellulare(nuovoCellulare)
            
            Fama += Int32(nuovoCellulare.fama)
            
            if Fama > 100 {
                Fama = 100
            }
        }
        else {
            nomoney(hDlg, Int32(CELLULRABBONAM))
        }
        
        EndDialog(hDlg, true);
    }
    
    func compraAbbonamento(_ scelta: Int, _ hDlg: HANDLE) {
        let nuovoAbbonamento = STABB.abbonamenti[scelta]
        
        if danaro.soldi < STABB.abbonamenti[scelta].prezzo {
            // Controlla se ha abbastanza soldi...
            
            nomoney(hDlg, Int32(CELLULRABBONAM));
            EndDialog(hDlg, true);
            return
        }


        if abbonamento.accredita(nuovoAbbonamento) {
            _ = danaro.paga(nuovoAbbonamento.prezzo)
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

    func _setScooter(_ newValue: NEWSTSCOOTER, benzin b: Int) {
    }
    
    // -
    // Vestiti
    // -

    func compraVestito(_ vestitoId: Int, hInstance: HANDLE) {
        let vestito = Vestiario.vestiti[vestitoId]
        
        if danaro.paga(vestito.prezzo) {
            vestiti.indossa(vestitoId)
            
            // E' necessario ridisegnare l' immagine del Tabbozzo...
            TabbozRedraw = 1
            
            Fama += Int32(vestito.fama)
            if Fama > 100 {
                Fama=100
            }
        }
        else {
            nomoney(hInstance, Int32(VESTITI))
        }
        
        Evento(hInstance)
    }
    
    func compraSigarette(_ sigaretteId: Int, hInstance: HANDLE) {
        let sigaretta = Tabacchi.sigarette[sigaretteId]
        
        if danaro.paga(sigaretta.prezzo) {
            Fama += Int32(sigaretta.fama)
            if Fama > 100 {
                Fama = 100
            }

            tabacchi.nuovoPacchetto()
            
            MessageBox_MessaggioPaurosoDaSigarette(hInstance)
            Evento(hInstance)
        }
        else {
            nomoney(hInstance, Int32(TABACCAIO))
        }
    }
    
    func vaiInDisco(_ discoId: Int, hDlg: HANDLE) {
        let disco = Club.disco[discoId]
        
        if disco.speed == 1 && scooter.stato == -1 {
            MessageBox_SenzaLoScooterNonVaiInDiscoFuoriPorta(hDlg)
            Evento(hDlg)
            return
        }
        
        if disco.mass == calendario.giornoSettimana.rawValue {
            MessageBox_UnCartelloRecitaGiornoDiChiusura(hDlg)
            return
        }
        
        let prezzo = sesso == UInt8(ascii: "M") ? disco.prezzo : disco.prezzo - 10
        
        if danaro.soldi >= prezzo {
            if disco.cc > Fama && sesso == UInt8(ascii: "M") {
                /* check selezione all'ingresso */
                
                if sound_active != 0 {
                    TabbozPlaySound(302)
                }
                
                MessageBox_ConciatoCosiNonPuoEntrare(hDlg)
                
                if Reputazione > 2 {
                    Reputazione -= 1
                }
                
                if Fama > 2 {
                    Fama -= 1
                }
            }
            else {
                if sound_active != 0 {
                    // suoni: 0303 -> 0305
                    TabbozPlaySound(303 + tabboz_random(3))
                }
                
                _ = danaro.paga(prezzo)
                
                Fama += Int32(disco.fama)
                Reputazione += Int32(disco.xxx)
                
                if Fama > 100 {
                    Fama = 100
                }
                
                if Reputazione > 100 {
                    Reputazione = 100
                }
            }
        }
        else {
            nomoney(hDlg, Int32(DISCO))
        }
        
        Evento(hDlg)
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
    var attivitaScooter:         String { return scooter.attivita.string            }
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

    static func enumerateVestiti(_ iteration: (Int, Int) -> Void) {
        Vestiario
            .vestiti
            .enumerated()
            .map { ($0.offset, $0.element.1) }
            .forEach(iteration)
    }

}
