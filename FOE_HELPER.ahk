#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#include %A_ScriptDir%  ; Ensures a consistent starting directory

#include %A_LineFile%\..\FOE_COMMON_FUNCTIONS.ahk
#include %A_LineFile%\..\FOE_GLOBALS.ahk
#include %A_LineFile%\..\FindClick.ahk

SetBatchLines -1

CoordMode Mouse, Screen
CoordMode Pixel, Screen
SetDefaultMouseSpeed 2

;;-----------------------------------------------------------------------------------------------------------------------
;; FillArmyWithSelectUnits
;;-----------------------------------------------------------------------------------------------------------------------


GetHelperFunctionsList()
{

	return "HelpAll|Buy|ConfirmSell|FillArmyWithSelectUnits|RemoveCurrentUnits|MouseClicksWhileKeyDown|AutoFightCDGLoop|AutoFightCDGFastLoop|ReplaceArmy|RecuringQuest|RemoveFriendsSmallScreen|PutFPS|Claim50Diamonds|CustomFunction"

}

GetGVGFunctionsList()
{
	return "FillArmyWithSelectUnits|RemoveCurrentUnits|ReplaceArmy|PlaceSiege|AutoFightGvG|MouseClicksWhileKeyDown"

}


FillArmyWithSelectUnits()
{
	if ( IsItBigScreen() )
	{
		FillArmyWithSelectUnitsBigScreen()
	}
	else
	{
		FillArmyWithSelectUnitsSmallScreen()
	}
}

FillArmyWithSelectUnitsBigScreen()
{
	MouseGetPos X, Y
	Loop 6
	{
		Click( 1497,851 )
		Click( 1494,846 )
	}
	MouseMove X, Y
}

FillArmyWithSelectUnitsSmallScreen()
{
	MouseGetPos X, Y
	Loop 11
	{
		Click( 736,669 )
	}
	MouseMove X, Y
}

;;-----------------------------------------------------------------------------------------------------------------------
;; SmartReplace
;;-----------------------------------------------------------------------------------------------------------------------

SmartReplace()
{
	units := Clipboard
	Loop, 10
	{
		if ( SubStr(units, 1, 5) == "UNITS" )
		{
			break
		}
		Wait( 100 )
		units := Clipboard
	}
	
	;; If there's no units data
	if ( SubStr(units, 1, 5) != "UNITS" )
	{
		msgbox, nope
		ReplaceArmy()
		return
	}
	
	Clipboard := ""
	
	switch FIGHT_AGE 
	{
		case 2:
			SmartReplaceVirtuel( units )
		case 3:
			SmartReplaceMarsRush( units )
		case 4:
			SmartReplaceMars( units )
		default:
			ReplaceArmy()
	}
	
}



SmartReplaceVirtuel( units )
{
	ninja := 0
	rocket := 0
	
	Loop, Parse, units, % "|"
	{
		if ( A_LoopField == "rocket_troop" )
		{
			rocket += 1
		}
		else if( A_LoopField == "ninja" )
		{
			ninja += 1
		}
	}
	if ( ninja == 0 )
	{
		;; Only rockets
		SmartReplaceWith( "Virtuel", 4, 8 )
	}
	else if ( rocket == 0 )
	{
		;; 2 ronin 6 voyoux
		SmartReplaceWith( "Virtuel", 2, 2, 3, 6 )
	}
	else
	{
		;; 2 char 6 voyoux
		SmartReplaceWith( "Futur", 2, 2, 3, 6 )
	}
}

SmartReplaceMarsRush( units )
{
	sents := 0
	sniper := 0
	wardens := 0
	
	Loop, Parse, units, % "|"
	{
		if ( A_LoopField == "steel_warden" )
		{
			wardens += 1
		}
		else if( A_LoopField == "sentinel" )
		{
			sents += 1
		}
		else if( A_LoopField == "sniperbot" )
		{
			sniper += 1
		}
	}
	if ( sniper > 1 && sents > 1 && tesla == 0 )
	{
		SmartReplaceWith( "Mars", 1, sents - 1, 3, 8 )
	}
	else if ( sents > 1 && sniper < 2 )
	{
		;; 2 steel 6 voyoux
		SmartReplaceWith( "Mars", 2, 2, 3, 6 )
	}
	else if ( sniper > 1 )
	{
		;; 8 sents
		SmartReplaceWith( "Mars", 1, 8 )
	}
	else
	{
		;; 2 steel 6 voyoux
		SmartReplaceWith( "Mars", 2, 2, 3, 6 )
	}
}


