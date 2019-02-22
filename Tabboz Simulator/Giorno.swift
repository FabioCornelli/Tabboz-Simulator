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
            calendario.giorno      == 29 &&
            calendario.mese        == .febbraio
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
        
        if lavoro.impegno_ > 0  {
            lavoro.lavoraGiorno()
            
            if calendario.giorno == 27 {
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
        calendario.vacanza = 0
        tipa.currentTipa = 0
        
        /* Hai gia' ricevuto gli auguri di natale ??? 04/01/1999*/
        natale2 = 0

        switch calendario.mese {
            
        case .gennaio:                   /* Gennaio --------------------------------------------------------- */
            if calendario.giorno < 7 {
                calendario.vacanza = 1
                if tipa.rapporto > 0 {
                    tipa.currentTipa = 1 /* 6 Maggio 1999 - Tipa vestita da Babbo Natale...*/
                }
            }
            break;                       /* Vacanze di Natale */
            
        case .giugno:                    /* Giugno ---------------------------------------------------------- */
            if (calendario.giorno == 15) {
                MessageBox_UltimoGiornoDiScuola(hInstance)
            }
    
            if calendario.giorno == 22 { /* Pagella */
                if scuola.promosso {
                    danaro.deposita(200)
                }
                
                LaPagella(hDlg: hInstance)
            }
            
            if calendario.giorno > 15 {
                calendario.vacanza = 1
            }
            
            break;
            
        case .luglio:                    /* Luglio e */
            fallthrough
            
        case .agosto:                    /* Agosto   */
            calendario.vacanza = 1
            
            if ((tipa.rapporto > 93) &&
                (tipa.figTipa > 95 ))
            {
                tipa.currentTipa = 2     /* 6 Maggio 1999 - Tipa al mare...*/
            }
            
            break;
            
        case .settembre:                 /* Settembre ------------------------------------------------------- */
            if calendario.giorno < 15 {
                calendario.vacanza = 1
            }
            
            if calendario.giorno == 15 {
                MessageBox_PrimoGiornoDiScuola(hInstance)
                scuola.azzeraMaterie()
            }
            
            break;
            
        case .dicembre:                  /* Dicembre -------------------------------------------------------- */
            if calendario.giorno > 22  {
                calendario.vacanza = 1   /* Vacanze di Natale */
                
                if tipa.rapporto > 0  {
                    tipa.currentTipa = 1 /* 6 Maggio 1999 - Tipa vestita da Babbo Natale...*/
                }
            }
            
            if (calendario.giorno == 25) &&
                ((vestiti.pantaloni == 19) &&
                    (vestiti.giubbotto == 19))
            {
                MessageBox_ConBabboStupisciTutti(hInstance)
                fama += 20
                
                if fama > 100 {
                    fama = 100
                }
            }
            
            if (calendario.giorno == 28) &&
                ((vestiti.pantaloni == 19) || (vestiti.giubbotto == 19)) {
                MessageBox_ToglitiQuelDannatoVestito(hInstance)
                fama -= 5
                if fama < 0 {
                    fama = 0
                }
            }
            
            break;
            
        default:
            break;
            
        }
        
        /* Domeniche e festivita' varie                VACANZE DI TIPO 2 */

        if calendario.giornoSettimana == .domenica {
            /* Domenica */
            calendario.vacanza = 2
        }

        if (natale2 == 0) {
            Vacanza
                .vacanze
                .filter { vacanza in
                    vacanza.mese == calendario.mese.rawValue &&
                    vacanza.giorno == calendario.giorno
                }
                .forEach { vacanza in
                    MessageBox_Vacanza(hInstance,
                                       vacanza.nome,
                                       vacanza.descrizione)
                    calendario.vacanza = 2 /* 2 = sono chiusi anche i negozi... */
                }
        }
    }
    
}

struct Vacanza {
    
    static let vacanze = [
        Vacanza("Capodanno",                 1,  1, "Oggi e' capodanno !"),
        Vacanza("Epifania",                  6,  1, "Epifania..."),
        Vacanza("Anniversario Liberazione", 25,  4, "Oggi mi sento liberato"),
        Vacanza("Festa dei lavoratori",      1,  5, "Nonostante nella tua vita, tu non faccia nulla, oggi fai festa anche tu..."),
        Vacanza("Ferragosto",               15,  8, "Oggi e' ferragosto..."),
        Vacanza("Tutti i Santi",             1, 11, "Figata, oggi e' vacanza..."),
        Vacanza("Sant' Ambrogio",            7, 12, "Visto che siamo a Milano, oggi facciamo festa."),
        Vacanza("Immacolata Concezione",     8, 12, "Oggi e' festa..."),
        Vacanza("Natale",                   25, 12, "Buon Natale !!!"),
        Vacanza("Santo Stefano",            26, 12, "Buon Santo Stefano..."),
    ]
    
    let nome:        String
    let giorno:      Int
    let mese:        Int
    let descrizione: String

    init(
        _ nome:        String,
        _ giorno:      Int,
        _ mese:        Int,
        _ descrizione: String
    ) {
        self.nome        = nome
        self.giorno      = giorno
        self.mese        = mese
        self.descrizione = descrizione
    }
    
}

func LaPagella(hDlg: HANDLE) {
    let lpproc = MakeProcInstance(
        { (a, b, c, d) in ObjCBool(MostraPagella(a, b, c, d)) },
        hDlg
    )
    
    _ = "La Pagella".withCString({ (string) in
        DialogBox(hInst,
                  MAKEINTRESOURCE_Real(110, string),
                  hDlg,
                  lpproc);
        FreeProcInstance(lpproc);
    })
}

