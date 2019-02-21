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

static 	int   spostamento;
static	char  descrizione[30];
			int	figTemp;
			char	nomeTemp[30];
			HWND	tipahDlg;	// Serve per BMPTipaWndProc (in Tabimg.c )

BOOL FAR PASCAL CercaTipa(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL DueDiPicche(HWND hDlg, WORD message, WORD wParam, LONG lParam);
void DescrizioneTipa(int f);
void DescrizioneTipo(int f);

// ------------------------------------------------------------------------------------------
// Tipa...
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL        Tipa(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
		 FARPROC	  		lpproc;

    if (message == WM_INITDIALOG) {
        if (sesso == 'M') spostamento=0; else spostamento=100;
        AggiornaTipa(hDlg);
        tipahDlg=hDlg;
        return(TRUE);
    }
    
    else if (message == WM_COMMAND)
    {
        switch (wParam)
        {
            case 110:			// Cerca tipa
                lpproc = MakeProcInstance(CercaTipa, hInst);
                DialogBox(hInst,
                          MAKEINTRESOURCE(CERCATIPA + spostamento),
                          hDlg,
                          lpproc);
                FreeProcInstance(lpproc);
                
                AggiornaTipa(hDlg);
                return(TRUE);
                
            case 111:			// Lascia tipa
                [Tabboz.global lasciaTipaWithHDlg:hDlg];
                return(TRUE);
                
            case 112:
                [Tabboz.global chiamaTipaWithHDlg:hDlg];
                return(TRUE);
                
            case 113:
                [Tabboz.global esciCollaTipaWithHDlg:hDlg];
                return(TRUE);
                
            case IDCANCEL:
            case IDOK:
                tipahDlg = 0; // Non si sa' mai...
                EndDialog(hDlg, TRUE);
                return(TRUE);
                
            default:
                return(TRUE);
        }
    }
    
    return(FALSE);
}


// ------------------------------------------------------------------------------------------
// Due Donne - 22 Aprile 1999
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL DueDonne(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[255];

	 if (message == WM_INITDIALOG) {
			sprintf(tmp, "Resto con %s", Nometipa);
			SetDlgItemText(hDlg, 2, tmp);
			if (!strcmp(Nometipa,nomeTemp)) { // Se le tipe si chiamano tutte e due con lo stesso nome
				if (sesso == 'M') sprintf(tmp, "Preferisco quella nuova");
				else sprintf(tmp, "Preferisco quello nuovo");
			} else
				sprintf(tmp, "Preferisco %s", nomeTemp);
			SetDlgItemText(hDlg, 102, tmp);
			return(TRUE);

	 } else if (message == WM_COMMAND) {
			switch (wParam)
			{
			case 101:		// Ottima scelta...
                    [Tabboz.global entrambeWithHDlg:hDlg];
                    return(TRUE);

			case 102:	   // Preferisci quella nuova...
                    [Tabboz.global nuovaWithHDlg:hDlg];
                    return(TRUE);

			case IDCANCEL: // Resti con la tua vecchia ragazza, bravo...
			default:
				EndDialog(hDlg, TRUE);
				return(TRUE);
			}
	 }

	 return(FALSE);
}

// ------------------------------------------------------------------------------------------
// Cerca Tipa
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL CercaTipa(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[255];
	 static int	  	i;

	 if (message == WM_INITDIALOG) {

		figTemp=random(71) + 30;		// 30 -> 100

		if (sesso == 'M') {
			DescrizioneTipa(figTemp);
			i=200+random(20);		// 200 -> 219 [nomi tipe]
		} else {
			DescrizioneTipo(figTemp);
			i=1200+random(20);   // 1200 -> 1219 [nomi tipi]
			}

		SetDlgItemText(hDlg, 107, descrizione);
		LoadString(hInst, i, (LPSTR)nomeTemp, 30);

		sprintf(tmp, "%s", nomeTemp);
		SetDlgItemText(hDlg, 105, tmp);

		sprintf(tmp, "%d/100", figTemp);
		SetDlgItemText(hDlg, 106, tmp);

		return(TRUE);
	}

     else if (message == WM_COMMAND)
     {
         switch (wParam)
         {
             case IDCANCEL:
                 EndDialog(hDlg, TRUE);
                 return(TRUE);
                 
             case 101:
                 [Tabboz.global provaciWithHDlg:hDlg];
                 return(TRUE);
                 
             default:
                 return(TRUE);
         }
     }

	 return(FALSE);
}

// ------------------------------------------------------------------------------------------
// Abbina una descrizione(breve) alla figosita' di una tipa.
// ------------------------------------------------------------------------------------------

void	DescrizioneTipa(int f)
{
char buf[30];

	if (f > 97) sprintf(buf,"Ultramegafiga"); else
	 if (f > 90) sprintf(buf,"Fighissima"); else
		if (f > 83) sprintf(buf,"Molto figa"); else
	if (f > 72) sprintf(buf,"Figa"); else
	  if (f > 67) sprintf(buf,"Abbastanza Figa"); else
		 if (f > 55) sprintf(buf,"Interessante"); else
			if (f > 45) sprintf(buf,"Passabile"); else
		if (f > 35) sprintf(buf,"Puo' piacere.."); else
			sprintf(buf,"E' un tipo...");

	sprintf(descrizione, "%s", buf);
}

// ------------------------------------------------------------------------------------------
// Abbina una descrizione(breve) alla figosita' di un tipo.
// ------------------------------------------------------------------------------------------

void	DescrizioneTipo(int f)
{
char buf[30];

	if (f > 97) sprintf(buf,"Ultramegafigo"); else
	 if (f > 90) sprintf(buf,"Bellissimo"); else
		if (f > 83) sprintf(buf,"Molto figo"); else
	if (f > 72) sprintf(buf,"Bello"); else
	  if (f > 67) sprintf(buf,"Abbastanza Figo"); else
		 if (f > 55) sprintf(buf,"Interessante"); else
			if (f > 45) sprintf(buf,"Passabile"); else
		if (f > 35) sprintf(buf,"Puo' piacere.."); else
			sprintf(buf,"Inutile...");

    sprintf(descrizione, "%s", buf);
}

// ------------------------------------------------------------------------------------------
// 2 di picche (la vita e' bella...)
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL DueDiPicche(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[1024];
	 static int	  i;

	 if (message == WM_INITDIALOG) {

	// IN QUESTA PARTE C'ERA UN BUG CHE FACEVA CRASCIARE IL TABBOZ SIMULATOR...

		if (sesso == 'M' )
			i=300+random(20);		// 300 -> 319 [sfighe varie]
		else
			i=1300+random(20);		// 300 -> 319 [sfighe varie]

		LoadString(hInst, i, (LPSTR)tmp, 1024);
		SetDlgItemText(hDlg, 105, tmp);

		i=0;

		return(TRUE);
	} else if (message == WM_COMMAND) {
		switch (wParam)
		{
			case 201:
			i++;
			if (i > 5) {
				sprintf(tmp,"Fino ad ora hai preso %ld due di picche !\nNon ti preoccupare, capita a tutti di prendere qualche due di picche nella vita ...",DDP);
				MessageBox( hDlg,
					tmp, "La vita e' bella...", MB_OK | MB_ICONINFORMATION);
				i = 0;
				}
			return(TRUE);

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

// ------------------------------------------------------------------------------------------
// AggiornaTipa
// ------------------------------------------------------------------------------------------

void AggiornaTipa(HWND hDlg)
{
char 	  tmp[128];
  if (Rapporti == 0) {
	 if ( sesso == 'M') SetDlgItemText(hDlg, 101, "Cerca Tipa");
	 SetDlgItemText(hDlg, 101, "Cerca Tipo");

	 sprintf(tmp, "");
	 SetDlgItemText(hDlg, 105, tmp);
	 SetDlgItemText(hDlg, 106, tmp);
	 SetDlgItemText(hDlg, 107, tmp);
  } else {
	 if ( sesso == 'M') SetDlgItemText(hDlg, 101, "Cerca Nuova Tipa");
	 else SetDlgItemText(hDlg, 101, "Cerca Nuovo Tipo");
	 sprintf(tmp, "%s", Nometipa);
	 SetDlgItemText(hDlg, 105, tmp);
	 sprintf(tmp, "%d", FigTipa);
	 SetDlgItemText(hDlg, 106, tmp);
	 sprintf(tmp, "%d/100", Rapporti);
	 SetDlgItemText(hDlg, 107, tmp);
  }
  sprintf(tmp, "%d/100", Fama);
  SetDlgItemText(hDlg, 104, tmp);
}


// ------------------------------------------------------------------------------------------
// 4 gennaio 1999
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL MostraSalutieBaci(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	if (message == WM_INITDIALOG) {
		return(TRUE);
	} else if (message == WM_COMMAND) {

		switch (wParam) {

			case 205:
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
