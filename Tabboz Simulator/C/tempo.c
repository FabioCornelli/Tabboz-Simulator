// Tabboz Simulator
// (C) Copyright 1997-2000 by Andrea Bonomi
// 5 Giugno 1999 - Conversione Tabbozzo -> Tabbozza

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
 char natale2;



// ------------------------------------------------------------------------------------------
// Giorno...
// ------------------------------------------------------------------------------------------


void	Giorno(HANDLE hInstance)
{
    [Tabboz.global giornoWithHInstance:hInstance];
}




// ------------------------------------------------------------------------------------------
// Mostra la pagella...
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL MostraPagella(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	 char          tmp[1024];
	 int i,k;

	 if (message == WM_INITDIALOG) {
	k=0;
	for (i=1;i<10;i++) {
		if (MaterieMem[i].xxx < 6) k++;		/* k = materie insuff o grav. insuf. */
		if (MaterieMem[i].xxx < 4) k++;		/* k = materie insuff o grav. insuf. */
		sprintf(tmp, "%ld",MaterieMem[i].xxx);
		SetDlgItemText(hDlg, i + 119, tmp);
	}

	if (Fama > 75)					// Condotta... + un e' figo, + sembra un bravo ragazzo...
		SetDlgItemText(hDlg, 129, "8");
	else
    	SetDlgItemText(hDlg, 129, "9");

	if (k > 4) {
		if (sound_active) TabbozPlaySound(401);
		sprintf(tmp, "NON ammess%c",ao);		/* bocciata/o */
		#ifdef TABBOZ_DEBUG
		writelog("giorno: Pagella... Bocciato !!!");
		#endif

	} else {
		sprintf(tmp, "ammess%c",ao);		/* promossa/o */
        [Tabboz.global.danaro deposita:200];
		#ifdef TABBOZ_DEBUG
		writelog("giorno: Pagella... Promosso...");
		#endif
	}

	SetDlgItemText(hDlg, 119, tmp);
	return(TRUE);
	}

    else if (message == WM_COMMAND)
    {
	switch (wParam)
	{
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
