// Tabboz Simulator
// Copyright (c) 1997-2000 Andrea Bonomi

/*
	 This file is part of Tabboz Simulator.

	 Tabboz Simulator is free software: you can redistribute it and/or modify
	 it under the terms of the GNU General Public License as published by
	 the Free Software Foundation, either version 3 of the License, or
	 (at your option) any later version.

	 Nome-Programma is distributed in the hope that it will be useful,
	 but WITHOUT ANY WARRANTY; without even the implied warranty of
	 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 GNU General Public License for more details.

	 You should have received a copy of the GNU General Public License
	 along with Nome-Programma.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "os.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "zarrosim.h"
#ifdef TABBOZ_WIN
#ifndef NONETWORK
#include "net.h"
#endif
#endif

__attribute__((unused)) static char sccsid[] = "@(#)" __FILE__ " " VERSION " (Andrea Bonomi) " __DATE__;

extern void	  Atinom(HANDLE hInstance);
extern int	  vvc(int i);		/* 15 Giugno 1998 - v0.7.1 - Verifica Valori Chiave */
extern u_long new_counter;
extern ATOM RegisterBMPTipaClass(HANDLE hInst);
extern ATOM RegisterBMPViewClass(HANDLE hInst);
extern char nome_del_file_su_cui_salvare[];
extern void OpenFileDlg(HWND hwnd);
extern void SaveFileDlg(HWND hwnd);
static void SalvaTutto(void);
static void CaricaTutto(void);

#define ScooterData Tabboz.global.scooter

// PRIMA LE VARIABILI GENERIKE...

int    cheat;
int    scelta;
char   Andrea[14];
char   Caccia[21];
char   Daniele[17];
char	 Obscured[29];
int	 firsttime;	   /* 29 Novembre 1998 - 0.8.1pr */
int	 ImgSelector;	/* 25 Febbraio 1999 - 0.8.3pr */
int	 TabbozRedraw;	/* 26 Febbraio 1999 - 0.8.3pr */
int	 ScuolaRedraw;	/* 27 Febbraio 1999 - 0.8.3pr */
// DOPO LE CARATTERISTIKE

u_long Paghetta;       // Paghetta Settimanale...
char   Nome[30];		  // Nome del Tabbozzo
char   Cognome[30];	  // Cognome del Tabbozzo ( 3 Marzo 1998 - 0.5.6a )
char	 City[50];	     // Citta' di nascita
char   Residenza[50];  // Citta' dove vive ( 11 Marzo 2000 - 0.9.0beta
char	 Street[50];	  // Dove sto' tipo abita ( 4 Marzo 1998 - 0.5.6a )
u_long DDP;				  // Due di picche (log...) - long,sono ottimista...
int	 Tempo_trascorso_dal_pestaggio; //      ( 12 Giugno 1998 - 0.6.98a )
int	 current_testa;

int	 timer_active;
int	 fase_di_avvio;
int	 sound_active;		/* 1 Marzo 1999 */

// #define WIN_PICCOLO SW_MINIMIZE
// #define WIN_PICCOLO SW_SHOWMINIMIZED
#define WIN_PICCOLO SW_HIDE
#define WIN_GRANDE  SW_SHOWNORMAL

// Questo serve se e' attivo il debug...

#ifdef TABBOZ_DEBUG                	// 12 Giugno 1998
FILE	*debugfile;
int	debug_active;						// 22 Giugno 1998
#endif

#ifndef NONETWORK
extern  WSADATA     Data;
extern  SOCKADDR_IN serverSockAddr;
extern  SOCKADDR_IN clientSockAddr;
extern  SOCKET 	  serverSocket;
extern  SOCKET 	  clientSocket;
extern  int         PortNumber;
HANDLE hModule;
#endif

HANDLE    hInst;                    // hInstance dell'applicazione
HWND      hWndMain;                 // hWnd della finestra principale

int	    euro;
char		 sesso;
char		 ao;
char  	 un_una[4];

static 	 int  t_random;	      	// Attesa a random tra i vari eventi timer
static 	 int  STARTcmdShow;

static	 char boolean_shutdown;


//*******************************************************************
// Calcola Sesso 29 Maggio 1999 - Maschietto o Femminucica
//*******************************************************************

static void CalcolaSesso(void)
{
	if ( sesso == 'M' ) {
		ao='o';
		strcpy(un_una,"un");
	} else {
		ao='a';
		strcpy(un_una,"una");
		}
}

//*******************************************************************
// ResetMe  26 Marzo 1999 - Reset del Tabboz Simulator
//*******************************************************************

void ResetMe(int primavolta)
{
char  tmp[128];

		TabbozRedraw 		=  1;
		Paghetta				= 30;

		strcpy(Residenza,"Milano");

		LoadString(hInst, (400 + random(22) ), City, (sizeof(City)-1));

		LoadString(hInst, (450 + random(50) ), tmp, (sizeof(tmp)-1));
		sprintf(Street,"%s n. %d",tmp,(1 + random(150)));

        [Tabboz initGlobalTabboz];
    
		if (primavolta) { // Se e' la prima volta che uso il tabboz resetta anche la configurazione...
			STARTcmdShow		=  1;
			timer_active		=  1;
			sound_active		=  1;
			euro					=  0;
			sesso					= 'M';
			strcpy(Nome,"Tizio");
			strcpy(Cognome,"Caio");
			CalcolaSesso();
			}

		if (sesso == 'F') {
			strcpy(Nome,"Nessuna");
			strcpy(Cognome,"In Particolare");
			}

		current_testa     =  0;

#ifndef NONETWORK
		net_enable			=  1;
		PortNumber			= 79;
#endif

}

//*******************************************************************
// Formattazione iniziale Tabbozzo (scelta sesso, nome...) 14-01-2000
//*******************************************************************

#pragma argsused
BOOL FAR PASCAL FormatTabboz(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
static char tmpsesso;

	 if (message == WM_INITDIALOG) {
			if (firsttime == 1) EnableWindow( GetDlgItem(hDlg,2), 0);;

			SendMessage(GetDlgItem(hDlg, 102), BM_SETCHECK, TRUE, 0L);
			if (random(2) == 1) tmpsesso='M'; else tmpsesso='F';

//			sprintf(buf,"prova");
//			SendMessage(GetDlgItem(hDlg, 110), CB_ADDSTRING, 0, t);

			return(TRUE);
			}

	 if (message == WM_COMMAND) {
			switch (LOWORD(wParam))	{
				case 100: tmpsesso = 'M';
							 break;
				case 101: tmpsesso = 'F';
							 break;
				case 102: if (random(2) == 1) tmpsesso='M'; else tmpsesso='F';
							 break;

				case IDOK:
					ResetMe(0);
					sesso=tmpsesso;
					CalcolaSesso();
					EndDialog(hDlg, TRUE);
					return(TRUE);

				case IDCANCEL:
					if (firsttime == 1) {
						sesso=tmpsesso;
						CalcolaSesso();
						EndDialog(hDlg, TRUE);
					}
					EndDialog(hDlg, TRUE);
					return(TRUE);

				default:
					return(TRUE);
			}
	 }

	 return(FALSE);
}

