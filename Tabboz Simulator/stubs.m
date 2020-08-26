//
//  stubs.c
//  Tabboz Simulator
//
//  Created by Antonio Malara on 10/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

#include <stdlib.h>
#include "os.h"

long DefWindowProc(HANDLE a, WORD b, WORD c, LONG d)       { abort(); }
void DeleteObject()                                        { abort(); }
void DestroyIcon()                                         { abort(); }
BOOL GetOpenFileName(OPENFILENAME * a)                     { abort(); }
BOOL GetSaveFileName(OPENFILENAME * a)                     { abort(); }
void GetPrivateProfileString()                             { abort(); }
void GetWindowRect()                                       { abort(); }
BOOL IsIconic(HANDLE a)                                    { abort(); }
void RegCloseKey()                                         { abort(); }
LONG RegQueryValue(HKEY a, char *b, char * c, LONG *d)     { abort(); }
void RegSetValue()                                         { abort(); }
void RemoveProp()                                          { abort(); }
void WritePrivateProfileString()                           { abort(); }
void new_counter()                                         { abort(); }
void ExitWindows()                                         { abort(); }

char * _argv[] = {""};
int _argc = 0;
int ps = 0;

void BWCCRegister(HANDLE _) {
    ;
}

void randomize() {
    ;
}

int tabboz_random(int x) {
    return 0;
}

LONG RegOpenKeyEx(int a, char * keyName, int c, int d, HKEY * hkey) {
    // Just fail
    //    printf("%s -- %d, %s, %d, %d, %p\n", __PRETTY_FUNCTION__, a, keyName, c, d, hkey);
    return 1;
}

LONG RegCreateKeyEx(int hkey,
                    char * name,
                    int c,
                    void * d,
                    int opt,
                    int access,
                    void * g,
                    HKEY *xKey,
                    LONG *disposition)
{
    // Just fail
    //    printf("%s -- %d, %s, %d, %p, %d %d %p %p %p\n", __PRETTY_FUNCTION__, hkey, name, c, d, opt, access, g, xKey, disposition);
    return 1;
}

void LoadString(HANDLE hinst, int b, LPSTR ptr, int size) {
    // Don't know where this strings come from yet
    snprintf(ptr, size, "String %d", b);
}

int LoadCursor(HANDLE hinst, INTRESOURCE b) {
    //    printf("%s -- %d, %d\n", __PRETTY_FUNCTION__, hinst, b);
    return 0;
}

ATOM RegisterClass(WNDCLASS * wc) {
    ApplicationHandle * handle = (__bridge ApplicationHandle *)wc->hInstance->impl;
    [handle registerClassWithClass:*wc];
    return 0;
}

INTRESOURCE MAKEINTRESOURCE_Real(int a, const char * n) {
    return (INTRESOURCE) {
        .number = a,
        .n = n,
    };
}

void new_reset_check() {
    ;
}

int new_check_i(int x) {
    return x;
}

u_long new_check_l(u_long x) {
    return x;
}

int DialogBox(HWND hinst, INTRESOURCE b, void * c, FARPROC proc) {
    ApplicationHandle * handle = (__bridge ApplicationHandle *)hinst->impl;
    [handle dialogBoxWithDlg:b parentHandle:(HANDLE)c farproc:proc];
    return 0;
}

FARPROC MakeProcInstance(DialogProcFunc proc, HWND hinst) {
    return proc;
}

void FreeProcInstance(FARPROC proc) {
}

int GetDlgItem(HWND hDlg, int x) {
    return x;
}

int LOWORD(int x) {
    return x;
}

int HIWORD(int x) {
    return x;
}

BOOL log_window = true;
BOOL didLog = false;
BOOL enableDialogTrace = false;
BOOL shouldEndDialog = false;

void EnableWindow(int x, int a) {
    if (log_window) printf("    enable window %d\n", x); didLog = true;
}

void SendMessage(int dlg, int msg, int value, int x) {
    if (log_window) printf("    sending dlg: %d, msg: %d, value: %d, x: %d\n", dlg, msg, value, x); didLog = true;
}

void EndDialog(HANDLE dlg, BOOL x) {
    [ApplicationHandle endDialogWithDlg:dlg result:x];
}

HICON LoadIcon(HANDLE h, INTRESOURCE r) {
    return 0;
}

void ShowWindow(HANDLE h, int flags) {
    if (log_window) printf("    show window %p %d\n", h, flags); didLog = true;
}

void SetDlgItemText(HANDLE h, int d, const char * str) {
    DialogNSWindow * dialogWin = (__bridge DialogNSWindow *)h->impl;
    [dialogWin setDlgItemTextWithDlg:d text:[NSString stringWithCString:str encoding:NSUTF8StringEncoding]];
}

