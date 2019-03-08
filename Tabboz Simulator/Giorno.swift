//
//  Giorno.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 20/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

import Foundation

@objc extension Tabboz {
    
    func giorno(hInstance: HANDLE) {
        calendario.nuovoGiorno()
        
        if
            calendario.annoBisesto == 1  &&
            calendario.giornoDellAnno.giorno == 29 &&
            calendario.giornoDellAnno.mese   == .febbraio
        {
            MessageBox_AnnoFunesto(hInstance)
        }
        
        if
            calendario.giornoSettimana == .lunedi &&
            current_testa > 0
        {
            current_testa -= 1  // Ogni 7 giorni diminuisce l' abbronzatura - 26 Feb 1999
            TabbozRedraw = 1    // e si deve aggiornare il disegno... (BUG ! Mancava fino alla versione 0.83pr )
        }
        
        /* ---------------> S T I P E N D I O <--------------- */
        
        if lavoro.impegno > 0  {
            lavoro.lavoraGiorno()
            
            if calendario.giornoDellAnno.giorno == 27 {
                /* Stipendio calcolato secondo i giorni effettivi di lavoro */
                let stipendietto = lavoro.prendiStipendioMese()
                
                if (stipendietto != -1) {
                    MessageBox_TiArrivaIlMiseroStipendio(hInstance, stipendietto)
                    danaro.deposita(stipendietto)
                }
            }
        }
        
        /* ---------------> P A L E S T R A <---------------    21 Apr 1998    */
        controllaScadenzaAbbonamentoPalestra(hInstance: hInstance)
        
        /* Calcola i giorni di vacanza durante l' anno ( da finire...)    */
        tipa.currentTipa = 0
        
        /* Hai gia' ricevuto gli auguri di natale ??? 04/01/1999*/
        natale2 = 0

        switch calendario.giornoDellAnno.mese {
            
        case .gennaio:                   /* Gennaio --------------------------------------------------------- */
            if calendario.giornoDellAnno.giorno < 7 {
                if tipa.rapporto > 0 {
                    tipa.currentTipa = 1 /* 6 Maggio 1999 - Tipa vestita da Babbo Natale...*/
                }
            }
            break;                       /* Vacanze di Natale */
            
        case .giugno:                    /* Giugno ---------------------------------------------------------- */
            if calendario.giornoDellAnno.giorno == 15 {
                MessageBox_UltimoGiornoDiScuola(hInstance)
            }
    
            if calendario.giornoDellAnno.giorno == 22 { /* Pagella */
                if scuola.promosso {
                    danaro.deposita(200)
                }
                
                FaiLaPagella(hDlg: hInstance)
            }
            
            break
            
        case .luglio:                    /* Luglio e */
            fallthrough
            
        case .agosto:                    /* Agosto   */
            if ((tipa.rapporto > 93) &&
                (tipa.figTipa > 95 ))
            {
                tipa.currentTipa = 2     /* 6 Maggio 1999 - Tipa al mare...*/
            }
            
            break
            
        case .settembre:                 /* Settembre ------------------------------------------------------- */
            
            if calendario.giornoDellAnno.giorno == 15 {
                MessageBox_PrimoGiornoDiScuola(hInstance)
                scuola.azzeraMaterie()
            }
            
            break;
            
        case .dicembre:                  /* Dicembre -------------------------------------------------------- */
            if (calendario.giornoDellAnno.giorno > 22) &&
                (tipa.rapporto > 0)
            {
                tipa.currentTipa = 1 /* 6 Maggio 1999 - Tipa vestita da Babbo Natale...*/
            }
            
            if (calendario.giornoDellAnno.giorno == 25) &&
                ((vestiti.pantaloni == 19) &&
                 (vestiti.giubbotto == 19))
            {
                MessageBox_ConBabboStupisciTutti(hInstance)
                fama.incrementa(di: 20)
            }
            
            if (calendario.giornoDellAnno.giorno == 28) &&
                ((vestiti.pantaloni == 19) ||
                 (vestiti.giubbotto == 19))
            {
                MessageBox_ToglitiQuelDannatoVestito(hInstance)
                fama.decrementa(di: 5)
            }
            
            break;
            
        default:
            break;
            
        }
        
        /* Domeniche e festivita' varie                VACANZE DI TIPO 2 */

        if (natale2 == 0) {
            Vacanza
                .vacanze
                .filter { $0.giorno == calendario.giornoDellAnno }
                .forEach { vacanza in
                    MessageBox_Vacanza(hInstance,
                                       vacanza.nome,
                                       vacanza.descrizione)
                }
        }
    }
    
}

struct Vacanza {
    
    static let vacanze = [
        Vacanza("Capodanno",                GiornoDellAnno( 1, .gennaio ), "Oggi e' capodanno !"),
        Vacanza("Epifania",                 GiornoDellAnno( 6, .gennaio ), "Epifania..."),
        Vacanza("Anniversario Liberazione", GiornoDellAnno( 1, .aprile  ), "Oggi mi sento liberato"),
        Vacanza("Festa dei lavoratori",     GiornoDellAnno( 1, .maggio  ), "Nonostante nella tua vita, tu non faccia nulla, oggi fai festa anche tu..."),
        Vacanza("Ferragosto",               GiornoDellAnno( 1, .agosto  ), "Oggi e' ferragosto..."),
        Vacanza("Tutti i Santi",            GiornoDellAnno( 1, .novembre), "Figata, oggi e' vacanza..."),
        Vacanza("Sant' Ambrogio",           GiornoDellAnno( 7, .dicembre), "Visto che siamo a Milano, oggi facciamo festa."),
        Vacanza("Immacolata Concezione",    GiornoDellAnno( 8, .dicembre), "Oggi e' festa..."),
        Vacanza("Natale",                   GiornoDellAnno(25, .dicembre), "Buon Natale !!!"),
        Vacanza("Santo Stefano",            GiornoDellAnno(26, .dicembre), "Buon Santo Stefano..."),
    ]
    
    let nome:        String
    let giorno:      GiornoDellAnno
    let descrizione: String

    init(
        _ nome:        String,
        _ giorno:      GiornoDellAnno,
        _ descrizione: String
    ) {
        self.nome        = nome
        self.giorno      = giorno
        self.descrizione = descrizione
    }
    
}