//*******************************************************************
// InitTabboz
//*******************************************************************
#pragma argsused
void InitTabboz(void)
{
	 char       tmp[128];
#ifdef TABBOZ_WIN
	 // Init della liberia grafica...
	 BWCCRegister(hInst); // Fanculo ! Mi sono magiato il fegato prima di trovare
	 // questa funzione ! non c'e' nessuno documento fottuto che mi abbia aiutato !
#endif

    [Tabboz initGlobalTabboz];
    
	 nome_del_file_su_cui_salvare[0]=0;

	 // Inizializzazione dei numeri casuali...
	 randomize();

	 // Inizializza un po' di variabile...
	 boolean_shutdown=0;		  /* 0=resta dentro, 1=uscita, 2=shutdown 19 Giugno 1999 / 14 Ottoble 1999 */


    ImgSelector=0;              /* W l' arte di arrangiarsi...  */
	 timer_active=1;             			 /* 10 Giugno  1998 */
	 fase_di_avvio=1;				 		    /* 11 Giugno  1998 */
	 Tempo_trascorso_dal_pestaggio=0;    /* 12 Giugno  1998 */

#ifdef PROMPT_ACTIVE
/* definitivamente rimosso il 		   10 Gennaio 1999 */
	prompt_mode=0;					  	   /* 15 Maggio  1998 */
#endif

#ifndef NONETWORK
	 Data.wVersion=0;			             /* 25 Giugno  1998 */
#endif

#ifdef TABBOZ_DEBUG

	 debug_active=atoi (RRKey("Debug"));

	 if (debug_active < 0) debug_active=0;

	 if (debug_active == 1) {
		 openlog();
		 sprintf(tmp,"tabboz: Starting Tabboz Simulator %s %s",VERSION,__DATE__);
		 writelog(tmp);
		 }
#endif

#ifdef TABBOZ_WIN
	 // Ottieni i nomi dei creatori di sto coso...
	 LoadString(hInst, 10, Andrea,   sizeof(Andrea));
	 LoadString(hInst, 11, Caccia,   sizeof(Caccia));
	 LoadString(hInst, 12, Daniele,  sizeof(Daniele));
	 LoadString(hInst,  2, Obscured, sizeof(Obscured));

	 /* Registra la Classe BMPView - E' giusto metterlo qui ??? - 25 Feb 1999 */
	 RegisterBMPViewClass(hInst);

	 /* Registra la Classe BMPTipa - 6 Maggio 1999 */
	 RegisterBMPTipaClass(hInst);

#ifndef NONETWORK
	 /* Azzera l' ultima connessione dalla rete */
	 sprintf(lastconnect,"none (Server is Down !)");
	 sprintf(lastneterror,"Network Server is Down");
#endif
#endif

	 firsttime=0;
	 CaricaTutto();
#ifdef TABBOZ_WIN
 // 15 Gen 1999 - Parametro 'config' sulla linea di comando
 // 12 Mar 1999 - A causa di un riordino generale, e' stata spostata qui...

	 if (_argc > 1)
		 if (! strcmp(_argv[1],"config") ) {
			 hWndMain = 0; // Segnala che non esiste proc. principale.
             __auto_type lpproc = MakeProcInstance(Configuration, hInst);
			 DialogBox(hInst,MAKEINTRESOURCE(CONFIGURATION),NULL,lpproc);
			 FineProgramma("config");
			 exit(0);
			 }

// 15 Mar 1998 - Ora mostra anche il logo iniziale
// 12 Mar 1999 - A causa di un riordino generale, e' stata spostata qui...

	 if (STARTcmdShow)
         [Tabboz showLogo];

// 14 Gen 1999 - Formattazione iniziale Tabbozzo
	 if (firsttime == 1)
         [Tabboz showFormatTabboz];

#endif
}


//*******************************************************************
//  Carica le caratteristiche dal registro o da un file...
//*******************************************************************

static void CaricaTutto(void)
{
#ifdef TABBOZ_PERSISTANCE
	 char       tmp[128];
	 int			i;

	 /* Prima che vengano caricate le informazioni... */
	 /* azzera il checksum... 15 Marzo 1999	        */
	 new_reset_check();

	 /* Cerca le informazioni registrate */

	 Soldi=new_check_l(atol(RRKey("Soldi")));	// ATOL, visto che Soldi e' un LONG, non un semplice INT

	 Paghetta=new_check_l(atol(RRKey("Paghetta")));

	 Reputazione=vvc(new_check_i(atoi (RRKey("Reputazione")) ));

	 Studio=vvc(new_check_i(atoi (RRKey("Studio")) ));

	 Fama=vvc(new_check_i(atoi (RRKey("Fama")) ));

	 Rapporti=vvc(new_check_i(atoi (RRKey("Rapporti")) ));

	 Stato=vvc(new_check_i(atoi (RRKey("Stato")) ));

	 DDP=new_check_l(atol(RRKey("DdP"))); // ATOL, visto che e' un LONG, non un semplice INT

	 FigTipa=vvc(new_check_i(atoi (RRKey("FigTipa"))));

	 if (TabbozReadKey("Nome",Nome)         == 0) Nome[0]='\0';
	 if (TabbozReadKey("Cognome",Cognome)   == 0) Cognome[0]='\0';
	 if (TabbozReadKey("Nometipa",Nometipa) == 0) Nometipa[0]='\0';

	 if (TabbozReadKey("City",City) == 0)
		firsttime=1;

	 TabbozReadKey("Residenza",Residenza);

	 TabbozReadKey("Street",Street);

	 // la serie di 9 "A" messe nella riga sotto NON E' CASUALE
	 // non sostituirla con altre lettere !

	 if (TabbozReadKey("Materie",tmp) 		 == 0) sprintf(tmp,"AAAAAAAAA");

	 for (i=1;i<10;i++) {
		MaterieMem[i].xxx=tmp[i-1] - 65;
		if ((MaterieMem[i].xxx < 0) || (MaterieMem[i].xxx > 10)) MaterieMem[i].xxx=0;
	 }
	 CalcolaStudio();

	 Fortuna=vvc(new_check_i(atoi(RRKey("Fortuna")) ));

	 // Se e' la prima volta che parte il Tabboz Simulator, la data e' impostata al 30 Settembre
	 x_mese=atoi (RRKey("Mese")); if (x_mese < 1) x_mese=9;
	 x_giorno=atoi (RRKey("Giorno")); if (x_giorno < 1) x_giorno=30;
	 x_giornoset=atoi (RRKey("GiornoSet")); if (x_giornoset < 1) x_giornoset=1;
	 x_anno_bisesto=atoi (RRKey("AnnoBisestile")); if (x_anno_bisesto > 3) x_anno_bisesto=3;

	 // Se non e' gia' settato,setta il compleanno
	 comp_mese=atoi (RRKey("CompMese"));
	 if (comp_mese < 1)   comp_mese=random(12)+1;

	 comp_giorno=atoi (RRKey("CompGiorno"));
	 if (comp_giorno < 1) comp_giorno=random(InfoMese[comp_mese-1].num_giorni)+1;

	 numeroditta     = vvc(atoi (RRKey("NumeroDitta")) );
	 scad_pal_giorno = vvc(atoi (RRKey("ScadPalGiorno")) );
	 scad_pal_mese   = vvc(atoi (RRKey("ScadPalMese")) );

	 impegno	 = vvc(new_check_i(atoi (RRKey("Impegno")) ));
	 giorni_di_lavoro	 = vvc(new_check_i(atoi (RRKey("GiorniDiLavoro")) ));
	 stipendio	 = new_check_i(atoi (RRKey("Stipendio")));
	 if (stipendio < 0) stipendio=0;

	 sizze	 = new_check_i(atoi (RRKey("Sigarette")));
	 if (sizze < 0) sizze=0;

	 current_testa =     vvc(new_check_i(atoi (RRKey("Testa")) ));
	 current_gibbotto =  vvc(new_check_i(atoi (RRKey("Giubbotto")) ));
	 current_pantaloni = vvc(new_check_i(atoi (RRKey("Pantaloni")) ));
	 current_scarpe =    vvc(new_check_i(atoi (RRKey("Scarpe")) ));

	 euro 	 = atoi (RRKey("Euro"));
	 if (euro < 0) {
		euro=0;
	 }

#ifdef NOTABBOZZA
	 sesso='M';
#else
	 strcpy(tmp,(RRKey("Sesso")));
	 sesso=tmp[0];
	 if ((sesso != 'M') && (sesso != 'F')) sesso = 'M';
#endif

	 CalcolaSesso();

	 STARTcmdShow = atoi (RRKey("STARTcmdShow"));
	 if (STARTcmdShow < 0) STARTcmdShow =1;

	 timer_active = atoi (RRKey("TimerActive"));
	 if (timer_active < 0) timer_active=1;

	 sound_active = atoi (RRKey("SoundActive"));
	 if (sound_active < 0) sound_active=1;

#ifndef NONETWORK
	 net_enable   = atoi (RRKey("NetEnable"));
	 if (net_enable < 0) net_enable=1;
	 PortNumber   = atoi (RRKey("NetPort"));
	 if (PortNumber < 1) PortNumber=79;
#endif


	 ScooterData.speed	    = new_check_i(atoi (RRKey("Scooter\\Speed")));
	 if (ScooterData.speed < 0) ScooterData.speed=0;
	 ScooterData.marmitta    = new_check_i(atoi (RRKey("Scooter\\Marmitta")));
	 if (ScooterData.marmitta < 0) ScooterData.marmitta=0;
	 ScooterData.carburatore = new_check_i(atoi (RRKey("Scooter\\Carburatore")));
	 if (ScooterData.carburatore < 0) ScooterData.carburatore=0;
	 ScooterData.cc	    = new_check_i(atoi (RRKey("Scooter\\CC")));
	 if (ScooterData.cc < 0) ScooterData.cc=0;
	 ScooterData.filtro	    = new_check_i(atoi (RRKey("Scooter\\Filtro")));
	 if (ScooterData.filtro < 0) ScooterData.filtro=0;
	 ScooterData.prezzo	    = new_check_i(atoi(RRKey("Scooter\\Prezzo")));
	 if (ScooterData.prezzo < 0) ScooterData.prezzo=0;
	 ScooterData.attivita    = new_check_i(atoi(RRKey("Scooter\\Attivita")));
	 if (ScooterData.attivita < 0) ScooterData.attivita=0;

	 ScooterData.stato	    = new_check_i(atoi(RRKey("Scooter\\Stato"))); /* -1 = nessuno */

	 benzina		    = new_check_i(atoi(RRKey("Scooter\\Benzina")));
	 if (benzina < 0) benzina=0;

/*  antifurto		    = atoi (RRKey("Scooter\\Antifurto") ); */

	 if (TabbozReadKey("Scooter\\Nome",ScooterData.nome) == 0) sprintf(ScooterData.nome,"nessuno");

	//  Cellulare ----------------------

	 AbbonamentData.dualonly = new_check_i(atoi (RRKey("Cellular\\DualOnly")));
	 AbbonamentData.creditorest = new_check_i(atoi (RRKey("Cellular\\CreditoRest")));
	 if (TabbozReadKey("Cellular\\NomeAbb",AbbonamentData.nome) == 0) AbbonamentData.creditorest= -1;

	 CellularData.dual = new_check_i(atoi (RRKey("Cellular\\DualBand")));
	 CellularData.stato = new_check_i(atoi (RRKey("Cellular\\Stato")));
	 CellularData.prezzo = new_check_i(atoi (RRKey("Cellular\\Prezzo")));
	 if (TabbozReadKey("Cellular\\Nome",CellularData.nome) == 0) CellularData.stato = -1;

	 if (firsttime) /* 29 Novembre 1998 */
		 ResetMe(1);


	 /* Controllo eventuali errori nella data (o data non settata...) */
	 if (x_giorno < 1)  	 x_giorno=1;
	 if (x_giorno > 31) 	 x_giorno=1;
	 if (x_mese < 1)  	 x_mese=1;
	 if (x_mese > 12) 	 x_mese=1;
	 if (x_giornoset < 1) x_giornoset=1;
	 if (x_giornoset > 7) x_giornoset=1;

	 x_giorno--; /* Per evitare che avanzi di giorno ogni volta che si apre il programma */
	 x_giornoset--;
	 Giorno(hInst);

#ifdef TABBOZ_DEBUG
// Non si possono mettere le infomazioni del counter nel file di log
// perche' sarebbe facilissimo hackerale...
//	 sprintf(tmp,"tabboz: (R) new_counter %lu", new_counter);
//	 writelog(tmp);
//	 sprintf(tmp,"tabboz: (R) read_counter %lu", atoi(RRKey("SoftCheck")) );
//	 writelog(tmp);
#endif

	// ven 10 marzo 2000
	// Guarda se qualche "bastardino" ha modificato dei valori nel registro...
	if (new_counter - atoi(RRKey("SoftCheck")))
		ResetMe(0);

#endif
}


