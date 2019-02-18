//
//  MessageBoxes.m
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

#import "C/os.h"

static char tmp[1024];
static char tmp1[1024];

void MessageBox_(HANDLE hDlg) {
}

void MessageBox_NonPuoiContinuamenteChiedereSoldi(HANDLE hDlg) {
    MessageBox( hDlg,
               "Ma insomma ! Non puoi continuamente chiedere soldi ! Aspetta ancora qualche giorno. Fai qualche cosa di economico nel frattempo...",
               "Non te li diamo", MB_OK | MB_ICONHAND);
}

void MessageBox_QuandoAndraiMeglioAScuolaPotrai(HANDLE hDlg) {
    sprintf(tmp, "Quando andrai meglio a scuola potrai tornare a chiederci dei soldi, non ora. \
            Ma non lo sai che per la tua vita e' importante studiare, e dovresti impegnarti \
            di piu, perche' quando ti impegni i risultati si vedono, solo che sei svogliat%c \
            e non fai mai nulla, mi ricordo che quando ero giovane io era tutta un altra cosa... \
            allora si' che i giovani studiavano...",
            ao);
    
    MessageBox(hDlg,
               tmp,
               "Errore irrecuperabile",
               MB_OK | MB_ICONHAND);
}

void MessageBox_HaiGiaUnAbbonamento(HANDLE hDlg) {
    MessageBox(hDlg,
               "Hai gia' un abbonamento, perche' te ne serve un altro ???",
               "Palestra",
               MB_OK | MB_ICONINFORMATION);
}

