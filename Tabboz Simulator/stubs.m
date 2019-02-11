//
//  stubs.c
//  Tabboz Simulator
//
//  Created by Antonio Malara on 10/02/2019.
//  Copyright © 2019 Antonio Malara. All rights reserved.
//

#include <stdlib.h>
#include "os.h"

void BeginPaint() { abort(); }
void BitBlt() { abort(); }
void CreateBitmap() { abort(); }
void CreateCompatibleDC() { abort(); }
void DefWindowProc() { abort(); }
void DeleteDC() { abort(); }
void DeleteObject() { abort(); }
void DestroyIcon() { abort(); }
void EndPaint() { abort(); }
void GetDC() { abort(); }
void GetDlgItemText() { abort(); }
void GetObject() { abort(); }
void GetOpenFileName() { abort(); }
void GetPrivateProfileString() { abort(); }
void GetProp() { abort(); }
void GetSaveFileName() { abort(); }
void GetSystemMetrics() { abort(); }
void GetWindowRect() { abort(); }
void HIWORD() { abort(); }
void IsIconic() { abort(); }
void KillTimer() { abort(); }
void LoadBitmap() { abort(); }
void MessageBox() { abort(); }
void MoveWindow() { abort(); }
void PlaySound() { abort(); }
void RGB() { abort(); }
void RegCloseKey() { abort(); }
void RegQueryValue() { abort(); }
void RegSetValue() { abort(); }
void ReleaseDC() { abort(); }
void RemoveProp() { abort(); }
void SelectObject() { abort(); }
void SetBkColor() { abort(); }
void SetFocus() { abort(); }
void SetProp() { abort(); }
void SetTextColor() { abort(); }
void SetWindowPos() { abort(); }
void WritePrivateProfileString() { abort(); }
void new_counter() { abort(); }

void sndPlaySound() { abort(); }
void ExitWindows() { abort(); }

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
    return x;
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

int LoadCursor(HANDLE hinst, int b) {
    //    printf("%s -- %d, %d\n", __PRETTY_FUNCTION__, hinst, b);
    return 0;
}

ATOM RegisterClass(WNDCLASS * wc) {
    //    printf("%s -- %p\n", __PRETTY_FUNCTION__, wc);
    return 0;
}

int MAKEINTRESOURCE(int a) {
    // Passthrough seem logical
    return a;
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

BOOL disableMessageBox = FALSE;

int DialogBox(HWND hinst, int b, void * c, DialogProc proc) {
    if (disableMessageBox)
        return 0;
    
    printf("%s -- %p, %d, %p, %p\n", __PRETTY_FUNCTION__, hinst, b, c, proc);
    [Tabboz dialogFrom:hinst dialog:b callback:proc];
    return 0;
}

FARPROC MakeProcInstance(FARPROC proc, HWND hinst) {
    //    printf("%s -- %p, %d\n", __PRETTY_FUNCTION__, proc, hinst);
    return 0;
}

void FreeProcInstance(FARPROC proc) {
    //    printf("%s -- %p\n", __PRETTY_FUNCTION__, proc);
}

int GetDlgItem(HWND hDlg, int x) {
    return x;
}

int LOWORD(int x) {
    return x;
}

BOOL log_window = true;
BOOL didLog = false;

void EnableWindow(int x, int a) {
    if (log_window) printf("    enable window %d\n", x); didLog = true;
}

void SendMessage(int dlg, int msg, int value, int x) {
    if (log_window) printf("    sending dlg: %d, msg: %d, value: %d, x: %d\n", dlg, msg, value, x); didLog = true;
}

void EndDialog(HANDLE dlg, int x) {
    if (log_window) printf("    end dialog %p, %d\n", dlg, x); didLog = true;
    
    [Tabboz endDialog];
}

HICON LoadIcon(HANDLE h, int r) {
    return 0;
}

void ShowWindow(HANDLE h, int flags) {
    if (log_window) printf("    show window %p %d\n", h, flags); didLog = true;
}

void SetDlgItemText(HANDLE h, int d, char * str) {
    if (log_window) printf("    set %p dlg text %3d %s\n", h, d, str); didLog = true;
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
    if (log_window) printf("    append menu %d cmd %d label %s\n", menu, cmd, label);
}

int GetSystemMenu(HANDLE h, int menu) {
    return 0;
}

void DrawMenuBar(HANDLE h) {
    ;
}

void SetTimer(HANDLE h, int msg, int msec, void * c) {
    if (log_window) printf("    set timer handle %p msg %d msec %d c %p\n", h, msg, msec, c);
}