//*******************************************************************
//      Fine Programma
//*******************************************************************
void FineProgramma(char *caller)
{
	 char tmp[128];

#ifdef TABBOZ_DEBUG
	 sprintf(tmp,"tabboz: FineProgramma chiamato da <%s>",caller);
	 writelog(tmp);
#endif

#ifndef NONETWORK
	 if (net_enable == 1) {
		 WSACleanup();
#ifdef TABBOZ_DEBUG
		 writelog("tabboz: WSACleanup()");
#endif
		 }
#endif

	 if (nome_del_file_su_cui_salvare[0] == 0) {
		 /* Salva lo stato del tabbozzo */
		 /* 0.8.1pr 29 Novembre 1998 Ora non salva piu' nel WIN.INI con WriteProfileString,
		 ma salva nel registro di configurazione... */
		 TabbozAddKey("Exe", _argv[0]);
	 }

	 SalvaTutto();
}

//*******************************************************************
//      Salva le caratteristiche nel registro o su di un file
//*******************************************************************

static void SalvaTutto(void) {
    
#ifdef TABBOZ_PERSISTANCE
    
	 char tmp[128];
	 int i;

	 new_reset_check();

	 sprintf(tmp,"%lu",new_check_l(Soldi));
	 TabbozAddKey("Soldi", tmp);

	 sprintf(tmp,"%lu",new_check_l(Paghetta));
	 TabbozAddKey("Paghetta", tmp);

	 sprintf(tmp,"%d",new_check_i(Reputazione));
	 TabbozAddKey("Reputazione", tmp);

	 sprintf(tmp,"%d",new_check_i(Studio));
	 TabbozAddKey("Studio", tmp);

	 sprintf(tmp,"%d",new_check_i(Fama));
	 TabbozAddKey("Fama", tmp);

	 sprintf(tmp,"%d",new_check_i(Rapporti));
	 TabbozAddKey("Rapporti", tmp);

	 sprintf(tmp,"%d",new_check_i(Stato));
	 TabbozAddKey("Stato", tmp);

	 sprintf(tmp,"%lu",new_check_l(DDP));
	 TabbozAddKey("DdP", tmp);

	 sprintf(tmp,"%d",new_check_i(FigTipa));
	 TabbozAddKey("FigTipa", tmp);

	 TabbozAddKey("Nome", Nome);
	 TabbozAddKey("Cognome", Cognome);
	 TabbozAddKey("Nometipa", Nometipa);
	 TabbozAddKey("City", City);
	 TabbozAddKey("Residenza", Residenza);
	 TabbozAddKey("Street", Street);

	 sprintf(tmp,"123456789");	// 9 materie
	 for (i=1;i<10;i++) {
					 tmp[i-1]=(char)(65 + MaterieMem[i].xxx);
	 }

	 TabbozAddKey("Materie", tmp);

	 sprintf(tmp,"%d",new_check_i(Fortuna));
	 TabbozAddKey("Fortuna", tmp);

	 sprintf(tmp,"%d",x_mese);
	 TabbozAddKey("Mese", tmp);
	 sprintf(tmp,"%d",x_giorno);
	 TabbozAddKey("Giorno", tmp);
	 sprintf(tmp,"%d",x_giornoset);
	 TabbozAddKey("GiornoSet", tmp);
	 sprintf(tmp,"%d",x_anno_bisesto);
	 TabbozAddKey("AnnoBisestile",tmp);

	 sprintf(tmp,"%d",comp_mese);
	 TabbozAddKey("CompMese", tmp);
	 sprintf(tmp,"%d",comp_giorno);
	 TabbozAddKey("CompGiorno", tmp);

	 sprintf(tmp,"%d",numeroditta);
	 TabbozAddKey("NumeroDitta", tmp);
	 sprintf(tmp,"%d", scad_pal_giorno);
	 TabbozAddKey("ScadPalGiorno", tmp);
	 sprintf(tmp,"%d",scad_pal_mese);
	 TabbozAddKey("ScadPalMese", tmp);

	 sprintf(tmp,"%d",new_check_i(impegno));
	 TabbozAddKey("Impegno", tmp);
	 sprintf(tmp,"%d",new_check_i(giorni_di_lavoro));
	 TabbozAddKey("GiorniDiLavoro", tmp);
	 sprintf(tmp,"%d",new_check_i(stipendio));
	 TabbozAddKey("Stipendio", tmp);

	 sprintf(tmp,"%d",new_check_i(sizze));
	 TabbozAddKey("Sigarette", tmp);

	 sprintf(tmp,"%d",new_check_i(current_testa));
	 TabbozAddKey("Testa", tmp);

	 sprintf(tmp,"%d",new_check_i(current_gibbotto));
	 TabbozAddKey("Giubbotto", tmp);

	 sprintf(tmp,"%d",new_check_i(current_pantaloni));
	 TabbozAddKey("Pantaloni", tmp);

	 sprintf(tmp,"%d",new_check_i(current_scarpe));
	 TabbozAddKey("Scarpe", tmp);

	 sprintf(tmp,"%d",euro);
	 TabbozAddKey("Euro", tmp);

	 sprintf(tmp,"%d",STARTcmdShow);
	 TabbozAddKey("STARTcmdShow", tmp);

	 sprintf(tmp,"%d",timer_active);
	 TabbozAddKey("TimerActive", tmp);

	 sprintf(tmp,"%d",sound_active);
	 TabbozAddKey("SoundActive", tmp);

#ifndef NOTABBOZZA
	 sprintf(tmp,"%c",sesso);
	 TabbozAddKey("Sesso", tmp);
#endif

#ifndef NONETWORK
	 sprintf(tmp,"%d",net_enable);
	 TabbozAddKey("NetEnable", tmp);
	 sprintf(tmp,"%d",PortNumber);
	 TabbozAddKey("NetPort", tmp);
#endif

#ifdef TABBOZ_DEBUG
	 sprintf(tmp,"%d",debug_active);
	 TabbozAddKey("Debug", tmp);
#endif

	 sprintf(tmp,"%d",new_check_i(ScooterData.speed));
	 TabbozAddKey("Scooter\\Speed", tmp);
	 sprintf(tmp,"%d",new_check_i(ScooterData.marmitta));
	 TabbozAddKey("Scooter\\Marmitta", tmp);
	 sprintf(tmp,"%d",new_check_i(ScooterData.carburatore));
	 TabbozAddKey("Scooter\\Carburatore", tmp);
	 sprintf(tmp,"%d",new_check_i(ScooterData.cc));
	 TabbozAddKey("Scooter\\CC", tmp);
	 sprintf(tmp,"%d",new_check_i(ScooterData.filtro));
	 TabbozAddKey("Scooter\\Filtro", tmp);
	 sprintf(tmp,"%d",new_check_i(ScooterData.prezzo));
	 TabbozAddKey("Scooter\\Prezzo", tmp);
	 sprintf(tmp,"%d",new_check_i(ScooterData.attivita));
	 TabbozAddKey("Scooter\\Attivita", tmp);

	 sprintf(tmp,"%d",new_check_i(ScooterData.stato));
	 TabbozAddKey("Scooter\\Stato", tmp);

	 sprintf(tmp,"%d",new_check_i(benzina));
	 TabbozAddKey("Scooter\\Benzina", tmp);

/*  sprintf(tmp,"%d",antifurto);
	 TabbozAddKey("Scooter\\Antifurto", tmp); */

	 TabbozAddKey("Scooter\\Nome", ScooterData.nome);

	 sprintf(tmp,"%d",new_check_i(AbbonamentData.dualonly));
	 TabbozAddKey("Cellular\\DualOnly",tmp);
	 sprintf(tmp,"%d",new_check_i(AbbonamentData.creditorest));
	 TabbozAddKey("Cellular\\CreditoRest",tmp);

	 TabbozAddKey("Cellular\\NomeAbb",AbbonamentData.nome);

	 sprintf(tmp,"%d",new_check_i(CellularData.dual));
	 TabbozAddKey("Cellular\\DualBand",tmp);
	 sprintf(tmp,"%d",new_check_i(CellularData.stato));
	 TabbozAddKey("Cellular\\Stato",tmp);
	 sprintf(tmp,"%d",new_check_i(CellularData.prezzo));
	 TabbozAddKey("Cellular\\Prezzo",tmp);

	 TabbozAddKey("Cellular\\Nome",CellularData.nome);

	 sprintf(tmp,"%lu",new_counter);
	 TabbozAddKey("SoftCheck", tmp);

	 TabbozAddKey("Version", VERSION);

// #ifdef TABBOZ_DEBUG
//	 sprintf(tmp,"tabboz: (W) new_counter %lu", new_counter);
//	 writelog(tmp);
// #endif

#endif
    
}



