// Tabboz Simulator
// (C) Copyright 1997,1998 by Andrea Bonomi
// 30 Maggio 1999 - Conversione Tabbozzo -> Tabbozza

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

BOOL FAR PASCAL RiparaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL VendiScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL Concessionario(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL AcquistaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL TruccaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
BOOL FAR PASCAL CompraUnPezzo(HWND hDlg, WORD message, WORD wParam, LONG lParam);

/* Il 28 Aprile 1998 la procedura scooter e' cambiata radicalmente... */
void AggiornaScooter(HWND hDlg);
void AggiornaScooter_Ex(HWND hDlg, NEWSTSCOOTER * scooter, NSInteger);


int	PezziMem[] =
	{ 400,	500,  600,		/* marmitte    */
	  300,	470,  650,   800,	/* carburatori */
	  200,	400,  800,  1000,	/* cc          */
		50,	120,  270,   400	/* filtro      */
	 };

/********************************************************************/
/* Scooter...                                                       */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Scooter(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    char          tmp[128];
    
    if (message == WM_INITDIALOG) {
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
        
        sprintf(tmp, "Parcheggia scooter");
        SetDlgItemText(hDlg, 105, tmp); /* 7 Maggio 1998 */
        
        if (ScooterData.stato != -1) {
            AggiornaScooter(hDlg);
            if (ScooterData.attivita == 4) {
                sprintf(tmp, "Usa scooter");
                SetDlgItemText(hDlg, 105, tmp);
            }
        }
        
        return(TRUE);
    }
    
    else if (message == WM_COMMAND)
    {
        switch (wParam)
        {
            case 101:
                [Tabboz.global aquistaDalConcessionarioWithHDlg:hDlg];
                return(TRUE);
                
            case 102:                   /* Trucca */
                [Tabboz.global truccaScooterWithHDlg:hDlg];
                return(TRUE);

            case 103:                   /* Ripara */
                [Tabboz.global vaiARiparaScooterWithHDlg:hDlg];
                return(TRUE);

            case 105:                   /* Parcheggia / Usa Scooter	7 Maggio 1998 */
                [Tabboz.global parcheggiaOUsaScooterWithHDlg:hDlg];
                return(TRUE);

            case 106:                   /* Fai Benzina	8 Maggio 1998 */
                [Tabboz.global faiBenzinaWithHDlg:hDlg];
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



/********************************************************************/
/* Acquista Scooter                                                 */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL AcquistaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
	     int           num_moto;

	if (message == WM_INITDIALOG) {
		scelta=-1;
     	SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
		return(TRUE);
	} else if (message == WM_COMMAND) {
		switch (wParam) {
			case 121:
			case 122:
			case 123:
			case 124:
			case 125:
			case 126:
				num_moto=wParam-120;
				scelta=num_moto;
                
				AggiornaScooter_Ex(hDlg, ScooterMem[num_moto], 100);
				return(TRUE);

			case IDCANCEL:
				scelta=-1;
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


/********************************************************************/
/* Vendi Scooter                                                    */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL VendiScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    static long          offerta;  /* importante lo static !!! */
    ldiv_t        lx;
    
    if (message == WM_INITDIALOG) {
        lx=ldiv(ScooterData.prezzo, 100L);
        if ( (ScooterData.attivita == 1) || (ScooterData.attivita == 4) ) /* 0.8.1pr 28 Novembre 1998 - Se lo scooter e' sputtanato, vale meno... */
            offerta=(lx.quot * (ScooterData.stato - 10 - random(10)));
        else
            offerta=(lx.quot * (ScooterData.stato - 50 - random(10)));
        
        if (offerta < 50) offerta = 50;          /* se vale meno di 50.000 nessuno lo vuole... */
        /* 0.8.1pr 28 Novembre 1998 - se vale meno di 50.000, viene pagato 50.000      */
        
        AggiornaScooter(hDlg);
        
        SetDlgItemText(hDlg, 118, MostraSoldi(offerta));
        return(TRUE);
    }

    else if (message == WM_COMMAND)
    {
        switch (wParam) {
                
            case IDCANCEL:
                EndDialog(hDlg, TRUE);
                return(TRUE);
                
            case IDOK:
                [Tabboz.global vendiScooterWithOfferta:offerta hDlg:hDlg];
                return(TRUE);
                
            default:
                return(TRUE);
        }
    }

    return(FALSE);
}

/********************************************************************/
/* Ripara Scooter                                                   */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL RiparaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
static long       costo;  // Importante lo static !!!

	if (message == WM_INITDIALOG) {
		// Calcola il costo della riparazione dello scooter...
		costo = (ScooterData.prezzo / 100 * (100 - ScooterData.stato)) + 10;

		SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
		SetDlgItemText(hDlg, 105, MostraSoldi(costo));

		return(TRUE);
	}
    else if (message == WM_COMMAND) {
		switch (wParam) {

            case IDCANCEL:
				EndDialog(hDlg, TRUE);
				return(TRUE);

			case IDOK:
                [Tabboz.global riparaScooterWithHDlg:hDlg];
				return(TRUE);

			default:
				return(TRUE);
			}
	 }

	 return(FALSE);
}




/********************************************************************/
/* Trucca Scooter                                                   */
/* 28 Aprile 1998 La procedura per truccare gli scooter cambia completamente... */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL TruccaScooter(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
   FARPROC       lpproc;

	if (message == WM_INITDIALOG) {
	  if (sound_active) TabbozPlaySound(101);
	  AggiornaScooter(hDlg);
	  return(TRUE);
	} else if (message == WM_COMMAND) {
	  switch (wParam) {
		 case 121:
		 case 122:
		 case 123:
	    case 124:
		lpproc = MakeProcInstance(CompraUnPezzo, hInst);
		DialogBox(hInst,
		    MAKEINTRESOURCE(wParam - 121 + 74),
		    hDlg, lpproc);
		FreeProcInstance(lpproc);
		/* CalcolaVelocita(hDlg); */
		AggiornaScooter(hDlg);
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




void AggiornaScooter_Ex(HWND hDlg, NEWSTSCOOTER * scooter, NSInteger stato)
{
char 	tmp[128];
    
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));

        SetDlgItemText(hDlg, 116, scooter.nome.UTF8String);
        SetDlgItemText(hDlg, 107, Tabboz.global.benzinaString.UTF8String);

		SetDlgItemText(hDlg, 110, Tabboz.global.speed.UTF8String);
		SetDlgItemText(hDlg, 111, scooter.marmittaString.UTF8String);
		SetDlgItemText(hDlg, 112, scooter.carburatoreString.UTF8String);
		SetDlgItemText(hDlg, 113, scooter.ccString.UTF8String);
		SetDlgItemText(hDlg, 114, scooter.filtroString.UTF8String);
		sprintf(tmp, "%ld%%", stato);
        SetDlgItemText(hDlg, 115, tmp);

		SetDlgItemText(hDlg, 117, MostraSoldi(ScooterData.prezzo));

}


void AggiornaScooter(HWND hDlg) {
    if (ScooterData.stato != -1) {
        AggiornaScooter_Ex(hDlg, Tabboz.global.scooter, ScooterData.stato);

    } else {
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
        SetDlgItemText(hDlg, 107, "" );
        SetDlgItemText(hDlg, 110, "" );
        SetDlgItemText(hDlg, 111, "" );
        SetDlgItemText(hDlg, 112, "" );
        SetDlgItemText(hDlg, 113, "" );
        SetDlgItemText(hDlg, 114, "" );
        SetDlgItemText(hDlg, 115, "" );
        SetDlgItemText(hDlg, 116, "" );
        SetDlgItemText(hDlg, 117, "" );
    }

}

// -----------------------------------------------------------------------
// Routine di acquisto generika di un pezzo di motorino
// -----------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL CompraUnPezzo(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    int		  i;

    if (message == WM_INITDIALOG) {
        SetDlgItemText(hDlg, 109, Tabboz.global.nomeScooter.UTF8String);
        SetDlgItemText(hDlg, 105, Tabboz.global.carburatore.UTF8String);
        SetDlgItemText(hDlg, 106, Tabboz.global.marmitta.UTF8String);
        SetDlgItemText(hDlg, 107, Tabboz.global.cilindro.UTF8String);
        SetDlgItemText(hDlg, 108, Tabboz.global.filtro.UTF8String);
        
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
        
        for (i=110;i<125;i++) {
            SetDlgItemText(hDlg, i, MostraSoldi(PezziMem[i-110]));
        }
        
        return(TRUE);
    }

    else if (message == WM_COMMAND)
    {
        switch (wParam)
        {
            case 130:	/* marmitte ----------------------------------------------------------- */
            case 131:
            case 132:
                [Tabboz.global compraMarmittaWithWParam:wParam hDlg:hDlg];
                return(TRUE);
                
            case 133:   /* carburatore -------------------------------------------------------- */
            case 134:
            case 135:
            case 136:
                [Tabboz.global compraCarburatoreWithWParam:wParam hDlg:hDlg];
                return(TRUE);
                
            case 137:	/* cc ----------------------------------------------------------------- */
            case 138:
            case 139:
            case 140:
                [Tabboz.global compraCarburatoreWithWParam:wParam hDlg:hDlg];
                return(TRUE);
                
            case 141:   /* filtro dell' aria -------------------------------------------------- */
            case 142:
            case 143:
            case 144:
                [Tabboz.global compraFiltroWithWParam:wParam hDlg:hDlg];
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

// -----------------------------------------------------------------------
// Concessionario...  7 Maggio 1998
// -----------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL Concessionario(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    if (message == WM_INITDIALOG) {
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
        return(TRUE);
    }

    else if (message == WM_COMMAND)
    {
	switch (wParam)
	{
	    case 101:           /* Compra Scooter Malagutty	  */
	    case 102:			/* Compra Scooter di altre marche */
            [Tabboz.global compraScooterWithMarca:wParam - 101 hDlg:hInst];
            return(TRUE);

	    case 103:
            [Tabboz.global vaiAVendiScooterWithHDlg:hDlg];
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