SmartReplaceMars( units )
{
	sents := 0
	sniper := 0
	wardens := 0
	tesla := 0
	
	Loop, Parse, units, % "|"
	{
		if ( A_LoopField == "steel_warden" )
		{
			wardens += 1
		}
		else if( A_LoopField == "sentinel" )
		{
			sents += 1
		}
		else if( A_LoopField == "sniperbot" )
		{
			sniper += 1
		}
		else if ( A_LoopField == "tesla_walker" )
		{
			tesla += 1
		}
	}
	if ( sniper > 1 && sents > 1 && tesla == 0 )
	{
		SmartReplaceWith( "Mars", 1, sents - 1, 3, 8 )
	}
	else if ( sents > 1 && sniper < 2 )
	{
		;; 2 steel 6 voyoux
		SmartReplaceWith( "Mars", 2, 2, 3, 6 )
	}
	else if ( sents == 0 && tesla == 0 )
	{
		;; Only rockets
		SmartReplaceWith( "Virtuel", 4, 8 )
	}
	else if ( sniper > 1 )
	{
		;; 8 sents
		SmartReplaceWith( "Mars", 1, 8 )
	}
	else if ( sents == 0 && wardens > 7 )
	{
		;; 8 tesla
		SmartReplaceWith( "Mars", 4, 8 )
	}
	else
	{
		;; 2 steel 6 voyoux
		SmartReplaceWith( "Mars", 2, 2, 3, 6 )
	}
}


;;  1 |  2  | 3   |   4     |  5
;;Fast|Heavy|Light|Artillery|Distance
;; Futur|Virtuel|
SmartReplaceWith( age, unit_type1, number1, unit_type2="", number2=0 )
{
	RUSH_MODE := 0
	if ( FIGHT_AGE == 3 )
	{
		RUSH_MODE := 1
	}
	LookForColorAround( 633,600,0x3D50AC, 2000 )
	RemoveCurrentUnits()
	
	Wait( 50 )
	
	
	if ( RUSH_MODE == 0 )
	{
		;; Click the age panel
		Click( 1327,601 )
		
		;; Wait for the panel to open
		WaitForColor( 1326,750,0xB4BBCA, 10, 1000 )
		
		;; Scroll to the bottom
		Click( 1325,731 )
		Wait( 50 )
		Click( 1325,731 )
		Wait( 250 )
		Wait( 200 )
		
		switch age 
		{
			case "Futur":
				Click( 1262,629 )
				Click( 1262,629 )
			case "Virtuel":
				Click( 1259,702 )
				Click( 1259,702 )
			case "Mars":
				Click( 1193,729 )
				Click( 1193,729 )
		}
	}
	
	Wait( 50 )
	
	switch unit_type1
	{
		case 1:
			Click ( 763,606 )
		case 2:
			Click( 806,608 )
		case 3:
			Click ( 853,608 )
		case 4:
			Click ( 896,612 )
		case 5:
			Click ( 939,610 )	
	}
	
	if ( RUSH_MODE == 0 )
	{
		;; Wait for the agepanel to close
		WaitForColor( 1230,628,0x522E16, 10, 1000 )
	}
	
	Wait( 50 )
	
	Loop %number1%
	{
		Click( 1085,738 )
	}
	
	Wait( 50 )
	
	switch unit_type2
	{
		case 1:
			Click ( 763,606 )
		case 2:
			Click( 806,608 )
		case 3:
			Click ( 853,608 )
		case 4:
			Click ( 896,612 )
		case 5:
			Click ( 939,610 )	
	}
	Wait( 50 )
	
	Loop %number2%
	{
		Click( 1085,738 )
	}
	
	
	
}


;;-----------------------------------------------------------------------------------------------------------------------
;; RemoveCurrentUnits
;;-----------------------------------------------------------------------------------------------------------------------

RemoveCurrentUnits()
{
	if ( IsItBigScreen() )
	{
		RemoveCurrentUnitsBigScreen()
	}
	else
	{
		RemoveCurrentUnitsSmallScreen()
	}
}

RemoveCurrentUnitsBigScreen()
{
	MouseGetPos X, Y
	Loop 11
	{
		Click( 1422,638 )
	}
	MouseMove X, Y
}

RemoveCurrentUnitsSmallScreen()
{
	MouseGetPos X, Y
	Loop 11
	{
		Click( 653,460 )
	}
	MouseMove X, Y
}

;;-----------------------------------------------------------------------------------------------------------------------
;; PlaceSiege
;;-----------------------------------------------------------------------------------------------------------------------

PlaceSiege()
{
	if ( IsItBigScreen() )
	{
		PlaceSiegeBigScreen()
	}
	else
	{
		PlaceSiegeSmallScreen()
	}
}

PlaceSiegeBigScreen()
{
	Click( 1859,631 )
	Wait( 50 )
	
	X:= 0
	Y:= 0
	
	if ( SIEGE_AGE == 1 ) ; TLA
	{
		X:= 1821
		Y:= 865
	}
	else ; OTHERS
	{
		X:= 1828
		Y:= 950
	}
	Click( X + 20,Y - 3 )
	Wait( 50 )
	Click( X - 20,Y - 2 )
	Wait( 50 )
	Click( X + 2,Y + 5 )
	Wait( 50 )
	Click( X - 2,Y + 1 )
	Wait( 50 )
	Click( X + 10,Y - 1 )
	Wait( 50 )
	Click( X - 20,Y - 2 )
	Wait( 50 )
	Click( X + 15,Y + 1 )
	Wait( 50 )
	Click( X - 22,Y + 2 )
	Wait( 50 )
	Click( X + 2,Y - 1 )
	Wait( 50 )
	Click( X - 21,Y - 2 )
	Wait( 50 )
	Click( X + 2,Y + 1 )
	Wait( 50 )
}

