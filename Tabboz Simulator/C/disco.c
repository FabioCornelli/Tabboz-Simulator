// Tabboz Simulator
// (C) Copyright 1997-1999 by Andrea Bonomi
// 6 Aprile 1999 - Inizio implementazione lettore CDROM
// 30 Maggio 1999 - Conversione Tabbozzo -> Tabbozza

#include "os.h"

// Lettore di CD-ROM per Windows... (cagata !)
// #define CDROM

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef TABBOZ_WIN
// #ifdef CDROM
// #include <mmsystem.h>
// #endif
#endif

#include "zarrosim.h"
__attribute__((unused)) static char sccsid[] = "@(#)" __FILE__ " " VERSION " (Andrea Bonomi) " __DATE__;
static int  numdisco;


//******************************************************************
// Disco...
//******************************************************************

# pragma argsused
BOOL FAR PASCAL Disco(HWND hDlg, WORD message, WORD wParam, LONG lParam)
{
		 char          buf[1024];
		 char				tmp[1024];
#ifdef TABBOZ_WIN
#ifdef CDROM
static char          mciTmp[1024];
static int				mciLen;
static DWORD			mciReturn;
#endif
#endif

	 if (message == WM_INITDIALOG) {
		numdisco=0;
		sprintf(buf, "O tip%c, in che disco andiamo ?",ao);
		SetDlgItemText(hDlg, 120, buf);

	/* [24 Marzo 1998] -  Perche' Discoteca era fino ad */
	/* oggi l'unica finestra che non mostrava i soldi   */
	/* che il tabbozzo ha ??? 			    */
		SetDlgItemText(hDlg, 110, MostraSoldi(Soldi));
#ifdef TABBOZ_WIN
#ifdef CDROM
//		mciReturn=mciSendString("open cdaudio", mciTmp, mciLen, 0);
		mciReturn=mciSendString("set cdaudio time format tmsf", mciTmp, mciLen, 0);

//		mciReturn=mciSendString("set cdaudio door open", mciTmp, mciLen, 0);
//		mciReturn=mciSendString("close cdaudio", mciTmp, mciLen, 0);
#endif
#endif
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
			numdisco=wParam-100;
			LoadString(hInst, wParam, buf, 1024);

			if (sesso == 'M')	// Le donne pagano meno...
				sprintf(tmp,buf,MostraSoldi(DiscoMem[numdisco].prezzo));
			else
				sprintf(tmp,buf,MostraSoldi(DiscoMem[numdisco].prezzo - 10));

			SetDlgItemText(hDlg, 120, tmp);
			return(TRUE);
#ifdef TABBOZ_WIN
#ifdef CDROM
		 case 607: // Eject
			mciReturn=mciSendString("status cdaudio mode", mciTmp, mciLen, 0);
			sprintf(buf,"%s",mciTmp);
			SetDlgItemText(hDlg, 120, buf);

			if (! strcmp(mciTmp,"open") )
				mciReturn=mciSendString("set cdaudio door close", mciTmp, mciLen, 0);
			else
				mciReturn=mciSendString("set cdaudio door open", mciTmp, mciLen, 0);
			return(TRUE);
#endif
#endif

		 case IDCANCEL:
			EndDialog(hDlg, TRUE);
			return(TRUE);

		 case IDOK:
            if (numdisco != 0) {
                [Tabboz.global vaiInDisco:numdisco hDlg:hDlg];
            }
                
			EndDialog(hDlg, TRUE);
			return(TRUE);

		 default:
			return(TRUE);

		}
	 }

	 return(FALSE);
}


