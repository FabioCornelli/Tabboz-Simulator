/* Tabboz Simulator				*/
/* (C) Copyright 1997-2000 by Andrea Bonomi	*/

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

// #define VERSION	      "Version 0.9pr"
// #define VERSION	      "Version 0.92pr"
#define VERSION	      "Version 0.92q"

/* Per attivare il Debug... 12 giugno 1998	*/
#define TABBOZ_DEBUG

/* Per disattivare la possibilitta' di giocare con la tabbozza 21 giugno 1999 */
// #define NOTABBOZZA

/* Per disabilitare la rete... 26 luglio 1998	*/
#define NONETWORK

/* Per attivare il Prompt ... 16 marzo 1999 */
// #define PROMPT_ACTIVE

/* Per la versione a 32 bit (uscira' mai ??? 8 aprile 1999 */
#ifdef TABBOZ_WIN32
#define TABBOZ32
#endif

#ifndef lint
static char copyright[] =
"@(#) Copyright (c) 1997-2001 Andrea Bonomi, Emanuele Caccialanza, Daniele Gazzarri.\n\
 All rights reserved.\n";
#endif /* not lint */


#ifdef NOT_WINDOWS

#define IDOK		1
#define IDCANCEL	2
#define IDABORT	3
#define IDYES		6
#define IDNO		7
#endif

enum {
QX_NOME      = 102,
QX_SOLDI     = 105,
QX_LOAD      = 106,
QX_SAVE      = 107,
QX_CLOSE     = 108,

QX_ADDW       = 119,
QX_NOREDRAW   = 120,
QX_REDRAW     = 121,

QX_ABOUT      = 120,
QX_LOGO       = 121,

QX_SCOOTER    = 130,
QX_VESTITI    = 131,
QX_DISCO      = 132,
QX_TIPA       = 133,
QX_COMPAGNIA  = 134,
QX_FAMIGLIA   = 135,
QX_SCUOLA     = 136,
QX_LAVORO     = 137,
QX_INFO       = 139,
QX_CONFIG     = 140,
QX_TABACCHI   = 141,
QX_PALESTRA   = 142,
QX_VESTITI1   = 143,
QX_VESTITI2   = 144,
QX_VESTITI3   = 145,
QX_VESTITI4   = 146,
QX_VESTITI5   = 147,
QX_PROMPT     = 150,
QX_NETWORK    = 151,
QX_CELLULAR	 = 155,


/* DIALOG (finestre)		*/

MAIN             = 1,
ABOUT            = 2,
WARNING          = 3,
DISCO            = 4,
FAMIGLIA         = 5,
COMPAGNIA        = 6,
SCOOTER          = 7,
VESTITI          = 8,
TIPA             = 9,
SCUOLA          = 10,
PERSONALINFO    = 11,
LOGO				= 12,
LAVORO				= 13,
CONFIGURATION   = 14,
SPEGNIMI			= 16,
NETWORK			= 17,
PROMPT				= 20,

ACQUISTASCOOTER = 70,
VENDISCOOTER    = 71,
RIPARASCOOTER   = 72,
TAROCCASCOOTER  = 73,

BAUHOUSE        = 80,
ZOCCOLARO       = 81,
FOOTSMOCKER     = 82,
ALTRIVESTITI4   = 83,
ALTRIVESTITI5   = 84,
ALTRIVESTITI6   = 85,

TABACCAIO       = 88,
PALESTRA			= 89,

CERCATIPA       = 91,
LASCIATIPA      = 92,
ESCICONLATIPA   = 93,
DUEDIPICCHE		= 95,

CELLULAR		  = 120,
COMPRACELLULAR = 121,
VENDICELLULAR  = 122,
CELLULRABBONAM = 123,

ATTESAMAX   		= 5,
};

typedef unsigned long   u_long;	// 28 Novembre 1998


#define ScooterData Tabboz.global.scooter

#define ScooterMem  NEWSTSCOOTER.scooter

#define MaterieMem  Tabboz.global.scuola.materie
#define VestitiMem  Vestiario.vestiti
#define SizeMem     Tabacchi.sigarette
#define PalestraMem STSCOOTER.palestra
#define LavoroMem   Carceri.lavoro
#define DiscoMem    Club.disco

#define CellularData Tabboz.global.cellulare
#define CellularMem  STCEL.cellulari

