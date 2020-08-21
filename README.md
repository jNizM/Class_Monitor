# Class_Monitor
 AutoHotkey wrapper for Monitor Configuration API Functions ([msdn-docs](https://docs.microsoft.com/en-us/windows/win32/api/_monitor/))


## Examples

**Retrieves a (particular) monitor's minimum, maximum, and current brightness settings.**
```AutoHotkey
for k, v in Monitor.GetBrightness("\\.\DISPLAY2")   ; or just "2"
	MsgBox % k ": " v
```

**Retrieves the defaults (primary) monitor's minimum, maximum, and current brightness settings.**
```AutoHotkey
for k, v in Monitor.GetBrightness()   ; empty parameter
	MsgBox % k ": " v
```

**Retrieves a (particular) monitor's minimum, maximum, and current contrast settings.**
```AutoHotkey
for k, v in Monitor.GetContrast("\\.\DISPLAY2")   ; or just "2"
	MsgBox % k ": " v
```

**Retrieves the defaults (primary) monitor's minimum, maximum, and current contrast settings.**
```AutoHotkey
for k, v in Monitor.GetContrast()   ; empty parameter
	MsgBox % k ": " v
```

**Retrieves a (particular) monitor's red, green and blue gamma ramp settings.**
```AutoHotkey
for k, v in Monitor.GetGammaRamp("\\.\DISPLAY2")   ; or just "2"
	MsgBox % k ": " v
```

**Retrieves the defaults (primary) monitor's red, green and blue gamma ramp settings.**
```AutoHotkey
for k, v in Monitor.GetGammaRamp()   ; empty parameter
	MsgBox % k ": " v
```

**Sets a (particular) monitor's brightness value.**
```AutoHotkey
Monitor.SetBrightness(50, "\\.\DISPLAY2")   ; or just "2"
```

**Sets the defaults (primary) monitor's brightness value.**
```AutoHotkey
Monitor.SetBrightness(50)   ; empty parameter
```

**Sets a (particular) monitor's contrast value.**
```AutoHotkey
Monitor.SetContrast(50, "\\.\DISPLAY2")   ; or just "2"
```

**Sets the defaults (primary) monitor's contrast value.**
```AutoHotkey
Monitor.SetContrast(50)   ; empty parameter
```

**Sets a (particular) monitor's red, green and blue gamma ramp value.**
```AutoHotkey
Monitor.SetGammaRamp(100, 100, 80, "\\.\DISPLAY2")   ; or just "2"
```

**Sets the defaults (primary) monitor's red, green and blue gamma ramp value.**
```AutoHotkey
Monitor.SetGammaRamp(100, 100, 80)   ; empty parameter
```

**Restores a (particular) monitor's settings to their factory defaults (brightness and contrast).**
```AutoHotkey
Monitor.RestoreFactoryDefault(\\.\DISPLAY2")   ; or just "2"
```

**Restores the defaults (primary) monitor's settings to their factory defaults (brightness and contrast).**
```AutoHotkey
Monitor.RestoreFactoryDefault()   ; empty parameter
```

## AHK v2 rewrite
[GitHub](https://github.com/tigerlily-dev/Monitor-Configuration-Class) by tigerlily-dev


## Questions / Bugs / Issues
Report any bugs or issues on the [AHK Thread](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=7854). Same for any questions.


## Copyright and License
[The Unlicense](LICENSE)


## Donations (PayPal)
[Donations are appreciated if I could help you](https://www.paypal.me/smithz)