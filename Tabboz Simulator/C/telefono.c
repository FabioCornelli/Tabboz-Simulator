// Tabboz Simulator
// (C) Copyright 1999 by Andrea Bonomi
// Iniziato il 31 Marzo 1999
// 31 Maggio 1999 - Conversione
//                                              Tabbozzo -> Tabbozza

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

#include "zarrosim.h"

__attribute__((unused)) static char sccsid[] = "@(#)" __FILE__ " " VERSION " (Andrea Bonomi) " __DATE__;

// ------------------------------------------------------------------------------------------
//  Compra Cellulare
// ------------------------------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL   CompraCellulare(HWND hDlg, WORD message, WORD wParam, LONG lParam) 	/* 31 Marzo 1999 */
{
static int  scelta = 0;
    
    if (message == WM_INITDIALOG) {
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
        
        [Tabboz enumerateAbbonamenti:^(NSInteger i, NSInteger prezzo) {
            SetDlgItemText(hDlg, 120 + (int)i, MostraSoldi((int)prezzo));
        }];
        
        return(TRUE);
    }
    else if (message == WM_COMMAND) {

         switch (LOWORD(wParam)) {
             case 110:
             case 111:
             case 112:
                 scelta = LOWORD(wParam) - 110;
                 return(TRUE);
                 
             case IDCANCEL:
                 EndDialog(hDlg, TRUE);
                 return(TRUE);
                 
             case IDOK:
                 [Tabboz.global compraCellulare:scelta hDlg:hDlg];
                 return(TRUE);
                 
             default:
                 return(TRUE);
         }
     }
    
	 return(FALSE);
}


// ------------------------------------------------------------------------------------------
//  Abbonamento
// ------------------------------------------------------------------------------------------


# pragma argsused
BOOL FAR PASCAL   AbbonaCellulare(HWND hDlg, WORD message, WORD wParam, LONG lParam) 	/* 31 Marzo 1999 */
{

    static int  scelta = 0;

    if (message == WM_INITDIALOG) {
		SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
        SetDlgItemText(hDlg, 105, Tabboz.global.nomeAbbonamento.UTF8String);
         
         [Tabboz enumerateAbbonamenti:^(NSInteger i, NSInteger prezzo) {
             SetDlgItemText(hDlg, 110 + (int)i, MostraSoldi((int)prezzo));
         }];
         
		return(TRUE);
	 }
    else if (message == WM_COMMAND) {

		switch (LOWORD(wParam)) {

		case 110:
		case 111:
		case 112:
		case 113:
		case 114:
		case 115:
		case 116:
		case 117:
		case 118:
			scelta = LOWORD(wParam) - 110;
			return(TRUE);

		case IDCANCEL:
			EndDialog(hDlg, TRUE);
			return(TRUE);

		case IDOK:
            [Tabboz.global compraAbbonamento:scelta :hDlg];
			return(TRUE);

		default:
			return(TRUE);
		}
	 }

	 return(FALSE);
}




// ------------------------------------------------------------------------------------------
//  Cellulare
// ------------------------------------------------------------------------------------------

void AggiornaCell(HWND hDlg)
{
    SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
    SetDlgItemText(hDlg, 120, Tabboz.global.nomeCellulare.UTF8String);
    SetDlgItemText(hDlg, 121, Tabboz.global.nomeAbbonamento.UTF8String);    // Abbonamento
    SetDlgItemText(hDlg, 122, Tabboz.global.creditoAbbonamento.UTF8String); // Credito
}


#pragma argsused
BOOL FAR PASCAL        Cellular(HWND hDlg, WORD message, WORD wParam, LONG lParam) 	/* 31 Marzo 1999 */
{
    if (message == WM_INITDIALOG) {
		AggiornaCell(hDlg);
		return(TRUE);
    }
    else if (message == WM_COMMAND) {
		switch (LOWORD(wParam)) {
            case 110:
                [Tabboz.global vaiACompraCellulareWithHDlg:hDlg];
                return(TRUE);

            case 111:
                [Tabboz.global vendiCellulareWithHDlg:hDlg];
                return(TRUE);

            case 112:
                [Tabboz.global vaiAdAbbonaCellulareWithHDlg:hDlg];
                return(TRUE);

            case 150:
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