#define AbbonamentData Tabboz.global.abbonamento

#define x_giorno         Tabboz.global.calendario.giorno
#define x_mese           Tabboz.global.calendario.mese
#define x_anno_bisesto   Tabboz.global.calendario.annoBisesto
#define x_giornoset      Tabboz.global.calendario.giornoSettimana
#define x_vacanza        Tabboz.global.calendario.vacanza

#ifdef PROMPT_ACTIVE
extern	int  prompt_mode;
#endif

// PRIMA LE VARIABILI GENERIKE...

extern  int     cheat;
extern  int     scelta;
extern  char    Andrea[14];
extern  char    Caccia[21];
extern  char    Daniele[17];
extern  int	    ImgSelector;
extern  int	    TabbozRedraw;			// E' necessario ridisegnare il Tabbozzo ???
extern  int 	 ScuolaRedraw;       // E' necessario ridisegnare la scuola ???


// DOPO LE CARATTERISTIKE...

#define Attesa            Tabboz.global.attesa

#define Fama              Tabboz.global.fama
#define Reputazione       Tabboz.global.reputazione
#define Fortuna           Tabboz.global.fortuna              // Fortuna del tabbozzo
#define Stato             Tabboz.global.stato                // Quanto stai male ??? (16 Marzo 1999 - 0.8.3pr )

#define Studio            Tabboz.global.scuola.studio        // Quanto vai bene a scuola (1 - 100)
#define Soldi             Tabboz.global.soldi         // Long...per forza! lo zarro ha tanti soldi...
extern  u_long  Paghetta;       // Paghetta Settimanale...
extern  char    Nome[30];
extern  char    Cognome[30];
#define Nometipa          Tabboz.global.tipa.nome.UTF8String
#define FigTipa           Tabboz.global.tipa.figTipa         // Figosita' della tipa
#define Rapporti          Tabboz.global.tipa.rapporto        // Rapporti Tipo <-> Tipa
extern  u_long	 DDP;
extern  int		 AttPaghetta;

#define numeroditta       Tabboz.global.lavoro.ditta
#define impegno           Tabboz.global.lavoro.impegno_
#define giorni_di_lavoro  Tabboz.global.lavoro.giorniDiLavoro // Serve x calcolare lo stipendio SOLO per il primo mese...
#define stipendio         Tabboz.global.lavoro.stipendio_

#define benzina           Tabboz.global.scooter.benzina_
extern  int 	 antifurto;
#define sizze             Tabboz.global.tabacchi.siga         // Numero di sigarette ( 16 Maggio 1998 - 0.6.92a )
extern  int		 Tempo_trascorso_dal_pestaggio;
extern  int	 	 current_testa;                               // Grado di abbronzatura del tabbozzo

#define current_gibbotto  Tabboz.global.vestiti.giubbotto     // Vestiti attuali del tabbozzo...
#define current_pantaloni Tabboz.global.vestiti.pantaloni
#define current_scarpe    Tabboz.global.vestiti.scarpe

#define current_tipa      Tabboz.global.tipa.currentTipa
extern  int  	 sound_active;
extern  char	 sesso; 	// M/F 29 Maggio 1999 --- Inizio...
extern  char	 ao;
extern  char  	 un_una[];
extern  int      euro;
extern char    nomeTemp[30];
extern int    figTemp;
extern char natale2;

static char * figNomTemp = nomeTemp;

#ifdef TABBOZ_DEBUG                	// Sistema di Debug... [12 Giugno 1998]
extern  FILE	 *debugfile;
extern  void    writelog(char *s);	// 22 Giugno 1998
#endif

#ifndef NONETWORK
extern   int	 net_enable;		   // Rete Attiva/Disattiva [24 Giugno 1998]
extern	char	 lastneterror[255];
extern   char   lastconnect[255];
extern   int  	 addrLen;
extern	HWND 	 NEThDlg;				// Punta alla procedura pricipale...
extern   void   TabbozStartNet(HANDLE hDlg);		// 24 Giugno 1998
#endif

// POI LE STRONZATE PER LE FINESTRELLE...

#ifdef TABBOZ_WIN
extern  HANDLE    hInst;
extern  HWND      hWndMain;
extern  HANDLE    hdlgr;
#endif

// ED I PROTOTIPI FUNZIONI...