void MessageBox_AppenaScadutoAbbonamentoPalestra(HANDLE hInstance) {
    MessageBox( hInstance,
               "E' appena scaduto il tuo abbonamento della palestra...",
               "Palestra", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_PrimaDiVenireInPalestraFaiUnAbbonamento(HANDLE hDlg) {
    MessageBox( hDlg,
               "Prima di poter venire in palestra devi fare un abbonamento !",
               "Palestra", MB_OK | MB_ICONINFORMATION);
    
}

void MessageBox_EccessivaEsposizioneAiRaggiUltravioletti(HANDLE hDlg) {
    MessageBox(hDlg, "L' eccessiva esposizione del tuo corpo ai raggi ultravioletti,\nprovoca un avanzato grado di carbonizzazione e pure qualche piccola mutazione genetica...", "Lampada", MB_OK  | MB_ICONSTOP);
}

void MessageBox_CheTeNeFaiDiRicaricaSenzaSim(HANDLE hDlg) {
    MessageBox( hDlg,
               "Oh, che  te ne fai di una ricarica se non hai la sim ???",
               "Telefonino", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_MessaggioPaurosoDaSigarette(HANDLE hDlg) {
    char tmp[255];
    LoadString(hInst, random(8) + 600, (LPSTR)tmp, 254);  // 600 -> 607
    MessageBox(hDlg,
               (LPSTR)tmp,
               "ART. 46 L. 29/12/1990 n. 428", MB_OK | MB_ICONINFORMATION );
}

void MessageBox_SenzaLoScooterNonVaiInDiscoFuoriPorta(HANDLE hDlg) {
    MessageBox( hDlg,
               "Senza lo scooter non puoi andare nelle discoteche fuori porta...",
               "Discoteca fuori porta", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_UnCartelloRecitaGiornoDiChiusura(HANDLE hDlg) {    
    MessageBox( hDlg,
               "Un cartello recita che oggi e' il giorno di chiusura settimanale...",
               "Giorno di chiusura", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ConciatoCosiNonPuoEntrare(HANDLE hDlg) {
    MessageBox( hDlg,
               "Mi dispiace signore, conciato cosi', qui non puo' entrare...\nVenga vestito meglio la prossima volta, signore.",
               "Selezione all' ingresso", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_TiAccorgiCheStaiPerFinireLeSizze(HANDLE hDlg) {
    MessageBox( hDlg,
               "Ti accorgi che stai per finire le tue sizze.",
               "Sigarette...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ApriIlPacchettoDisperatameneteVuoto(HANDLE hDlg) {
    MessageBox( hDlg,
               "Apri il tuo pacchetto di sigarette e lo trovi disperatamente vuoto...",
               "Sei senza sigarette !", MB_OK | MB_ICONSTOP);
}

void MessageBox_CerchiDiTelefonareMaHaiFinitoISoldi(HANDLE hDlg) {
    MessageBox( hDlg,
               "Cerchi di telefonare e ti accorgi di aver finito i soldi a tua disposizione...",
               "Telefonino", MB_OK | MB_ICONSTOP);
}

void MessageBox_StaiPerFinireLaRicarica(HANDLE hDlg) {
    MessageBox( hDlg,
               "Ti accorgi che stai per finire la ricarica del tuo telefonino.",
               "Telefonino", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_IlTuoCellulareSiSpacca(HANDLE hDlg) {
    MessageBox( hDlg,
               "Dopo una vita di duro lavoro, a furia di prendere botte, il tuo cellulare si spacca...",
               "Telefonino", MB_OK | MB_ICONSTOP);
}

void MessageBox_PerdiIlLavoro(HANDLE hDlg) {
    sprintf(tmp,"Un bel giorno ti svegli e scopri di essere stat%c licenziat%c.",ao,ao);
    MessageBox( hDlg, tmp,
               "Perdi il lavoro...", MB_OK | MB_ICONSTOP);
}

void MessageBox_DoppiaPaghetta(HANDLE hDlg) {
    MessageBox( hDlg,
               "Visto che vai bene a scuola, ti diamo il doppio della paghetta...",
               "Paghetta settimanale", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_MetaPaghetta(HANDLE hDlg) {
    MessageBox( hDlg,
               "Finche' non andrai bene a scuola, ti daremo solo meta' della paghetta...",
               "Paghetta settimanale", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_LaTipaTiMolla(HANDLE hDlg, int scusa) {
    if (sesso == 'M') {
        LoadString(hDlg, (1040 + scusa), (LPSTR)tmp, 255);  /* 1041 -> 1050 */
        MessageBox( hDlg,
                   (LPSTR)tmp,
                   "La tipa ti molla...", MB_OK | MB_ICONSTOP);
    } else {
        LoadString(hDlg, (1340 + scusa), (LPSTR)tmp, 255);  /* 1041 -> 1050 */
        MessageBox( hDlg,
                   (LPSTR)tmp,
                   "Vieni mollata...", MB_OK | MB_ICONSTOP);
    }
}

void MessageBox_ScooterRidottoAdUnAmmassoDiRottami(HANDLE hDlg) {
    MessageBox( hDlg,
               "Quando ti rialzi ti accorgi che il tuo scooter e' ormai ridotto ad un ammasso di rottami.",
               "Scooter Distrutto", MB_OK | MB_ICONSTOP);
}

void MessageBox_SeiFortunato(HANDLE hDlg, int caso) {
    sprintf(tmp,"Sei fortunat%c...",ao);
    
    LoadString(hInst, (1000 + caso), (LPSTR)tmp1, 255);
    MessageBox(hDlg,
               (LPSTR)tmp1,tmp, MB_OK | MB_ICONSTOP);
}

void MessageBox_Scuola(HANDLE hDlg, int caso, int materia) {
    LoadString(hInst, (1000 + caso), (LPSTR)tmp, 255);
    strcat(tmp,MaterieMem[materia].nome.UTF8String);
    MessageBox( hDlg,
               (LPSTR)tmp,
               "Scuola...", MB_OK | MB_ICONSTOP);
}

int MessageBox_QualcunoTiCaga(HANDLE hDlg, int nome, int figTemp) {
    if (sesso == 'M') {
        LoadString(hDlg, (200+nome), (LPSTR)nomeTemp, 30); // 200 -> 219 [nomi tipe]
        sprintf(tmp,"Una tipa, di nome %s (Figosita' %d/100), ci prova con te'...\nCi stai ???",nomeTemp,figTemp);
    } else {
        LoadString(hDlg, (1200+nome), (LPSTR)nomeTemp, 30); // 200 -> 219 [nomi tipi]
        sprintf(tmp,"Una tipo, di nome %s (Figosita' %d/100), ci prova con te'...\nCi stai ???",nomeTemp,figTemp);
    }
    
    return MessageBox(hDlg, tmp, "Qualcuno ti caga...", MB_YESNO);
}

void MessageBox_RifiutiUnaFigona(HANDLE hDlg) {
    MessageBox( hDlg,
               "Appena vengono a sapere che non ti vuoi mettere insieme ad una figona come quella, i tuoi amici ti prendono a scarpate.",
               "Idiota...", MB_OK | MB_ICONSTOP);
}

int MessageBox_MiAmi(HANDLE hDlg) {
    return MessageBox( hDlg,
                      "Mi ami ???",
                      "Domande inutili della Tipa...", MB_YESNO | MB_ICONQUESTION);
    
}

void MessageBox_SeiIlSolitoStronzo(HANDLE hDlg) {
    MessageBox( hDlg,
               "Sei sempre il solito stronzo.. non capisco perche' resto ancora con uno come cosi'...",
               "Risposta sbagliata...", MB_OK | MB_ICONSTOP);
}

int MessageBox_MaSonoIngrassata(HANDLE hDlg) {
    return MessageBox( hDlg,
                      "Ma sono ingrassata ???",
                      "Domande inutili della Tipa...", MB_YESNO | MB_ICONQUESTION);
}

void MessageBox_SeiUnBastardo(HANDLE hDlg) {
    MessageBox( hDlg,
               "Sei un bastardo, non capisci mai i miei problemi...",
               "Risposta sbagliata...", MB_OK | MB_ICONSTOP);
}

void MessageBox_IlTelefoninoCadeDiTasca(HANDLE hDlg) {
    MessageBox( hDlg,
               "Il telefonino di cade di tasca e vola per terra...",
               "Telefonino", MB_OK | MB_ICONSTOP);
}