/********************************************************************/
/* About...                                                         */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL About(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          buf[128];
	 char          tmp[128];

	 if (message == WM_INITDIALOG) {
		sprintf(tmp, "%s", Andrea);
		SetDlgItemText(hDlg, 110, tmp);
		sprintf(tmp, "%s", Caccia);
		SetDlgItemText(hDlg, 111, tmp);
		sprintf(tmp, "%s", Daniele);
		SetDlgItemText(hDlg, 112, tmp);

		sprintf(tmp, "%s, %s", VERSION,__DATE__);
		SetDlgItemText(hDlg, 115, tmp);

		sprintf(tmp, "%s", Obscured);	/* Obscured Truckware (se il nome e' diverso, crash ! ) */
		SetDlgItemText(hDlg, 116, tmp);

		cheat = 0;
		return(TRUE);


	} else if (message == WM_COMMAND) {
	switch (LOWORD(wParam))
	{
	   case IDOK:
		  EndDialog(hDlg, TRUE);
		  return(TRUE);
		case IDCANCEL:
		  EndDialog(hDlg, TRUE);
		  return(TRUE);

		case 203:
		case 113:
		  Atinom(hDlg);
		  return(TRUE);

		case 257:
		  cheat=cheat+1;
		  if (cheat >= 10) { /* Lunedi' 13 Aprile 1998 - Ora il trukko viene un attimo modificato... */

			sprintf(buf,"%s %s",Nome,Cognome);

			LoadString(hInst, 13, tmp, sizeof(tmp));  /* Dino... */
			if (! strcmp(tmp,buf)) {
                [Tabboz.global cheatDino];
			}

			LoadString(hInst, 14, tmp, sizeof(tmp));  /* Fratello di Dino... */
			if (! strcmp(tmp,buf)) {
                [Tabboz.global cheatFratelloDiDino];
			}

			if (! strcmp(Daniele,buf)) {	/* Murdock, ti regala una macchinina... */
                [Tabboz.global cheatDaniele];
			}

			if (! strcmp(Caccia,buf)) {	/* Caccia fa' aumentare i dindi... */
                [Tabboz.global cheatCaccia];
			}

			if (! strcmp(Andrea,buf)) {	/* Io porto la scuola e la tipa al 100% */
                [Tabboz.global cheatAndrea];
			}


			cheat = 0;
			}
	    default:
		return(TRUE);
	}
    }

	 return(FALSE);
}

/********************************************************************/
/* Logo...                                                          */
/********************************************************************/

# pragma argsused

BOOL FAR PASCAL Logo(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
int	x,y,w,h;

	if (message == WM_INITDIALOG) {

	if (sound_active) TabbozPlaySound(0);

	/* [[[ Posiziona il logo a centro dello schermo ]]] Veneedi' 17 Aprile 1998 */
	/* GetWindowRect(hDlg, (LPRECT) &wrect);                                    */
	/* w = wrect.right - wrect.left;                                            */
	/* h = wrect.bottom - wrect.top;					    */

	w = 522; /* dimensioni dell' immagine del logo */
	h = 402;

	x=GetSystemMetrics(SM_CXSCREEN);
	y=GetSystemMetrics(SM_CYSCREEN);

	x= (x - w) / 2;
	y= (y - h) / 2;

	MoveWindow(hDlg, x, y, w, h, 1);

	if ( fase_di_avvio == 1)
	    SetTimer(hDlg, WM_TIMER, 10000, NULL);	/* 10 Secondi */

	return(TRUE);
	}

    if (message == WM_TIMER) {
	if ( fase_di_avvio == 1) {
		KillTimer(hDlg, WM_TIMER);	     /* Distrugge il timer... */
		EndDialog(hDlg, TRUE);
		}
	}

	 if (message == WM_COMMAND) {
	switch (LOWORD(wParam))
	{
		 case IDOK:
		 case 202:
		 case 203:
		if ( fase_di_avvio == 1) {
			KillTimer(hDlg, WM_TIMER);
			}
		EndDialog(hDlg, TRUE);
		return(TRUE);
		 default:
		return(TRUE);
	}
	 }

	 return(FALSE);
}

