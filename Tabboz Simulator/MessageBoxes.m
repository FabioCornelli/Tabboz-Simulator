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
