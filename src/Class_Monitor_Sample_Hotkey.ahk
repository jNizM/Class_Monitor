; GLOBAL SETTINGS ===============================================================================================================

#NoEnv
#SingleInstance Force
#Persistent

SetBatchLines -1

; SCRIPT ========================================================================================================================

; Win + Numpad 1    -> Set Brightness to 100, 100, 90 (RGB)
#Numpad1::Monitor.SetBrightness(100, 100, 90)

; Win + Numpad 2    -> Set Brightness to 90, 90, 80 (RGB)
#Numpad2::Monitor.SetBrightness(90,  90,  80)

; Win + Numpad 3    -> Set Color Temperature to 4900K and 0.34 alpha (86, 76, 68)
#Numpad3::Monitor.SetColorTemperature(4900, 0.34)

; win + Numpad 4    -> Get Brightness
#Numpad4::
    GetBrightness := Monitor.GetBrightness()
    MsgBox % "Red:`t" GetBrightness.Red "`nGreen:`t" GetBrightness.Green "`nBlue:`t" GetBrightness.Blue
return

; INCLUDES ======================================================================================================================

#Include Class_Monitor.ahk

; ===============================================================================================================================