PlaceSiegeSmallScreen()
{
	WaitForColor( 1092,463, 0x894521, 10, 15000 )
	Click( 1092,463 )
	Wait( 50 )
	X:= 0
	Y:= 0
	if ( SIEGE_AGE == 1 ) ; TLA
	{
		X:= 1065
		Y:= 684
	}
	else ; OTHERS
	{
		X:= 1064
		Y:= 766
	}
	Click( X, Y )
	Click( X + 50,Y - 4 )
	Wait( 25 )
	Click( X - 40,Y - 2 )
	Wait( 25 )
	Click( X + 2,Y + 3 )
	Wait( 25 )
	Click( X - 2,Y + 1 )
	Wait( 25 )
	Click( X + 30,Y - 3 )
	Wait( 25 )
	Click( X - 20,Y - 2 )
	Wait( 25 )
	Click( X + 5,Y + 3 )
	Wait( 25 )
	Click( X - 21,Y + 2 )
	Wait( 25 )
	Click( X + 3,Y - 1 )
	Wait( 25 )
	Click( X - 15,Y - 2 )
	Wait( 25 )
	Click( X + 27,Y + 1 )
	Wait( 25 )
}

;;-----------------------------------------------------------------------------------------------------------------------
;; ConfirmSell
;;-----------------------------------------------------------------------------------------------------------------------

ConfirmSell()
{
	if ( IsItBigScreen() )
	{
		ConfirmSellBigScreen()
	}
	else
	{
		ConfirmSellSmallScreen()
	}
}

ConfirmSellBigScreen()
{
	MouseGetPos X, Y
	;Click( 1843,873 )
	;Click( 1832,901 )
	;Click( 1842,927 )
	;MouseMove X, Y
	
	Click( X, Y )
	Wait( 50 )

	if (SearchForColor( 1832,850, 1842,940, fX, fY, 0x922D1D, 5, 1500 ) )
	{
		if ( SearchForColor( fX + 20, fY, fX + 22, fY, xt, yt, 0x922D1D, 5, 1500 ) )
		{
			Click( fX, fY )
			MouseMove, X, Y
			return
		}
	}
	
}

ConfirmSellSmallScreen()
{
	MouseGetPos X, Y
	;Click( 755,713 )
	;MouseMove X, Y
	
	Click( X, Y )
	Wait( 50 )
	Loop
	{
		if (SearchForColor( 977,647, 1035,754, fX, fY, 0x922D1D, 5, 3000 ) )
		{
			if ( SearchForColor( fX + 40, fY, fX + 42, fY,  xt, yt, 0x922D1D, 5, 100 ) )
			{
				Click( fX, fY )
				MouseMove, X, Y
				return
			}
		}
	}
}

;;-----------------------------------------------------------------------------------------------------------------------
;; Buy
;;-----------------------------------------------------------------------------------------------------------------------

Buy()
{
	if ( IsItBigScreen() )
	{
		BuyBigScreen()
	}
	else
	{
		BuySmallScreen()
	}
}

BuyBigScreen()
{
	MouseGetPos X, Y
	switch CONSTRUCTION_SLOTS
	{
		case 1:
			Click( 58,980 )
		case 2:
			Click( 164,973 )
		case 3:
			Click( 62,1140 )
		case 4:
			Click( 162,1141 )
	}
	MouseMove, 500, 500
	Wait( 50 )
	Click( X, Y )
}

BuySmallScreen()
{
	MouseGetPos X, Y
	switch CONSTRUCTION_SLOTS
	{
		case 1:
			Click( 56,625 )
		case 2:
			Click( 160,622 )
		case 3:
			Click( 57,774 )
		case 4:
			Click( 154,776 )
	}
	MouseMove, 300, 300
	Wait( 50 )
	Click( X, Y )
}

;;-----------------------------------------------------------------------------------------------------------------------
;; DoFight
;;-----------------------------------------------------------------------------------------------------------------------

DoFight()
{
	if ( IsItBigScreen() )
	{
		DoFightBigScreen()
	}
	else
	{
		DoFightSmallScreen()
	}
}

DoFightBigScreen()
{
	2fights := 0
	WaitForColor( 1427,789,0x38499D, 10, 2000 )
	if ( WaitForColor( 1791,669,0x692020, 10, 50 ) )
	{
		2fights := 1
		text := "2 fights "
		ToolTip , %text%, 10, 10
	}
	else
	{
		text := "1 fight "
		ToolTip , %text%, 10, 10
	}
	Click( 1649,1003 )
	Wait( 50 )
	Click( 1649,1003 )
	Wait( 50 )
	Click( 1649,1003 )
	Wait( 50 )
	X:= 0
	Y:= 0
	
	if ( 2fights == 1 && SearchForColor( 1780, 970, 1820, 1100, X, Y, 0x975221, 10, 3000 ) )
	{
		Wait( 100 )
		Click( X,Y )
		Wait( 100 )
	}
	if ( SearchForColor2( 1600, 950, 1700, 1050, X, Y, 0x87C92D, 0x507B1C, 10, 3000 ) )
	{
		Wait( 100 )
		Click( X,Y+10 )
		Wait( 100 )
	}
}

