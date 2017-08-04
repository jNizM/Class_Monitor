; GLOBAL SETTINGS ===============================================================================================================

#NoEnv
#SingleInstance Force
#Persistent

SetBatchLines -1

; INI READ ======================================================================================================================

global MonRed    := IniRead("Monitor.ini", "Settings", "Red", 128)
global MonGreen  := IniRead("Monitor.ini", "Settings", "Green", 128)
global MonBlue   := IniRead("Monitor.ini", "Settings", "Blue", 128)
global MonTemp   := IniRead("Monitor.ini", "Settings", "Temperature", 6600)
global MonBright := IniRead("Monitor.ini", "Settings", "Brightness", 50)

; MENU ==========================================================================================================================

Menu, Tray, NoStandard
Menu, Tray, Add, Settings, MENU_SETTINGS
Menu, Tray, Add
Menu, Tray, Add, Reload,   MENU_RELOAD
Menu, Tray, Add, Exit,     MENU_EXIT
SessionChange := New SessionChange()
return

; GUI ===========================================================================================================================

MENU_SETTINGS:
Gui, Destroy
Gui, -MinimizeBox +hWndhMyGUI +LastFound
Gui, Margin, 7, 7
Gui, Color, FFFFFF

Gui, Add, GroupBox, xm ym w314 h173 Section

Gui, Font, s13 c787878, Segoe UI
Gui, Add, Text, xs+8 ys+13 0x200, % "Set brightness:"
Gui, Font, s13 c000000, Segoe UI
Gui, Add, Edit, x+1 yp w41 h25 -VScroll +Limit3 0x2002 -E0x200 gCHECK_COLORTEMPERATURE vMyEdt01, % MonBright
Gui, Add, Slider, xs+1 y+2 w312 Range1-100 0x0110 gCHECK_COLORTEMPERATURE vMySld01, % MonBright

Gui, Font, s13 c787878, Segoe UI
Gui, Add, Text, xs+8 y+14 0x200, % "Set color temperature:"
Gui, Font, s13 c000000, Segoe UI
Gui, Add, Edit, x+1 yp w50 h25 -VScroll +Limit5 0x2002 -E0x200 gCHECK_COLORTEMPERATURE vMyEdt02, % MonTemp
Gui, Add, Edit, x+0 yp h25 -VScroll +Limit1 0x0800 -E0x200, % "K"
Gui, Add, Slider, xs+1 y+2 w312 Range3200-6600 0x0110 gCHECK_COLORTEMPERATURE vMySld02, % MonTemp

Gui, Font, s12 c000000, Segoe UI
Gui, Add, Button, xs+226 y+3 w80 h32 gBTN_COLORTEMPERATURE, % "Set"

Gui, Font
Gui, Add, GroupBox, xm y+7 w314 h239 Section

Gui, Font, s13 c787878, Segoe UI
Gui, Add, Text, xs+8 ys+13 0x200, % "Set red:"
Gui, Font, s13 c000000, Segoe UI
Gui, Add, Edit, x+1 yp w41 h25 -VScroll +Limit3 0x2002 -E0x200 gCHECK_COLORMANUAL vMyEdt03, % MonRed
Gui, Add, Slider, xs+1 y+2 w312 Range1-255 0x0110 vMySld03 gCHECK_COLORMANUAL, % MonRed

Gui, Font, s13 c787878, Segoe UI
Gui, Add, Text, xs+8 y+14 0x200, % "Set green:"
Gui, Font, s13 c000000, Segoe UI
Gui, Add, Edit, x+1 yp w41 h25 -VScroll +Limit3 0x2002 -E0x200 gCHECK_COLORMANUAL vMyEdt04, % MonGreen
Gui, Add, Slider, xs+1 y+2 w312 Range1-255 0x0110 gCHECK_COLORMANUAL vMySld04, % MonGreen

Gui, Font, s13 c787878, Segoe UI
Gui, Add, Text, xs+8 y+14 0x200, % "Set blue:"
Gui, Font, s13 c000000, Segoe UI
Gui, Add, Edit, x+1 yp w41 h25 -VScroll +Limit3 0x2002 -E0x200 gCHECK_COLORMANUAL vMyEdt05, % MonBlue
Gui, Add, Slider, xs+1 y+2 w312 Range1-255 0x0110 gCHECK_COLORMANUAL vMySld05, % MonBlue

Gui, Font, s12 c000000, Segoe UI
Gui, Add, Button, xs+226 y+3 w80 h32 gBTN_COLORMANUAL, % "Set"

Gui, Font, s12 c000000, Segoe UI
Gui, Add, Button, xm+150 y+13 w80 h32 gBTN_SAVE vBtn03, % "Save"
Gui, Add, Button, x+5  yp  w80 h32 gBTN_RESET vBtn04, % "Reset"

