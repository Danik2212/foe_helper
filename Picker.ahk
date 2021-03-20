#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_LineFile%\..\Gdip_All.ahk

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

Mouse := ""
Color := ""


ARGBtoRGB( ARGB )
{
	VarSetCapacity( RGB,6,0 )
	DllCall( "msvcrt.dll\sprintf", Str,RGB, Str,"%06X", UInt,ARGB<<8 )
	msgbox, %RGB%
	return "0x" . RGB
}

RAlt & C::
MouseGetPos, mouseX, mouseY
PixelGetColor, color, mouseX, mouseY, RGB
Clipboard := mouseX . "," . mouseY . "," . color
Color:= Clipboard
return


RAlt & M::
MouseGetPos, mouseX, mouseY
Clipboard := mouseX . "," . mouseY
Mouse:= Clipboard
return

RAlt & N::
Clipboard := "ValidateLoop( " . Color . ", 2000, ""Click"", " . Mouse . " )"
Mouse := ""
Color := ""
return


RAlt & B::
mousegetpos, w1mx, w1my, w1id
	
CoordMode, Mouse, Window
WinActivate, ahk_exe firefox.exe
MouseGetPos, mouseX, mouseY
Clipboard := mouseX . "," . mouseY
CoordMode, Mouse, Screen
return


RAlt & Y::
mousegetpos, w1mx, w1my, w1id
	
CoordMode, Mouse, Window
WinActivate, ahk_exe firefox.exe
MouseGetPos, mouseX, mouseY
WinGetPos, winX, winY, , , ahk_exe firefox.exe
PixelGetColor, color, mouseX+winX, mouseY+winY, RGB
Clipboard := mouseX . "," . mouseY . "," . color
CoordMode, Mouse, Screen

MouseMove, winX+mouseX, winY+mouseY
return


RAlt & V::

mousegetpos, w1mx, w1my, hwnd
WinActivate, ahk_id %hwnd%
CoordMode, Mouse, Window
MouseGetPos, mouseX, mouseY

pToken := Gdip_Startup()
pBitmap:= Gdip_BitmapFromHWND(hwnd)
v := Gdip_SaveBitmapToFile( pBitmap, "C:\Users\Danik\OneDrive\FOE\test.jpg" )
;color:=Gdip_GetPixel(pBitmap, 20, 20)
ARGB := Gdip_GetPixel(pBitmap, mouseX, mouseY)

RGB := ARGB & 0x00ffffff

HEX := 0
SetFormat, Integer, hex
HEX += RGB
RGB := HEX
SetFormat, Integer, dec

Clipboard := mouseX . "," . mouseY . "," . RGB
CoordMode, Mouse, Screen

Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)

return