DoFightSmallScreen()
{
	2fights := 0
	WaitForColor( 648,627,0x2C3978, 10, 2000 )
	if ( WaitForColor( 1032,489,0x6C2121, 10, 50 ) )
	{
		2fights := 1
		text := "2 fights "
		ToolTip , %text%, 10, 10
	}
	else
	{
		text := "1 fight "
		ToolTip , %text%, 10, 10
	}

	X:= 0
	Y:= 0
	
	Click( 931,814 )
	Wait( 250 )
	Loop{
		if ( NO_RANKS )
		{
			if ( 2fights && SearchForColor2( 884,815, 917,823, X, Y, 0xB47622, 0x995423, 10, 50 ) )
			{
				Wait( 100 )
				Click( X,Y+3 )
				Wait( 100 )
			}
		
			if ( SearchForColor2( 884,761, 941,791, X, Y, 0x72A725, 0x57861F, 10, 50 ) )
			{	
				if ( LookForColorAround( 1044,371,0xFEFADF, 100 ) )
				{
					Wait( 100 )
					Click( X,Y+3 )
					Wait( 100 )
					return
				}
				
			}
		}
		else
		{
			if ( 2fights && SearchForColor2( 884,815, 917,823, X, Y, 0xB47622, 0x995423, 10, 50 ) )
			{
				Wait( 100 )
				Click( X,Y+3 )
				Wait( 100 )
			}
		
			if ( SearchForColor2( 889,825, 934,830, X, Y, 0x72A725, 0x57861F, 10, 50 ) )
			{	
				if ( LookForColorAround( 1032,601,0x4D3118, 100 ) )
				{
					Wait( 100 )
					Click( X,Y+3 )
					Wait( 100 )
					return
				}
				
			}
		
		}
	
	}
	
}

;;-----------------------------------------------------------------------------------------------------------------------
;; ReplaceArmy
;;-----------------------------------------------------------------------------------------------------------------------

ReplaceArmy()
{
	if ( IsItBigScreen() )
	{
		ReplaceArmyBigScreen()
	}
	else
	{
		ReplaceArmySmallScreen()
	}
}

ReplaceArmyBigScreen()
{
	WaitForColor( 1427,789,0x38499D, 10, 2000 )
	RemoveCurrentUnits()
	Wait( 50 )
	
	switch UNIT_TYPE
	{
		case 1:
			Click ( 1524,789 )
		case 2:
			Click( 1566,789 )
		case 3:
			Click ( 1612,791 )
		case 4:
			Click ( 1655,787 )
		case 5:
			Click ( 1703,790 )	
	}
	Wait( 50 )
	Loop %UNITS_NUMBER%
	{
		
		Click( 1496,840 )
	}
	
	Click ( 1615,789 )	
	Wait( 50 )
	
	Loop %ROGUES_NUMBER%
	{
		Click( 2053,839 )
	}
	
	MouseMove 1655,996
}

ReplaceArmySmallScreen()
{

	LookForColorAround( 633,600,0x3D50AC, 2000 )
	RemoveCurrentUnits()
	;Wait( 50 )
	
	switch UNIT_TYPE
	{
		case 1:
			Click ( 763,606 )
		case 2:
			Click( 806,608 )
		case 3:
			Click ( 853,608 )
		case 4:
			Click ( 896,612 )
		case 5:
			Click ( 939,610 )	
	}
	;Wait( 50 )
	Loop %UNITS_NUMBER%
	{
		Click( 1294,664 )
	}
	
	Click ( 850,606 )	
	;Wait( 50 )
	
	Loop %ROGUES_NUMBER%
	{
		Click( 1079,739 )
	}
	
	;MouseMove, 896,820
	;MouseMove, 896,820
} 

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoFight
;;-----------------------------------------------------------------------------------------------------------------------

AutoFight()
{
	if ( SMART_FIGHTING )
	{
		
		SmartReplace()
	}
	else
	{
		ReplaceArmy()
	}
	
	DoFight()	
}


;;-----------------------------------------------------------------------------------------------------------------------
;; FinishFightCDG
;;-----------------------------------------------------------------------------------------------------------------------

FinishFightCDG()
{
	if ( IsItBigScreen() )
	{
		FinishFightCDGBigScreen()
	}
	else
	{
		FinishFightCDGSmallScreen()
	}
}

FinishFightCDGBigScreen()
{
	Loop
	{
		Click( 1656,831 )
		Click( 1656,831 )
		Click( 1669,847 )
		if( WaitForColor( 1427,789,0x38499D, 10, 100 ) )
			break
	}

}

FinishFightCDGSmallScreen()
{
	Loop
	{
		Click( 893,670 )
		Click( 902,625 )
		if( WaitForColor( 648,627,0x2C3978, 10, 50 ) )
			break
	}

}

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoFightCDG
;;-----------------------------------------------------------------------------------------------------------------------

AutoFightCDG()
{
	FinishFightCDG()
	AutoFight()
}

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoFightCDGLoop
;;-----------------------------------------------------------------------------------------------------------------------

AutoFightCDGLoop()
{
	Loop
	{
		AutoFightCDG()
		Wait( 1500 )
	}
	return true
}

AutoFightCDGFastLoop()
{
	Loop
	{
		AutoFightCDG()
	}
	return true
}


;;-----------------------------------------------------------------------------------------------------------------------
;; RecuringQuest
;;-----------------------------------------------------------------------------------------------------------------------

