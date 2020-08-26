//
//  stubs.h
//  Tabboz Simulator
//
//  Created by Antonio Malara on 11/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

#ifndef stubs_h
#define stubs_h

#define FAR
#define NEAR
#define PASCAL

#define TABBOZ_WIN
#define TABBOZ_WIN32

#define random tabboz_random
#define openlog tabboz_openlog

#define BOOL _Bool

// -
// Type definitions
// -

//

typedef int bc;

typedef int WORD;
typedef int DWORD;
typedef int LONG;
typedef int HKEY;
typedef uint32_t COLORREF;

@class Win32HBITMAP;
typedef Win32HBITMAP * HBITMAP;

@class Win32HDC;
typedef Win32HDC * HDC;

typedef struct {
    int bmWidth;
    int bmHeight;
} BITMAP;

typedef char * LPSTR;
typedef void * LPCREATESTRUCT;
typedef int ATOM;

typedef struct {
    int right;
    int left;
    int bottom;
    int top;
} RECT;

typedef RECT* LPRECT;
typedef int HICON;
typedef int PAINTSTRUCT;

//

struct TabbozHANDLE { void * impl; };

typedef struct TabbozHANDLE * HANDLE;
typedef struct TabbozHANDLE * HWND;

//typedef struct TabbozDialogProc * DialogProc;

typedef _Bool (*DialogProcFunc)(HANDLE, WORD, WORD, LONG);

typedef DialogProcFunc FARPROC;

struct TabbozINTRESOURCE {
    int number;
    const char * n;
};

typedef struct TabbozINTRESOURCE INTRESOURCE;

//

typedef struct {
    int    lStructSize;
    HANDLE hwndOwner;
    HANDLE hInstance;
    char * lpstrFile;
    int    nMaxFile;
    char * lpstrDefExt;
    char * lpstrFilter;
    int    Flags;
} OPENFILENAME;

typedef struct {
    long   (*lpfnWndProc)(HANDLE hWnd, WORD msg, WORD wParam, LONG lParam);
    HANDLE hInstance;
    int    hCursor;
    int    hbrBackground;
    char   *lpszClassName;
} WNDCLASS;

// -
// Constants Definitions
// -

static const int SRCAND = 0;
static const int SRCPAINT = 0;
static const int SRCCOPY = 0;

static const int SC_CLOSE = 0;
static const int BM_SETCHECK = 0;

static const int MF_BYCOMMAND = 0;
static const int MF_STRING = 0;
static const int MF_SEPARATOR = 0;

static const int MB_OK = 0x00000000;
static const int MB_YESNO = 0x00000004;
static const int MB_ICONQUESTION = 0x00000020L;
static const int MB_ICONINFORMATION = 0x00000040L;
static const int MB_ICONCONFIRMATION = 0x00000020L;
static const int MB_ICONSTOP = 0x00000010;
static const int MB_ICONHAND = 0x00000010;

static const int WM_INITDIALOG = 0;
static const int WM_COMMAND = 1;
static const int WM_CREATE = 2;
static const int WM_DESTROY = 3;
static const int WM_PAINT = 4;
static const int WM_LBUTTONDOWN = 5;
static const int WM_TIMER = 5;
static const int WM_ENDSESSION = 6;
static const int WM_QUERYDRAGICON = 7;
static const int WM_SYSCOMMAND = 8;

static const int IDOK = 1;
static const int IDCANCEL = 2;
static const int IDYES = 6;
static const int IDNO = 7;

static const int SM_CXSCREEN = 0;
static const int SM_CYSCREEN = 0;

static const int SW_HIDE = 0;
static const int SW_SHOWNORMAL = 0;

static const int MAX_PATH = 512;

static const int OFN_HIDEREADONLY = 0;
static const int OFN_FILEMUSTEXIST = 0;
static const int OFN_OVERWRITEPROMPT = 0;
static const int OFN_NOTESTFILECREATE = 0;

static const int SWP_NOMOVE = 0;
static const int SWP_NOZORDER = 0;

static const INTRESOURCE IDC_ARROW = { .number = 0 };
static const int COLOR_WINDOW = 0;

static const int REG_OPTION_NON_VOLATILE = 0;
static const int KEY_ALL_ACCESS = 0;
static const int HKEY_CURRENT_USER = 0;
static const int HKEY_ALL_ACCESS = 0;

static const int SND_ASYNC = 0;
static const int SND_NODEFAULT = 0;