Gui, Show, AutoSize
GuiControl, Focus, Btn03
return

; SCRIPT ========================================================================================================================

CHECK_COLORTEMPERATURE:
    GuiControlGet, OutputVar,, % A_GuiControl
    if (A_GuiControl = "MyEdt01")
        GuiControl,, MySld01, % MonBright := OutputVar
    if (A_GuiControl = "MySld01")
        GuiControl,, MyEdt01, % MonBright := OutputVar
    if (A_GuiControl = "MyEdt02")
        GuiControl,, MySld02, % MonTemp := OutputVar
    if (A_GuiControl = "MySld02")
        GuiControl,, MyEdt02, % MonTemp := OutputVar
return

BTN_COLORTEMPERATURE:
    Gui, Submit, NoHide
    Monitor.SetColorTemperature(MySld02, MySld01 / 100)
    CLR := Monitor.GetBrightness()
    GuiControl,, MyEdt03, % MonRed := CLR.Red
    GuiControl,, MyEdt04, % MonGreen := CLR.Green
    GuiControl,, MyEdt05, % MonBlue := CLR.Blue
return

CHECK_COLORMANUAL:
    GuiControlGet, OutputVar,, % A_GuiControl
    if (A_GuiControl = "MyEdt03")
        GuiControl,, MySld03, % OutputVar
    if (A_GuiControl = "MySld03")
        GuiControl,, MyEdt03, % OutputVar
    if (A_GuiControl = "MyEdt04")
        GuiControl,, MySld04, % OutputVar
    if (A_GuiControl = "MySld04")
        GuiControl,, MyEdt04, % OutputVar
    if (A_GuiControl = "MyEdt05")
        GuiControl,, MySld05, % OutputVar
    if (A_GuiControl = "MySld05")
        GuiControl,, MyEdt05, % OutputVar
return

BTN_COLORMANUAL:
    Gui, Submit, NoHide
    Monitor.SetBrightness(MySld03, MySld04, MySld05)
return

BTN_SAVE:
    Gui, Submit, NoHide
    CLR := Monitor.GetBrightness()
    IniWrite(CLR.Red, "Monitor.ini", "Settings", "Red")
    IniWrite(CLR.Green, "Monitor.ini", "Settings", "Green")
    IniWrite(CLR.Blue, "Monitor.ini", "Settings", "Blue") 
    IniWrite(MySld02, "Monitor.ini", "Settings", "Temperature")
    IniWrite(MySld01, "Monitor.ini", "Settings", "Brightness")
return

BTN_RESET:
    GuiControl,, MyEdt01, % 50
    GuiControl,, MyEdt02, % 6500
    GuiControl,, MyEdt03, % 128
    GuiControl,, MyEdt04, % 128
    GuiControl,, MyEdt05, % 128
return

MENU_RELOAD:
    Reload
return

MENU_EXIT:
    ExitApp
return

; FUNCTIONS =====================================================================================================================

CtlColorBtns()
{
    static init := OnMessage(0x0135, "CtlColorBtns")
    return DllCall("gdi32\CreateSolidBrush", "uint", 0xFFFFFF, "uptr")
}

IniRead(Filename, Section, Key, Default := 0)
{
    IniRead, OutputVar, % Filename, % Section, % Key, % Default
    return OutputVar
}

IniWrite(Value, Filename, Section, Key)
{
    IniWrite, % Value, % Filename, % Section, % Key
}

; CLASS =========================================================================================================================

Class SessionChange
{
    static hScript := A_ScriptHwnd
    static WTSSESSION_CHANGE := ObjBindMethod(SessionChange, "WM_WTSSESSION_CHANGE")

    __New()
    {
        if !(DllCall("wtsapi32\WTSRegisterSessionNotificationEx", "ptr", 0, "ptr", this.hScript, "uint", 1))
            throw Exception("Error in WTSRegisterSessionNotificationEx function")
        OnMessage(0x02B1, this.WTSSESSION_CHANGE)
    }

    WM_WTSSESSION_CHANGE(wParam)
    {
        if (wParam = 0x5) || (wParam = 0x8)
            Monitor.SetBrightness(MonRed, MonGreen, MonBlue)
    }

    __Delete()
    {
        OnMessage(0x02B1, "")
        if !(DllCall("wtsapi32\WTSUnRegisterSessionNotificationEx", "ptr", 0, "ptr", this.hScript))
            throw Exception("Error in WTSUnRegisterSessionNotificationEx function")
    }
}

; INCLUDES ======================================================================================================================

#Include Class_Monitor.ahk

; ===============================================================================================================================