RecuringQuest()
{
	if ( RQ_LOOP )
	{
		RecuringQuestLoop()
	}
	else
	{
		RecuringQuestSingle()
	}

}

;;-----------------------------------------------------------------------------------------------------------------------
;; RecuringQuestSingle
;;-----------------------------------------------------------------------------------------------------------------------

RecuringQuestSingle()
{
	switch RQ_SLOTS
	{
		case 1:
			RecuringQuest1()
		case 2:
			RecuringQuest2()
	}
	
}

;;-----------------------------------------------------------------------------------------------------------------------
;; RecuringQuestLoop
;;-----------------------------------------------------------------------------------------------------------------------

RecuringQuestLoop()
{
	Loop
	{
		switch RQ_SLOTS
		{
			case 1:
				RecuringQuest1()
			case 2:
				RecuringQuest2()
		}
	
	}

}

;;-----------------------------------------------------------------------------------------------------------------------
;; RecuringQuest1
;;-----------------------------------------------------------------------------------------------------------------------

RecuringQuest1()
{
	
	ClickSlow( 317,1051 )
	Wait( 100 )
	ClickSlow( 317,1051 )
	Wait( 100 )
	ClickSlow( 317,1051 )
	Wait( 100 )
	;Open quest window
	
	ClickSlow( 32,232 )
	Wait( 1000 )
	X:= 0
	Y:= 0
	if ( SearchForColor( 516, 299, 614, 341, X, Y, 0x56821E, 10, 1000 ) )
	{
		ClickSlow( X, Y )
	}
	Wait( 500 )

	;Remove any popups
	ClickSlow( 26,212 )
	Wait( 500 )
	ClickSlow( 26,212 )
	
	Wait( 500 )
	
	;Cycle through the quests
	Loop 7
	{
		Wait( 500 )
		X1:= 0
		Y1:= 0
		if ( VerifyAbandonner1( X1, Y1 ) )
		{
			ClickSlow( X1,Y1 )
		}
	}
	
	ClickSlow( 565,1341 )
	ClickSlow( 565,1341 )
	Wait( 500 )
	if ( SearchForColor( 1949, 645, 1951, 665, X, Y, 0x9E5825, 10, 1000 ) )
	{
		ClickSlow( X, Y )
	}
	Wait( 500 )
	ClickSlow( 1951,648 )
	Wait( 250 )
	Send %RQ_PFS%
	Wait( 250 )
	ClickSlow( 2013,646 )
	Wait( 250 )
}

;;-----------------------------------------------------------------------------------------------------------------------
;; RecuringQuest2
;;-----------------------------------------------------------------------------------------------------------------------

RecuringQuest2()
{
	
	; Open the quest panel
	ValidateLoop( 659,147,0xE7D6B6, 500, "Click", 26,234 )
	
	Wait( 500 )
	
	Click( 570,298 )
	
	Clipboard := ""
	
	Loop
	{	
		if ( Clipboard == "QuestReady" )
		{
			Clipboard := ""
			Click( 458,91 )
			
			; Open the GM panel
			ValidateLoop( 658,369,0x662518, 2000, "Click", 563,980 )
			
			; Open the first GM
			ValidateLoop( 613,274,0x662518, 2000, "Click", 1202,473 )
			
			Click( 1189,463 )
			Wait( 100 )
			Send, 200
			
			MouseMove, 1205,473 
			return
		}
		CancelQuests()
			
	}

}

CancelQuests()
{
	ValidateLoop( 658,147,0xE5D3B1, 50, "Click", 637,144 )
	X2:=0
	X3:=0
	SearchForColor( 226,220,256,418, X2, Y2, 0x82281C, 5, 100 )
	SearchForColor( 222,570,267,693, X3, Y3, 0x82281C, 5, 100 )

	if( X3 != 0 )
	{
		Click( X3, Y3 )
	}
	if( X2 != 0 )
	{
		Click( X2, Y2 )
	}
	if ( Inc == 4 )
	{
		Wait( 500 )
	}
	MouseMove, 229,378

}





; Quest to complete
; 933122
; 933125


; Quest for battle
; 933131
; 933132


AutoQuestAndBattle()
{




}




GetProperQuestState()
{
	Loop
	{
		; First of all, put the quest in the right order
		; Close the quest panel
		ValidateLoop( 549,89,0x4F2F17, 2000, "Click", 548,90 )
		
		wait( 1000 )
		
		; Open the quest panel
		ValidateLoop( 663,144,0xE7D6B6, 2000, "Click", 30,242 )
		
		questsArray := []
		quests := Clipboard
		Loop, Parse, quests, % "|"
		{
			quest := A_LoopField
			questsArray.Push( IsAGoodQuest( quest ) )
		}
		
		if ( ( questsArray[1] == 1 ) and ( questsArray[2] == 1 ) and ( questsArray[3] == 1 ) ) return
		
		if ( ( questsArray[1] == 2 ) or ( questsArray[2] == 2 ) or ( questsArray[3] == 2 ) )
		{
			X1:=0
			; Collect rewards
			SearchForColor( 514,279,639,415, X1, Y1, 0x537F1D, 5, 100 )		
			
			if( X1 != 0 )
			{
				Click( X1, Y1 )
			}
			
			continue
		}
		msgbox, % questsArray[1] questsArray[2] questsArray[3]
		if ( questsArray[1] == 0 )
		{
			X2:=0
			SearchForColor( 225,383,242,539, X2, Y2, 0x82281C, 5, 100 )
			if( X2 != 0 )
			{
				Click( X2, Y2 )
			}
			
			continue
		}
		
		if ( questsArray[2] == 0 )
		{
			X3:=0
			SearchForColor( 222,570,267,693, X3, Y3, 0x82281C, 5, 100 )
			if( X3 != 0 )
			{
				Click( X3, Y3 )
			}
			
			else
			{
				; Scroll down a little
				Click( 655,313 )
				Wait( 500 )
				msgbox, not found
				SearchForColor( 222,570,267,693, X3, Y3, 0x82281C, 5, 100 )
				if( X3 != 0 )
				{
					Click( X3, Y3 )
				}
			}
			
			continue
		}
		
	}
	
}


