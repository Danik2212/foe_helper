#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#include %A_ScriptDir%  ; Ensures a consistent starting directory

#include %A_LineFile%\..\FOE_COMMON_FUNCTIONS.ahk
#include %A_LineFile%\..\FOE_GLOBALS.ahk

SetBatchLines -1

CoordMode Mouse, Screen
CoordMode Pixel, Screen

global ReloadNextIt := 0

ArticCycleRQ()
{
	BlockInput MouseMove
	
	Loop
	{
		if ( ReloadNextIt )
		{
			Reload
		}
		; Close the quest panel
		Wait( 250 )
		Click( 582,85 )
		Wait( 50 )
		Click( 582,85 )
		Wait( 50 )
		
		; Open the buy fp panel
		ValidateLoop( 684,348,0x5D2115, 3000, "Click", 1013,109 )
		Wait( 50 )
		
		Loop, 10
		{
			if ( LookForColorAround( 105,242,0x3A6214, 100 ) )
			{
				break
			}
			Wait( 100 )
			; Buy 5 fp
			ValidateLoop( 721,495,0xD29C7B, 2000, "Click", 762,546 )
			
			
		}
		
		Click( 37,235 )
		Wait( 50 )
		
		; Open the quest
		ValidateLoop( 658,158,0x4A556D, 1500, "Click", 33,231 )
		Wait( 500 )
		
		; Collect reward - Checking the mark next to her face
		ValidateLoop( 568,354,0xBA8D42, 1500, "Click", 569,299 )
		Wait( 500 )
		
		Clipboard := ""
		
		ArticCycleQuestBack()
		
		; Close the quest panel
		Wait( 250 )
		Click( 582,85 )
		Wait( 50 )
		Click( 582,85 )
		Wait( 50 )
		
		; Open GM panel
		ValidateLoop( 627,379,0x4D190D, 1500, "Click", 349,978 )
		Wait( 50 )
		
		; Open the first GM
		ValidateLoop( 635,280,0x5A2013, 1500, "Click", 1204,474 )
		Wait( 50 )
		
		; Put the fps
		Click( 1255,469 )
		Wait( 50 )
		Click( 1255,469 )
		Wait( 50 )
		
		; Close the panels
		Click( 568,88 )
		Wait( 250 )
		Click( 568,88 )
		
	}
	
}



ArticPrepare()
{
	;Click refresh
	Click( 83,51 )
	Wait( 20000 )
	Click( 576,85 )
	Wait( 500 )
	Click( 576,85 )
	Wait( 500 )
	Click( 576,85 )
	Wait( 500 )
	Click( 576,85 )
	Wait( 500 )
	ArticAdjustTheZoomAndPosition()

}

ArticAdjustTheZoomAndPosition()
{
	Loop
	{
		DragSlow( 1815,929, 252,272 )
		Wait( 500 )
		DragSlow( 1815,929, 252,272 )
		Wait( 500 )
		DragSlow( 1815,929, 252,272 )
		
		if ( LookForColorAround( 1252,488,0xEBB563, 100 ))
		{
			return
		}
		;; Zoom
		Click( 193,1025 )
		Wait( 500 )
	}
}

ArticConfirmSellDeco()
{
	Click( 1079,684 )
	Click( 1085,723 )	
}

ArticCycleQuestBack()
{
	Inc:= 0
	Clipboard := "---"
	Loop
	{	
		if ( Clipboard == "QuestReady" )
		{
			Clipboard := "---"
			return
		}
		Wait( 250 )
		ValidateLoop( 658,147,0xE5D3B1, 50, "Click", 637,144 )
		X2:=0
		X3:=0 
		SearchForColor( 226,320,256,418, X2, Y2, 0x82281C, 15, 100 )
		SearchForColor( 222,570,267,693, X3, Y3, 0x82281C, 15, 100 )
		if( X3 != 0 )
		{
			Click( X3, Y3 )
		}
		if( X2 != 0 )
		{
			Click( X2, Y2 )
		}
		MouseMove, 229,378
			
	}
}


