// Tabboz Simulator
// (C) Copyright 1997-2000 by Andrea Bonomi
// 31 Maggio 1999 - Conversione Tabbozzo -> Tabbozza

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


extern void EventiPalestra(HANDLE hInstance);
BOOL FAR PASCAL CompraQualcosa(HWND hDlg, WORD message, WORD wParam, LONG lParam);
void PagaQualcosa(HWND parent);

/********************************************************************/
/* Vestiti...                                                       */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Vestiti(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[128];
	 FARPROC       lpproc;

	 if (message == WM_INITDIALOG) {
		SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));

		/* Vestito da Babbo Natale... 11 Marzo 1999 */
#define COSTO_VESTITO_NATALIZIO 58

		if ((x_mese == 12) && (Soldi >= COSTO_VESTITO_NATALIZIO))
			if ((x_giorno > 14) && ( x_giorno < 25) && ( current_gibbotto!=19) && (current_pantaloni!=19)) {
				int scelta;
				sprintf(tmp,"Vuoi comperare, per %s, un meraviglioso vestito da Babbo Natale ?",MostraSoldi(COSTO_VESTITO_NATALIZIO));
				scelta=MessageBox( hDlg,
					tmp,
					"Offerte Natalizie...", MB_YESNO | MB_ICONQUESTION);
				if (scelta == IDYES) {
					current_gibbotto=19;
					current_pantaloni=19;
					TabbozRedraw = 1;	// E' necessario ridisegnare l' immagine del Tabbozzo...
					Soldi-=COSTO_VESTITO_NATALIZIO;
					}
			}

		return(TRUE);

	 }else if (message == WM_COMMAND) {

		switch (wParam) {

		case 101:		// MAKEINTRESOURCE 80
		case 102:		// MAKEINTRESOURCE 81
		case 103:		// MAKEINTRESOURCE 82
		case 104:		// MAKEINTRESOURCE 83
		case 105:		// MAKEINTRESOURCE 84
			RunVestiti(hDlg,(wParam-21));
			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
			return(TRUE);

		case 110:		// Tabaccaio
			RunTabacchi(hDlg);
			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
			return(TRUE);

		case 111:		// Palestra
			RunPalestra(hDlg);
			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
			return(TRUE);

		case 112:	   // Cellulare
			lpproc = MakeProcInstance(Cellular, hInst);
			DialogBox(hInst,
				MAKEINTRESOURCE(CELLULAR),
				hDlg,
				lpproc);
			FreeProcInstance(lpproc);

			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
			return(TRUE);

		case IDCANCEL:
			EndDialog(hDlg, TRUE);
			return(TRUE);

		case IDOK:
			EndDialog(hDlg, TRUE);
			return(TRUE);

		default:
			return(TRUE);
		}
	 }

	 return(FALSE);
}

//*******************************************************************
// Routine per il pagamento di qualunque cosa...
//*******************************************************************

void
PagaQualcosa(HANDLE hInstance)
{
char	tmp[128];

	if (scelta != 0) {
		if (VestitiMem[scelta].prezzo > Soldi) {
			(void)nomoney(hInstance,VESTITI);
		} else {
			Soldi-= VestitiMem[scelta].prezzo;

			switch (scelta) {	/* 25 Febbraio 1999 */
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:  current_gibbotto=scelta; break;
				case 7:
				case 8:
				case 9:
				case 10: current_pantaloni=scelta-6; break;
				case 11:
				case 12:
				case 13:
				case 14:
				case 15:
				case 16:
				case 17: current_scarpe=scelta-10; break;
			}

			TabbozRedraw = 1;	// E' necessario ridisegnare l' immagine del Tabbozzo...

	      #ifdef TABBOZ_DEBUG
	      sprintf(tmp,"vestiti: Paga %s",MostraSoldi(VestitiMem[scelta].prezzo));
			writelog(tmp);
	      #endif
	      Fama+=VestitiMem[scelta].fama;
	      if (Fama > 100) Fama=100;
	   }
	   Evento(hInstance);
	}
}


//*******************************************************************
// Routine di acquisto generica
//*******************************************************************

# pragma argsused
BOOL FAR PASCAL CompraQualcosa(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[128];
	 int		  i;

	 if (message == WM_INITDIALOG) {
	scelta=0;
	SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
	sprintf(tmp, "%d/100", Fama);
	SetDlgItemText(hDlg, 121, tmp);

	for (i=101;i<120;i++) {
		SetDlgItemText(hDlg, i, MostraSoldi(VestitiMem[i-100].prezzo));
	}
	return(TRUE);
	}

	 else if (message == WM_COMMAND)
	 {
	switch (wParam)
	{
		 case 101:
		 case 102:
		 case 103:
		 case 104:
		 case 105:
		 case 106:
		 case 107:
		 case 108:
		 case 109:
		 case 110:
		 case 111:
		 case 112:
		 case 113:
		 case 114:
		 case 115:
		 case 116:
		 case 117:
		 case 118:
		 case 119:
		scelta=wParam-100;
		return(TRUE);

		 case IDCANCEL:
		scelta=0;
		EndDialog(hDlg, TRUE);
		return(TRUE);

		 case IDOK:
		PagaQualcosa(hDlg);
		EndDialog(hDlg, TRUE);
		return(TRUE);

		 default:
		return(TRUE);
	}
	 }

	 return(FALSE);
}