IsAGoodQuest( quest )
{		
	if ( ( quest == "933122(collectReward)" ) or ( quest == "933125(collectReward)" ) )
	{
		return 2
	}
	if ( ( quest == "933122(accepted)" ) or ( quest == "933125(accepted)" ) or ( quest == "933131(accepted)" ) or ( quest == "933132(accepted)" ) )
	{
		return 1
	}
	return 0
}





















;;-----------------------------------------------------------------------------------------------------------------------
;; VerifyAbandonner2
;;-----------------------------------------------------------------------------------------------------------------------

VerifyAbandonner2( ByRef X1, ByRef Y1, ByRef X2, ByRef Y2, Inc := 0 )
{
	X1_1:= 0
	Y1_1:= 0
	X2_1:= 0
	Y2_1:= 0
	
	X1_2:= 0
	Y1_2:= 0
	X2_2:= 0
	Y2_2:= 0
	
	if ( SearchForColor( 220, 360, 386, 425, X1_1, Y1_1, 0x7C261A, 5, 1000 ) )
	{
		if ( SearchForColor( 220, 600, 385, 668, X2_1, Y2_1, 0x7C261A, 5, 1000 ) )
		{
			Wait( 150 )
			if ( SearchForColor( 220, 360, 386, 425, X1_2, Y1_2, 0x7C261A, 5, 1000 ) )
			{
				if ( SearchForColor( 220, 600, 385, 668, X2_2, Y2_2, 0x7C261A, 5, 1000 ) )
				{
					Y1Dif := Abs( Y1_1 - Y1_2 )
					Y2Dif := Abs( Y2_1 - Y2_2 )
					if ( Y1Dif < 5 && Y2Dif < 5 )
					{
						; If there's yellow/brown next to it
						if ( SearchForColor( X1_2 - 50, Y1_2, X1_2 + 50, Y1_2, temp1, temp2, 0xDFC79A, 10, 100 ) )
						{
							X1 := X1_2
							X2 := X2_2
							Y1 := Y1_2
							Y2 := Y2_2
							return true
						}
						
					}

				}
			}
			
		}
	}
	if ( Inc < 10 )
	{
		Inc := Inc + 1
		return VerifyAbandonner2( X1, Y1, X2, Y2, Inc )
	}
	else
	{
		return false
	}

}

;;-----------------------------------------------------------------------------------------------------------------------
;; VerifyAbandonner1
;;-----------------------------------------------------------------------------------------------------------------------

VerifyAbandonner1( ByRef X1, ByRef Y1, Inc := 0 )
{
	X1_1:= 0
	Y1_1:= 0
	
	X1_2:= 0
	Y1_2:= 0
	

	if ( SearchForColor( 242, 562, 391, 647, X1_1, Y1_1, 0x7C261A, 5, 1000 ) )
	{
		Wait( 250 )
		if ( SearchForColor( 242, 562, 391, 647, X1_2, Y1_2, 0x7C261A, 5, 1000 ) )
		{
			Y1Dif := Abs( Y1_1 - Y1_2 )
			Y2Dif := Abs( Y2_1 - Y2_2 )
			if ( Y1Dif < 5 && Y2Dif < 5 )
			{
				; If there's yellow/brown next to it
				if ( SearchForColor( X1_2 - 50, Y1_2, X1_2 + 50, Y1_2, temp1, temp2, 0xDFC79A, 10, 100 ) )
				{
					X1 := X1_2
					Y1 := Y1_2
					return true
				}
			}
		}	
	}
	if ( Inc < 10 )
	{
		Inc := Inc + 1
		return VerifyAbandonner1( X1, Y1, Inc )
	}
	else
	{
		return false
	}

}

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoFightGvG
;;-----------------------------------------------------------------------------------------------------------------------

AutoFightGvG()
{
	X:= 0
	Y:= 0
	MouseGetPos X, Y
	Loop{
		Loop
		{
			Click( X, Y )
			if ( LookForColorAround( X+180,Y+14,0x573319, 50 ) )
			{
				Click( X+87, Y-14 )
				Wait( 100 )
				break
			}
			if ( LookForColorAround( 633,600,0x3D50AC, 50 ) )
			{
				break
			}
		}

		; Wait for the unit panel
		LookForColorAround( 632,395,0x342E2C , 2000 )
		
		; If there's a missing unit
		if( LookForColorAround( 857,531,0x422714, 50 ) )
		{
			ReplaceArmy()
		}
		DoFight()
		Send, {Escape}
		Wait( 50 )
		Send, {Escape}
		Wait( 50 )
	}
}