/********************************************************************/
/* Spegnimi... 11 giugno 1998                                       */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Spegnimi(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
int	 x,y,w,h;
static RECT   wrect;

	 if (message == WM_INITDIALOG) {
		/* Centra la finestra... */
		GetWindowRect(hDlg, (LPRECT) &wrect);
		w = wrect.right - wrect.left;
		h = wrect.bottom - wrect.top;

		x=GetSystemMetrics(SM_CXSCREEN);
		y=GetSystemMetrics(SM_CYSCREEN);

		x= (x - w) / 2;
		y= (y - h) / 2;

		MoveWindow(hDlg, x, y, w, h, 1);
		boolean_shutdown=1; // Uscita normale...

		SendMessage(GetDlgItem(hDlg, 102), BM_SETCHECK, FALSE, 0L);
		SendMessage(GetDlgItem(hDlg, 101), BM_SETCHECK, TRUE, 0L);
		return(TRUE);

	} else if (message == WM_COMMAND) {

		switch (LOWORD(wParam)) {

		case 101: // Un bug nella v 0.8.51pr impediva l' uscita corretta...
			boolean_shutdown=1; // 1=uscita
			return(TRUE);

		case 102:
			boolean_shutdown=2; // 2=shutdown
			return(TRUE);

		case 110:
			MessageBox( hDlg,
			 "'Spegni il computer ed esci di casa'\n\nPubblicita' Progresso per il recupero dei giovani disadattati a causa dei computer sponsorizzata da Obscured Truckware.",
			 "Guida del Tabboz Simulator", MB_OK );
			return(TRUE);

		case IDOK:
#ifdef TABBOZ32
			SpegniISuoni();
#endif
			EndDialog(hDlg, TRUE);
			return(TRUE);

		case IDCANCEL:
			boolean_shutdown=0; // non e' proprio un boolean, ma va bene lo stesso...
			EndDialog(hDlg, TRUE);
			return(TRUE);

		default:
			return(TRUE);
		}
	 }

	 return(FALSE);
}



/********************************************************************/
/* Configuration...                                                 */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Configuration(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	FARPROC  lpproc;
#ifdef TABBOZ_DEBUG
static	int	temp_debug;
#endif
	 if (message == WM_INITDIALOG) {
#ifdef TABBOZ_DEBUG
		temp_debug=debug_active;
#endif

		if (STARTcmdShow)
			SendMessage(GetDlgItem(hDlg, 106), BM_SETCHECK, TRUE, 0L);
		if (euro)
			SendMessage(GetDlgItem(hDlg, 107), BM_SETCHECK, TRUE, 0L);
		if (timer_active)
			SendMessage(GetDlgItem(hDlg, 108), BM_SETCHECK, TRUE, 0L);

#ifdef TABBOZ_DEBUG
		if (debug_active)
			SendMessage(GetDlgItem(hDlg, 109), BM_SETCHECK, TRUE, 0L);
#endif

		if (sound_active)
			SendMessage(GetDlgItem(hDlg, 110), BM_SETCHECK, TRUE, 0L);

		if ( Fortuna >= 20 ) SendMessage(GetDlgItem(hDlg, 101), BM_SETCHECK, TRUE, 0L); else
		if ( Fortuna >= 15 ) SendMessage(GetDlgItem(hDlg, 102), BM_SETCHECK, TRUE, 0L); else
		if ( Fortuna >= 10 ) SendMessage(GetDlgItem(hDlg, 103), BM_SETCHECK, TRUE, 0L); else
		if ( Fortuna >=  5 ) SendMessage(GetDlgItem(hDlg, 104), BM_SETCHECK, TRUE, 0L); else
		SendMessage(GetDlgItem(hDlg, 105), BM_SETCHECK, TRUE, 0L);

		return(TRUE);
	}
	else if (message == WM_COMMAND)
	{

	switch (LOWORD(wParam))
	{
		case 101: Fortuna=20; return(TRUE);	/* Livelli di Difficolta' */
		case 102: Fortuna=15; return(TRUE);
		case 103: Fortuna=10; return(TRUE);
		case 104: Fortuna= 5; return(TRUE);
		case 105: Fortuna= 0; return(TRUE);
		case 106:
			STARTcmdShow=!STARTcmdShow;
			return(TRUE);
		case 107:
			euro=!euro;
			return(TRUE);
		case 108:
			timer_active=!timer_active;
			return(TRUE);
#ifdef TABBOZ_DEBUG
		case 109:
			debug_active=!debug_active;
			return(TRUE);
#endif
		case 110:
			sound_active=!sound_active;
			return(TRUE);

		case 203:	// Reset - 26 Marzo 1999
			EndDialog(hDlg, TRUE);

			// Se il tabboz e' chiamato con il parametro "config", hWndMain NON ESITE !
			if (hWndMain != 0)
				ShowWindow(hWndMain, WIN_PICCOLO);

			lpproc = MakeProcInstance(FormatTabboz, hInst);
			DialogBox(hInst,
					MAKEINTRESOURCE(15),
					hDlg,
					lpproc);
			FreeProcInstance(lpproc);

			return(TRUE);

		case IDOK:
		case IDCANCEL:
#ifdef TABBOZ_DEBUG
			if (debug_active != temp_debug) {
			  if (debug_active) {
				 openlog();
				 writelog("tabboz: Start logging...");
			  } else {
				 writelog("tabboz: Stop logging...");
				 closelog();
			  }
			}
#endif
			EndDialog(hDlg, TRUE);
			return(TRUE);
		default:
			return(TRUE);
	}
	 }

	 return(FALSE);
}


/********************************************************************/
/* Personal Information...                                          */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL PersonalInfo(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[128];

	 if (message == WM_INITDIALOG) {
		SetDlgItemText(hDlg, 103, Tabboz.global.compleannoString.UTF8String); // Data di nascita
		sprintf(tmp, "%ld", Tabboz.global.documento);
		SetDlgItemText(hDlg, 104, tmp); // Numero documento di nascita (inutile ma da' spessore...)

		if (numeroditta < 1) {        // Professione
			if (sesso == 'M')
				sprintf(tmp,"Studente");
			else
				sprintf(tmp,"Studentessa");
		} else
			sprintf(tmp,"Sfruttat%c",ao);

		SetDlgItemText(hDlg, 108, tmp);

		sprintf(tmp,"Nat%c il", ao); SetDlgItemText(hDlg, 109, tmp); // Nata/o il
		if (sesso == 'M') SetDlgItemText(hDlg, 110, "Celibe"); else SetDlgItemText(hDlg, 110, "Libera");

		SetDlgItemText(hDlg, 111, Residenza);		// Residenza
		SetFocus(GetDlgItem(hDlg, 111));

		SetDlgItemText(hDlg, 107, Street);			// Indirizzo (inutile ma da' spessore...)
		SetFocus(GetDlgItem(hDlg, 107));

		SetDlgItemText(hDlg, 105, City);				// Citta' di nascita (inutile ma da' spessore...)
		SetFocus(GetDlgItem(hDlg, 105));

		SetDlgItemText(hDlg, 101, Cognome);			// Cognome
		SetFocus(GetDlgItem(hDlg, 101));

		SetDlgItemText(hDlg, QX_NOME, Nome);		// Nome
		SetFocus(GetDlgItem(hDlg, QX_NOME));

		return(TRUE);
	}

	else if (message == WM_COMMAND)
	{

	  switch (LOWORD(wParam))
	  {
		 case 111:
			GetDlgItemText(hDlg, wParam, Residenza, sizeof(Residenza));
			break;

		 case 107:
			GetDlgItemText(hDlg, wParam, Street, sizeof(Street));
			break;

		 case 105:
			GetDlgItemText(hDlg, wParam, City, sizeof(City));
			break;

		 case 101:                  /* Cognome del tabbozzo */
			GetDlgItemText(hDlg, wParam, Cognome, sizeof(Cognome));
			break;

		 case QX_NOME:              /* Nome del tabbozzo */
			GetDlgItemText(hDlg, wParam, Nome, sizeof(Nome));
			break;

		 case IDOK:
		 case IDCANCEL:
		EndDialog(hDlg, TRUE);
		return(TRUE);

		 default:
		return(TRUE);
	}
	 }

    return(FALSE);
}


/********************************************************************/
/* Warning...                                                       */
/* 12 Maggio 1998 - Questa funzione non e' piu' usata da anni...    */
/********************************************************************/

#ifdef VECCHIO_RICORDO
# pragma argsused

/*    PortTool v2.2     4/8/1999    14:40          */
/*      Found   : FAR          */
/*      Issue   : Win32 is non-segmented, thus FAR == NEAR == nothing!          */
BOOL FAR PASCAL Warning(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    char          buf[128];


    if (message == WM_INITDIALOG)
	return(TRUE);


/*    PortTool v2.2     4/8/1999    14:40          */
/*      Found   : WM_COMMAND          */
/*      Issue   : wParam/lParam repacking, refer to tech. ref. for details          */
	 else if (message == WM_COMMAND)
	 {

/*    PortTool v2.2     4/8/1999    14:40          */
/*      Found   : LOWORD          */
/*      Issue   : Check if LOWORD target is 16- or 32-bit          */
	switch (LOWORD(wParam))
	{
	    case IDOK:
		EndDialog(hDlg, TRUE);
		return(TRUE);

		 default:
		return(TRUE);
	}
    }

	 return(FALSE);
}
#endif

