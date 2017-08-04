; ===============================================================================================================================

Class Monitor
{
    SetBrightness(red := 128, green := 128, blue := 128)        ; https://msdn.microsoft.com/en-us/library/dd372194(v=vs.85).aspx
    {
        loop % VarSetCapacity(buf, 1536, 0) / 6
        {
            NumPut((r := (red   + 128) * (A_Index - 1)) > 65535 ? 65535 : r, buf,        2 * (A_Index - 1), "ushort")
            NumPut((g := (green + 128) * (A_Index - 1)) > 65535 ? 65535 : g, buf,  512 + 2 * (A_Index - 1), "ushort")
            NumPut((b := (blue  + 128) * (A_Index - 1)) > 65535 ? 65535 : b, buf, 1024 + 2 * (A_Index - 1), "ushort")
        }
        DllCall("gdi32\SetDeviceGammaRamp", "ptr", hDC := DllCall("user32\GetDC", "ptr", 0, "ptr"), "ptr", &buf)
        DllCall("user32\ReleaseDC", "ptr", 0, "ptr", hDC)
    }

    GetBrightness()                                             ; https://msdn.microsoft.com/en-us/library/dd316946(v=vs.85).aspx
    {
        VarSetCapacity(buf, 1536, 0)
        DllCall("gdi32\GetDeviceGammaRamp", "ptr", hDC := DllCall("user32\GetDC", "ptr", 0, "ptr"), "ptr", &buf)
        CLR := {}
        CLR.Red   := NumGet(buf,        2, "ushort") - 128
        CLR.Green := NumGet(buf,  512 + 2, "ushort") - 128
        CLR.Blue  := NumGet(buf, 1024 + 2, "ushort") - 128
        return CLR, DllCall("user32\ReleaseDC", "ptr", 0, "ptr", hDC)
    }

    SetColorTemperature(kelvin := 6500, alpha := 0.5)   ; http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
    {
        kelvin := (kelvin < 1000) ? 1000 : (kelvin > 40000) ? 40000 : kelvin
        kelvin /= 100

        if (kelvin <= 66) {
            red   := 255
        } else {
            red   := 329.698727446 * ((kelvin - 60) ** -0.1332047592)
            red   := (red < 0) ? 0 : (red > 255) ? 255 : red
        }

        if (kelvin <= 66) {
            green := 99.4708025861 * Ln(kelvin) - 161.1195681661
            green := (green < 0) ? 0 : (green > 255) ? 255 : green
        } else {
            green := 288.1221695283 * ((kelvin - 60) ** -0.0755148492)
            green := (green < 0) ? 0 : (green > 255) ? 255 : green
        }

        if (kelvin >= 66) {
            blue  := 255
        } else if (kelvin <= 19) {
            blue  := 0
        } else {
            blue  := 138.5177312231 * Ln(kelvin - 10) - 305.0447927307
            blue  := (blue < 0) ? 0 : (blue > 255) ? 255 : blue
        }

        return this.SetBrightness(red * alpha, green * alpha, blue * alpha)
    }
}

; ===============================================================================================================================