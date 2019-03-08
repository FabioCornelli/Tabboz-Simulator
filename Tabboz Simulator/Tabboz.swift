//
//  Tabboz.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

struct Stat  {
    
    private(set) var valore: Int
    
    init(valore: Int) {
        self.valore = valore
    }
    
    mutating func resetta(a tanto: Int) {
        valore = tanto
    }
    
    mutating func incrementa(di tanto: Int, seMinoreDi limite: Int? = nil) {
        if limite.map({ valore < $0 }) ?? true {
            incrementa(di: tanto)
        }
    }

    mutating func decrementa(di tanto: Int, seMaggioreDi limite: Int? = nil, minimo: Int? = nil) {
        if limite.map({ valore > $0 }) ?? true {
            decrementa(di: tanto)
        }
        
        if let minimo = minimo {
            valore = max(valore, minimo)
        }
    }
    
}

class Tabboz : NSObject {
    
    @objc static private(set) var global = Tabboz()

    @objc              var fortuna     : Int =         0 /* Uguale a me...               */
    
          private(set) var attesa      : Int = ATTESAMAX // Tempo prima che ti diano altri soldi...
    
                       var fama        = Stat(valore: 0)
                       var reputazione = Stat(valore: 0)
                       var danaro      = Danaro(quanti: 5)
                       var calendario  = Calendario(oggi: GiornoDellAnno(30, .settembre))
          private(set) var scuola      = Scuole()
          private(set) var vestiti     = Vestiario()
          private(set) var tipa        = Fiddhiola()
          private(set) var tabacchi    = Tabacchi()
          private(set) var palestra    = Palestra()
          private(set) var compleanno  = GiornoDellAnno.random()
          private(set) var scooter     = Motorino()
          private(set) var cellulare   = Telefono()
          private(set) var abbonamento = AbbonamentoCorrente()
          private(set) var lavoro      = Carceri()
    
    @objc static func initGlobalTabboz() {
        global = Tabboz()
    }

}

@objc extension Tabboz {
    
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
            
            fama.incrementa(di: 1, seMinoreDi: 82)
            