/********************************************************************/
/* Famiglia...                                                      */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Famiglia(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char        tmp[1024];

	 if (message == WM_INITDIALOG) {
		sprintf(tmp,"Papa', mi dai %s ?",MostraSoldi(100));
		SetDlgItemText(hDlg, 103, tmp);
		SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
		SetDlgItemText(hDlg, 105, MostraSoldi(Paghetta));
		return(TRUE);
	} else if (message == WM_COMMAND) {
		switch (LOWORD(wParam))
		{
			case 101:                   /* Chiedi aumento paghetta */
				if (Studio > 40) {
					if (((Studio - Paghetta +  Fortuna) > ( 75 + random(50))) & (Paghetta < 96) ) {
						sprintf(tmp,"Va bene... ti daremo %s di paghetta in piu'...",MostraSoldi(5));
						MessageBox( hDlg, tmp,
						  "Aumento paghetta !", MB_OK | MB_ICONINFORMATION);
						Paghetta+=5;
						Evento(hDlg);
					} else {
						MessageBox( hDlg,
						"Vedi di scordartelo... Dovra' passare molto tempo prima che ti venga aumentata la paghetta...",
							"Errore irrecuperabile", MB_OK | MB_ICONHAND);
						Evento(hDlg);
					}
				} else {
					MessageBox( hDlg,
						"Quando andrai meglio a scuola, forse...",
						"Errore irrecuperabile", MB_OK | MB_ICONHAND);
			}
			SetDlgItemText(hDlg, 105, MostraSoldi(Paghetta));
			return(TRUE);

		 case 102:                   // Chiedi paghetta extra
                [Tabboz.global chiediPaghettaExtra:hDlg];
			return(TRUE);

		 case 103:                   // Papa, mi dai 100000 lire ?
			if (sound_active) TabbozPlaySound(801);
				MessageBox( hDlg,
					"Non pensarci neanche lontanamente...",
					"Errore irrecuperabile", MB_OK | MB_ICONHAND);
				Evento(hDlg);
				return(TRUE);

		 case IDOK:
		 case IDCANCEL:
				EndDialog(hDlg, TRUE);
				return(TRUE);

		 default:
				return(TRUE);
		 }
	 }

	 return(FALSE);
}


//*******************************************************************
// Compagnia...
//*******************************************************************

# pragma argsused

/*    PortTool v2.2     4/8/1999    14:40          */
/*      Found   : FAR          */
/*      Issue   : Win32 is non-segmented, thus FAR == NEAR == nothing!          */
BOOL FAR PASCAL Compagnia(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[128];

	 if (message == WM_INITDIALOG) {
         sprintf(tmp, "%d/100", Reputazione);
         SetDlgItemText(hDlg, 104, tmp);
         return(TRUE);
     }


/*    PortTool v2.2     4/8/1999    14:40          */
/*      Found   : WM_COMMAND          */
/*      Issue   : wParam/lParam repacking, refer to tech. ref. for details          */
    else if (message == WM_COMMAND) {

/*    PortTool v2.2     4/8/1999    14:40          */
/*      Found   : LOWORD          */
/*      Issue   : Check if LOWORD target is 16- or 32-bit          */
         switch (LOWORD(wParam)) {
                 
             case 101:	// Gareggia con lo scooter...
                 [Tabboz.global gareggiaWithHDlg:hDlg];
                 return(TRUE);
                 
             case 102:
                 [Tabboz.global esciConLaCompagniaWithHDlg:hDlg];
                 return(TRUE);
                 
             case 103:
                 [Tabboz.global minacciaQualcunoWithHDlg:hDlg];
                 return(TRUE);
                 
             case IDOK:
                 EndDialog(hDlg, TRUE);
                 return(TRUE);
                 
             case IDCANCEL:
                 EndDialog(hDlg, TRUE);
                 return(TRUE);
                 
             default:
                 return(TRUE);
                 
         }
     }

    return(FALSE);
}

//*******************************************************************
// Nomoney...
//*******************************************************************

void nomoney(HWND parent,int tipo)
{
    [Tabboz.global noMoneyWithHDlg:parent tipo:tipo];
}

//*******************************************************************
// Aggiorna la finestra principale
//*******************************************************************

void AggiornaPrincipale(HWND parent)
{
char tmp[128];

	 ShowWindow(parent, WIN_GRANDE);

	 sprintf(tmp, "%s %s",Nome,Cognome);
	 SetDlgItemText(parent, QX_NOME, tmp);

	 SetDlgItemText(parent, QX_SOLDI, MostraSoldi(Soldi));

	 sprintf(tmp, "%d/100", Fama);		// Figosita'
	 SetDlgItemText(parent, 151, tmp);

	 sprintf(tmp, "%d/100", Reputazione);	// Reputazione
	 SetDlgItemText(parent, 152, tmp);

	 sprintf(tmp, "%ld/100", Studio);		// Profitto scolastico
	 SetDlgItemText(parent, 153, tmp);

	 if ( Rapporti != 0 ) {
		 sprintf(tmp, "%s", Nometipa);	// Nometipa
		 SetDlgItemText(parent, 155, tmp);
		 sprintf(tmp, "%d/100", Rapporti);	// Rapporti con la tipa
		 SetDlgItemText(parent, 154, tmp);
	 } else {
		 sprintf(tmp, " ");			// Nometipa
		 SetDlgItemText(parent, 155, tmp);
		 SetDlgItemText(parent, 154, tmp);
	 }


	 if (ScooterData.stato != -1) {
		SetDlgItemText(parent, 150, Tabboz.global.nomeScooter.UTF8String);	// Nomescooter
		sprintf(tmp, "%ld/100", ScooterData.stato);
		SetDlgItemText(parent, 156, tmp);	// Stato scooter
	 } else {
		sprintf(tmp, " ");
		SetDlgItemText(parent, 150, tmp);	// Nomescooter
		SetDlgItemText(parent, 156, tmp);	// Stato scooter
	 }

	 SetDlgItemText(parent, 157, Tabboz.global.calendarioString.UTF8String);

	 if ( sesso == 'M' )	{// Non usare la variabile "ao" xche' qui e' necessario
		 DeleteMenu(GetMenu(parent), QX_TIPA, MF_BYCOMMAND);
		 AppendMenu( GetSubMenu(GetMenu(parent),1), MF_STRING, QX_TIPA, "&Tipa...");
		 SetDlgItemText(parent, 133, "Tipa"); // che ci sia scritto Tipa x il maschietto e
		 SetDlgItemText(parent, 170, "Rapporto con la tipa");
	 } else {							  //	Tipo x la femminuccia...
		 DeleteMenu( GetMenu(parent), QX_TIPA, MF_BYCOMMAND);
		 AppendMenu( GetSubMenu(GetMenu(parent),1), MF_STRING, QX_TIPA, "&Tipo...");
		 SetDlgItemText(parent, 133, "Tipo");
		 SetDlgItemText(parent, 170, "Rapporto con il tipo");
	 }

}




//*******************************************************************
// MainDlgBoxProc - handle Main dialog messages (modeless)
//
// This is a modeless dialog box procedure that controls this
// entire application.
//
// paramaters:
//             hDlg          - The window handle for this message
//             message       - The message number
//             wParam        - The WORD parmater for this message
//             lParam        - The LONG parmater for this message
//
//*******************************************************************

#pragma argsused

