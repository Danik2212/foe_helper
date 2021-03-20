#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#include %A_ScriptDir%  ; Ensures a consistent starting directory
#Include %A_LineFile%\..\Gdip_All.ahk

;SetBatchLines 100

CoordMode, Mouse, Window
CoordMode, Pixel, Window

global START_TIME := 0
global QUEST_DONE := 0
global RESET := 0


global ID := 0

Start()
{	
	mousegetpos, w1mx, w1my, w1id
	ID := w1id
	Tooltip, Starting... Firefox ID: %ID%, 10, 10
	IACycleRQ()
}

IACycleRQ()
{
	Inc := 0
	START_TIME := A_TickCount
	Loop
	{
		;; Look for abandonner button
		if( SearchForColor( 378,587, 378,665, x,y, 0x7F271C, 15, 1000 ) )
		{
			Inc:= 0 
			; Look for the quest ( give button 1 and give button 2 )
			if (  y > 635 )
			{
				if( LookForColorAround( 20,647,0x5c6363, 100, 10, 10 ) )
				{
					ClickAbandonner( x, y )
				}
				else if( LookForColorAround( 471,528,0xD88E3D, 200, 10, 10 ) )
				{
					if ( DoQuest() )
					{
						Wait( 100 )
						total_time := ( A_TickCount - START_TIME ) / 1000
						QUEST_DONE := QUEST_DONE + 1
						average := ( total_time / QUEST_DONE )
						Tooltip, Total done: %QUEST_DONE% Average time: %average% Reset: %RESET%, 10, 10
					}
				}
				else
				{
					ClickAbandonner( x, y )
				}
			}
			else
			{
				ClickAbandonner( x, y )
			}
		
		}
		else
		{
			Inc:= Inc + 1
			if ( Inc > 50 )
			{
				ReadyUp()
				Inc:= 0
			}
		}
	}

}

ClickAbandonner( x, y )
{
	ClickFirefox( x, y )
	if ( LookForColorAround( 779,502,0x5a2013, 50, 5, 5 ) && LookForColorAround( 856,637,0xdecca0, 50, 5, 5 ) )
	{
		ReadyUp()
	}
	Wait( 100 )

}

ReadyUp()
{
	RESET := RESET + 1
	Loop
	{
		; Refresh the page
		ControlSend,, ^r, ahk_id %ID%
		Wait( 15000 )
		
		; Close boxes
		ClickFirefox( 546,90 )
		Wait( 500 )
		
		; Close boxes
		ClickFirefox( 546,90 )
		Wait( 500 )
		
		; Close boxes
		ClickFirefox( 546,90 )
		Wait( 2000 )
		
		ControlSend,, q, ahk_id %ID%
		Wait( 4000 )
		
		if ( LookForColorAround( 670,159,0xe7d6b6, 50, 10, 10 ) )
		{
			; Abandon possible quest
			Wait( 500 )
			ClickFirefox( 300,343 )
			; Abandon possible quest
			Wait( 500 )
			ClickFirefox( 300,343 )
			return
		}
		
	
	}
}

DoQuest()
{
	Inc:= 0
	Loop
	{
		WaitForColor( 476,536,0xDC9340, 3000 )
		; Click the first button
		ClickFirefox( 473,526 )
		; Click the second button
		ClickFirefox( 472,594 )
		
		; Wait for both green bar
		if( LookForColorAround( 372,522,0x697D2B, 50) && LookForColorAround( 393,594,0x697D2B, 50 ) )
		{
			; Click collecter
			WaitForColor( 535,553,0x4F791B, 3000 )
			Loop
			{
				ClickFirefox( 572,555 )
				ClickFirefox( 572,555 )
				// If abandonner present
				if( SearchForColor( 236,587, 236,655, x,y, 0x7F271C, 10, 50 ) )
				{
					Wait( 50 )
					return true
				}
				ClickFirefox( 42,182 )
			}
		}
		
		ClickFirefox( 42,182 )
		Inc := Inc + 1
		if ( Inc > 20 )
		{
			return false
		
		}
	}

}


Wait( timeout )
{
	Random, t, 0, 50
	t := t - 25
	Sleep, timeout + t
}

ClickFirefox( cX, cY )
{
	PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %ID% ; WM_MOUSEMOVE
	PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %ID% ; WM_LBUTTONDOWN
	PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %ID% ; WM_LBUTTONUP  
}


LookForColorAround( x, y, color, timeout=10000, range=2, colorRange = 10 )
{
	return SearchForColor( x-range, y-range, x+range, y+range, foundX, foundY, color, colorRange, timeout )
}

ValidateLoopIA( x, y, color, timeout, func, arg1 = -1, arg2 = -1, arg3 = -1, arg4 = -1, arg5 = -1 )
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
			return false
		}
	}
	return true 
}