            eventiPalestra(hDlg)
            AggiornaPalestra(hDlg)
        }
    }
    
    func faiLaLampada(_ hDlg: HANDLE) {
        if danaro.paga(Tabboz.palestraCostoLampada) {
            if (current_testa < 3) {
                // Grado di abbronzatura
                current_testa += 1
                
                fama.incrementa(di: 1, seMinoreDi: 20) // Da 0 a 3 punti in piu' di fama
                fama.incrementa(di: 1, seMinoreDi: 45) // ( secondo quanta se ne ha gia')
                fama.incrementa(di: 1, seMinoreDi: 96)
            }
            else {
                // Carbonizzato...
                current_testa = 4;
                fama       .decrementa(di: 8, seMaggioreDi: 8)
                reputazione.decrementa(di: 5, seMaggioreDi: 5)
                
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
        reputazione.decrementa(di: 4, seMaggioreDi: 10)
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
            fama.incrementa(di: nuovoCellulare.fama)
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
                reputazione.decrementa(di: 1, seMaggioreDi: 3)
            }
            else {
                scooter.compraScooter(Int(scelta))
                
                MessageBox_FaiUnGiroPerFartiVedere(hDlg)
                reputazione.incrementa(di: 4)
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
    
    func CalcolaVelocita(_ hDlg: HANDLE) {
        if scooter.attivitaCalcolata != .funzionante {
            MessageBox(
                hDlg,
                "Il tuo scooter e' \(scooter.attivitaCalcolata.string).",
                "Attenzione",
                MB_OK | MB_ICONINFORMATION
            )
        }
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
            fama.incrementa(di: vestito.fama)
        }
        else {
            nomoney(hInstance, Int32(VESTITI))
        }
        
        Evento(hInstance)
    }
    
    func compraSigarette(_ sigaretteId: Int, hInstance: HANDLE) {
        let sigaretta = Tabacchi.sigarette[sigaretteId]
        
        if danaro.paga(sigaretta.prezzo) {
            fama.incrementa(di: sigaretta.fama)
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
                
                fama       .decrementa(di: 1, seMaggioreDi: 2)
                reputazione.decrementa(di: 1, seMaggioreDi: 2)
            }
            else {
                if sound_active != 0 {
                    // suoni: 0303 -> 0305
                    TabbozPlaySound(303 + tabboz_random(3))
                }
                
                _ = danaro.paga(prezzo)
                
                fama.incrementa(di: disco.fama)
                reputazione.incrementa(di: disco.xxx)
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
            
            tipa.rapporto.resetta(a: 0)
            
            if (tipa.figTipa >= 79) && (sesso == Int8("M")) {
                MessageBox_PrendonoAScarpate(hDlg)
                reputazione.decrementa(di: 8)
            }
            
            if (tipa.figTipa <= 40) && (sesso == Int8("M")) {
                reputazione.incrementa(di: 4)
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
        }
        else {
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
            
            tipa.rapporto.incrementa(di: 1, seMinoreDi: 60)
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
            
            tipa.rapporto.decrementa(di: 3, seMaggioreDi: 5)
            
            AggiornaTipa(tipahDlg)
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
            
            // NOTE: Original bug!
            // tipa.rapporto.incrementa(di: 3)
            
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
        
        tipa.rapporto.incrementa(di: 5)
        fama.incrementa(di: 1, seMinoreDi: tipa.figTipa)
        scooter.consuma(benza: 3)
        
        CalcolaVelocita(hDlg);
        AggiornaTipa(hDlg);
    }
    
    func entrambe(hDlg: HANDLE) {
        MessageBox_MentreSeiAppartatoTiTiraETiLascia(hDlg, tipa.nome, String(utf8String: figNomTemp))
        
        tipa.rapporto.resetta(a: 0)
        
        fama       .decrementa(di: 4)
        reputazione.decrementa(di: 8)
        
        EndDialog(hDlg, true)
    }
    
    func nuova(hDlg: HANDLE) {
        tipa.nuovaTipa(
            nome: String(utf8String: figNomTemp)!,
            figosita: Int(figTemp),
            rapporto: 30 + tabboz_random(15)
        )

        fama       .incrementa(di: tipa.figTipa / 10)
        reputazione.incrementa(di: tipa.figTipa / 13)
        
        EndDialog(hDlg, true)
    }
    
    func provaci(hDlg: HANDLE) {
        // Calcola se ce la fa o meno con la tipa... ------------------------------------
        
        let puntiTipa = (tipa.figTipa * 2) + tabboz_random(50)
        let puntiMiei = fama + (reputazione + tabboz_random(30))
        
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
                
                fama       .incrementa(di: tipa.figTipa / 10)
                reputazione.incrementa(di: tipa.figTipa / 13)
            }
        }
        else {
            // 2 di picche... -------------------------------------------------------
            
                                    // un giorno fortunato...
            
            DDP += 1                // log due di picche...
            
            reputazione.decrementa(di: 2) // decremento reputazione
            fama       .decrementa(di: 2) // decremento figosita'
            
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
                    
                    reputazione.decrementa(di: 2, seMaggioreDi: 3)
                    
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
                    
                    reputazione.decrementa(di: 2, seMaggioreDi: 3)

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
            reputazione.decrementa(di: 5, seMaggioreDi: 10) // Studiare costa fatica...
            fama       .decrementa(di: 1, seMaggioreDi: 5)  // (oltre che Reputazione e Fama...)
            
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
            reputazione.decrementa(di: 1, seMaggioreDi:  3)
            break
            
        case VESTITI:
            MessageBox_ConCosaPaghi(parent)
            fama       .decrementa(di: 3, seMaggioreDi: 12)
            reputazione.decrementa(di: 2, seMaggioreDi:  4)
            break
            
        case PALESTRA:
            MessageBox_IstruttoreTiSuonaComeUnaZampogna(parent)

            fama       .decrementa(di: 4, seMaggioreDi: 14) // Ah,ah ! fino al 10 Jan 1999 c'era scrittto Reputazione-=4...
            reputazione.decrementa(di: 4, seMaggioreDi: 18)
            
            break
            
        case SCOOTER:
            MessageBox_IlMeccanicoTiRiempieDiPugni(parent)
            
            if (sesso == Int8("M")) {
                reputazione.decrementa(di: 5, seMaggioreDi: 7)
                
                if scooter.stato > 7 {
                    scooter.danneggia(5)
                }
            }
            else {
                reputazione.decrementa(di: 4, seMaggioreDi: 6)
                fama       .decrementa(di: 2, seMaggioreDi: 3)
            }
            
            break
            
        case TABACCAIO:
            MessageBox_FuoriDalMioLocale(parent)
            fama.decrementa(di: 1, seMaggioreDi: 2)
            break
            
        case CELLULRABBONAM:
            MessageBox_NonTiSeiAccortoDiNonAvareSoldi(parent)
            fama.decrementa(di: 1, seMaggioreDi: 2)
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
        
        if ((reputazione + fortuna + tabboz_random(80)) > tabboz_random(200))   {
            lavoro.assumi(
                presso: Int(n_ditta),
                impegnoDelta: tabboz_random(20),
                stipendioDelta: tabboz_random(10) * 100
            )
            
            MessageBox_SeiStatoAssunto(hDlg, Carceri.lavoro[Int(n_ditta)].nome);
        } else {
            MessageBox_NonSeiRiuscitoASuperareIlTest(hDlg)
            reputazione.decrementa(di: 2, seMaggioreDi: 10)
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
        
        if (lavoro.impegno > 90) {
            if ((30 + fortuna) > (30 + tabboz_random(50))) {
                MessageBox_ForsePotremmoDartiQualcosina(hDlg)
                lavoro.stipendio_ += ((tabboz_random(1)+1) * 100)
                lavoro.impegno.decrementa(di: 30)
                Evento(hDlg);
            } else {
                MessageBox_VediDiScordartelo(hDlg);
                lavoro.impegno.decrementa(di: 20)
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
        
        reputazione   .decrementa(di: 1, seMaggioreDi: 20)
        lavoro.impegno.incrementa(di: 1)
        
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
        
        reputazione   .decrementa(di: 10, seMaggioreDi: 85)
        lavoro.impegno.decrementa(di: 15, seMaggioreDi: 19)
        
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

        lavoro.impegno.incrementa(di: 1, seMinoreDi: 85)

        if sound_active != 0 {
            TabbozPlaySound(501)
        }
        
        Evento(hDlg)
        AggiornaLavoro(hDlg)
    }

    // -
    // Famiglia
    // -

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

    func chiediAumentoPaghetta(hDlg: HANDLE) {
        if (scuola.studio > 40) {
            if ((scuola.studio - Int(Paghetta) + fortuna) >
                ( 75 + tabboz_random(50)))
                && (Int(Paghetta) < 96)
            {
                MessageBox_VaBeneAPaghettaInPiu(hDlg, MostraSoldi(5))
                Paghetta += 5
                Evento(hDlg)
            } else {
                MessageBox_VediDiScordarteloDovraPassareMoltoTempo(hDlg)
                Evento(hDlg)
            }
        }
        else {
            MessageBox_QuandoAndraiMeglioAScuola(hDlg)
        }
        
        SetDlgItemText(hDlg, 105, MostraSoldi(Paghetta));
    }
    
    func papaMiDai100KLire(hDlg: HANDLE) {
        if sound_active != 0 {
            TabbozPlaySound(801)
        }
        
        MessageBox_NonPensarciNeancheLontanamente(hDlg)
        
        Evento(hDlg)
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
                
                reputazione.decrementa(di: 3, seMaggioreDi: 80)
                reputazione.decrementa(di: 2, seMaggioreDi: 10)
                
                MessageBox_DopoPochiMetriSiVedeLInferiorita(hDlg)
            }
            else {
                // vinci
                reputazione.incrementa(di: 10)
                MessageBox_BruciInPartenza(hDlg)
            }
        }
        else {
            // Se non accetti la sfida, perdi rep...
            
            reputazione.decrementa(di: 3, seMaggioreDi: 80)
            reputazione.decrementa(di: 2, seMaggioreDi: 10)
        }
        
        scooter.consuma(benza: 5)
        CalcolaVelocita(hDlg)
        
        Evento(hDlg)
        SetDlgItemText(hDlg, 104, "\(reputazione)/100")
    }
    
    func esciConLaCompagnia(hDlg: HANDLE) {
        // Uscendo con la propria compagnia si puo' arrivare
        // solamente a reputazione = 57
        // Se la rep e' bassa, sale + in fretta
        
        reputazione.incrementa(di: 1, seMinoreDi: 57)
        reputazione.incrementa(di: 1, seMinoreDi: 37)
        reputazione.incrementa(di: 1, seMinoreDi: 12)
        
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
                reputazione.incrementa(di: 3, seMinoreDi: 80)
            }
            else {
                MessageBox_AncheITuiAmiciVengonoScacagnati(hDlg)
                reputazione.incrementa(di: 5, seMinoreDi: 95)
            }
            
            Evento(hDlg);
        }
        else {
            MessageBox_VistoCheNonCeNessunoTuttiSeNeVanno(hDlg)
        }
        
        SetDlgItemText(hDlg, 104, "\(reputazione)/100")
    }
    
    // ------------------------------------------------------------------------------------------
    //  Controlla se e' un giorno di vacanza...
    // ------------------------------------------------------------------------------------------
    
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

func FaiLaPagella(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(MostraPagella(a, b, c, d)) },
        hDlg
    )
    
    "La Pagella".withCString { (string) in
        _ =  DialogBox(hInst,
                       MAKEINTRESOURCE_Real(110, string),
                       hDlg,
                       lpproc)
    }
    
    FreeProcInstance(lpproc);
}