;;-----------------------------------------------------------------------------------------------------------------------
;; RemoveFriendsSmallScreen
;;-----------------------------------------------------------------------------------------------------------------------

RemoveFriendsSmallScreen()
{
	Loop, %FRIENDS_TO_REMOVE%
	{
		;; Click the portrait
		ValidateLoop( 765,982,0x341E0D, 2000, "Click", 741,925 )
		Wait( 100 )
		;; Click remove friend
		ValidateLoop( 871,611,0xE3D3A9, 2000, "Click", 883,979 )
		Wait( 100 )
		;; Confirm
		ValidateLoop( 567,89,0x53351C, 2000, "Click", 1077,679 )
		Wait( 100 )
	}
}

;;-----------------------------------------------------------------------------------------------------------------------
;; Claim50DiamondsSmallScreen
;;-----------------------------------------------------------------------------------------------------------------------

global 50D_COLLECTION_DONE := 0
global 50D_TOTAL := 0

Claim50Diamonds()
{
	if ( IsItBigScreen() )
	{
		Claim50DiamondsBigScreen()
	}
	else
	{
		Claim50DiamondsSmallScreen()
	}
}

Claim50DiamondsBigScreen()
{
	StartTime := A_TickCount
	Loop{
		;; Search for the button
		if ( SearchForColor( 1992,802, 2014,885, X, Y, 0xB36C29, 10, 1000 ) )
		{
			Click( X, Y )
			Wait( 3000 )
			StartTime := A_TickCount
		}
		
		if ( LookForColorAround( 1508,644,0x530B0B, 1000 ) )
		{
			Click( 1704,843 )
			50D_COLLECTION_DONE += 1
			50D_TOTAL += 50
			Tooltip, Done: %50D_COLLECTION_DONE% Total: %50D_TOTAL%, 10, 40
			Wait( 2000 )
			StartTime := A_TickCount
		}
		
		if ( LookForColorAround( 1508,671,0xE7D7AC, 1000 ) )
		{
			if ( A_TickCount > (StartTime + 10000) )
			{
				Click( 2123,806 )
				Click( 2123,806 )
				Click( 2123,806 )
				Click( 2123,806 )
				StartTime := A_TickCount
			}
		
		}
		
	}
	
}

Claim50DiamondsSmallScreen()
{
	StartTime := A_TickCount
	Loop{
		;; Search for the button
		if ( SearchForColor( 1227,620, 1256,698, X, Y, 0x975321, 10, 1000 ) )
		{
			Click( X, Y )
			50D_COLLECTION_DONE += 1
			50D_TOTAL += 50
			Tooltip, Done: %50D_COLLECTION_DONE% Total: %50D_TOTAL%, 10, 40
			Wait( 3000 )
			StartTime := A_TickCount
		}
		else
		{
			if ( LookForColorAround( 950,581,0x5A3A1E, 1000 ) )
			{
				if ( A_TickCount > (StartTime + 10000) )
				{
					Click( 1361,624 )
					Click( 1361,624 )
					Click( 1361,624 )
					Click( 1361,624 )
					StartTime := A_TickCount
				}
			}
		}
		
		if ( LookForColorAround( 777,672,0xBC9C6B, 1000 ) )
		{
			Click( 968,711 )
			Wait( 2000 )
			StartTime := A_TickCount
		}
		
		
		
	}
}



;;-----------------------------------------------------------------------------------------------------------------------
;; ReplaceWithBestFastUnits
;;-----------------------------------------------------------------------------------------------------------------------

ReplaceWithBestFastUnits()
{
	if ( IsItBigScreen() )
	{
		ReplaceWithBestFastUnitsBigScreen()
	}
	else
	{
		ReplaceWithBestFastUnitsSmallScreen()
	}
}

ReplaceWithBestFastUnitsBigScreen()
{
	RemoveCurrentUnits()
	Click( 893,576 )
	Wait( 350 )
	Loop 6
	{
		Click( 2085,929 )
		Wait( 50 )
	}
	Wait( 100 )
	Click( 1992,932 )
	Wait( 100 )
	
	Click( 1522,785 )

	Loop 8
	{
		Click( 1704,843 )
	}
}

ReplaceWithBestFastUnitsSmallScreen()
{
	RemoveCurrentUnits()
	Click( 1324,599 )
	Wait( 350 )
	Click( 1322,699 )
	Wait( 700 )
	Click( 1244,700 )
	Wait( 100 )
	Click( 764,609 )
	Wait( 100 )
	
	Loop 8
	{
		Click( 740,664 )
	}
}

;;-----------------------------------------------------------------------------------------------------------------------
;; 5MinProductionLoop
;;-----------------------------------------------------------------------------------------------------------------------