WaitForColor( x, y, RGBColor, range=10, timeout=3000)
{
	found := 0
	StartTime := A_TickCount
	X1 := x - 2
	X2 := x + 2
	Y1 := y - 2
	Y2 := y + 2
	Loop{
		found := PixelSearchB( foundX, foundY, X1, Y1, X2, Y2, RGBColor, range )
		if ( found == 1 )
		{
			return 1
		}
		if ( A_TickCount > (StartTime + timeout) )
		{
			return 0
		}
		
	} Until found > 0
	
	if found == 1
		return 1
	else
		return 0
}

SearchForColor( X1, Y1, X2, Y2, ByRef foundX, ByRef foundY, RGBColor, range, timeout )
{
	found := 0
	StartTime := A_TickCount
	Loop{
		found := PixelSearchB( foundX, foundY, X1, Y1, X2, Y2, RGBColor, range )
		if ( found == 1 )
		{
			return 1
		}
		if ( A_TickCount > (StartTime + timeout) )
		{
			return 0
		}
		
	} Until found > 0
	
	if found == 1
		return 1
	else
		return 0
}

PixelSearchB( ByRef foundX, ByRef foundY, X1, Y1, X2, Y2, RGBColor, range=10 )
{
	X := X1
	Y := Y1
	
	pToken := Gdip_Startup()
	pBitmap:= Gdip_BitmapFromHWND(ID)
	RGBColorDec += RGBColor
	
	R1 := (0x00ff0000 & RGBColorDec) >> 16
	G1 := (0x0000ff00 & RGBColorDec) >> 8
	B1 := 0x000000ff & RGBColorDec
	
	
	;;Gdip_FromARGB(RGBColor,A1,R1, G1, B1)
	
	pBitmap:=Gdip_BitmapFromHWND(ID)


	Loop{
		if ( X <= X2 )
		{
			Loop
			{
				if ( Y <= Y2 )
				{
					color:=Gdip_GetPixel(pBitmap, X, Y)
					A := (0xff000000 & color) >> 24
					R2 := (0x00ff0000 & color) >> 16
					G2 := (0x0000ff00 & color) >> 8
					B2 := 0x000000ff & color
					if ( ( Abs( R1 - R2 ) < range ) && ( Abs( G1 - G2 ) < range ) && ( Abs( B1 - B2 ) < range ) )
					{
						foundX := X
						foundY := Y
						Gdip_DisposeImage(pBitmap)
						Gdip_Shutdown(pToken)
						return 1
					}
				}
				else
				{
					break
				}
				Y := Y + 2
			}
			X := X + 2
		}
		else
		{
			Gdip_DisposeImage(pBitmap)
			Gdip_Shutdown(pToken)
			return 0
		}
	}
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	return 0
	
	
}
	

PixelSearchB_( ByRef foundX, ByRef foundY, X1, Y1, X2, Y2, RGBColor, range=10 )	
{
	X := X1
	Y := Y1

	R1 := (0x00ff0000 & RGBColorDec) >> 16
	G1 := (0x0000ff00 & RGBColorDec) >> 8
	B1 := 0x000000ff & RGBColorDec

	pToken := Gdip_Startup()
	pBitMap := Gdip_BitmapFromHWND(ID)
	E1 := Gdip_LockBits(pBitmap, 0, 0, Gdip_GetImageWidth(pBitmap), Gdip_GetImageHeight(pBitmap), Stride, Scan0, BitmapData)
	
	Loop{
		if ( X <= X2 )
		{
			Loop
			{
				if ( Y <= Y2 )
				{
					color:=Gdip_GetPixel(pBitmap, X, Y)
					
					New_Index_X := 30+A_Index-1
					color := Gdip_GetLockBitPixel(Scan0, X, Y, Stride)
					
					A := (0xff000000 & color) >> 24
					R2 := (0x00ff0000 & color) >> 16
					G2 := (0x0000ff00 & color) >> 8
					B2 := 0x000000ff & color
					if ( ( Abs( R1 - R2 ) < range ) && ( Abs( G1 - G2 ) < range ) && ( Abs( B1 - B2 ) < range ) )
					{
						foundX := X
						foundY := Y
						Gdip_UnlockBits(pBitmap, BitmapData)
						Gdip_DisposeImage(pBitmap)
						Gdip_Shutdown(pToken)
						return 1
					}
				}
				else
				{
					break
				}
				Y := Y + 2
			}
			X := X + 2
		}
		else
		{
			Gdip_UnlockBits(pBitmap, BitmapData)
			Gdip_DisposeImage(pBitmap)
			Gdip_Shutdown(pToken)
			return 0
		}
	}

	
	Gdip_UnlockBits(pBitmap, BitmapData)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	return 0

	
	

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


RAlt & Q::
Reload
return

RAlt & W::
Pause
return

RAlt & E::
Start()
return

