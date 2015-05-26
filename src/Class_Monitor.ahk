Class Monitor ; https://msdn.microsoft.com/en-us/library/dd692964.aspx
{
    static FreeSize, FreeArray
    static hDXVA2 := DllCall("kernel32.dll\LoadLibrary", "Str", "dxva2.dll", "Ptr")
    static hGDI32 := DllCall("Kernel32.dll\GetModuleHandle", "Str", "gdi32.dll", "Ptr")

    __New()
    {
        this._GetDeviceGammaRamp                      := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hGDI32, "Ptr", 1472, "Ptr")
        this._SetDeviceGammaRamp                      := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hGDI32, "Ptr", 1662, "Ptr")
        this._DestroyPhysicalMonitor                  := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",    6, "Ptr")
        this._DestroyPhysicalMonitors                 := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",    7, "Ptr")
        this._GetMonitorBrightness                    := DllCall("Kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",    9, "Ptr")
       ;this._GetMonitorColorTemperature              := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   11, "Ptr")
        this._GetMonitorContrast                      := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   12, "Ptr")
        this._GetNumberOfPhysicalMonitorsFromHMONITOR := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   18, "Ptr")
        this._GetPhysicalMonitorsFromHMONITOR         := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   20, "Ptr")
        this._SetMonitorBrightness                    := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   30, "Ptr")
       ;this._SetMonitorColorTemperature              := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   31, "Ptr")
        this._SetMonitorContrast                      := DllCall("kernel32.dll\GetProcAddress", "Ptr", this.hDXVA2, "Ptr",   32, "Ptr")
        this.hDC := DllCall("user32.dll\GetDC", "Ptr", 0, "Ptr")
    }

; ===============================================================================================================================

    GetDeviceGammaRamp()                                                 ; https://msdn.microsoft.com/en-us/library/dd316946.aspx
    {
        VarSetCapacity(buf, 1536, 0)
        if !(DllCall(this._GetDeviceGammaRamp, "Ptr", this.hDC, "Ptr", &buf))
            return "*" DllCall("kernel32.dll\GetLastError")
        return NumGet(buf, 2, "UShort") - 128
    }

; ===============================================================================================================================

    SetDeviceGammaRamp(SetNew := 128)                                 ; https://msdn.microsoft.com/en-us/library/dd372194.aspx
    {
        SetNew := (SetNew > 255) ? 255 : (SetNew < 0) ? 0 : SetNew
        loop % VarSetCapacity(buf, 1536) / 6
            NumPut((N := (SetNew + 128) * (A_Index - 1)) > 65535 ? 65535 : N, buf, 2 * (A_Index - 1), "UShort")
        DllCall("RtlMoveMemory", "Ptr", &buf +  512, "Ptr", &buf, "UPtr", 512, "Ptr")
        DllCall("RtlMoveMemory", "Ptr", &buf + 1024, "Ptr", &buf, "UPtr", 512, "Ptr")
        if !(DllCall(this._SetDeviceGammaRamp, "Ptr", this.hDC, "Ptr", &buf))
            if !(DllCall(this._SetDeviceGammaRamp, "Ptr", this.hDC, "Ptr", &buf))             ; <== Call it twice solves Error 87
                return "*" DllCall("kernel32.dll\GetLastError")
        return SetNew
    }

; ===============================================================================================================================

    MonitorFromWindow(hWnd := 0, Flags := 0)                             ; https://msdn.microsoft.com/en-us/library/dd145064.aspx
    {
        return DllCall("user32.dll\MonitorFromWindow", "Ptr", hWnd, "UInt", Flags, "Ptr")
    }

    EnumDisplayMonitors(MonitorNumber)                                   ; https://msdn.microsoft.com/en-us/library/dd162610.aspx
    {
        static MonitorEnumProc := RegisterCallback("Monitor.MonitorEnumProc")
        static Monitors
        static Init := Monitor.EnumDisplayMonitors("")
        if (MonitorNumber = "")
        {
            Monitors := {}
            return DllCall("user32.dll\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", MonitorEnumProc, "Ptr", &Monitors)
        }
        return Monitors[MonitorNumber]
    }

    MonitorEnumProc(hDC, RECT, lParam)                                   ; https://msdn.microsoft.com/en-us/library/dd145061.aspx
    {
        hMonitor := this
        return Object(lParam).Push(hMonitor)
    }

; ===============================================================================================================================

    DestroyPhysicalMonitor(hMonitor)                                     ; https://msdn.microsoft.com/en-us/library/dd692936.aspx
    {
        if !(DllCall(this._DestroyPhysicalMonitor, "Ptr", hMonitor))
            return "*" DllCall("kernel32.dll\GetLastError")
        return true
    }

; ===============================================================================================================================

    DestroyPhysicalMonitors(Size, PHYSICAL_MONITOR)                      ; https://msdn.microsoft.com/en-us/library/dd692937.aspx
    {
        if !(DllCall(this._DestroyPhysicalMonitors, "UInt", Size, "Ptr", &PHYSICAL_MONITOR))
            return % "*" DllCall("kernel32.dll\GetLastError")
        return true
    }

