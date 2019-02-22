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

void MessageBox_AnnoFunesto(HANDLE hDlg) {
    MessageBox(hDlg,
               "Anno bisesto, anno funesto...",
               "Anno Bisestile",
               MB_OK | MB_ICONSTOP);
}

void MessageBox_TiArrivaIlMiseroStipendio(HANDLE hDlg, NSInteger stipendietto) {
    sprintf(tmp,"Visto che sei stat%c %s brav%c dipendente sottomess%c, ora ti arriva il tuo misero stipendio di %s",
            ao, un_una, ao, ao, MostraSoldi(stipendietto));
    
    MessageBox( hDlg, tmp,
               "Stipendio !", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_UltimoGiornoDiScuola(HANDLE hDlg) {
    MessageBox( hDlg,
               "Da domani iniziano le vacanza estive !",
               "Ultimo giorno di scuola", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_PrimoGiornoDiScuola(HANDLE hDlg) {
    MessageBox( hDlg,
               "Questa mattina devi tornare a scuola...",
               "Primo giorno di scuola", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ConBabboStupisciTutti(HANDLE hDlg) {
    MessageBox( hDlg,
               "Con il tuo vestito da Babbo Natale riesci a stupire tutti...",
               "Natale...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ToglitiQuelDannatoVestito(HANDLE hDlg) {
    MessageBox( hDlg,
               "Natale e' gia' passato... Togliti quel dannato vestito...",
               "Natale...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_Vacanza(HANDLE hDlg, NSString * nome, NSString * descrizione) {
    MessageBox( hDlg,
               descrizione.UTF8String,
               nome.UTF8String,
               MB_OK | MB_ICONINFORMATION);
}

void MessageBox_CheTipoAvrestiIntenzioneDiLasciare(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg,
                   "Scusa, che ragazza avresti intenzione di lasciare ???",
                   "Lascia Tipa", MB_OK | MB_ICONINFORMATION);
    else
        MessageBox( hDlg,
                   "Scusa, che tipo avresti intenzione di lasciare, visto che sei sola come un cane ???",
                   "Lascia Tipo", MB_OK | MB_ICONINFORMATION);
}

int MessageBox_SeiSicuroDiVolerLasciare(HANDLE hDlg, NSString * tipa) {
    sprintf(tmp,"Sei proprio sicuro di voler lasciare %s ?", tipa.UTF8String);
    
    if (sesso == 'M')
        return MessageBox( hDlg,
                          tmp,
                          "Lascia tipa", MB_YESNO | MB_ICONQUESTION);
    else
        return MessageBox( hDlg,
                          tmp,
                          "Molla tipo", MB_YESNO | MB_ICONQUESTION);
    
}

void MessageBox_PrendonoAScarpate(HANDLE hDlg) {
    MessageBox( hDlg,
               "Appena vengono a sapere quello che hai fatto, i tuoi amici ti prendono a scarpate.\nQualcuno, piu' furbo di te, va a consolarla...",
               "Idiota...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ChiVorrestiChiamare(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg,
                   "Scusa, che ragazza vorresti chiamare ???",
                   "Non sei molto intelligente...", MB_OK | MB_ICONINFORMATION);
    else
        MessageBox( hDlg,
                   "Scusa, che ragazzo vorresti chiamare, visto che sei sola ???",
                   "Non sei molto intelligente...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_SeFaiAncoraUnaTelefonataTiSpezzoLeGambe(HANDLE hDlg) {
    MessageBox( hDlg,
               """Sei fai ancora una telefonata, ti spezzo le gambe"", disse tuo padre con un accetta in mano...",
               "Non toccare quel telefono...", MB_OK | MB_ICONSTOP);
}

void MessageBox_ConChiVorrestiUscire(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg,
                   "Scusa, con che tipa vorresti uscire ???",
                   "Non sei molto intelligente...", MB_OK | MB_ICONINFORMATION);
    else
        MessageBox( hDlg,
                   "Scusa, ma con chi vorresti uscire, ???",
                   "Non sei molto intelligente...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_CompraLoScooter(HANDLE hDlg) {
    MessageBox( hDlg,
               "Finche' non comprerai lo scooter, non usciremo piu' insieme...",
               "Compra lo scooter", MB_OK | MB_ICONSTOP);
}

void MessageBox_RisistemaScooter(HANDLE hDlg, NSString * attivita) {
    sprintf(tmp,"Finche' il tuo scooter restera' %s non potremo uscire insieme...",attivita.UTF8String);
    MessageBox( hDlg, tmp, "Risistema la scooter", MB_OK | MB_ICONINFORMATION);
}


void MessageBox_RiparaLoScooter(HANDLE hDlg) {
    MessageBox( hDlg,
               "Finche' non riparerai lo scooter, non usciremo piu' insieme...",
               "Ripara lo scooter", MB_OK | MB_ICONSTOP);
}

void MessageBox_NonPossoPagareTuttoIo(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg,
                   "Se mi vuoi portare fuori, cerca di avere almeno un po' di soldi...",
                   "Sei povero", MB_OK | MB_ICONSTOP);
    else
        MessageBox( hDlg,
                   "Oh tipa... cioe' non posso pagare sempre tutto io, cioe' ohhhh...",
                   "Che palle", MB_OK | MB_ICONSTOP);
}

void MessageBox_MentreSeiAppartatoTiTiraETiLascia(HANDLE hDlg, NSString * vecchiaTipa, NSString * nuovaTipa) {
    if (sesso == 'M')
        sprintf(tmp,
                "Mentre sei appartato con la %s, arriva la tua ragazza, %s, ti tira uno schiaffo e ti lascia.\
                Capendo finalmente di che pasta sei fatto, anche la %s si allontana...",
                nuovaTipa.UTF8String,
                vecchiaTipa.UTF8String,
                nuovaTipa.UTF8String);
    else
        sprintf(tmp,
                "%s viene a sapere che di %s, gli spacca la faccia e ti molla...\
                Dopo questa tragica esperienza anche %s sparisce...",
                vecchiaTipa.UTF8String,
                nuovaTipa.UTF8String,
                nuovaTipa.UTF8String);
    
    MessageBox( hDlg,
               tmp ,
               "La vita e' bella", MB_OK | MB_ICONSTOP);
}

void MessageBox_ConIlTuoFacinoSeduciLaTipa(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg,
                   "Con il tuo fascino nascosto da tabbozzo, seduci la tipa e ti ci metti insieme." ,
                   "E' andata bene !", MB_OK | MB_ICONINFORMATION);
    else
        MessageBox( hDlg,
                   "Ora non ti puoi piu' lamentare di essere sola..." ,
                   "Qualcono ti caga...", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ButtafuoriTiDepositaInUnCassonetto(HANDLE hDlg) {
    sprintf(tmp,"Appena entrat%c ti accorgi di non avere abbastanza soldi per pagare il biglietto.\n Un energumeno buttafuori ti deposita gentilmente in un cassonetto della spazzatura poco distante dalla discoteca.",ao);
    MessageBox( hDlg, tmp,
               "Bella figura", MB_OK | MB_ICONSTOP);
}

void MessageBox_ConCosaPaghi(HANDLE hDlg) {
    sprintf(tmp,"Con cosa avresti intenzione di pagare, stronzett%c ??? Caramelle ???",ao);
    MessageBox( hDlg, tmp,
               "Bella figura", MB_OK | MB_ICONSTOP);
}

void MessageBox_IstruttoreTiSuonaComeUnaZampogna(HANDLE hDlg) {
    if (sesso == 'M') {
        MessageBox( hDlg,
                   "L' enorme istruttore di bodybulding ultra-palestrato ti suona come una zampogna e ti scaraventa fuori dalla palestra.",
                   "Non hai abbastanza soldi...", MB_OK | MB_ICONSTOP);
    }
    else {
        MessageBox( hDlg,
                   "L' enorme istruttore di bodybulding ultra-palestrato ti scaraventa fuori dalla palestra.",
                   "Non hai abbastanza soldi...", MB_OK | MB_ICONSTOP);
    }
}

void MessageBox_IlMeccanicoTiRiempieDiPugni(HANDLE hDlg) {
    if (sesso == 'M') {
        MessageBox( hDlg,
                   "L' enorme meccanico ti affera con una sola mano, ti riempe di pugni, e non esita a scaraventare te ed il tuo motorino fuori dall' officina.",
                   "Non hai abbastanza soldi", MB_OK | MB_ICONSTOP);
    }
    else {
        MessageBox( hDlg,
                   "Con un sonoro calcio nel culo, vieni buttata fuori dall' officina.",
                   "Non hai abbastanza soldi", MB_OK | MB_ICONSTOP);
    }
}

void MessageBox_FuoriDalMioLocale(HANDLE hDlg) {
    sprintf(tmp,"Fai fuori dal mio locale, brut%c pezzente !, esclama il tabaccaio con un AK 47 in mano...",ao);
    MessageBox( hDlg, tmp,
               "Non hai abbastanza soldi...", MB_OK | MB_ICONSTOP);
}

void MessageBox_NonTiSeiAccortoDiNonAvareSoldi(HANDLE hDlg) {
    sprintf(tmp,"Forse non ti sei accorto di non avere abbastanza soldi, stronzett%c...",ao);
    MessageBox( hDlg, tmp,
               "Non hai abbastanza soldi...", MB_OK | MB_ICONSTOP);
}

void MessageBox_TroviICancelliInrimediabilmenteChiusi(HANDLE hDlg) {
    sprintf(tmp,"Arrivat%c davanti ai cancelli della ditta li trovi inrimediabilmente chiusi...",ao);
    MessageBox( hDlg, tmp, "Cerca Lavoro", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ForseNonTiRicordiCheHaiGiaUnLavoro(HANDLE hDlg) {
    MessageBox( hDlg,
               "Forse non ti ricordi che hai gia' un lavoro...",
               "Cerca Lavoro", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_AlloraSparisci(HANDLE hDlg) {
    MessageBox( hDlg,
               "Allora sparisci...",
               "Cerca Lavoro", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_PercheDovremmoAssumereChiNonSaMettereCrocette(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg, "Mi spieghi perche' dovremmo assumere qualcuno che non e' neanche in grado di mettere delle crocette su un foglio ???", "Sei un po' stupido...", MB_OK | MB_ICONQUESTION);
    else
        MessageBox( hDlg, "Signorina,mi spieghi perche' dovremmo assumere qualcuno che non e' neanche in grado di mettere delle crocette su un foglio ???", "Sei un po' stupida...", MB_OK | MB_ICONQUESTION);
}

void MessageBox_SeiStatoAssunto(HANDLE hDlg, NSString * nome) {
    if (sesso == 'M')
        sprintf(tmp, "SEI STATO ASSUNTO ! Ora sei un felice dipendente della %s !", nome.UTF8String);
    else
        sprintf(tmp, "SEI STATO ASSUNTA ! Ora sei una felice dipendente della %s !", nome.UTF8String);
    
    MessageBox( hDlg, tmp, "Hai trovato lavoro !", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_NonSeiRiuscitoASuperareIlTest(HANDLE hDlg) {
    if (sesso == 'M')
        MessageBox( hDlg,
                   "Mi dispiace ragazzo, ma non sei riuscito a superare il test... Ora puoi anche portare la tua brutta faccia fuori dal mio ufficio, prima che ti faccia buttare fuori a calci... Grazie e arrivederci...",
                   "Cerca Lavoro", MB_OK | MB_ICONINFORMATION);
    else
        MessageBox( hDlg,
                   "Mi dispiace signorina, ma non e' riuscito a superare il test... Se ne vada immediatamente, grazie...",
                   "Cerca Lavoro", MB_OK | MB_ICONINFORMATION);
}

int MessageBox_VuoiDareLeDimissioni(HANDLE hDlg, NSString * ditta) {    
    sprintf(tmp,"Sei proprio sicur%c di voler dare le dimissioni dalla %s ?",ao,LavoroMem[numeroditta].nome.UTF8String);
    return MessageBox( hDlg,
                      tmp,
                      "Licenziati", MB_YESNO | MB_ICONQUESTION);
}

void MessageBox_ForsePotremmoDartiQualcosina(HANDLE hDlg) {
    sprintf(tmp,"Forse per questa volta potremmo darti qualcosina in piu'...");
    MessageBox( hDlg, tmp,
               "Chiedi aumento salario", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_VediDiScordartelo(HANDLE hDlg) {
    sprintf(tmp,"Forse per questa volta potremmo darti qualcosina in piu'...");
    MessageBox( hDlg, tmp,
               "Chiedi aumento salario", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_EventiPalestra(HANDLE hDlg, int evento) {
    LoadString(hInst, (1100 + evento), (LPSTR)tmp, 255);
    MessageBox( hDlg,
               (LPSTR)tmp,
               "Palestra...", MB_OK | MB_ICONSTOP);
}

int MessageBox_PerTantoPotreiDimenticare(HANDLE hDlg, int i) {
    sprintf(tmp,"Ma... forse per %s potrei dimenticare i tuoi ultimi compiti in classe...", MostraSoldi(i) );
    return MessageBox( hDlg, tmp,
                  "Corrompi i professori", MB_YESNO | MB_ICONQUESTION);

}

void MessageBox_ConQualeScooterVorrestiGarggiare(HANDLE hDlg) {
    MessageBox( hDlg,
               "Con quale scooter vorresti gareggiare, visto che non lo possiedi ?",
               "Gareggia con lo scooter", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_PurtroppoNonPuoiGareggiareVistoCheLoScooterE(HANDLE hDlg, NSString * attivita) {
    sprintf(tmp, "Purtroppo non pui gareggiare visto che il tuo scooter e' %s.", attivita.UTF8String);
    MessageBox(hDlg, tmp, "Gareggia con lo scooter", MB_OK | MB_ICONINFORMATION);
}

int MessageBox_AccettiLaSfidaDi(HANDLE hDlg, NSString * scooter) {
    sprintf(tmp,"Accetti la sfida con un tabbozzo che ha un %s ?", scooter.UTF8String);
    return MessageBox( hDlg,
                      tmp,
                      "Gareggia con lo scooter", MB_YESNO | MB_ICONQUESTION);
}

void MessageBox_DopoPochiMetriSiVedeLInferiorita(HANDLE hDlg) {
    MessageBox( hDlg,
               "Dopo pochi metri si vede l' inferiorita' del tuo scooter...",
               "Hai perso", MB_OK | MB_ICONSTOP);

}

void MessageBox_BruciInPartenza(HANDLE hDlg) {
    MessageBox( hDlg,
               "Con il tuo scooter, bruci l' avversario in partenza...",
               "Hai vinto", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ConLaScarsaReputazioneTuttiTrovanoDiMeglio(HANDLE hDlg) {
    MessageBox( hDlg,
               "Con la scarsa reputazione che hai, tutti trovano qualcosa di meglio da fare piuttosto che venire.",
               "Chiama la Compagnia", MB_OK | MB_ICONSTOP);
    
}

void MessageBox_ChiTiHaPicchiatoNonSiFaraVedere(HANDLE hDlg) {
    MessageBox( hDlg,
               "Dopo aver visto i tuoi amici, chi ti ha picchiato non si fara' piu' vedere in giro x un bel pezzo...",
               "Chiama la Compagnia", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_AncheITuiAmiciVengonoScacagnati(HANDLE hDlg) {
    MessageBox( hDlg,
               "Anche i tuoi amici, al gran completo, vengono sacagnati di botte da chi ti aveva picchiato, accorgendosi cosi' che non sei solo tu ad essere una chiavica, ma lo sono anche loro...",
               "Chiama la Compagnia", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_VistoCheNonCeNessunoTuttiSeNeVanno(HANDLE hDlg) {
    MessageBox( hDlg,
               "Visto che non c'e' nessuno da minacciare, tutti se ne vanno avviliti...",
               "Chiama la Compagnia (perche'?)", MB_OK | MB_ICONSTOP);
}

void MessageBox_PerIlTuoVecchioScooterTiDiamoSupervalutazione(HANDLE hDlg, const char * soldi) {
    sprintf(tmp,"Per il tuo vecchio scooter da rottamare ti diamo %s di supervalutazione...", soldi);
    MessageBox( hDlg,
               tmp,
               "Incentivi", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_TiPiacerebbeComprareLoScooter(HANDLE hDlg) {
    MessageBox( hDlg,
               "Ti piacerebbe comprare lo scooter, vero ?\nPurtroppo, non hai abbastanza soldi...",
               "Non hai abbastanza soldi", MB_OK | MB_ICONSTOP);
}

void MessageBox_FaiUnGiroPerFartiVedere(HANDLE hDlg) {
    MessageBox( hDlg,
               "Fai un giro del quartiere per farti vedere con lo scooter nuovo...",
               "Lo scooter nuovo", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_MaQualeScooterVendi(HANDLE hDlg) {
    MessageBox( hDlg,
               "Scusa, ma quale scooter avresti intenzione di vendere visto che non ne hai neanche uno ???",
               "Vendi lo scooter", MB_OK | MB_ICONQUESTION);
}

int MessageBox_TiPossoDare(HANDLE hDlg, NSInteger offerta) {
    sprintf(tmp,"Ti posso dare %s per il tuo telefonino... vuoi vendermelo ?",MostraSoldi(offerta));
    return MessageBox( hDlg,
                      tmp,
                      "Telefonino", MB_YESNO | MB_ICONQUESTION);
}

void MessageBox_AlloraVaiAFartiFottere(HANDLE hDlg) {
    MessageBox( hDlg,
               "Allora vai a farti fottere, pirletta !",
               "Telefonino", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_CheTelefoninoVuoiVendere(HANDLE hDlg) {
    MessageBox( hDlg,
               "Che telefonino vuoi vendere, pirletta ?",
               "Telefonino", MB_OK | MB_ICONINFORMATION);
}

int MessageBox_VuoiComperareUnMeravigliosoVestitoNatalizio(HANDLE hDlg, NSInteger soldi) {
    sprintf(tmp,"Vuoi comperare, per %s, un meraviglioso vestito da Babbo Natale ?",MostraSoldi(soldi));
    return MessageBox( hDlg,
                      tmp,
                      "Offerte Natalizie...", MB_YESNO | MB_ICONQUESTION);
}

void MessageBox_IlConcessionarioEChiuso(HANDLE hDlg, const char * titolo) {
    sprintf(tmp,"Oh, tip%c... oggi il concessionario e' chiuso...",ao);
    MessageBox( hDlg,
               tmp,
               titolo, MB_OK | MB_ICONINFORMATION);
}

void MessageBox_MaQualeScooterAvrestiIntenzioneDiTruccare(HANDLE hDlg) {
    MessageBox( hDlg,
               "Scusa, ma quale scooter avresti intenzione di truccare visto che non ne hai neanche uno ???",
               "Trucca lo scooter", MB_OK | MB_ICONQUESTION);
}

void MessageBox_CheMotiviHaiPerVolerRiparareLoScooter(HANDLE hDlg) {
    MessageBox( hDlg,
               "Che motivi hai per voleer riparare il tuo scooter\nvisto che e' al 100% di efficienza ???",
               "Ripara lo scooter", MB_OK | MB_ICONQUESTION);
}

void MessageBox_ComeFaiAFartiRiparareLoScooterSeNonLoHai(HANDLE hDlg) {
    MessageBox( hDlg,
               "Mi spieghi come fai a farti riparare lo scooter se non lo hai ???",
               "Ripara lo scooter", MB_OK | MB_ICONQUESTION);
}

void MessageBox_IlMeccanicoEChiuso(HANDLE hDlg) {
    sprintf(tmp,"Oh, tip%c... oggi il meccanico e' chiuso...",ao);
    MessageBox( hDlg,
               tmp,
               "Ripara lo scooter", MB_OK | MB_ICONINFORMATION);
}

void MessageBox_ComeFaiAParcheggiareLoScooterSeNonLoHai(HANDLE hDlg) {
    MessageBox( hDlg,
               "Mi spieghi come fai a parcheggiare lo scooter se non lo hai ???",
               "Parcheggia lo scooter", MB_OK | MB_ICONQUESTION);
}

void MessageBox_ComeFaiAParcheggiareLoScooterVistoCheE(HANDLE hDlg, const char * attivita) {
    sprintf(tmp, "Mi spieghi come fai a parcheggiare lo scooter visto che e' %s ???", attivita);
    MessageBox(hDlg,
               tmp,
               "Parcheggia lo scooter", MB_OK | MB_ICONQUESTION);
}

void MessageBox_ComeFaiAFarBenzinaAlloScooterSeNonLoHai(HANDLE hDlg) {
    MessageBox( hDlg,
               "Mi spieghi come fai a far benzina allo scooter se non lo hai ???",
               "Fai benza", MB_OK | MB_ICONQUESTION);
}

void MessageBox_AlDistributorePuoiFareUnMinimoDi(HANDLE hDlg, const char * soldi) {
    sprintf(tmp,
            "Al distributore automatico puoi fare un minimo di %s di benzina...",
            soldi);
    
    MessageBox(hDlg,
               tmp,
               "Fai benza", MB_OK | MB_ICONQUESTION);
}

void MessageBox_FaiBenzaERiempi(HANDLE hDlg, const char * soldi) {
    sprintf(tmp,
            "Fai %s di benzina e riempi lo scooter...",
            MostraSoldi(10));
    
    MessageBox(hDlg,
               tmp,
               "Fai benza", MB_OK | MB_ICONINFORMATION);
}