@objc extension Tabboz {
    
    @objc(fama)        var X:    Int    { return fama.valore                        }
    @objc(reputazione) var Y:    Int    { return reputazione.valore                 }

    @objc(scooter)     var Z:    NEWSTSCOOTER { return scooter.scooter              }
    
    var soldi:                   Int    { return danaro.soldi                       }
    var vacanza:                 Int32  { return calendario.vacanza                 }
    var giubbotto:               Int32  { return Int32(vestiti.giubbotto)           }
    var pantaloni:               Int32  { return Int32(vestiti.pantaloni)           }
    var scarpe:                  Int32  { return Int32(vestiti.scarpe)              }
    var currentTipa:             Int32  { return Int32(tipa.currentTipa)            }
    var nomeTipa:                String { return tipa.nome                          }
    var figTipa:                 Int32  { return Int32(tipa.figTipa)                }
    var rapporto:                Int32  { return Int32(tipa.rapporto.valore)        }
    var studio:                  Int32  { return Int32(scuola.studio)               }
    var promosso:                Bool   { return scuola.promosso                    }
    var siga:                    Int32  { return Int32(tabacchi.siga)               }
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
    var benzinaString:           String { return scooter.benzinaString              }
    var carburatore:             String { return scooter.scooter.carburatore.string }
    var marmitta:                String { return scooter.scooter.marmitta.string    }
    var cilindro:                String { return scooter.scooter.cc.string          }
    var filtro:                  String { return scooter.scooter.filtro.string      }
    var speed:                   String { return scooter.speedString                }
    var nomeCellulare:           String { return cellulare.displayName              }
    var nomeAbbonamento:         String { return abbonamento.nomeDisplay            }
    var creditoAbbonamento:      String { return abbonamento.creditoDisplay         }
    var ditta:                   Int32  { return Int32(lavoro.ditta)                }
    var impegno_:                Int32  { return Int32(lavoro.impegno.valore)       }
    var stipendio_:              Int32  { return Int32(lavoro.stipendio_)           }

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