int GetMenu(HANDLE h) {
    return 0;
}

void DeleteMenu(int menu, int item, int flags) {
    if (log_window) printf("    delete menu %d item %d flags %d\n", menu, item, flags); didLog = true;
}

int GetSubMenu(int menu, int i) {
    return 0;
}

void AppendMenu(int menu, int type, int cmd, char * label) {
    if (log_window) printf("    append menu %d cmd %d label %s\n", menu, cmd, label); didLog = true;
}

int GetSystemMenu(HANDLE h, int menu) {
    return 0;
}

void DrawMenuBar(HANDLE h) {
    ;
}

void SetTimer(HANDLE h, int msg, int msec, void * c) {
    if (log_window) printf("    set timer handle %p msg %d msec %d c %p\n", h, msg, msec, c); didLog = true;
}

void KillTimer(HANDLE h, int msg) {
    if (log_window) printf("    kill timer handle %p msg %d \n", h, msg); didLog = true;
}

void PlaySound(void * a, void * b, int c) {
    if (log_window) printf("    play sound"); didLog = true;
}

int MessageBox(HANDLE h, const char * msg, const char * title, int flags) {
    return [ApplicationHandle
            messageBoxWithHInst: h
            message: [NSString
                      stringWithCString: msg
                      encoding: NSUTF8StringEncoding]
            title: [NSString
                    stringWithCString:title
                    encoding:NSUTF8StringEncoding]
            flags:flags];
}

void GetDlgItemText(HANDLE h, int param, char * buf, size_t size) {
    if (log_window) printf("    get item text - handle: %p param: %d\n", h, param); didLog = true;
    static int unk = 0;
    snprintf(buf, size, "unk %d", unk++);
}

void sndPlaySound(char * filename, int flags) {
    if (log_window) printf("    play sound %s\n", filename); didLog = true;

}

int GetSystemMetrics(int x) {
    return 500;
}

void MoveWindow(HANDLE handle, int x, int y, int w, int h, int q) {
    if (log_window) printf("    move window\n"); didLog = true;
}

void SetFocus(int dlg) {
    if (log_window) printf("    set focus dlg %d\n", dlg); didLog = true;
}

/* - */

HBITMAP LoadBitmap(HANDLE a, INTRESOURCE b) {
    ApplicationHandle * app = (__bridge ApplicationHandle *)a->impl;
    return [app loadBitmapWithResource:b];
}

COLORREF RGB(int r, int g, int b) {
    return
        ((r & 0xff) << 24) |
        ((g & 0xff) << 16) |
        ((b & 0xff) <<  8);
}

HDC GetDC(void * a) {
    return 0;
}

HDC CreateCompatibleDC(HDC a) {
    return [[Win32HDC alloc] init];
}

void ReleaseDC() {
    ;
}

void GetObject() {
}

HBITMAP SelectObject(HDC hdc, HBITMAP bitmap) {
    return [hdc selectObject:bitmap];
}

void DeleteDC() {
}

void SetTextColor() {
}

COLORREF SetBkColor(HDC hdc, COLORREF color) {
    return [hdc setBkColor:color];
}

HBITMAP CreateBitmap(int a, int b, int c, int d, void * e) {
    return nil;
}

void SetProp(HANDLE handle, char * name, HBITMAP bitmap) {
    CustomControlView *
    control = (__bridge CustomControlView *)handle->impl;
    
    NSString *
    theName = [NSString stringWithCString:name
                                 encoding:NSUTF8StringEncoding];
    
    [control setPropWithName:theName
                      bitmap:bitmap];
}

HBITMAP GetProp(HANDLE handle, char * name) {
    CustomControlView *
    control = (__bridge CustomControlView *)handle->impl;
    
    NSString *
    theName = [NSString stringWithCString:name
                                 encoding:NSUTF8StringEncoding];
    
    return [control getPropWithName:theName];
}

void SetWindowPos() {
}

HDC BeginPaint(HANDLE handle, PAINTSTRUCT * b) {
    CustomControlView *
    control = (__bridge CustomControlView *)handle->impl;
    return [control beginPaint];
}

void EndPaint() {
}

void BitBlt(HDC hdc,
            int x,
            int y,
            int cx,
            int cy,
            HDC srcHDC,
            int sx,
            int sy,
            int flags)
{
    [hdc bitBltWithDestinationRect:CGRectMake(x, y, cx, cy)
                            srcHDC:srcHDC
                       sourcePoint:CGPointMake(sx, sy)
                             flags:flags];
}
