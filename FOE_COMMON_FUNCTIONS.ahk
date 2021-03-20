#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

SetBatchLines -1

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetDefaultMouseSpeed, 2
DetectHiddenWindows, on

IsItBigScreen()
{
	if ( BIG_SCREEN == -1 )
	{
		SysGet, mon, MonitorWorkArea
		width := monRight - monLeft
	
		if( width > 1980 )
		{
			BIG_SCREEN := 1
		}
		else
		{
			BIG_SCREEN := 0
		}
	}
	return BIG_SCREEN == 1
}

Wait( timeout)
{
	Sleep, timeout
}

Click(X, Y)
{
	SetMouseDelay -1
	;SendEvent {Click %X%, %Y%}
	;Wait( d )

	MouseMove, X + 3, Y + 3
	MouseMove, X, Y
	Send {vk01sc000}
	;MouseClick, Left, X, Y, 1, 0, D
	;Wait( 50 )
	;MouseClick, Left, X, Y, 1, 0, U
	;Wait( 50 )
}

ClickSlow(X, Y)
{
	previous := A_MouseDelayPlay
	SetMouseDelay 30
	
	MouseMove, X + 3, Y -1, 25
	Click, %X%, %Y%, down
	Wait( 100 )
	Click, %X%, %Y%, up
	
	SetMouseDelay %previous%
	
}

ClickSlow2( X, Y )
{
	previous := A_MouseDelayPlay
	SetMouseDelay 30
	
	MouseMove, X + 5, Y -5, 15
	MouseMove, X, Y, 15
	Click, %X%, %Y%, down
	Wait( 10 )
	Click, %X%, %Y%, down
	Wait( 10 )
	Click, %X%, %Y%, down
	Wait( 75 )
	Click, %X%, %Y%, up
	Wait( 10 )
	Click, %X%, %Y%, up
	Wait( 10 )
	Click, %X%, %Y%, up
	
	SetMouseDelay %previous%

}

ClickSlow3(X, Y)
{
	;SetMouseDelay 60
	;MouseMove, X + 3, Y -1, 5
	;Click(X, Y)
	;SetMouseDelay 0
	
	MouseMove, X + 3, Y -1, 10
	;SetMouseDelay 100
	Click, %X%, %Y%, down
	Wait( 25 )
	Click, %X%, %Y%, up
	Wait( 25 )
	Click, %X%, %Y%, down
	Wait( 25 )
	Click, %X%, %Y%, up
	;SetMouseDelay 0
	
}

DragSlow( X1, Y1, X2, Y2 )
{
	;MouseMove, X1 + 3, Y1 + 3, 1
	Wait( 150 )
	MouseClickDrag, Left, X1, Y1, X2, Y2, 3
	Wait( 100 )
}

DragWithId( cX1, cY1, cX2, cY2, id )
{	
	PostMessage, 0x200, 0, cX1&0xFFFF | cY1<<16,, ahk_id %id% ; WM_MOUSEMOVE
	PostMessage, 0x201, 0, cX1&0xFFFF | cY1<<16,, ahk_id %id% ; WM_LBUTTONDOWN
	Sleep, 100
	PostMessage, 0x200, 0, cX2&0xFFFF | cY2<<16,, ahk_id %id% ; WM_MOUSEMOVE
	PostMessage, 0x202, 0, cX2&0xFFFF | cY2<<16,, ahk_id %id% ; WM_LBUTTONUP  
}

ClickWithId(cX, cY, id )
{
	PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_MOUSEMOVE
	PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_LBUTTONDOWN
	PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_LBUTTONUP  
}

ClickWithIdSlow(cX, cY, id )
{
  PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_MOUSEMOVE
  PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_LBUTTONDOWN
  Sleep, 100
  PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_LBUTTONUP  
}

ClickWithIdSlow2(cX, cY, id )
{
  PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %id% ; WM_MOUSEMOVE
  SetControlDelay, 100
  ControlClick, X%cX% Y%cY%  , ahk_id %id%,,,,NA
}



WaitForColor( x, y, RGBColor, range, timeout)
{
	found := 0
	StartTime := A_TickCount
	X1 := x - 2
	X2 := x + 2
	Y1 := y - 2
	Y2 := y + 2
	Loop{
		PixelSearch, foundX, foundY, X1, Y1, X2, Y2, RGBColor, range, RGB
		if (ErrorLevel = 0 )
			found := 1
		if ( A_TickCount > (StartTime + timeout) )
			found := 2
		
	} Until found > 0
	
	if found = 1
		return 1
	else
		return 0
}