    func enumerateMaterie(_ iteration: (Int, String) -> Void) {
        scuola
            .materie
            .dropFirst()
            .enumerated()
            .map { ($0.offset, $0.element.nome) }
            .forEach(iteration)
    }

    func nomeDellaMateria(_ materia: Int) -> String {
        return scuola.materie[materia].nome
    }

    func votoDellaMateria(_ materia: Int) -> Int {
        return scuola.materie[materia].xxx
    }

}

class ScooterData : NSObject { }

@objc extension ScooterData {
    static var stato:    Int               { return Tabboz.global.scooter.stato    }
    static var attivita: Motorino.Attivita { return Tabboz.global.scooter.attivita }
    static var prezzo:   Int               { return Tabboz.global.scooter.prezzo   }
}

extension Stat {
    
    static func  >(a: Stat, b: Int ) -> Bool { return a.valore  > b        }
    static func <=(a: Stat, b: Int ) -> Bool { return a.valore <= b        }
    static func  <(a: Stat, b: Int ) -> Bool { return a.valore  < b        }
    static func >=(a: Stat, b: Int ) -> Bool { return a.valore >= b        }
    static func  >(a: Int,  b: Stat) -> Bool { return a         > b.valore }
    static func  +(a: Stat, b: Int)  -> Int  { return a.valore  + b        }
    static func  +(a: Int,  b: Stat) -> Int  { return a         + b.valore }
    static func  -(a: Stat, b: Int ) -> Int  { return a.valore  - b        }
    static func  *(a: Stat, b: Int ) -> Int  { return a.valore  * b        }

}