#ifdef TABBOZ_WIN
extern  int	PASCAL 		WinMain(HANDLE hInstance, HANDLE hPrevInstance,
					LPSTR lpszCmdLine, int cmdShow);
extern  BOOL FAR PASCAL MainDlgBoxProc(HWND hDlg, WORD message,
					WORD wParam, LONG lParam);
#endif

extern  void Evento(HWND hWnd);
extern  void RunPalestra(HWND hDlg);	/* 23 Aprile 1998 */
extern  void RunTabacchi(HWND hDlg);	/* 23 Aprile 1998 */
extern  void RunVestiti(HWND hDlg,int numero);  /* 23 Aprile 1998 */

extern  BOOL FAR PASCAL        About(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Warning(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Disco(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Famiglia(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Compagnia(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Tipa(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Lavoro(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Scuola(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Scooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Vestiti(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Configuration(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL	       PersonalInfo(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        Logo(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 13 Marzo 1998 */
extern  BOOL FAR PASCAL        Tabaccaio(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 19 Marzo 1998 */
extern  BOOL FAR PASCAL        Palestra(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* iniziata il 20 Marzo 1998  */
extern  BOOL FAR PASCAL        Setup(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 9 Giugno 1998 */
extern  BOOL FAR PASCAL        Spegnimi(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 11 Giugno 1998 */
extern  BOOL FAR PASCAL        Network(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 25 Giugno 1998 */
extern  BOOL FAR PASCAL	       MostraSalutieBaci(HWND hDlg, WORD message, WORD wParam, LONG lParam); /* 4 Gennaio 1999 */
extern  BOOL FAR PASCAL        Cellular(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 31 Marzo 1999 */
extern  BOOL FAR PASCAL        Concessionario(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        TruccaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern  BOOL FAR PASCAL        RiparaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);

BOOL FAR PASCAL FormatTabboz(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL TabbozWndProc(HWND hWnd, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL MostraMetallone(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL DueDonne(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL MostraPagella(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL DueDiPicche(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL ElencoDitte(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL CercaLavoro(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL AcquistaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL VendiScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL CompraCellulare(HWND hDlg, WORD message, WORD wParam, LONG lParam);     /* 31 Marzo 1999 */
BOOL FAR PASCAL AbbonaCellulare(HWND hDlg, WORD message, WORD wParam, LONG lParam);     /* 31 Marzo 1999 */

extern  void  TabbozAddKey(char *key,char *v);
extern  char  *TabbozReadKey(char *key,char *buf);
extern  void  TabbozPlaySound(int number);

void Aggiorna(HWND parent);

#ifdef PROMPT_ACTIVE
extern  BOOL FAR PASCAL        Prompt(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* iniziato il 15 Maggio 1998 */
#endif


extern  void FineProgramma(char *caller);
extern  void CalcolaStudio(void);
extern  char *MostraSoldi(u_long i);

extern  char   *RRKey(char *xKey);		// 29 Novembre 1998
extern  int     new_check_i(int i);		// 14 Marzo 1999
extern  u_long  new_check_l(u_long i);  // 14 Marzo 1999
extern  void    new_reset_check(void); 	// 14 Marzo 1999


extern  void    openlog(void);
extern  void	closelog(void);
extern  void    nomoney(HWND parent,int tipo);
extern  void    AggiornaPrincipale(HANDLE);
extern  void    Giorno(HANDLE hInstance);
extern  void    CalcolaStudio(void);
extern  void    CalcolaVelocita(HANDLE hDlg);
extern  void    InitTabboz(void);
extern  void    AggiornaTipa(HWND hDlg);
extern  void    AggiornaPalestra(HWND parent);
extern  void    AggiornaLavoro(HWND hDlg);
extern  void    AggiornaCell(HWND hDlg);
extern  void    AggiornaScooter(HWND hDlg);
extern  int     GiornoDiLavoro(HWND hDlg, const char *s);

// Numero di ditte
#define NUM_DITTE 8

extern int      punti_scheda;

extern char     Risposte1[3];
extern char     Risposte2[3];
extern char     Risposte3[3];

static char *   Risposte_1 = Risposte1;
static char *   Risposte_2 = Risposte2;
static char *   Risposte_3 = Risposte3;

extern int      scheda;    /* numero scheda del quiz ( 0 - 9 ) */
extern int      accetto;

extern int      Rcheck;
extern int      Lcheck;

