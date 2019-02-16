//
//  MessageBoxes.m
//  Tabboz Simulator
//
//  Created by Antonio Malara on 13/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

#import "C/os.h"

static char tmp[1024];

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
