// Tabboz Simulator
// (C) Copyright 1998-1999 by Andrea Bonomi

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

// 31 Maggio 1999 - Conversione Tabbozzo -> Tabbozza

#include "os.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "zarrosim.h"
__attribute__((unused)) static char sccsid[] = "@(#)" __FILE__ " " VERSION " (Andrea Bonomi) " __DATE__;

int    punti_scheda;

BOOL FAR PASCAL ElencoDitte(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL CercaLavoro(HWND hDlg, WORD message, WORD wParam, LONG lParam);
void AggiornaLavoro(HWND hDlg);


char Risposte1[3];
char Risposte2[3];
char Risposte3[3];

int	scheda;	/* numero scheda del quiz ( 0 - 9 ) */
int	accetto;

int      Rcheck;
int      Lcheck;

/********************************************************************/
/* Lavoro...                                                        */
/********************************************************************/

int	GiornoDiLavoro(HWND hDlg, const char *s)
{
	char	tmp[255];

	if (numeroditta < 1)  {
		sprintf(tmp,"Forse non ti ricordi che sei disokkupat%c...",ao);
		MessageBox( hDlg, tmp, s, MB_OK | MB_ICONINFORMATION);
		return(TRUE);
		}

	if ( x_vacanza == 2 ) {
		sprintf(tmp,"Arrivat%c davanti ai cancelli della ditta li trovi inrimediabilmente chiusi...",ao);
		MessageBox( hDlg, tmp, s, MB_OK | MB_ICONINFORMATION);
		return(TRUE);
		}

	return FALSE;
}


# pragma argsused
BOOL FAR PASCAL        Lavoro(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    if (message == WM_INITDIALOG) {
        if (sesso == 'M')
            SetDlgItemText(hDlg, 113, "Fai il leccaculo");
        else
            SetDlgItemText(hDlg, 113, "Fai la leccaculo");
        
        AggiornaLavoro(hDlg);
        return(TRUE);
    }
    
    else if (message == WM_COMMAND)
    {
        switch (wParam)
        {
                
            case 110:		// Cerca Lavoro ----------------------------------------------------------------------------------
                [Tabboz.global cercaLavoroWithHDlg:hDlg];
                return(TRUE);
                
            case 111:		/* Licenziati ------------------------------------------------------------------------------------ */
                [Tabboz.global licenziatiWithHDlg:hDlg];
                return(TRUE);
                
            case 112:		/* Chiedi aumento salario ------------------------------------------------------------------------ */
                [Tabboz.global chiediAumentoSalarioWithHDlg:hDlg];
                return(TRUE);
                
            case 113:		/* Fai il leccaculo ------------------------------------------------------------------------------ */
                [Tabboz.global faiIlLeccaculoWithHDlg:hDlg];
                return(TRUE);
                
            case 114:		/* Elenco ditte ---------------------------------------------------------------------------------- */
                [Tabboz.global elencoDitteWithHDlg:hDlg];
                return(TRUE);
                
            case 115:		/* Sciopera  ----------------------------------------------------------------------------------  */
                [Tabboz.global scioperaWithHDlg:hDlg];
                return(TRUE);
                
            case 116:		/* Lavora  ----------------------------------------------------------------------------------  */
                [Tabboz.global lavoraWithHDlg:hDlg];
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


/* Cerca Lavoro ------------------------------------------------------------------------------- */

# pragma argsused
BOOL FAR PASCAL CercaLavoro(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
int 		i;

    if (message == WM_INITDIALOG) {
	for(i=0;i<3;i++)		/* Azzera le risposte... */
		Risposte1[i]=0;
	for(i=0;i<3;i++)
		Risposte2[i]=0;
	for(i=0;i<3;i++)
		Risposte3[i]=0;
	return(TRUE);
	}

    else if (message == WM_COMMAND)
    {
	switch (wParam)
	{
	    case 101:
	    case 102:
	    case 103:
		Risposte1[wParam-101]=!(Risposte1[wParam-101]);
		return(TRUE);
	    case 104:
	    case 105:
	    case 106:
		Risposte2[wParam-104]=!(Risposte2[wParam-104]);
		return(TRUE);
	    case 107:
	    case 108:
	    case 109:
		Risposte3[wParam-107]=!(Risposte3[wParam-107]);
		return(TRUE);
	    case IDCANCEL:
		EndDialog(hDlg, TRUE);
		accetto = IDNO;
		return(TRUE);
	    case IDOK:
		EndDialog(hDlg, TRUE);
		accetto = IDYES;
		return(TRUE);

	}
    }

    return(FALSE);
}



void AggiornaLavoro(HWND hDlg)
{
char 	  tmp[128];
   if (numeroditta < 1) {	// Nessun lavoro
    sprintf(tmp, "");
    SetDlgItemText(hDlg, 105, tmp);	// Ditta
    SetDlgItemText(hDlg, 106, tmp);	// Stipendio
    SetDlgItemText(hDlg, 107, tmp);	// Impegno
  } else {
    sprintf(tmp, "%s", LavoroMem[numeroditta].nome.UTF8String);
    SetDlgItemText(hDlg, 105, tmp);	// Ditta
    SetDlgItemText(hDlg, 106, MostraSoldi(stipendio)); // Stipendio
    sprintf(tmp, "%d/100", impegno);
	 SetDlgItemText(hDlg, 107, tmp);	// Impegno
  }
  SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
}


# pragma argsused
BOOL FAR PASCAL ElencoDitte(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 FARPROC	  lpproc;

	if (message == WM_INITDIALOG) {
		return(TRUE);
	}
	else if (message == WM_COMMAND)
	{
	 switch (wParam)
	  {			// Informazioni su ogni ditta
		 case 100:
		 case 101:
		 case 102:
		 case 103:
		 case 104:
		 case 105:
		 case 106:
		 case 107:
		 case 108:
	    case 109:
		lpproc = MakeProcInstance(CercaLavoro, hInst);
		DialogBox(hInst,
			 MAKEINTRESOURCE(wParam+190),
			 hDlg,
			 lpproc);
		FreeProcInstance(lpproc);
		return(TRUE);

		 case IDCANCEL:
		EndDialog(hDlg, TRUE);
		return(TRUE);
	    case IDOK:
		EndDialog(hDlg, TRUE);
		return(TRUE);

	}
    }

    return(FALSE);
}

