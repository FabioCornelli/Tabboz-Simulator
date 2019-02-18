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
    [Tabboz.global eventiWithHDlg:hInstance];
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

