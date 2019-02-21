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

                       var fama        : Int =         0
    @objc              var reputazione : Int =         0
    @objc              var fortuna     : Int =         0 /* Uguale a me...               */
    @objc private      var stato       : Int =       100
    
    @objc private      var attesa      : Int = ATTESAMAX // Tempo prima che ti diano altri soldi...
    
    @objc private(set) var danaro      = Danaro(quanti: 5)
    @objc private(set) var calendario  = Calendario()
    @objc private(set) var scuola      = Scuole()
    @objc private(set) var vestiti     = Vestiario()
    @objc private(set) var tipa        = Fiddhiola()
    @objc private(set) var tabacchi    = Tabacchi()
          private      var palestra    = Palestra()
          private      var compleanno  = GiornoDellAnno.random()
    @objc private(set) var scooter     = Motorino()
    @objc private(set) var cellulare   = Telefono()
    @objc private(set) var abbonamento = AbbonamentoCorrente()
    @objc private(set) var lavoro      = Carceri()

    
    @objc static func initGlobalTabboz() {
        global = Tabboz()
    }

}

@objc extension Tabboz {
    
    func chiediPaghettaExtra(_ hDlg: HANDLE) {
        if (scuola.studio >= 40) {
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
            
            if fama < 82 {
                fama += 1
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
                if fama < 20 { fama += 1 }    // Da 0 a 3 punti in piu' di fama
                if fama < 45 { fama += 1 }    // ( secondo quanta se ne ha gia')
                if fama < 96 { fama += 1 }
            }
            else {
                // Carbonizzato...
                current_testa = 4;
                if fama > 8        { fama -= 8 }
                if reputazione > 5 { reputazione -= 5 }
                
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
            
        if tabboz_random(5 + fortuna) == 0 {
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
            
            fama += nuovoCellulare.fama
            
            if fama > 100 {
                fama = 100
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

    func gareggia(con tipo: NEWSTSCOOTER) -> Bool {
        let fortunaDelTipo = tipo.speed + 80 + tabboz_random(40)
        let fortunaMia     = scooter.scooter.speedCalcolata + scooter.stato + fortuna
        return fortunaDelTipo > fortunaMia
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
            
            fama += vestito.fama
            if fama > 100 {
                fama=100
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
            fama += sigaretta.fama
            if fama > 100 {
                fama = 100
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
            if disco.cc > fama && sesso == UInt8(ascii: "M") {
                /* check selezione all'ingresso */
                
                if sound_active != 0 {
                    TabbozPlaySound(302)
                }
                
                MessageBox_ConciatoCosiNonPuoEntrare(hDlg)
                
                if reputazione > 2 {
                    reputazione -= 1
                }
                
                if fama > 2 {
                    fama -= 1
                }
            }
            else {
                if sound_active != 0 {
                    // suoni: 0303 -> 0305
                    TabbozPlaySound(303 + tabboz_random(3))
                }
                
                _ = danaro.paga(prezzo)
                
                fama += disco.fama
                reputazione += disco.xxx
                
                if fama > 100 {
                    fama = 100
                }
                
                if reputazione > 100 {
                    reputazione = 100
                }
            }
        }
        else {
            nomoney(hDlg, Int32(DISCO))
        }
        
        Evento(hDlg)
    }
    
    // -
    // Tipa
    // -
    
    func lasciaTipa(hDlg: HANDLE) {
        if tipa.rapporto <= 0  {
            MessageBox_CheTipoAvrestiIntenzioneDiLasciare(hDlg)
            return
        }
        
        let lasciaoraddoppia = MessageBox_SeiSicuroDiVolerLasciare(hDlg, tipa.nome)
        
        if lasciaoraddoppia == IDYES {
            if sound_active != 0 {
                TabbozPlaySound(603)
            }
            
            tipa.rapporto = 0
            
            if (tipa.figTipa >= 79) && (sesso == Int8("M")) {
                MessageBox_PrendonoAScarpate(hDlg)
                
                reputazione -= 8
                if reputazione < 0 {
                    reputazione = 0
                }
            }
            
            if (tipa.figTipa <= 40) && (sesso == Int8("M")) {
                reputazione += 4
                
                if reputazione > 100 {
                  reputazione = 100
                }
            }
            
            Evento(hDlg);
        }
        
        AggiornaTipa(hDlg);
    }
    
    func chiamaTipa(hDlg: HANDLE) {
        if tipa.rapporto <= 0  {
            MessageBox_ChiVorrestiChiamare(hDlg)
            return
        }
        
        if (danaro.soldi <= 5) &&
            ((abbonamento.creditorest < 2) && !cellulare.attivo)
        {
            MessageBox_SeFaiAncoraUnaTelefonataTiSpezzoLeGambe(hDlg)
        } else {
            if sound_active != 0 {
                TabbozPlaySound(602)
            }
            
            // 5 Maggio 1999 - Telefono di casa o telefonino ???
            
            if ((abbonamento.creditorest >= 2) && cellulare.attivo) {
                abbonamento.addebita(-2)
            }
            else {
                _ = danaro.paga(5)
            }
            
            if tipa.rapporto <= 60 {
                tipa.rapporto += 1
            }
        }
        
        AggiornaTipa(hDlg)
    }
    
    func esciCollaTipa(hDlg: HANDLE) {
        if (tipa.rapporto <= 0)  {
            MessageBox_ConChiVorrestiUscire(hDlg)
            return
        }
        
        if (scooter.stato <= 0) && (sesso == Int8("M")) {
            MessageBox_CompraLoScooter(hDlg)
            return
        }
        
        if (scooter.attivita != .funzionante) && (sesso == Int8("M"))  {
            MessageBox_RisistemaScooter(hDlg, scooter.attivita.string)
            return
        }
        
        if (scooter.stato <= 35) && (sesso == Int8("M"))  {
            MessageBox_RiparaLoScooter(hDlg)
            return
        }
        
        if (!danaro.paga(15)) {
            MessageBox_NonPossoPagareTuttoIo(hDlg)
            return
        }
        
        tipa.rapporto += 5
        
        if tipa.rapporto > 100 {
            tipa.rapporto = 100
        }

        if tipa.figTipa > fama {
            fama += 1
        }
        
        if fama > 100 {
            fama = 100
        }

        scooter.consuma(benza: 3)
        
        CalcolaVelocita(hDlg);
        AggiornaTipa(hDlg);
    }
    
    func entrambe(hDlg: HANDLE) {
        MessageBox_MentreSeiAppartatoTiTiraETiLascia(hDlg, tipa.nome, String(utf8String: figNomTemp))
        
        tipa.rapporto = 0
        
        reputazione -= 8
        if reputazione < 0 {
            reputazione = 0
        }
        
        fama -= 4
        if fama < 0 {
            fama = 0
        }
        
        EndDialog(hDlg, true)
    }
    
    func nuova(hDlg: HANDLE) {
        tipa.nuovaTipa(
            nome: String(utf8String: figNomTemp)!,
            figosita: Int(figTemp),
            rapporto: 30 + tabboz_random(15)
        )
        
        fama += tipa.figTipa / 10
        if fama > 100 {
            fama = 100
        }
        
        reputazione += tipa.figTipa / 13
        if reputazione > 100 {
            reputazione = 100
        }
        
        EndDialog(hDlg, true)
    }
    
    func provaci(hDlg: HANDLE) {
        // Calcola se ce la fa o meno con la tipa... ------------------------------------
        
        let puntiTipa = (tipa.figTipa * 2) + tabboz_random(50)
        let puntiMiei = fama + reputazione + tabboz_random(30)
        
        if puntiTipa <= puntiMiei {
            // E' andata bene... ----------------------------------------------------
            
            MessageBox_ConIlTuoFacinoSeduciLaTipa(hDlg)
            
            // ...ma comunque controlla che tu non abbia gia' una tipa -------------------------
            
            if tipa.rapporto > 0 {
                // hai gia' una tipa..
                LeDueDonne(hDlg: hDlg)
            }
            else {
                // bravo, no hai una tipa...
                tipa.nuovaTipa(nome: String(utf8String: figNomTemp)!,
                               figosita: Int(figTemp),
                               rapporto: 30 + tabboz_random(15))
                
                fama += tipa.figTipa / 10
                if (fama > 100) { fama=100 }
                
                reputazione += tipa.figTipa / 13
                if reputazione > 100 {
                    reputazione = 100
                }
            }
        }
        else {
            // 2 di picche... -------------------------------------------------------
            
                                    // un giorno fortunato...
            
            DDP += 1                // log due di picche...
            
            reputazione -= 2        // decremento reputazione
            if reputazione < 0 {
                reputazione = 0
            }
            
            fama -= 2               // decremento figosita'
            if fama < 0 {
              fama=0
            }
            
            if sound_active != 0 {
                TabbozPlaySound(601)
            }
            
            IlDueDiPicche(hDlg: hDlg)
        }
        
        Evento(hDlg)
        EndDialog(hDlg, true)
    }
    
    // -
    // Scuola
    // -
    
    func studia(hDlg: HANDLE) {
        if CheckVacanza(hDlg) {
            if reputazione > 10 {    /* Studiare costa fatica...          */
                reputazione -= 5     /* (oltre che Reputazione e Fama...) */
            }
            
            if fama > 5 {
                fama -= 1
            }
            
            scuola.materie[Int(scelta)].xxx += 1
            
            if scuola.materie[Int(scelta)].xxx > 10 {
              scuola.materie[Int(scelta)].xxx = 10
            }
            
            Aggiorna(hDlg)
            Evento(hDlg)
        }
    }
    
    func noMoney(hDlg parent: HANDLE, tipo: Int) {
        switch (tipo) {
            
        case DISCO:
            MessageBox_ButtafuoriTiDepositaInUnCassonetto(parent)
            
            if reputazione > 3 {
                reputazione -= 1
            }
            
            break
            
        case VESTITI:
            MessageBox_ConCosaPaghi(parent)
            
            if fama > 12 {
                fama -= 3
            }
            
            if reputazione > 4 {
                reputazione -= 2
            }
            
            break
            
        case PALESTRA:
            MessageBox_IstruttoreTiSuonaComeUnaZampogna(parent)
            
            if fama > 14 {
                fama -= 4    /* Ah,ah ! fino al 10 Jan 1999 c'era scrittto Reputazione-=4... */
            }
            
            if reputazione > 18 {
                reputazione -= 4
            }
            
            break
            
        case SCOOTER:
            MessageBox_IlMeccanicoTiRiempieDiPugni(parent)
            
            if (sesso == Int8("M")) {
                if reputazione > 7 {
                    reputazione -= 5
                }
                
                if scooter.stato > 7 {
                    scooter.danneggia(5)
                }
            }
            else {
                if reputazione > 6 {
                    reputazione -= 4
                }
                
                if fama > 3 {
                    fama -= 2
                }
            }
            
            break
            
        case TABACCAIO:
            MessageBox_FuoriDalMioLocale(parent)
            
            if fama > 2 {
                fama -= 1
            }
            
            break
            
        case CELLULRABBONAM:
            MessageBox_NonTiSeiAccortoDiNonAvareSoldi(parent)
            
            if (fama > 2) {
                fama -= 1
            }
            
            break
            
        default:
            break
        }
    }
    
}

func MetalloEMagutto(_ i: Int, hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(MostraMetallone(a, b, c, d)) },
        hDlg
    )
    
    "Metalloni & Manovali".withCString { string in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(i), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func LeDueDonne(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(DueDonne(a, b, c, d)) },
        hDlg
    )
    
    let dialog = sesso == Int8("M") ? 92 : 192
    
    "Due Donne".withCString { string in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(dialog), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func IlDueDiPicche(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(DueDiPicche(a, b, c, d)) },
        hDlg
    )
    
    "Due Di Picche".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(95, string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

@objc extension Tabboz {
    
    @objc(fama) var fama_:       Int    { return fama                               }
    
    var scadenzaPalestraString:  String { return palestra.scadenzaString            }
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
