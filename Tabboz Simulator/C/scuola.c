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


void ScriviVoti(HWND parent);
void Aggiorna(HWND parent);

/********************************************************************/
/* Scuola...							    */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Scuola(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    char          tmp[128];

    if (message == WM_INITDIALOG) {
		scelta=1;
		SendMessage(GetDlgItem(hDlg, 110), BM_SETCHECK, TRUE, 0L); /* Seleziona agraria */

		sprintf(tmp, "Corrompi il prof di %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);
		SetDlgItemText(hDlg, 101, tmp);
		if (sesso == 'M')
			sprintf(tmp, "Minaccia il prof di %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);
		else
			sprintf(tmp, "Seduci il prof di %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);

		SetDlgItemText(hDlg, 102, tmp);
		sprintf(tmp, "Studia %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);
		SetDlgItemText(hDlg, 103, tmp);

		ScriviVoti(hDlg);  /* Scrive i voti, soldi, reputazione e studio nelle apposite caselle */
		return(TRUE);

	} else if (message == WM_COMMAND) {
	switch (wParam)
	{
		case 101:                    /* Corrompi i professori */
            [Tabboz.global corrompiIProfessoriWithHDlg:hDlg];
			return(TRUE);

		case 102:                    /* Minaccia-Seduci i professori */
            [Tabboz.global minacciaIProfessoriWithHDlg:hDlg];
            return(TRUE);

		case 103:                    /* Studia */
            [Tabboz.global studiaWithHDlg:hDlg];
            return(TRUE);

		 case 110:
		 case 111:
		 case 112:
		 case 113:
		 case 114:
		 case 115:
		 case 116:
		 case 117:
		 case 118:
			scelta=wParam-109;
            sprintf(tmp, "Corrompi il prof di %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String); SetDlgItemText(hDlg, 101, tmp);
			if (sesso == 'M')
				sprintf(tmp, "Minaccia il prof di %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);
			else
				sprintf(tmp, "Seduci il prof di %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);
			SetDlgItemText(hDlg, 102, tmp);
			sprintf(tmp, "Studia %s",[Tabboz.global nomeDellaMateria:scelta].UTF8String);
            SetDlgItemText(hDlg, 103, tmp);
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


/* Scrive i voti nelle apposite caselle */
void
ScriviVoti(HWND parent)
{
    int i;
    char tmp[128];
    ScuolaRedraw=0;
    
    SetDlgItemText(parent, 104, MostraSoldi(Soldi));
    sprintf(tmp, "%d/100", Reputazione);
    SetDlgItemText(parent, 105, tmp);
    sprintf(tmp, "%d/100", Studio);
    SetDlgItemText(parent, 106, tmp);
    
    for (i=1;i<10;i++) {
        sprintf(tmp, "%ld",[Tabboz.global votoDellaMateria:i]);
        SetDlgItemText(parent, i + 119, tmp);
    }
}

/* Aggiorna */
void
Aggiorna(HWND parent)
{
    char tmp[128];
    
    if (ScuolaRedraw == 1) ScriviVoti(parent);
    
    SetDlgItemText(parent, 104, MostraSoldi(Soldi));
    
    sprintf(tmp, "%d/100", Reputazione);
    SetDlgItemText(parent, 105, tmp);
    
    sprintf(tmp, "%d/100", Studio);
    SetDlgItemText(parent, 106, tmp);
    
    sprintf(tmp, "%ld",[Tabboz.global votoDellaMateria:scelta]);
    SetDlgItemText(parent, scelta + 119, tmp);
}
