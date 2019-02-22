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
                       var reputazione : Int =         0
    @objc              var fortuna     : Int =         0 /* Uguale a me...               */
    @objc private      var stato       : Int =       100
    
          private      var attesa      : Int = ATTESAMAX // Tempo prima che ti diano altri soldi...
    
          private(set) var danaro      = Danaro(quanti: 5)
          private(set) var calendario  = Calendario()
    @objc private(set) var scuola      = Scuole()
          private(set) var vestiti     = Vestiario()
          private(set) var tipa        = Fiddhiola()
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
            
            eventiPalestra(hDlg)
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
    
    func eventiPalestra(_ hDlg: HANDLE) {
        /********************************************************************/
        /* EVENTI PALESTRA - 14 Luglio 1998                                 */
        /********************************************************************/
        
        let i = tabboz_random(29 + (fortuna / 2))
        
        if (i > 9) {
            return    /* eventi: 0 - 10) */
        }
        
        MessageBox_EventiPalestra(hDlg, Int32(i))
        
        if reputazione > 10 {
            reputazione -= 4
        }
    }
    
    // -
    // Telefono
    // -

    func vaiACompraCellulare(hDlg: HANDLE) {
        if cellularVacanza(hDlg: hDlg) {
            FaiCompraCellulare(hDlg: hDlg)
            AggiornaCell(hDlg)
        }
    }

    func vendiCellulare(hDlg: HANDLE) {
        if cellularVacanza(hDlg: hDlg) {
            if cellulare.attivo {
                let offerta = cellulare.prezzo / 2 + 15

                if MessageBox_TiPossoDare(hDlg, offerta) == IDYES {
                    cellulare.invalidate()
                    danaro.deposita(offerta)
                } else {
                    MessageBox_AlloraVaiAFartiFottere(hDlg)
                }
            } else {
                MessageBox_CheTelefoninoVuoiVendere(hDlg)
            }
            
            AggiornaCell(hDlg)
        }
    }
    
    func vaiAdAbbonaCellulare(hDlg: HANDLE) {
        if cellularVacanza(hDlg: hDlg) {
            FaiAbbonaCellulare(hDlg: hDlg)
            AggiornaCell(hDlg)
        }
    }
    
    // - //
    
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

    func aquistaDalConcessionario(hDlg: HANDLE) {
        if calendario.vacanza == 2 {
            MessageBox_IlConcessionarioEChiuso(hDlg, "Concessionario")
            return
        }
        
        FaiAquistaScooterDalConcessionario(hDlg: hDlg)
        Evento(hDlg)
        AggiornaScooter(hDlg)
    }
    
    func truccaScooter(hDlg: HANDLE) {
        if scooter.stato != -1 {
            if calendario.vacanza != 2 {
                FaiTruccaScooter(hDlg: hDlg)
                Evento(hDlg)
                AggiornaScooter(hDlg)
            }
            else {
                MessageBox_IlConcessionarioEChiuso(hDlg, "Trucca lo scooter")
            }
        }
        else {
            MessageBox_MaQualeScooterAvrestiIntenzioneDiTruccare(hDlg)
        }
        
        switch scooter.attivita { /* 7 Maggio 1998 */
        case .parcheggiato: SetDlgItemText(hDlg, 105, "Usa scooter")
        default:            SetDlgItemText(hDlg, 105, "Parcheggia scooter");
        }
        
        Evento(hDlg)
    }
    
    func vaiARiparaScooter(hDlg: HANDLE) {
        if scooter.stato != -1 {
            if scooter.stato == 100 {
                MessageBox_CheMotiviHaiPerVolerRiparareLoScooter(hDlg)
            }
            else {
                if calendario.vacanza != 2 {
                    FaiRiparaScooter(hDlg: hDlg)
                    AggiornaScooter(hDlg);
                } else {
                    MessageBox_IlMeccanicoEChiuso(hDlg)
                }
            }
            
            return
        }
        else {
          MessageBox_ComeFaiAFartiRiparareLoScooterSeNonLoHai(hDlg)
        }
        
        Evento(hDlg);
    }
    
    func parcheggiaOUsaScooter(hDlg: HANDLE) {
        if scooter.stato < 0 {
            MessageBox_ComeFaiAParcheggiareLoScooterSeNonLoHai(hDlg)
            return
        }
        
        if scooter.usaOParcheggia() {
            SetDlgItemText(hDlg, 105, "\(scooter.attivita == .parcheggiato ? "Usa scooter" : "Parcheggia scooter")")
        }
        else {
            MessageBox_ComeFaiAParcheggiareLoScooterVistoCheE(hDlg, scooter.attivita.string)
        }
        
        AggiornaScooter(hDlg)
    }
    
    func faiBenzina(hDlg: HANDLE) {
        if scooter.stato < 0 {
             MessageBox_ComeFaiAFarBenzinaAlloScooterSeNonLoHai(hDlg)
        }
        
        if danaro.paga(10) {
            MessageBox_AlDistributorePuoiFareUnMinimoDi(hDlg, MostraSoldi(10))
        }
        else {
            switch scooter.attivita {
                
            case .funzionante: fallthrough
            case .ingrippato:  fallthrough
            case .invasato:    fallthrough
            case .aSecco:
                
                scooter.faiIlPieno()
                CalcolaVelocita(hDlg)
                MessageBox_FaiBenzaERiempi(hDlg, MostraSoldi(10))
                
            default:
                MessageBox_ComeFaiAParcheggiareLoScooterVistoCheE(hDlg, scooter.attivita.string)
            }
        }
        
        AggiornaScooter(hDlg)
        Evento(hDlg)
    }

    // -

    func riparaScooter(hDlg: HANDLE) {
        if !danaro.paga(scooter.costoRiparazioni) {
            noMoney(hDlg: hDlg, tipo: SCOOTER)
        }
        else {
            scooter.ripara()
            CalcolaVelocita(hDlg)
        }
        
        EndDialog(hDlg, true)
    }
    
    // -
    
    func gareggia(con tipo: NEWSTSCOOTER) -> Bool {
        let fortunaDelTipo = tipo.speed + 80 + tabboz_random(40)
        let fortunaMia     = scooter.scooter.speedCalcolata + scooter.stato + fortuna
        return fortunaDelTipo > fortunaMia
    }

    func compraScooter(marca: Int, hDlg: HANDLE) {
        scelta = -1
        
        FaiAquistaScooter(marca: Int32(marca), hDlg: hDlg)
        
        if (scelta != -1) {
            if (scooter.stato != -1) {
                MessageBox_PerIlTuoVecchioScooterTiDiamoSupervalutazione(hDlg, MostraSoldi(1000))
                danaro.deposita(1000)
                scooter.distruggi()
            }
            
            if !danaro.paga(NEWSTSCOOTER.scooter[Int(scelta)].prezzo) {
                MessageBox_TiPiacerebbeComprareLoScooter(hDlg)
                if reputazione > 3 {
                    reputazione -= 1
                }
            }
            else {
                scooter.compraScooter(Int(scelta))
                
                MessageBox_FaiUnGiroPerFartiVedere(hDlg)
                
                reputazione += 4
                if reputazione > 100 {
                    reputazione = 100
                    
                }
            }
            Evento(hDlg);
        }
        
        SetDlgItemText(hDlg, 104, MostraSoldi(UInt(danaro.soldi)));
    }
    
    func vendiScooter(offerta: Int, hDlg: HANDLE) {
        scooter.distruggi()
        danaro.deposita(offerta)
        EndDialog(hDlg, true)
    }
    
    func vaiAVendiScooter(hDlg: HANDLE) {
        if scooter.stato != -1 {
            FaiVendiScooter(hDlg: hDlg)
        }
        else {
            MessageBox_MaQualeScooterVendi(hDlg)
        }
        
        SetDlgItemText(hDlg, 104, MostraSoldi(UInt(danaro.soldi)))
    }
    
    // -
    
    static let prezziDeiPezzi = [
        400, 500, 600,        // marmitte
        300, 470, 650,   800, // carburatori
        200, 400, 800,  1000, // cc
         50, 120, 270,   400, // filtro
    ]
    
    func compraMarmitta(wParam: Int, hDlg: HANDLE) {
        if !danaro.paga(Tabboz.prezziDeiPezzi[wParam - 130]) {
            noMoney(hDlg: hDlg, tipo: SCOOTER)
            return
        }
        
        scooter.scooter.marmitta = NEWSTSCOOTER.Marmitta(rawValue: wParam - 129)!
        
        CalcolaVelocita(hDlg)
        EndDialog(hDlg, true)
    }
    
    func compraCarburatore(wParam: Int, hDlg: HANDLE) {
        if !danaro.paga(Tabboz.prezziDeiPezzi[wParam - 130]) {
            noMoney(hDlg: hDlg, tipo: SCOOTER)
            return
        }
        
        scooter.scooter.carburatore = NEWSTSCOOTER.Carburatore(rawValue: wParam - 132)!
        
        CalcolaVelocita(hDlg)
        EndDialog(hDlg, true)
    }
    
    func compraCilindro(wParam: Int, hDlg: HANDLE) {
        if !danaro.paga(Tabboz.prezziDeiPezzi[wParam - 130]) {
            noMoney(hDlg: hDlg, tipo: SCOOTER)
            return
        }
        
        /* Piccolo bug della versione 0.6.91, qui c'era scritto ScooterData.marmitta */
        /* al posto di ScooterData.cc :-) */
        
        scooter.scooter.cc = NEWSTSCOOTER.Cilindrata(rawValue: wParam - 136)!
        
        CalcolaVelocita(hDlg)
        EndDialog(hDlg, true)
    }
    
    func compraFiltro(wParam: Int, hDlg: HANDLE) {
        if !danaro.paga(Tabboz.prezziDeiPezzi[wParam - 130]) {
            noMoney(hDlg: hDlg, tipo: SCOOTER)
            return
        }
        
        scooter.scooter.cc = NEWSTSCOOTER.Cilindrata(rawValue: wParam - 140)!
        
        CalcolaVelocita(hDlg)
        EndDialog(hDlg, true)
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
    
    func palpatina(hDlg: HANDLE) {
        if tipa.rapporto < 0 {
            //            MessageBox( hWnd, "Brutto porco, che cazzo tocchi ?", "Palpatina...", MB_OK | MB_ICONSTOP);
            //            if (sound_active) TabbozPlaySound(604);
            //            AggiornaTipa(tipahDlg);
        }
        else if tipa.rapporto < (20 + (tipa.figTipa / 2)) {
            // + e' figa, - te la da' (perla di saggezza)
            
            if sound_active != 0  {
                TabbozPlaySound(604)
            }
            
            MessageBox(hDlg,
                       "Brutto porco, che cazzo tocchi ?",
                       "Palpatina...",
                       MB_OK)
            
            if tipa.rapporto > 5 {
                tipa.rapporto -= 3
            }
            
            AggiornaTipa(tipahDlg);
        }
        else if (tipa.rapporto < (30 + (tipa.figTipa / 2))) {
            MessageBox(hDlg,
                       "Dai, smettila... Voi uomini pensato solo a quello...",
                       "Palpatina...",
                       MB_OK | MB_ICONQUESTION)
        }
        else {
            MessageBox(hDlg,
                       "Mmhhhhhhhh.........",
                       "Palpatina...",
                       MB_OK | MB_ICONINFORMATION)
            
            _ = tipa.rapporto + 3 // NOTE: Original bug!
            
            if (tipa.rapporto < 100) {
                tipa.rapporto = 100
            }
            
            Giorno(hDlg)
            AggiornaTipa(tipahDlg)
        }
        
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
    
    func corrompiIProfessori(hDlg: HANDLE) {
        if !CheckVacanza(hDlg) {
            let i = 30 + (tabboz_random(30) * 2); /* 21 Apr 1998 - I valori dei soldi e' meglio che siano sempre pari, in modo da facilitare la divisione x gli euro... */
            
            let i2 = MessageBox_PerTantoPotreiDimenticare(hDlg, Int32(i))
            
            if (i2 == IDYES) {
                if danaro.paga(i) {
                    scuola.materie[Int(scelta)].xxx += 3
                    
                    if scuola.materie[Int(scelta)].xxx > 10 {
                        scuola.materie[Int(scelta)].xxx = 10
                    }
                }
                else {
                    if scuola.materie[Int(scelta)].xxx < 2 {
                        scuola.materie[Int(scelta)].xxx -= 2
                    }
                    
                    MessageBox( hDlg,
                    "Cosa ??? Prima cerchi di corrompermi, poi si scopre che non hai abbastanza soldi !!!",
                    "Errore critico", MB_OK | MB_ICONSTOP);
                }
            }

            Evento(hDlg);
            Aggiorna(hDlg);
        }
    }
    
    func minacciaIProfessori(hDlg: HANDLE) {
        if !CheckVacanza(hDlg) {
            if sesso == Int8("M") {
                // Maschietto - minaccia prof.
                
                if (reputazione >= 30) || (tabboz_random(10) < 1) {
                    scuola.materie[Int(scelta)].xxx += 2
                    if (scuola.materie[Int(scelta)].xxx > 10) {
                        scuola.materie[Int(scelta)].xxx = 10
                    }
                }
                else {
                    if sound_active != 0 {
                        TabbozPlaySound(402)
                    }
                    
                    MessageBox( hDlg,
                    "Cosa ??? Credi di farmi paura piccolo pezzettino di letame vestito da zarro... Deve ancora nasce chi puo' minacciarmi...",
                    "Bella figura", MB_OK | MB_ICONINFORMATION)
                    
                    if reputazione > 3  {
                        reputazione -= 2
                    }
                    
                    if scuola.materie[Int(scelta)].xxx > 2 {
                        scuola.materie[Int(scelta)].xxx -= 1
                    }
                }
            }
            else {
                // Femminuccia - seduci prof.
                
                if ((fama >= 50) || (tabboz_random(10) < 2)) {
                    scuola.materie[Int(scelta)].xxx += 2
                    if scuola.materie[Int(scelta)].xxx > 10 {
                      scuola.materie[Int(scelta)].xxx = 10
                    }
                } else {
                    if sound_active != 0 {
                        TabbozPlaySound(402)
                    }
                    
                    MessageBox( hDlg,
                    "Infastidito dalla tua presenza, il prof ti manda via a calci.",
                    "Bella figura", MB_OK | MB_ICONINFORMATION);
                    
                    if reputazione > 3 {
                        reputazione -= 2
                    }
                    
                    if (scuola.materie[Int(scelta)].xxx > 2 ) {
                        scuola.materie[Int(scelta)].xxx -= 1
                    }
                }
            }
            
            Aggiorna(hDlg);
            Evento(hDlg);
        }
        
    }
    
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
    
    
    func CheckVacanza(_ hDlg: HANDLE) -> Bool {
        if calendario.vacanza != 0 {
            MessageBox(hDlg,
                       "Non puoi andare a scuola in un giorno di vacanza !",
                       "Scuola",
                       MB_OK | MB_ICONINFORMATION)
            return true
        }
        else {
            return false
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
    
    // -
    // Lavori
    // -
    
    func cercaLavoro(hDlg: HANDLE) {
        if calendario.vacanza == 2 {
            MessageBox_TroviICancelliInrimediabilmenteChiusi(hDlg);
            return
        }
        
        if lavoro.ditta > 0  {
            MessageBox_ForseNonTiRicordiCheHaiGiaUnLavoro(hDlg);
            return
        }
        
        Rcheck = 0
        Lcheck = 0
        
        let n_ditta = tabboz_random(NUM_DITTE) + 1;
        

        let accetto = VaiACercaLavoro(n_ditta: n_ditta, hDlg: hDlg)
        
        if accetto == IDNO { // Viva la finezza...
            MessageBox_AlloraSparisci(hDlg)
            return
        }
        
        scheda = tabboz_random(9)
        punti_scheda = 0;
        
        FaiLaScheda(scheda: scheda, hDlg: hDlg)
        
        /* Facciamo finta che la scheda venga effettivamente tenuta in considerazione...            */
        /* forse in un futuro verranno controllate le risposte, ma per ora non servono a nulla.     */
        
        /* 24 Maggio 1998 - v0.6.94                        */
        /* Le risposte cominciano a venire controllate.... */
        
        for i in 0 ..< 3 {
            if (Risposte_1.advanced(by: i).pointee != 0) {
                Rcheck += 1
            }
        }
        
        for i in 0 ..< 3 {
            if (Risposte_2.advanced(by: i).pointee != 0) {
                Rcheck += 10
            }
        }
        
        for i in 0 ..< 3 {
            if (Risposte_3.advanced(by: i).pointee != 0) {
                Rcheck += 100
            }
        }
        
        if Rcheck != 111 {
            MessageBox_PercheDovremmoAssumereChiNonSaMettereCrocette(hDlg)
            AggiornaLavoro(hDlg);
            return
        }
        
        if (( reputazione + fortuna + tabboz_random(80) ) > tabboz_random(200))   {
            lavoro.assumi(
                presso: Int(n_ditta),
                impegnoDelta: tabboz_random(20),
                stipendioDelta: tabboz_random(10) * 100
            )
            
            MessageBox_SeiStatoAssunto(hDlg, Carceri.lavoro[Int(n_ditta)].nome);
        } else {
            MessageBox_NonSeiRiuscitoASuperareIlTest(hDlg)
            
            if reputazione > 10 {
                reputazione -= 2
            }
        }
        
        Evento(hDlg);
        AggiornaLavoro(hDlg);
    }
    
    func licenziati(hDlg: HANDLE) {
        if GiornoDiLavoro(hDlg, "Licenziati") {
            return
        }
        
        if MessageBox_VuoiDareLeDimissioni(hDlg, Carceri.lavoro[lavoro.ditta].nome) == IDYES {
            lavoro.disimpegnati()
            Evento(hDlg)
        }
        
        AggiornaLavoro(hDlg)
    }
    
    func chiediAumentoSalario(hDlg: HANDLE) {
        if GiornoDiLavoro(hDlg, "Chiedi aumento salario") {
            return
        }
        
        if (lavoro.impegno_ > 90) {
            if ((30 + fortuna) > (30 + tabboz_random(50))) {
                MessageBox_ForsePotremmoDartiQualcosina(hDlg)
                lavoro.stipendio_ += ((tabboz_random(1)+1) * 100)
                lavoro.impegno_ -= 30
                Evento(hDlg);
            } else {
                MessageBox_VediDiScordartelo(hDlg);
                lavoro.impegno_ -= 20
                Evento(hDlg)
            }
        } else {
            MessageBox( hDlg,
                        "Che cosa vorresti ??? SCORDATELO !!!!",
                        "Chiedi aumento salario", MB_OK | MB_ICONHAND);
        }
        
        AggiornaLavoro(hDlg);
    }
    
    func faiIlLeccaculo(hDlg: HANDLE) {
        if sesso == Int8("M") { if (GiornoDiLavoro(hDlg, "Fai il leccaculo")) { return } }
        else                  { if (GiornoDiLavoro(hDlg, "Fai la leccaculo")) { return } }
        
        if sound_active != 0 {
            TabbozPlaySound(503)
        }
        
        if reputazione > 20 {
            reputazione -= 1
        }
        
        if lavoro.impegno_ < 99 {
           lavoro.impegno_ += 1
        }
        
        if tabboz_random(fortuna + 3) == 0 {
            Evento(hDlg)
        }
        
        AggiornaLavoro(hDlg)
    }
    
    func elencoDitte(hDlg: HANDLE) {
        if lavoro.ditta == 0 {
            FaiElencoDitte(hDlg: hDlg)
        }
        else {
            FaiCercaLavoro(ditta: Int32(lavoro.ditta), hDlg: hDlg)
        }
    }
    
    func sciopera(hDlg: HANDLE) {
        if GiornoDiLavoro(hDlg, "Sciopera") {
            return
        }
        
        if sound_active != 0 {
            TabbozPlaySound(502)
        }
        
        if reputazione < 85 {
            reputazione += 10
        }
        
        if lavoro.impegno_ > 19 {
            lavoro.impegno_ -= 15
        }
        
        if tabboz_random(fortuna + 3) == 0 {
            Evento(hDlg)
        }
        
        Evento(hDlg)
        AggiornaLavoro(hDlg)
    }
    
    func lavora(hDlg: HANDLE) {
        if GiornoDiLavoro(hDlg, "Lavora") {
            return
        }

        if lavoro.impegno_ < 85 {
            lavoro.impegno_ += 1
        }
        
        if sound_active != 0 {
            TabbozPlaySound(501)
        }
        
        Evento(hDlg)
        AggiornaLavoro(hDlg)
    }
    
    // -
    // Compagnia
    // -
    
    func gareggia(hDlg: HANDLE) {
        if scooter.stato <= 0 {
            MessageBox_ConQualeScooterVorrestiGarggiare(hDlg)
            return
        }
        
        if scooter.attivita != .funzionante {
            MessageBox_PurtroppoNonPuoiGareggiareVistoCheLoScooterE(hDlg, scooter.attivita.string)
            return
        }
        
        if sound_active != 0 {
            TabbozPlaySound(701)
        }
        
        let i = 1 + tabboz_random(6)    // 28 Aprile 1998 - (E' cambiato tutto cio' che riguarda gli scooter...)
        
        let i2 = MessageBox_AccettiLaSfidaDi(hDlg, NEWSTSCOOTER.scooter[i].nome)
        
        if scooter.stato > 30 {
            scooter.danneggia(tabboz_random(2))
        }
        
        if (i2 == IDYES) {
            //             if ( (ScooterMem[i].speed + 70 + random(50)) > (ScooterData.speed + ScooterData.stato + Fortuna) ) {
            if gareggia(con: NEWSTSCOOTER.scooter[i]) {
                // perdi
                
                if reputazione > 80 {
                    reputazione -= 3
                }
                
                if reputazione > 10 {
                    reputazione -= 2
                }
                
                MessageBox_DopoPochiMetriSiVedeLInferiorita(hDlg)
            }
            else {
                // vinci
                reputazione += 10
                
                if reputazione > 100 {
                  reputazione = 100
                }
                
                MessageBox_BruciInPartenza(hDlg)
            }
        }
        else {
            // Se non accetti la sfida, perdi rep...
            
            if reputazione > 80 {
                reputazione -= 3
            }
            
            if reputazione > 10 {
                reputazione -= 2
            }
        }
        
        scooter.consuma(benza: 5)
        CalcolaVelocita(hDlg)
        
        Evento(hDlg)
        SetDlgItemText(hDlg, 104, "\(reputazione)/100")
    }
    
    func esciConLaCompagnia(hDlg: HANDLE) {
                                // Uscendo con la propria compagnia si puo' arrivare
                                // solamente a reputazione = 57
        if reputazione < 57 {
            reputazione += 1
        }
        
        if reputazione < 37 {   // Se la rep e' bassa, sale + in fretta
            reputazione += 1
        }
        
        if reputazione < 12 {
            reputazione += 1
        }
        
        Evento(hDlg);
        EndDialog(hDlg, true);
    }
    
    func minacciaQualcuno(hDlg: HANDLE) {
        /* 12 Giugno 1998 - Qualche mese dopo gli altri pulsanti della finestra... */
        
        if (reputazione < 16) {
            MessageBox_ConLaScarsaReputazioneTuttiTrovanoDiMeglio(hDlg)
            Evento(hDlg)
            return
        }
        
        if (Tempo_trascorso_dal_pestaggio > 0) {
            if (tabboz_random(2) == 1) {
                MessageBox_ChiTiHaPicchiatoNonSiFaraVedere(hDlg)
                
                if reputazione < 80 {
                    reputazione += 3
                }
            }
            else {
                MessageBox_AncheITuiAmiciVengonoScacagnati(hDlg)
                
                if reputazione < 95 {
                    reputazione += 5
                }
            }
            
            Evento(hDlg);
        }
        else {
            MessageBox_VistoCheNonCeNessunoTuttiSeNeVanno(hDlg)
        }
        
        SetDlgItemText(hDlg, 104, "\(reputazione)/100")
    }
    
    func cellularVacanza(hDlg: HWND) -> Bool {
        if calendario.vacanza != 2 {
            return true
        }
        else {
            MessageBox(hDlg,
                       "Stranamente, in un giorno di vacanza, il negozio e' chiuso...",
                       "Telefonino",
                       MB_OK | MB_ICONINFORMATION)
            return false
            
        }
    }
    
    func compraVestitoNatalizio(hDlg: HANDLE) {
        /* Vestito da Babbo Natale... 11 Marzo 1999 */
        
        let costoVestitoNatalizio = 58
        
        if ((calendario.giornoDellAnno.mese == .dicembre) &&
            (danaro.soldi >= costoVestitoNatalizio))
        {
            if ((calendario.giornoDellAnno.giorno  > 14) &&
                (calendario.giornoDellAnno.giorno  < 25) &&
                (vestiti.giubbotto != 19) &&
                (vestiti.pantaloni != 19))
            {
                let scelta = MessageBox_VuoiComperareUnMeravigliosoVestitoNatalizio(hDlg, costoVestitoNatalizio)
                
                if (scelta == IDYES) {
                    vestiti.giubbotto = 19
                    vestiti.pantaloni = 19
                    
                    TabbozRedraw = 1;    // E' necessario ridisegnare l' immagine del Tabbozzo...
                    
                    _ = danaro.paga(costoVestitoNatalizio)
                }
            }
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

func VaiACercaLavoro(n_ditta: Int32, hDlg: HANDLE) -> Int32 {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(CercaLavoro(a, b, c, d)) },
        hDlg
    )

    "Cerca Lavoro".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(389 + n_ditta, string),
                      hDlg,
                      lpproc)
    }

    FreeProcInstance(lpproc)
    
    return accetto
}

func FaiLaScheda(scheda: Int32, hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(CercaLavoro(a, b, c, d)) },
        hDlg
    )
    
    "Fai La Scheda".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(200 + scheda, string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiElencoDitte(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(ElencoDitte(a, b, c, d)) },
        hDlg
    )
    
    "Elenco Ditte".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(210, string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiCercaLavoro(ditta: Int32, hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(CercaLavoro(a, b, c, d)) },
        hDlg
    )
    
    "Cerca Lavoro".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(289 + ditta, string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func GiornoDiLavoro(_ hDlg: HANDLE, _ x: String) -> Bool {
    return x.withCString({ GiornoDiLavoro(hDlg, $0) }) != 0
}

func FaiAquistaScooter(marca: Int32, hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(AcquistaScooter(a, b, c, d)) },
        hDlg
    )
    
    "Acquista Scooter".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(78 + marca, string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiVendiScooter(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(VendiScooter(a, b, c, d)) },
        hDlg
    )
    
    "Vendi Scooter".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(VENDISCOOTER), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiCompraCellulare(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(CompraCellulare(a, b, c, d)) },
        hDlg
    )
    
    "Compra Cellulare".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(COMPRACELLULAR), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiAbbonaCellulare(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(AbbonaCellulare(a, b, c, d)) },
        hDlg
    )
    
    "Abbona Cellulare".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(CELLULRABBONAM), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiAquistaScooterDalConcessionario(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(Concessionario(a, b, c, d)) },
        hDlg
    )
    
    "Acquista Scooter".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(ACQUISTASCOOTER), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiTruccaScooter(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(TruccaScooter(a, b, c, d)) },
        hDlg
    )
    
    "Trucca Scooter".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(73, string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

func FaiRiparaScooter(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(RiparaScooter(a, b, c, d)) },
        hDlg
    )
    
    "Ripara Scooter".withCString { (string) in
        _ = DialogBox(hInst,
                      MAKEINTRESOURCE_Real(Int32(RIPARASCOOTER), string),
                      hDlg,
                      lpproc)
    }
    
    FreeProcInstance(lpproc)
}

@objc extension Tabboz {
    
    @objc(fama)        var X:    Int    { return fama                               }
    @objc(reputazione) var Y:    Int    { return reputazione                        }
    
    var soldi:                   Int    { return danaro.soldi                       }
    var vacanza:                 Int32  { return calendario.vacanza                 }
    var giubbotto:               Int32  { return Int32(vestiti.giubbotto)           }
    var pantaloni:               Int32  { return Int32(vestiti.pantaloni)           }
    var scarpe:                  Int32  { return Int32(vestiti.scarpe)              }
    var currentTipa:             Int32  { return Int32(tipa.currentTipa)            }
    var nomeTipa:                String { return tipa.nome                          }
    var figTipa:                 Int32  { return Int32(tipa.figTipa)                }
    var rapporto:                Int32  { return Int32(tipa.rapporto)               }
    var scadenzaPalestraString:  String { return palestra.scadenzaString            }
    var calendarioString:        String { return calendario.giornoSettimana.string
                                               + " "
                                               + calendario.giornoDellAnno.string   }
    var compleannoString:        String { return compleanno.string                  }
    var compleannoGiorno:        Int32  { return Int32(compleanno.giorno)           }
    var compleannoMese:          Int    { return compleanno.mese.rawValue           }
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
