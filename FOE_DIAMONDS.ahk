#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#include %A_ScriptDir%  ; Ensures a consistent starting directory
#Include %A_LineFile%\..\Gdip_All.ahk

SetBatchLines 10

CoordMode, Mouse, Window
CoordMode, Pixel, Window

global START_TIME := 0
global COLLECTION_DONE := 0
global TOTAL := 0


global ID := 0

Start()
{	
	mousegetpos, w1mx, w1my, w1id
	ID := w1id
	Tooltip, Starting... Firefox ID: %ID%, 10, 40
	DiamondCycle()
}

DiamondCycle()
{
	StartTime := A_TickCount
	Loop{
		;; Search for the button
		if ( SearchForColor( 1241,631, 1241,719, X, Y, 0x975321, 10, 200 ) )
		{	
			Click( X, Y )
			Wait( 3000 )
			StartTime := A_TickCount
		}
		else
		{
			;; Look the screen isn't greyed out
			if ( LookForColorAround( 1056,528,0xe5d5ac, 200 ) )
			{
				if ( A_TickCount > (StartTime + 10000) )
				{
					; Scroll up
					Click( 1369,635 )
					Click( 1369,635 )
					Click( 1369,635 )
					Click( 1369,635 )

					StartTime := A_TickCount
				}
			
			}
		
		}
		
		;; Look for the yellow slowdown banner
		;if ( LookForColorAround(1431,109,0xffe900, 100 ) )
		;{
		;	Click( 1894,106 )
		;	Wait( 500 )
		;}
		
		;; If the 50 diamonds popup is there
		if ( LookForColorAround( 862,677,0xd8c497, 200 ) )
		{
			Click( 958,675 )
			COLLECTION_DONE += 1
			TOTAL += 50
			Tooltip, Done: %COLLECTION_DONE% Total: %TOTAL%, 10, 40
			Wait( 2000 )
			StartTime := A_TickCount
		}
		
		
		
	}

}

Wait( timeout )
{
	Random, t, 0, 50
	t := t - 25
	Sleep, timeout + t
}

Click( cX, cY )
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
				Sleep, 1
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


RAlt & F2::
Reload
return

RAlt & F3::
Pause
return

RAlt & F1::
Start()
return

