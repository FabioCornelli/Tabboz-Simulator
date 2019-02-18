// Tabboz Simulator
// (C) Copyright 1997-1999 by Andrea Bonomi

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
__attribute__((unused)) static char sccsid[] = "@(#)" __FILE__ " " VERSION " (Andrea Bonomi) " __DATE__;

			char 	messaggio[256];
BOOL FAR PASCAL MostraMetallone(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern	BOOL FAR PASCAL DueDonne(HWND hDlg, WORD message, WORD wParam, LONG lParam);
extern	int	figTemp;
extern	char	nomeTemp[];
//extern	int	AdV;

/********************************************************************/
/* EVENTI CASUALI...                                                */
/********************************************************************/

void Evento(HANDLE hInstance)
{
int 		  caso;
char 		  tmp[128];
    didLog = true;
    
	if (Fortuna < 0) Fortuna = 0;		/* Prima che qualcuno bari... */
	if (Fortuna > 100) Fortuna = 100;

	//if ( (AdV - 1) != 0 ) return;

	Giorno(hInstance);

	if (Tempo_trascorso_dal_pestaggio > 0)
		Tempo_trascorso_dal_pestaggio--;

/* Sigarette -------------------------------------------------------- */
    [Tabboz.global eventiSigaretteWithHDlg:hInstance];

/* Cellulare ----------------------------------------16 Apr 1999----- */
    [Tabboz.global eventiCellulareWithHDlg:hInstance];

/* Rapporti Tipa ---------------------------------------------------- */
    [Tabboz.global eventiTipaWithHDlg:hInstance];
    
/* Lavoro ----------------------------------------------------------- */
    [Tabboz.global eventiLavoroWithHDlg:hInstance];

/* Paghetta --------------------------------------------------------- */
    [Tabboz.global eventiPaghettaWithHDlg:hInstance];

/* Eventi casuali --------------------------------------------------- */
    caso = random(100+(Fortuna*2));

//	caso = 21;	/* TEST - TEST - TEST - TEST - TEST - TEST - TEST */

	#ifdef TABBOZ_DEBUG
	sprintf(tmp,"eventi: Evento casule n. %d",caso);
	writelog(tmp);
	#endif

	if (caso < 51) {
		 switch (caso) {

// -------------- Metalloni e Manovali ---------------------------------------------------------------------

		case  1:
		case  2:
		case  3:
		case  4:
		case  5:
		case  6:
		case  7:
		case  8:
		case  9:
		case 10:
                 [Tabboz.global eventiCasualiMetalloniEManovaliWithCaso:caso hDlg:hInstance];
                 break;;

// -------------- Scooter -----------------------------------------------------------------------

		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
		case 16:
		case 17:
		case 18:
		case 19:
		case 20:
                [Tabboz.global eventiCasualiScooterWithCaso:caso hDlg:hInstance];
                 break;;

// -------------- Figosita' --------------------------------------------------------------------

		case 21:
		case 22:
		case 23:
		case 24:
		case 25:
		case 26:
		case 27:
		case 28:
		case 29:
		case 30:
                 [Tabboz.global eventiCasualiFigositaWithCaso:caso hDlg:hInstance];
                 break;;

// -------------- Skuola --------------------------------------------------------------------------

		case 31:
		case 32:
		case 33:
		case 34:
		case 35:
		case 36:
		case 37:
		case 38:
		case 39:
		case 40:
                 [Tabboz.global eventiCasualiFigositaWithCaso:caso hDlg:hInstance];
                 break;;

// -------------- Tipa/o ---------------------------------------------------------------------------

		case 41:
		case 42:
                 [Tabboz.global eventiCasualiTipaCiProvaWithCaso:caso hDlg:hInstance];
                 break;;


		case 43: // Domande inutili... 11 Giugno 1999
		case 44:
                 [Tabboz.global eventiCasualiDomandeInutiliWithCaso:caso hDlg:hInstance];
			break;;

		case 45:
		case 46:
		case 47:
		case 48:
			#ifdef TABBOZ_DEBUG
			writelog("eventi: Evento riguardante la tipa//o (da fare...)");
			#endif
			break;;

// -------------- Vari ed eventuali ----------------------------------------------------------------

		case 49:
		case 50:
                 [Tabboz.global eventiCasualiTelefoninoWithCaso:caso hDlg:hInstance];
                 break;;

		default:
                 ;;
		 }
	}

}


//
//	MOSTRA METALLONE, non e' solo per i metalloni, e' molto utile anche per mostrare
//	tutte quelle finestre in cui non c'e' altro di particolare se non il pulsante di
//	[OK] ed un nome casuale di [VIA]...
//

# pragma argsused
BOOL FAR PASCAL MostraMetallone(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[1024];

	 if (message == WM_INITDIALOG) {
		LoadString(hInst, (450 + random(50) ), tmp, (sizeof(tmp)-1) );

/* 15 giugno 1998 - La prima lettera viene scritta minuscola (appare "via..." al posto di "Via..." ) */

		tmp[0]=tolower(tmp[0]);
		SetDlgItemText(hDlg, 111, tmp);

		if (sound_active) TabbozPlaySound(1400);
			return(TRUE);

	 } else if (message == WM_COMMAND) {
		switch (wParam) {

		case IDCANCEL:
		case IDOK:
			EndDialog(hDlg, TRUE);
			return(TRUE);

		default:
			return(TRUE);
		}
	 }

	 return(FALSE);
}

