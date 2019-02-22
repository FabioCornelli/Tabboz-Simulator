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

void CalcolaVelocita(HWND hDlg);

const char *MostraSpeed(void);


int	PezziMem[] =
	{ 400,	500,  600,		/* marmitte    */
	  300,	470,  650,   800,	/* carburatori */
	  200,	400,  800,  1000,	/* cc          */
		50,	120,  270,   400	/* filtro      */
	 };

void CalcolaVelocita(HWND hDlg) {
    
    if (ScooterData.attivitaCalcolata != 1) {
        char   buf[128];
        
        sprintf(buf,"Il tuo scooter e' %s.", Tabboz.global.attivitaScooter.UTF8String);
        MessageBox( hDlg, buf, "Attenzione", MB_OK | MB_ICONINFORMATION);
        return;
    }
}

/********************************************************************/
/* Scooter...                                                       */
/********************************************************************/

# pragma argsused
BOOL FAR PASCAL Scooter(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    char          buf[128];
    char          tmp[128];
    FARPROC       lpproc;

    if (message == WM_INITDIALOG) {
	SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));

	sprintf(tmp, "Parcheggia scooter");               SetDlgItemText(hDlg, 105, tmp); /* 7 Maggio 1998 */

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
		if ( x_vacanza == 2 ) {
			sprintf(tmp,"Oh, tip%c... oggi il concessionario e' chiuso...",ao);
			MessageBox( hDlg,
			  tmp,
			  "Concessionario", MB_OK | MB_ICONINFORMATION);
			return(TRUE);
		}

		lpproc = MakeProcInstance(Concessionario, hInst);
		DialogBox(hInst,
			  MAKEINTRESOURCE(ACQUISTASCOOTER),
			  hDlg,
			  lpproc);
		FreeProcInstance(lpproc);
		Evento(hDlg);
		AggiornaScooter(hDlg);
		return(TRUE);

	    case 102:                   /* Trucca */
		if (ScooterData.stato != -1) {
			if ( x_vacanza != 2 ) {
				/* 28 Aprile 1998 La procedura per truccare gli scooter cambia completamente... */
				lpproc = MakeProcInstance(TruccaScooter, hInst);
				DialogBox(hInst,
				    MAKEINTRESOURCE(73),
				    hDlg,
				    lpproc);

				FreeProcInstance(lpproc);
				Evento(hDlg);
				AggiornaScooter(hDlg);

				return(TRUE);
			} else {
				sprintf(tmp,"Oh, tip%c... oggi il meccanico e' chiuso...",ao);
				MessageBox( hDlg, tmp,
				"Trucca lo scooter", MB_OK | MB_ICONINFORMATION);
			}
		} else MessageBox( hDlg,
			  "Scusa, ma quale scooter avresti intenzione di truccare visto che non ne hai neanche uno ???",
			  "Trucca lo scooter", MB_OK | MB_ICONQUESTION);

		sprintf(tmp, "Parcheggia scooter");	/* 7 Maggio 1998 */
		SetDlgItemText(hDlg, 105, tmp);

		if (ScooterData.attivita == 4) {
			sprintf(tmp, "Usa scooter");
			SetDlgItemText(hDlg, 105, tmp);
			}

		Evento(hDlg);
		return(TRUE);

	    case 103:                   /* Ripara */
			if (ScooterData.stato != -1) {
				if (ScooterData.stato == 100)
					MessageBox( hDlg,
						"Che motivi hai per voleer riparare il tuo scooter\nvisto che e' al 100% di efficienza ???",
						"Ripara lo scooter", MB_OK | MB_ICONQUESTION);
				else {
					if ( x_vacanza != 2 ) {
						lpproc = MakeProcInstance(RiparaScooter, hInst);
							DialogBox(hInst,
							MAKEINTRESOURCE(RIPARASCOOTER),
							hDlg,lpproc);
						FreeProcInstance(lpproc);
						AggiornaScooter(hDlg);
					} else {
						sprintf(tmp,"Oh, tip%c... oggi il meccanico e' chiuso...",ao);
						MessageBox( hDlg, tmp,
							"Ripara lo scooter", MB_OK | MB_ICONINFORMATION);
						}
					}
				return(TRUE);
			} else MessageBox( hDlg,
				  "Mi spieghi come fai a farti riparare lo scooter se non lo hai ???",
				  "Ripara lo scooter", MB_OK | MB_ICONQUESTION);
			Evento(hDlg);
			return(TRUE);

		 case 105:                   /* Parcheggia / Usa Scooter	7 Maggio 1998 */
		if (ScooterData.stato < 0) {
			MessageBox( hDlg,
			  "Mi spieghi come fai a parcheggiare lo scooter se non lo hai ???",
			  "Parcheggia lo scooter", MB_OK | MB_ICONQUESTION);
			return(TRUE);
			}

            if ([Tabboz.global.scooter usaOParcheggia]) {
                SetDlgItemText(hDlg, 105, ScooterData.attivita == 4 ? "Usa scooter" : "Parcheggia scooter");
            }
            else{
                sprintf(buf, "Mi spieghi come fai a parcheggiare lo scooter visto che e' %s ???",Tabboz.global.attivitaScooter.UTF8String);
				 MessageBox( hDlg,
				   buf,
				   "Parcheggia lo scooter", MB_OK | MB_ICONQUESTION);
            }

		AggiornaScooter(hDlg);
		return(TRUE);


	    case 106:                   /* Fai Benzina	8 Maggio 1998 */
		if (ScooterData.stato < 0) {
			MessageBox( hDlg,
			  "Mi spieghi come fai a far benzina allo scooter se non lo hai ???",
			  "Fai benza", MB_OK | MB_ICONQUESTION);
			return(TRUE);
			}

		switch (ScooterData.attivita)
		{
			case 1:
			case 2:
			case 3:
			case 6:
                if ([Tabboz.global.danaro paga:10]) {
                    sprintf(buf,
                            "Al distributore automatico puoi fare un minimo di %s di benzina...",
                            MostraSoldi(10));
                    
                    MessageBox(hDlg,
                               buf,
                               "Fai benza", MB_OK | MB_ICONQUESTION);
                }
                
                else {
#ifdef TABBOZ_DEBUG
                    sprintf(tmp,"scooter: Paga benzina (%s)",MostraSoldi(10));
                    writelog(tmp);
#endif
                    
                    [Tabboz.global.scooter faiIlPieno];
                    
                    CalcolaVelocita(hDlg);
                    
                    sprintf(buf,
                            "Fai %s di benzina e riempi lo scooter...",
                            MostraSoldi(10));
                    
                    MessageBox(hDlg,
                               buf,
                               "Fai benza", MB_OK | MB_ICONINFORMATION);
                }
                
                break;

			default: sprintf(buf, "Mi spieghi come fai a far benzina allo scooter visto che e' %s ???",Tabboz.global.attivitaScooter.UTF8String);
				 MessageBox( hDlg,
				   buf,
					"Fai benza", MB_OK | MB_ICONQUESTION);
		};

		AggiornaScooter(hDlg);
		Evento(hDlg);
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
       char          tmp[128]; /* Arghhhh ! fino alla 0.8.0 qui c'era un 30 che faceva crashiare tutto !!!! */
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
	switch (wParam)
	{
	    case IDCANCEL:
		EndDialog(hDlg, TRUE);
		return(TRUE);

	    case IDOK:
            [Tabboz.global.scooter distruggi];
            [Tabboz.global.danaro deposita:offerta];

		#ifdef TABBOZ_DEBUG
			sprintf(tmp,"scooter: Vendi lo scooter per %s",MostraSoldi(offerta));
			writelog(tmp);
		#endif

		EndDialog(hDlg, TRUE);
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
		 char       tmp[128];
static long       costo;  // Importante lo static !!!

	if (message == WM_INITDIALOG) {
		// Calcola il costo della riparazione dello scooter...
		costo= (ScooterData.prezzo / 100 * (100 - ScooterData.stato)) + 10;

		SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));
		SetDlgItemText(hDlg, 105, MostraSoldi(costo));

		return(TRUE);

	} else if (message == WM_COMMAND) {
		switch (wParam) {

			case IDCANCEL:

				EndDialog(hDlg, TRUE);
				return(TRUE);

			case IDOK:

				if (![Tabboz.global.danaro paga:costo])
					nomoney(hDlg,SCOOTER);
				else {

					#ifdef TABBOZ_DEBUG
					sprintf(tmp,"scooter: Paga riparazione (%s)",MostraSoldi(costo));
					writelog(tmp);
					#endif

// Per questa cagata, crascia il tabboz all' uscita...
//					if (sound_active) TabbozPlaySound(102);

                    [Tabboz.global.scooter ripara];
                    
					CalcolaVelocita(hDlg);
				}
				EndDialog(hDlg, TRUE);
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



#undef ScooterData

void AggiornaScooter_Ex(HWND hDlg, NEWSTSCOOTER * ScooterData, NSInteger stato)
{
char 	tmp[128];
    
        SetDlgItemText(hDlg, 104, MostraSoldi(Soldi));

        SetDlgItemText(hDlg, 116, ScooterData.nome.UTF8String);
        SetDlgItemText(hDlg, 107, Tabboz.global.scooter.benzinaString.UTF8String);

		SetDlgItemText(hDlg, 110, MostraSpeed());
		SetDlgItemText(hDlg, 111, Tabboz.global.marmittaString.UTF8String);
		SetDlgItemText(hDlg, 112, Tabboz.global.carburatoreString.UTF8String);
		SetDlgItemText(hDlg, 113, Tabboz.global.ccString.UTF8String);
		SetDlgItemText(hDlg, 114, Tabboz.global.filtroString.UTF8String);
		sprintf(tmp, "%ld%%", stato);
        SetDlgItemText(hDlg, 115, tmp);

		SetDlgItemText(hDlg, 117, MostraSoldi(ScooterData.prezzo));

}

#define ScooterData Tabboz.global.scooter

void AggiornaScooter(HWND hDlg) {
    if (ScooterData.stato != -1) {
        AggiornaScooter_Ex(hDlg, Tabboz.global.scooter.scooter, ScooterData.stato);

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
	 char      tmp[128];
	 int		  i;

    if (message == WM_INITDIALOG) {
	SetDlgItemText(hDlg, 109, Tabboz.global.nomeScooter.UTF8String);
	SetDlgItemText(hDlg, 105, Tabboz.global.carburatoreString.UTF8String);
	SetDlgItemText(hDlg, 106, Tabboz.global.marmittaString.UTF8String);
	SetDlgItemText(hDlg, 107, Tabboz.global.ccString.UTF8String);
	SetDlgItemText(hDlg, 108, Tabboz.global.filtroString.UTF8String );

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
            if (![Tabboz.global.danaro paga:PezziMem[wParam - 130]]) {
                nomoney(hDlg,SCOOTER);
                return(TRUE);
            }

        #ifdef TABBOZ_DEBUG
		sprintf(tmp,"scooter: Paga marmitta (%s)",MostraSoldi(PezziMem[wParam - 130]));
		writelog(tmp);
		#endif

		ScooterData.scooter.marmitta = (wParam - 129); /* (1 - 3 ) */
		CalcolaVelocita(hDlg);
		EndDialog(hDlg, TRUE);
		return(TRUE);

	    case 133:   /* carburatore -------------------------------------------------------- */
	    case 134:
	    case 135:
	    case 136:
            if (![Tabboz.global.danaro paga:PezziMem[wParam - 130]]) {
				nomoney(hDlg,SCOOTER);
				return(TRUE);
			}
			#ifdef TABBOZ_DEBUG
			sprintf(tmp,"scooter: Paga carburatore (%s)",MostraSoldi(PezziMem[wParam - 130]));
			writelog(tmp);
			#endif

			ScooterData.scooter.carburatore = (wParam - 132 );  /* ( 1 - 4 ) */
			CalcolaVelocita(hDlg);
			EndDialog(hDlg, TRUE);
			return(TRUE);

		 case 137:	/* cc ----------------------------------------------------------------- */
		 case 138:
		 case 139:
		 case 140:
            if (![Tabboz.global.danaro paga:PezziMem[wParam - 130]]) {
				nomoney(hDlg,SCOOTER);
				return(TRUE);
			}
			#ifdef TABBOZ_DEBUG
			sprintf(tmp,"scooter: Paga cilindro e pistone (%s)",MostraSoldi(PezziMem[wParam - 130]));
			writelog(tmp);
			#endif

			/* Piccolo bug della versione 0.6.91, qui c'era scritto ScooterData.marmitta */
			/* al posto di ScooterData.cc :-) */
			ScooterData.scooter.cc = (wParam - 136); /* ( 1 - 4 ) */
			CalcolaVelocita(hDlg);
			EndDialog(hDlg, TRUE);
			return(TRUE);

		 case 141:   /* filtro dell' aria -------------------------------------------------- */
		 case 142:
		 case 143:
		 case 144:
            if (![Tabboz.global.danaro paga:PezziMem[wParam - 130]]) {
				nomoney(hDlg,SCOOTER);
				return(TRUE);
			}
			#ifdef TABBOZ_DEBUG
			sprintf(tmp,"scooter: Paga filtro dell' aria (%s)",MostraSoldi(PezziMem[wParam - 130]));
			writelog(tmp);
			#endif

			ScooterData.scooter.filtro = (wParam - 140); /* (1 - 4) */
			CalcolaVelocita(hDlg);
			EndDialog(hDlg, TRUE);
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

const char	*MostraSpeed(void)
{
    return Tabboz.global.speedString.UTF8String;
}


// -----------------------------------------------------------------------
// Concessionario...  7 Maggio 1998
// -----------------------------------------------------------------------

# pragma argsused
BOOL FAR PASCAL Concessionario(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
    char          tmp[128];
    FARPROC       lpproc;

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