; ===============================================================================================================================

    GetMonitorBrightness(MonNum := 1)                                    ; https://msdn.microsoft.com/en-us/library/dd692939.aspx
    {
        hMonitor := this.GetPhysicalMonitorsFromHMONITOR(MonNum), min := cur := max := ""
        if !(DllCall(this._GetMonitorBrightness, "Ptr", hMonitor, "UInt*", min, "UInt*", cur, "UInt*", max))
            return "*" DllCall("kernel32.dll\GetLastError")
        GMB := {}, GMB.MinimumBrightness := min, GMB.CurrentBrightness := cur, GMB.MaximumBrightness := max
        return GMB
    }

; ===============================================================================================================================
    /*
    GetMonitorColorTemperature(MonNum := 1)                              ; https://msdn.microsoft.com/en-us/library/dd692941.aspx
    {
        static MC_COLOR_TEMPERATURE := ["UNKNOWN", "4000K", "5000K", "6500K", "7500K", "8200K", "9300K", "10000K", "11500K"]
        hMonitor := this.GetPhysicalMonitorsFromHMONITOR(MonNum)
        if !(DllCall(this._GetMonitorColorTemperature, "Ptr", hMonitor, "UInt*", CurColTemp))
            return "*" DllCall("kernel32.dll\GetLastError")
        return MC_COLOR_TEMPERATURE[CurColTemp]
    }
    */
; ===============================================================================================================================

    GetMonitorContrast(MonNum := 1)                                      ; https://msdn.microsoft.com/en-us/library/dd692942.aspx
    {
        hMonitor := this.GetPhysicalMonitorsFromHMONITOR(MonNum), min := cur := max := ""
        if !(DllCall(this._GetMonitorContrast, "Ptr", hMonitor, "UInt*", min, "UInt*", cur, "UInt*", max))
            return "*" DllCall("kernel32.dll\GetLastError")
        GMC := {}, GMC.MinimumContrast := min, GMC.CurrentContrast := cur, GMC.MaximumContrast := max
        return GMC
    }

; ===============================================================================================================================

    GetNumberOfPhysicalMonitorsFromHMONITOR(ByRef hMonitor, MonNum := 1) ; https://msdn.microsoft.com/en-us/library/dd692948.aspx
    {
        hMonitor := this.EnumDisplayMonitors(MonNum), PhysMons := ""
        if !(DllCall(this._GetNumberOfPhysicalMonitorsFromHMONITOR, "Ptr", hMonitor, "UInt*", PhysMons))
            return "*" DllCall("kernel32.dll\GetLastError")
        return PhysMons
    }

; ===============================================================================================================================

    GetPhysicalMonitorsFromHMONITOR(MonNum := 1)                         ; https://msdn.microsoft.com/en-us/library/dd692950.aspx
    {
        FreeSize := PhysMons := this.GetNumberOfPhysicalMonitorsFromHMONITOR(hMonitor, MonNum)
        VarSetCapacity(PHYSICAL_MONITOR, (A_PtrSize + 256) * PhysMons, 0)
        if !(DllCall(this._GetPhysicalMonitorsFromHMONITOR, "Ptr", hMonitor, "UInt", PhysMons, "Ptr", &PHYSICAL_MONITOR))
            return "*" DllCall("kernel32.dll\GetLastError")
        return FreeArray := NumGet(PHYSICAL_MONITOR, 0, "UPtr")
    }

; ===============================================================================================================================

    SetMonitorBrightness(MonNum := 1, SetNew := 50)               ; https://msdn.microsoft.com/en-us/library/dd692972.aspx
    {
        SetNew := (SetNew > 100) ? 100 : (SetNew < 0) ? 0 : SetNew
        hMonitor := this.GetPhysicalMonitorsFromHMONITOR(MonNum)
        if !(DllCall(this._SetMonitorBrightness, "Ptr", hMonitor, "UInt", SetNew))
            return "*" DllCall("kernel32.dll\GetLastError")
        return SetNew
    }

; ===============================================================================================================================
    /*
    SetMonitorColorTemperature(MonNum := 1, ColorTemperature := 3)       ; https://msdn.microsoft.com/en-us/library/dd692973.aspx
    {
        hMonitor := this.GetPhysicalMonitorsFromHMONITOR(MonNum)
        if !(DllCall(this._SetMonitorColorTemperature, "Ptr", hMonitor, "UInt", ColorTemperature))
            return "*" DllCall("kernel32.dll\GetLastError")
        return true
    }
    */
; ===============================================================================================================================

    SetMonitorContrast(MonNum := 1, SetNew := 50)                  ; https://msdn.microsoft.com/en-us/library/dd692974.aspx
    {
        SetNew := (SetNew > 100) ? 100 : (SetNew < 0) ? 0 : SetNew
        hMonitor := this.GetPhysicalMonitorsFromHMONITOR(MonNum)
        if !(DllCall(this._SetMonitorContrast, "Ptr", hMonitor, "UInt", SetNew))
            return "*" DllCall("kernel32.dll\GetLastError")
        return SetNew
    }

; ===============================================================================================================================

    OnExit()
    {
        this.DestroyPhysicalMonitors(this.FreeSize, this.FreeArray)
        DllCall("user32.dll\ReleaseDC", "Ptr", 0, "Ptr", this.hDC)
        DllCall("kernel32.dll\FreeLibrary", "Ptr", this.hDXVA2)
    }
}