extern char * _argv[];
extern int _argc;
extern HANDLE hWndMain;
extern HANDLE hInst;
extern HANDLE tipahDlg;
extern int ps;
extern char ao;

HICON LoadIcon(HANDLE h, INTRESOURCE r);
void BWCCRegister(HANDLE _);
void randomize(void);
int tabboz_random(int x);
void LoadString(HANDLE hinst, int b, LPSTR ptr, int size);
int LoadCursor(HANDLE hinst, INTRESOURCE b);
ATOM RegisterClass(WNDCLASS * wc);

INTRESOURCE MAKEINTRESOURCE_Real(int a, const char * n);

#define MAKEINTRESOURCE(x) MAKEINTRESOURCE_Real(x, NULL)

void new_reset_check(void);
int new_check_i(int x);
u_long new_check_l(u_long x);
int DialogBox(HWND hinst, INTRESOURCE b, void * c, DialogProcFunc proc);
FARPROC MakeProcInstance(DialogProcFunc proc, HWND hinst);
void FreeProcInstance(FARPROC proc);
int GetDlgItem(HWND hDlg, int x);
int LOWORD(int x);
int HIWORD(int x);
void EnableWindow(int x, int a);
void SendMessage(int dlg, int msg, int value, int x);
void EndDialog(HANDLE dlg, BOOL x) ;
void ShowWindow(HANDLE h, int flags);
void SetDlgItemText(HANDLE h, int d, const char * str);
int GetMenu(HANDLE h);
void DeleteMenu(int menu, int item, int flags);
int GetSubMenu(int menu, int i);
void AppendMenu(int menu, int type, int cmd, char * label);
int GetSystemMenu(HANDLE h, int menu);
void DrawMenuBar(HANDLE h);
void SetTimer(HANDLE h, int msg, int msec, void *);
void KillTimer(HANDLE h, int msg);
void PlaySound(void *, void *, int);
int MessageBox(HANDLE h, const char * msg, const char * title, int flags);
void GetDlgItemText(HANDLE h, int param, char * buf, size_t size);
void sndPlaySound(char * filename, int flags);
int GetSystemMetrics(int x);
void MoveWindow(HANDLE handle, int x, int y, int w, int h, int q);
void SetFocus(int dlg);

HDC CreateCompatibleDC(HDC);
HBITMAP SelectObject(HDC, HBITMAP);
COLORREF SetBkColor(HDC, COLORREF);
COLORREF RGB(int, int, int);
void BitBlt(HDC, int x, int y,int cx, int cy, HDC hdc, int sx, int sy, int flags);
HDC GetDC(void *);
void DeleteDC(HDC);
void ReleaseDC(void *, HDC);
void GetObject(HBITMAP, size_t, LPSTR);
void DeleteObject(HBITMAP);
HBITMAP CreateBitmap(int width, int height, int planes, int bitdepth, void * info);
void SetTextColor(HDC, int);
HDC BeginPaint(HANDLE, PAINTSTRUCT *);
void EndPaint(HANDLE, PAINTSTRUCT *);
HBITMAP GetProp(HANDLE, char * name);
void SetProp(HANDLE, char *, HBITMAP);
void RemoveProp(HANDLE, char *);

HBITMAP LoadBitmap(HANDLE, INTRESOURCE);
void GetWindowRect(HANDLE, RECT *);
void SpegniISuoni(void);
void DestroyIcon(HICON);
BOOL IsIconic(HANDLE);
void ExitWindows(int, int);
BOOL GetOpenFileName(OPENFILENAME *);
BOOL GetSaveFileName(OPENFILENAME *);
void SetWindowPos(HANDLE, void *, int, int, int, int, int);
long DefWindowProc(HANDLE, WORD msg, WORD wparam, LONG lparam);
LONG RegOpenKeyEx(int a, char * keyName, int c, int d, HKEY * hkey);
LONG RegCreateKeyEx(int hkey,
                    char * name,
                    int c,
                    void * d,
                    int opt,
                    int access,
                    void * g,
                    HKEY *xKey,
                    LONG *disposition);
void RegSetValue(HKEY key, char * keyName, int c, char * keyValue, DWORD keylen);
void RegCloseKey(HKEY key);
LONG RegQueryValue(HKEY key, char * keyName, char * keyValue, LONG * keyLen);
void WritePrivateProfileString(char * a, char * keyName, char * keyValue, char * filename);
void GetPrivateProfileString(char * a, char * keyName, void * c, char * keyValue, int e, char * filename);

#endif /* stubs_h */