5MinProductionLoop()
{
	Loop
	{
		;Click( 1033,401 )
		;Loop 30
		;{
		;	Start5MinProduction()
		;	Wait( 1000 )
		;}
		

		;if ( SearchForColor( 810,369, 1498,726, X, Y, 0x753C22, 10, 1000 ) )
		;{
		;	Click( X, Y - 20 )
		;	Wait( 1000 )
		;}
		
		
		
	}

}

;;-----------------------------------------------------------------------------------------------------------------------
;; Start5MinProduction
;;-----------------------------------------------------------------------------------------------------------------------

Start5MinProduction()
{
	Wait( 50 )
	Send, 1
	Wait( 50 )
	Send, 1
	Click( 729,530 )


}

;;-----------------------------------------------------------------------------------------------------------------------
;; MouseClicksWhileKeyDown()
;;-----------------------------------------------------------------------------------------------------------------------

MouseClicksWhileKeyDown()
{
	while GetKeyState("F23")
	{
		MouseGetPos, X, Y
		Click( X, Y )
		Random, r, 30, 70
		Wait( r )
	}
}

;;-----------------------------------------------------------------------------------------------------------------------
;; RemoveAndReplaceSiege()
;;-----------------------------------------------------------------------------------------------------------------------

RemoveAndReplaceSiege()
{
	Click( 653,773 )
	Wait( 25 )
	Click( 1100,456 )
	Wait( 25 )
	Click( 1091,673 )
	Wait( 25 )
	PlaceSiege()

}


HelpAll()
{
	Click( 308,1026 )
	Click( 421,1025 )
	Click( 520,1028 )
	Click( 629,1028 )
	Click( 743,1029 )
	MouseMove, 915,975
}

NegoDoer()
{
	Loop, Parse, clipboard
	{
		Send, %A_LoopField%
		if ( Mod( A_Index, 2 ) == 0 )
		{
			Wait( 200 )
		}
	}
	Wait( 200 )
	Send, {space}

}



PutFPS()
{
	Loop, % FRIENDS_TO_REMOVE
	{
		if ( Mod( A_INDEX, 5 ) == 1 )
		{
			PutFPSWorker( 779,980 )
		}
		
		if ( Mod( A_INDEX, 5 ) == 2 )
		{
			PutFPSWorker( 673,979 )
		}
		
		if ( Mod( A_INDEX, 5 ) == 3 )
		{
			PutFPSWorker( 565,980 )
		}
		
		if ( Mod( A_INDEX, 5 ) == 4 )
		{
			PutFPSWorker( 457,977 )
		}
		
		if ( Mod( A_INDEX, 5 ) == 0 )
		{
			PutFPSWorker( 350,981 )
			Wait( 250 )
			Click( 244,976 )
			Wait( 250 )
		}
	
	}

}

PutFPSWorker(x, y)
{
	; Wait for grey to be over
	Wait( 500 )
	WaitForColor( 649,88,0x55361C,10, 3000 )
	
	; Click the gm button
	ValidateLoop( 642,373,0x5F2216, 2000, "Click", x,y )
	Wait( 500 )
	
	; Click the first gm
	ValidateLoop( 604,275,0x652518, 2000, "Click", 1230,473 )
	Wait( 1000 )
	
	; Click the 1 pf
	Click( 762,467 )
	Wait( 250 )
	
	; Close the panels
	Click( 508,89 )
	Wait( 50 )
	Click( 508,89 )
	
	; Finish closing the panels
	ValidateLoop( 561,87,0x523017, 250, "Click", 474,88 )
	
}



PutReinforcementsWhileKeyDown()
{
	while GetKeyState("F19")
	{
		if( LookForColorAround( 856,455,0x432815, 50 ) )
		{
			FillArmyWithSelectUnits()
			continue
		}
		
		if ( CheckForAvailableSlotAndFill( 1092,533 ) )
		{
			continue
		}
		
		if ( CheckForAvailableSlotAndFill(1156,461 ) )
		{
			continue
		}
		
		if ( CheckForAvailableSlotAndFill(1156,534 ) )
		{
			continue
		}
		
		if ( CheckForAvailableSlotAndFill(1219,462 ) )
		{
			continue
		}
		
		if ( CheckForAvailableSlotAndFill(1220,533 ) )
		{
			continue
		}
		
		if ( CheckForAvailableSlotAndFill(1283,463 ) )
		{
			continue
		}
		
		if ( CheckForAvailableSlotAndFill(1284,532 ) )
		{
			continue
		}
		
	}
}

CheckForAvailableSlotAndFill( X, Y )
{
	if ( LookForColorAround( X,Y,0x945025, 50 ) )
	{
		Click( X,Y )
		return 1
	}
	return 0
}




;;-----------------------------------------------------------------------------------------------------------------------
;; CustomFunction
;;-----------------------------------------------------------------------------------------------------------------------

CustomFunction()
{
	;FindClick()
	Loop
	{
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Coconut.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Sleep.png", "o5 x0 y+80" )
		Send, 1
		Sleep, 500
		if ( Mod( A_Index, 10 )== 0 )
		{
			Send, {esc}
		}
	}
	;5MinProductionLoop()

	;ImageSearch, FoundX, FoundY, 584,355, 1476,827, *10 C:\Users\Danik\Documents\GitHub\foe_helper\Coconut.png
	;MouseMove, FoundY, FoundY

	return
	

}