SearchForColor( X1, Y1, X2, Y2, ByRef foundX, ByRef foundY, RGBColor, range, timeout )
{
	found := 0
	StartTime := A_TickCount
	Loop{
		PixelSearch, foundX, foundY, X1, Y1, X2, Y2, RGBColor, range, RGB Fast
		if (ErrorLevel = 0 ){
			found := 1
		}
		
		if ( A_TickCount > (StartTime + timeout) )
			found := 2
		
	} Until found > 0
	
	if found = 1
		return 1
	else
		return 0
}

SearchForColor2( X1, Y1, X2, Y2, ByRef foundX, ByRef foundY, RGBColor1, RGBColor2, range, timeout )
{
	found := 0
	StartTime := A_TickCount
	Loop{
		X:= 0
		Y:= 0
		PixelSearch, X, Y, X1, Y1, X2, Y2, RGBColor1, range, RGB Fast
		if (ErrorLevel = 0 ){
			foundX := X
			foundY := Y
			found := 1
		}
		else{
			PixelSearch, X, Y, X1, Y1, X2, Y2, RGBColor2, range, RGB Fast
			if (ErrorLevel = 0 ){
				foundX := X
				foundY := Y
				found := 1
			}
		}
		
		
		if ( A_TickCount > (StartTime + timeout) )
			found := 2
		
	} Until found > 0
	
	if found = 1
		return 1
	else
		return 0
}

GetPixelColor( X, Y )
{
	return PixelGetColor, newColor, X, Y, RGB
}

WaitForColorChange( X, Y, RGBColor, timeout )
{
	StartTime := A_TickCount
	Loop{
		PixelGetColor, newColor, X, Y, RGB
		if ( newColor != RGBColor )
		{
			return 1
		}
		if ( A_TickCount > (StartTime + timeout) )
		{
			return 0
		}
	}

}

LookForColorAround( x, y, color, timeout=10000, range=2, colorRange = 10 )
{
	return SearchForColor( x-range, y-range, x+range, y+range, foundX, foundY, color, colorRange, timeout )
}


ValidateLoop( x, y, color, timeout, func, arg1 = -1, arg2 = -1, arg3 = -1, arg4 = -1, arg5 = -1 )
{
	Inc:= 0
	Loop{
		Inc:= Inc + 1
		CallFunc( func, arg1, arg2, arg3, arg4, arg5 )
		if( LookForColorAround( x,y,color, timeout ) )
		{
			break
		}
		if (Inc > 20 )
		{
			return
		}
	}
}

ValidateLoopReverse( x, y, color, timeout, func, arg1 = -1, arg2 = -1, arg3 = -1, arg4 = -1, arg5 = -1 )
{
	Inc:= 0
	Loop{
		Inc:= Inc + 1
		if( LookForColorAround( x,y,color, timeout ) )
		{
			break
		}
		CallFunc( func, arg1, arg2, arg3, arg4, arg5 )
		if (Inc > 20 )
		{
			return
		}
	}
}

ValidateLoopClick2( x, y, color, timeout, func, X1, Y1, X2, Y2)
{
	Inc:= 0
	Loop{
		Inc:= Inc + 1
		CallFunc( func, X1, Y1 )
		if( LookForColorAround( x,y,color, timeout ) )
		{
			break
		}
		
		if (Inc > 30 )
		{
			CallFunc( func, X2, Y2 )
			Inc := 0
		}
	}

}

CallFunc( func, arg1 = -1, arg2 = -1, arg3 = -1, arg4 = -1, arg5 = -1)
{
	if ( arg5 != -1 )
	{
		%func%( arg1, arg2, arg3, arg4, arg5 )
	}
	else if ( arg4 != -1 )
	{
		%func%( arg1, arg2, arg3, arg4 )
	}
	else if ( arg3 != -1 )
	{
		%func%( arg1, arg2, arg3 )
	}
	else if ( arg2 != -1 )
	{
		%func%( arg1, arg2 )
	}
	else if ( arg1 != -1 )
	{
		%func%( arg1 )
	}
	else
	{
		%func%()
	}
}

















