//*******************************************************************
// Tabaccaio ! (che centra tra i vestiti ??? Come procedura e' simile...)
//*******************************************************************

# pragma argsused
BOOL FAR PASCAL Tabaccaio(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char      tmp_descrizione[1024];
	 char      tmp[255];
	 int		  i;

	 if (message == WM_INITDIALOG) {
	 if (sound_active) TabbozPlaySound(203);
		scelta=-1; // Fino alla 0.8.51pr c'era un bug che non faceva comprare le Barclay...
		SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
		sprintf(tmp, "%d", sizze);
		SetDlgItemText(hDlg, 105, tmp);
		sprintf(tmp, "Che sigarette vuoi, ragazz%c ?",ao);
		SetDlgItemText(hDlg, 106, tmp);
		return(TRUE);
	 } else if (message == WM_COMMAND) {
		switch (wParam) {
		 case 400:
		 case 401:
		 case 402:
		 case 403:
		 case 404:
		 case 405:
		 case 406:
		 case 407:
		 case 408:
		 case 409:
		 case 410:
		 case 411:
		 case 412:
		 case 413:
		 case 414:
		 case 415:
		 case 416:
		 case 417:
		 case 418:
		 case 419:
		 case 420:
		 case 421:
		 case 422:
		 case 423:
			scelta=wParam-400;
			LoadString(hInst, (wParam + 1000), tmp, 254);

			if (SizeMem[scelta].cc == 0) {
				/* Se i valori sono impostati a 0, non li scrive */
				sprintf(tmp_descrizione,"%s\n%s",
					SizeMem[scelta].nome.UTF8String, tmp );
			} else {
                __auto_type nico = SizeMem[scelta].cc;
                sprintf(tmp_descrizione,"%s\n%sCondensato: %ld Nicotina: %ld.%ld",
					SizeMem[scelta].nome.UTF8String, tmp, SizeMem[scelta].speed, nico / 10, nico % 10);
			}

			SetDlgItemText(hDlg, 106, tmp_descrizione);
			return(TRUE);


		 case IDCANCEL:
			scelta=-1;
			EndDialog(hDlg, TRUE);
			return(TRUE);

		 case IDOK:
			if (scelta != -1) {
				if (SizeMem[scelta].prezzo > Soldi) {
					nomoney(hDlg,TABACCAIO);
				} else {
					Soldi-= SizeMem[scelta].prezzo;
					#ifdef TABBOZ_DEBUG
					sprintf(tmp,"tabaccaio: Paga %s",MostraSoldi(SizeMem[scelta].prezzo));
					writelog(tmp);
					#endif
					Fama+=SizeMem[scelta].fama;
					if (Fama > 100) Fama=100;
					sizze+=20;
				}
				i = random(8) + 600;
				LoadString(hInst, i, (LPSTR)tmp, 254);  // 600 -> 607
				MessageBox( hDlg,
				(LPSTR)tmp,
				"ART. 46 L. 29/12/1990 n. 428", MB_OK | MB_ICONINFORMATION );

				Evento(hDlg);
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
// Palestra ! (che centra tra i vestiti ??? Come procedura e' simile...)
//*******************************************************************

void AggiornaPalestra(HWND parent)
{
char tmp[128];

	SetDlgItemText(parent, 104, MostraSoldi(Soldi));
	sprintf(tmp, "%d/100", Fama);
	SetDlgItemText(parent, 105, tmp);

    SetDlgItemText(parent, 106, Tabboz.global.scadenzaAbbonamentoPalestraString.UTF8String);

	// Scrive il grado di abbronzatura... 4 Marzo 1999
	switch (current_testa) {
	case  1: sprintf(tmp,"Abbronzatura Lieve");	  break;
	case  2: sprintf(tmp,"Abbronzatura Media");    break;
	case  3: sprintf(tmp,"Abbronzatura Pesante");  break;
	case	4: sprintf(tmp,"Carbonizzat%c...",ao);   break;
	default: sprintf(tmp,"Non abbronzat%c",ao);
	}
	SetDlgItemText(parent, 107, tmp);
}

//*******************************************************************

# pragma argsused
BOOL FAR PASCAL Palestra(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    if (message == WM_INITDIALOG) {
        AggiornaPalestra(hDlg);
        SetDlgItemText(hDlg, 120, MostraSoldi([Tabboz PalestraCostoAbbonamento:AbbonamentiPalestraUnMese ]));
        SetDlgItemText(hDlg, 121, MostraSoldi([Tabboz PalestraCostoAbbonamento:AbbonamentiPalestraSeiMesi]));
        SetDlgItemText(hDlg, 122, MostraSoldi([Tabboz PalestraCostoAbbonamento:AbbonamentiPalestraUnAnno ]));
        SetDlgItemText(hDlg, 123, MostraSoldi([Tabboz PalestraCostoLampada]));
        
        return TRUE;
	}
    else if (message == WM_COMMAND)
    {
        switch (wParam)
        {
            case 110: [Tabboz.global vaiInPalestra:hDlg];                                     return TRUE;
            case 111: [Tabboz.global faiLaLampada: hDlg];                                     return TRUE;
            case 115: [Tabboz.global compraAbbonamento:AbbonamentiPalestraUnMese  hDlg:hDlg]; return TRUE;
            case 116: [Tabboz.global compraAbbonamento:AbbonamentiPalestraSeiMesi hDlg:hDlg]; return TRUE;
            case 117: [Tabboz.global compraAbbonamento:AbbonamentiPalestraUnAnno  hDlg:hDlg]; return TRUE;
                
            case IDOK:
            case IDCANCEL:
            default:
                EndDialog(hDlg, TRUE);
                return TRUE;
        }
    }
    
    return FALSE;
}



void RunTabacchi(HWND hDlg)
{
	 FARPROC       lpproc;

	 if ( x_vacanza != 2 ) { // 19 Mar 98 - Tabaccaio
			lpproc = MakeProcInstance(Tabaccaio, hInst);
			DialogBox(hInst,
				MAKEINTRESOURCE(TABACCAIO),
				hDlg,
				lpproc);
			FreeProcInstance(lpproc);
	 } else {
	MessageBox( hDlg,
	  "Rimani fisso a guardare la saracinesca del tabaccaio inrimediabilmente chiusa...",
				"Bar Tabacchi", MB_OK | MB_ICONINFORMATION);
	 }
}

void RunPalestra(HWND hDlg)
{
	 FARPROC       lpproc;

	 if ( x_vacanza != 2 ) { // 20 Mar 98 - Palestra
	lpproc = MakeProcInstance(Palestra, hInst);
	DialogBox(hInst,
			MAKEINTRESOURCE(PALESTRA),
			hDlg,
			lpproc);
	FreeProcInstance(lpproc);
	 } else {
	MessageBox( hDlg,
	  "Il tuo fisico da atleta dovra' aspettare... visto che oggi la palestra e' chiusa...",
				"Palestra", MB_OK | MB_ICONINFORMATION);
	 }
}

void RunVestiti(HWND hDlg,int numero)
{
	FARPROC       lpproc;
	char			  tmp[128];

	// Versione femminile di "Bau House" e "Blue Rider"
	if ((numero == 80) && (sesso == 'F')) numero=85;
	if ((numero == 84) && (sesso == 'F')) numero=86;

	if ( x_vacanza != 2 ) { // 26 Feb 98... finalmente i negozi sono chiusi durante le vacanze...
	if (sound_active) {
		if (numero < 82)
		  TabbozPlaySound(204);
		else
		  TabbozPlaySound(205);
	}

	lpproc = MakeProcInstance(CompraQualcosa, hInst); // La funzione e' uguale x tutti...
	DialogBox(hInst,
		 MAKEINTRESOURCE_Real(numero, NULL),
		 hDlg, lpproc);
	FreeProcInstance(lpproc);
	} else {
			sprintf(tmp,"Oh, tip%c... i negozi sono chiusi di festa...",ao);
			MessageBox( hDlg, tmp,
				"Vestiti", MB_OK | MB_ICONINFORMATION);
	}
}



/********************************************************************/
/* EVENTI PALESTRA - 14 Luglio 1998                                 */
/********************************************************************/

void EventiPalestra(HANDLE hInstance)
{
int i;
char messaggio[128];

	i=random(29 + (Fortuna / 2));

	if (i > 9) return;	/* eventi: 0 - 10) */

	LoadString(hInst, (1100 + i), (LPSTR)messaggio, 255);

	MessageBox( hInstance,
	(LPSTR)messaggio,
		"Palestra...", MB_OK | MB_ICONSTOP);

	if (Reputazione > 10)
		Reputazione-=4;


#ifdef TABBOZ_DEBUG
	writelog("eventi: Evento riguardante la palestra");
#endif

}