#ifdef WIN32
#pragma argsused
BOOL CALLBACK _export TabbozWndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
#else
#pragma argsused
BOOL FAR PASCAL TabbozWndProc(HWND hWnd, WORD message, WORD wParam, LONG lParam)
#endif
{
static HICON 	 hIcon;
		 FARPROC  lpproc;

	switch (message) {

	case WM_ENDSESSION:
		 if (wParam)
			FineProgramma("end session");
		 break;

	case WM_QUERYDRAGICON:	   // 25 Feb 1999 - Questa e' l' icona per ALT-TAB...
		 if (!hIcon)
			hIcon = LoadIcon(hInst,MAKEINTRESOURCE(1));
		 return (long)hIcon;


	case WM_DESTROY:
		 if (hIcon)
			DestroyIcon(hIcon);
		 KillTimer(hWnd, WM_TIMER);
		 break;

	case WM_SYSCOMMAND:
		 switch (LOWORD(wParam))
		 {
		 case QX_ABOUT:
			 /* Display about box. */
			 lpproc = MakeProcInstance(About, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(ABOUT),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 return(TRUE);

		 case SC_CLOSE:

			lpproc = MakeProcInstance(Spegnimi, hInst);
			DialogBox(hInst,
			  MAKEINTRESOURCE(SPEGNIMI),
			  hWnd,
			  lpproc);
			FreeProcInstance(lpproc);

			if (boolean_shutdown != 0)
				EndDialog(hWnd,TRUE); // Chiudi la baracca...

			return(TRUE);

		 }
		 return(FALSE);

	case WM_INITDIALOG:
		 hIcon = LoadIcon(hInst,MAKEINTRESOURCE(1));
		 hWndMain = hWnd;
		 // Scrive quanti soldi ci sono... ( ed ora scrive anche molta altra roba...)
		 AggiornaPrincipale(hWnd);


#ifndef NONETWORK
		 hModule = GetModuleHandle("WINSOCK.DLL");

		 NEThDlg=hWnd;

		 if (net_enable)
		TabbozStartNet(NEThDlg);
#endif

		 /* 11 Jun 98 - Modifika il menu' di sistema... */
		 AppendMenu(GetSystemMenu(hWnd, 0), MF_SEPARATOR, 0, 0);
		 AppendMenu(GetSystemMenu(hWnd, 0), MF_STRING, QX_ABOUT, "&About Tabboz Simulator...");

//	    AppendMenu( GetSubMenu(GetMenu(hWnd),1), MF_STRING, QX_ABOUT, "&Chiesa..."); // Aggiunge la chiesa ai negozi :-)))
//	    DeleteMenu(GetMenu(hWnd), QX_ABOUT, MF_BYCOMMAND); // Cancella l' about(per esempio...)
//	    EnableMenuItem(GetMenu(hWnd), QX_NETWORK, MF_GRAYED); // Disabilita un menu'

#ifndef NONETWORK
// Aggiunge la voce "Network..." al menu' "Special" - 04 Jan 1999
		 AppendMenu(GetSubMenu(GetMenu(hWnd),2), MF_SEPARATOR, 0, NULL);
		 AppendMenu(GetSubMenu(GetMenu(hWnd),2), MF_STRING, QX_NETWORK, "&Network...");
#endif
#ifdef PROMPT_ACTIVE
		 AppendMenu(GetSubMenu(GetMenu(hWnd),2), MF_SEPARATOR, 0, NULL);
		 AppendMenu(GetSubMenu(GetMenu(hWnd),2), MF_STRING, QX_PROMPT, "&Prompt...");
#endif

		 DrawMenuBar(hWnd);


/*	    MessageBeep(0x0050); Crea un beep. Non e' necessario qui, ma e' solo x ricordarselo... */



		 /* Inizio implementazione timer: 9 giugno 1998 */
		 SetTimer(hWnd, WM_TIMER, 60000, NULL);     /* 60 secondi.. (il massimo e' 65534, 65 secondi...) */
		 t_random=6 + random(20);	/* 6 - 26 minuti tra un evento ed il seguente...*/
		 t_random=1;

		 fase_di_avvio=0;	/* 11 Giugno 1998 */
		 return TRUE;

	case WM_TIMER :
		if (timer_active == 1) {
			 /* Il timer viene contollato SOLO se la finestra e' ridotta ad ICONA */
			 if (IsIconic(hWndMain) != 0) {
			if (t_random > 0) {
				/* Per un altro minuto siamo a posto... */
				t_random--;
				break;
			}
			t_random=12 + random(20);	/* 12 - 21 minuti tra un evento ed il seguente...*/
			t_random=1;

			KillTimer(hWnd, WM_TIMER);	     /* Distrugge il timer... */
			ShowWindow(hWndMain, SW_SHOWNORMAL); /* Ingrandisce la finestra */
			Giorno(hWnd);

			SetTimer(hWnd, WM_TIMER, 60000, NULL);     /* 60 secondi.. (il massimo e' 65534, 65 secondi...) */
			 }
		}
		return TRUE;

#ifndef NONETWORK
	case SOCKET_MESSAGE:
		switch(WSAGETSELECTEVENT(lParam))
		{

			 case FD_ACCEPT:
			 {
			/* Get a pending accept */

			clientSocket = accept(serverSocket,(LPSOCKADDR) &clientSockAddr, &addrLen);

			/* Memorizza l' indirizzo dell' ultima connessione... */

			sprintf(lastconnect,"%d.%d.%d.%d",
				clientSockAddr.sin_addr.s_net,clientSockAddr.sin_addr.s_host,
				clientSockAddr.sin_addr.s_lh,clientSockAddr.sin_addr.s_impno);


			#ifdef TABBOZ_DEBUG
			sprintf(tmp,"tabboz: Got a connection from %s",lastconnect);
			writelog(tmp);
			#endif

			if (clientSocket == INVALID_SOCKET)
			{
				#ifdef TABBOZ_DEBUG
				writelog("tabboz: ERROR: Unable to accept connection.");
				#endif
				break;
			}

			SendReceiveToClient((void *)clientSocket);

			}
		}
		break;
#endif

	case WM_COMMAND:
		 switch (LOWORD(wParam))
		 {
		 case QX_LOAD:
			 OpenFileDlg(hWnd);
			 AggiornaPrincipale(hWnd);
			 break;

		 case QX_SAVE:
			 SaveFileDlg(hWnd);
			 AggiornaPrincipale(hWnd);
			 break;

		 case QX_CLOSE:

			lpproc = MakeProcInstance(Spegnimi, hInst);
			DialogBox(hInst,
			  MAKEINTRESOURCE(SPEGNIMI),
			  hWnd,
			  lpproc);
			FreeProcInstance(lpproc);

			if (boolean_shutdown != 0)
				EndDialog(hWnd,TRUE); // Chiudi la baracca...

			return(TRUE);

		 case QX_ABOUT:
			 /* Display about box. */
			 lpproc = MakeProcInstance(About, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(ABOUT),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_LOGO:
			 lpproc = MakeProcInstance(Logo, hInst);
			 DialogBox(hInst,
			      MAKEINTRESOURCE(LOGO),
					hWnd,
			      lpproc);
		    FreeProcInstance(lpproc);

		    AggiornaPrincipale(hWnd);
		    break;
		case QX_CONFIG:
			 /* Display configuration box. */
			 lpproc = MakeProcInstance(Configuration, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(CONFIGURATION),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
//		case 251: /* Ex Immagine Tabbozzo */
		case QX_INFO:
			 /* Display Personal Information box. */
			 lpproc = MakeProcInstance(PersonalInfo, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(PERSONALINFO),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_FAMIGLIA:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 /* Display Famiglia box. */
			 lpproc = MakeProcInstance(Famiglia, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(FAMIGLIA),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_DISCO:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 /* Display Disco box. */
			 lpproc = MakeProcInstance(Disco, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(DISCO),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_COMPAGNIA:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 /* Display Compagnia box. */
			 lpproc = MakeProcInstance(Compagnia, hInst);

			  DialogBox(hInst,
					MAKEINTRESOURCE(COMPAGNIA),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_SCUOLA:
			 if ( x_vacanza == 0 ) {
				 ShowWindow(hWnd, WIN_PICCOLO);
				 /* Display Scuola box. */
				 lpproc = MakeProcInstance(Scuola, hInst);
				  DialogBox(hInst,
						MAKEINTRESOURCE(SCUOLA),
						hWnd,
						lpproc);
				 FreeProcInstance(lpproc);
				 AggiornaPrincipale(hWnd);

			 } else {
				 MessageBox( hWnd,
						"Non puoi andare a scuola in un giorno di vacanza !",
						"Scuola", MB_OK | MB_ICONINFORMATION);
			 }

			 break;
		case QX_SCOOTER:
			 /* Display Scooter box. */
			 ShowWindow(hWnd, WIN_PICCOLO);

			 lpproc = MakeProcInstance(Scooter, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(SCOOTER),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_VESTITI:
			 /* Display Vestiti box. */
			 ShowWindow(hWnd, WIN_PICCOLO);

			 lpproc = MakeProcInstance(Vestiti, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(VESTITI),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_TABACCHI:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 RunTabacchi(hWnd);
			 AggiornaPrincipale(hWnd);
			 break;
		case QX_PALESTRA:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 RunPalestra(hWnd);
			 AggiornaPrincipale(hWnd);
			 break;
		case QX_CELLULAR:  // 31 Marzo 1999
			 ShowWindow(hWnd, WIN_PICCOLO);
			 lpproc = MakeProcInstance(Cellular, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(CELLULAR),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);
			 AggiornaPrincipale(hWnd);
			 break;
		case QX_VESTITI1:
		case QX_VESTITI2:
		case QX_VESTITI3:
		case QX_VESTITI4:
		case QX_VESTITI5:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 RunVestiti(hWnd, (wParam - QX_VESTITI1 + BAUHOUSE));
			 AggiornaPrincipale(hWnd);
			 break;
		case QX_TIPA:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 lpproc = MakeProcInstance(Tipa, hInst);
			 if (sesso == 'M')
				 DialogBox(hInst,
						MAKEINTRESOURCE(TIPA),
						hWnd,
						lpproc);
			 else
				 DialogBox(hInst,
						MAKEINTRESOURCE(190),
						hWnd,
						lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
		case QX_LAVORO:
			 ShowWindow(hWnd, WIN_PICCOLO);
			 // Display Lavoro box.
			 lpproc = MakeProcInstance(Lavoro, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(LAVORO),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
#ifdef PROMPT_ACTIVE
		case QX_PROMPT:	    	/* Display Tabboz Simulator Prompt */
			 lpproc = MakeProcInstance(Prompt, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(PROMPT),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
#endif
#ifndef NONETWORK
		case QX_NETWORK:	/* Tabboz Simulator Network Config/Stat */
			 lpproc = MakeProcInstance(Network, hInst);
			 DialogBox(hInst,
					MAKEINTRESOURCE(NETWORK),
					hWnd,
					lpproc);
			 FreeProcInstance(lpproc);

			 AggiornaPrincipale(hWnd);
			 break;
#endif
		default:
			 break;
		 }
		 break;

	 }

	 return FALSE;
}

//*******************************************************************

char	*MostraSoldi(u_long i)
{
static	char   tmp[128];

	if (euro)
		sprintf(tmp, "%lue", (i / 2) );
	else if ( i == 0)
			sprintf(tmp, "0 L.");
		else
			sprintf(tmp, "%lu000 L.", i);

	return tmp;
}

/*********************************************************************/

void	Atinom(HANDLE hInstance)
{

	MessageBox( hInstance,
"Il biglietto e' valido solo dopo la convalida.Il biglietto deve essere conservato per tutta la durata \
del viaggio. Il diritto a viaggiare cessa al termine della tratta corrispondente al valore del biglietto. \
Il passeggero che al controllo non fosse in grado di presentare il biglietto o lo presentasse irriconoscibile, \
o comunque non valido, verra' abbattuto. La notifica del decesso verra' inviata ai parenti solo previo pagamento \
delle spese postali.", "Norme di utilizzo", MB_OK | MB_ICONINFORMATION);

}

/*********************************************************************/

int	vvc(int i)		/* 15 Giugno 1998 - v0.7.1 - Verifica Valori Chiave */
{
	if ( i < 0)
		return 0;
	else
		if ( i > 100)
			return 100;
		else
			return (i);
}

/*********************************************************************/

#ifdef TABBOZ_DEBUG
void	openlog()
{
	debugfile = fopen("\\ZARROSIM.LOG", "w");
}

void	closelog()
{
	fclose(debugfile);
}

void	writelog(char *s)
{
time_t 	t;

	if (debug_active) {
		time(&t);
        printf("Tabboz Debug: %24.24s %s\n",ctime(&t),s); // NOTE(Biappi): changed to printf from fprintf
		fflush(debugfile); // Escegue il flush del file, cosi' anche se il Tabboz craschia si ha il file di log...
	}
}
#endif


//*******************************************************************
// PROCEDURA PRINCIPALE per la versione Windows.

#ifdef TABBOZ_WIN

#pragma argsused
int PASCAL WinMain(HANDLE hInstance, HANDLE hPrevInstance,
			LPSTR lpszCmdLine, int cmdShow)
{
	 hInst = hInstance;

#ifdef TABBOZ_WIN16
	 /* Non si puo' lanciare piu' di una copia del Tabboz Simulator x volta... 17 Maggio 1998 */
	 if (hPrevInstance != NULL) return(NULL);
#endif

	 /* Inizializza il programma */
	 InitTabboz();

	 /* Finestra principale */
    __auto_type lpproc = MakeProcInstance(TabbozWndProc, hInst);
	 DialogBox(hInst,MAKEINTRESOURCE(1),NULL,lpproc);

	 /* Chiusura */

	 // Nuova chiusura - 19 Giugno 1999, speriamo che ora non crashi piu'...
	 if (boolean_shutdown == 2) {
			FineProgramma("shutdown"); // Salvataggio partita...
			#ifdef TABBOZ_DEBUG
			if (debug_active) {
					writelog("tabboz: end (exit + shutdown)");
					closelog();
			}
			#endif
			ExitWindows(0, 0);

	 } else {
			FineProgramma("main"); // Salvataggio partita...
			#ifdef TABBOZ_DEBUG
			if (debug_active) {
					writelog("tabboz: end (standard exit)");
					closelog();
			}
			#endif
	 }

	 return 0;
}
#endif


//*******************************************************************
// 'Possibile' main per Linux usando le GTK+

#ifdef LINUX

int main (int argc, char **argv)
 {
	/* Initialize i18n support */
	gtk_set_locale();

	/* Initialize the widget set */
	gtk_init (&argc, &argv);

	/* Inizializza il programma */
	InitTabboz();

	/* Create the main window */
	mainwin = gtk_window_new (GTK_WINDOW_TOPLEVEL);

	/* Set up our GUI elements */
	...

	/* Show the application window */
	gtk_widget_showall (mainwin);

	/* Let the user interact with our application */
	gtk_main();

	/* Chiusura */

   // salvataggio partita...

	gtk_exit (0);
 }

#endif


//*******************************************************************
// Dialog x la scelta del file da aprire...
//*******************************************************************
void OpenFileDlg(HWND hwnd) { }

void Tabboz_OpenFileDlg(HWND hwnd)
{
#define OFN_LONGNAMES      0x00200000L

  static char szFileName[MAX_PATH];
  static OPENFILENAME ofn;
  memset(&(ofn), 0, sizeof(OPENFILENAME));

  ofn.lStructSize = sizeof(OPENFILENAME);
  ofn.hwndOwner = hwnd;
  ofn.hInstance = hInst;
  ofn.lpstrFile = szFileName;
  ofn.nMaxFile = MAX_PATH;
  ofn.lpstrDefExt = "tbz";
  ofn.lpstrFilter = "Tabboz Files (*.tbz)\000*.tbz\000";
  ofn.Flags = OFN_HIDEREADONLY | OFN_LONGNAMES | OFN_FILEMUSTEXIST;

  if(GetOpenFileName(&ofn)) {
		strcpy(nome_del_file_su_cui_salvare,szFileName);
		CaricaTutto();
		nome_del_file_su_cui_salvare[0]='\0';
  }
}

//*******************************************************************
// Dialog x la scelta del file da salvare...
//*******************************************************************

void SaveFileDlg(HWND hwnd) {}

void Tabboz_SaveFileDlg(HWND hwnd)
{
#define OFN_LONGNAMES      0x00200000L
  static char szFileName[256];
  static	OPENFILENAME ofn;
  memset(&(ofn), 0, sizeof(OPENFILENAME));

  ofn.lStructSize = sizeof(OPENFILENAME);
  ofn.hwndOwner = hwnd;
  ofn.hInstance = hInst;
  ofn.lpstrFile = szFileName;
  ofn.nMaxFile = sizeof(szFileName);
  ofn.lpstrDefExt = "tbz";
  ofn.lpstrFilter = "Tabboz Files (*.tbz)\000*.tbz\000";
  ofn.Flags = OFN_HIDEREADONLY | OFN_LONGNAMES | OFN_OVERWRITEPROMPT | OFN_NOTESTFILECREATE;

  if(GetSaveFileName(&ofn)) {
		strcpy(nome_del_file_su_cui_salvare,szFileName);
		SalvaTutto();
		nome_del_file_su_cui_salvare[0]='\0';
  }
}


//*******************************************************************
// Copyright (c) 1997-2000 Andrea Bonomi
//*******************************************************************

