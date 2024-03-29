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

	return "HelpAll|Buy|ConfirmSell|FillArmyWithSelectUnits|RemoveCurrentUnits|MouseClicksWhileKeyDown|AutoFightCDGLoop|AutoFightCDGFastLoop|ReplaceArmy|RecuringQuest|RemoveFriendsSmallScreen|5MinProductionLoop|Claim50Diamonds|CustomFunction|NegoDoer|AutoQuestAndBattle"

}

GetGVGFunctionsList()
{
	return "FillArmyWithSelectUnits|RemoveCurrentUnits|ReplaceArmy|PlaceSiege|AutoFightGvG|MouseClicksWhileKeyDown|KeepFightingGvG"

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
	
	Click( 967,821 )
	;Wait( 250 )
	start := A_TickCount
	
	if( 2fights == 0 )
	{
		2fightDone := 1
	}
	Loop{
		if ( NO_RANKS )
		{
			if ( 2fights && SearchForColor2( 884,815, 917,823, X, Y, 0xB47622, 0x995423, 10, 50 ) )
			{
				Wait( 100 )
				Click( X,Y+3 )
				Wait( 100 )
				2fightDone := 1
			}
		
			if ( 2fightDone && SearchForColor2( 884,761, 941,791, X, Y, 0x72A725, 0x57861F, 10, 50 ) )
			{	
				if ( LookForColorAround( 1044,371,0xFEFADF, 100 ) )
				{
					;Wait( 100 )
					Click( X,Y+3 )
					;Wait( 100 )
					return
				}
				
			}
		}
		else
		{
			if ( 2fights && SearchForColor2( 884,820, 917,845, X, Y, 0xB47622, 0x995423, 10, 50 ) )
			{
				if ( LookForColorAround( 1178,315,0xFAF6D1, 100 ) )
				{
					Wait( 100 )
					Click( X,Y+3 )
					2fightDone := 1
				}
			}
			
			if ( 2fightDone && SearchForColor2( 961,822, 985,853, X, Y, 0x72A725, 0x57861F, 10, 50 ) )
			{	
				if ( LookForColorAround( 1083,410,0x51C175, 100 ) )
				{
					;Wait( 100 )
					Click( X,Y+3 )
					;Wait( 100 )
					return
				}
				
			}
		
		}
		
		if ( ( A_TickCount - start ) > 2000 ) 
			return
	
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
		if( WaitForColor( 648,627,0x2C3978, 10, 25 ) )
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

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoFightCDGFastLoop
;;-----------------------------------------------------------------------------------------------------------------------

AutoFightCDGFastLoop()
{
	Loop
	{
		AutoFightCDG()
	}
	return true
}

;;-----------------------------------------------------------------------------------------------------------------------
;; CancelQuests
;;-----------------------------------------------------------------------------------------------------------------------

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

;;-----------------------------------------------------------------------------------------------------------------------
;; ReloadAndFinishLoad
;;-----------------------------------------------------------------------------------------------------------------------

ReloadAndFinishLoad()
{
	Loop, 10
	{
		Click( 86,52 )
		Wait( 3000 )
		WaitForColor( 501,87,0x53341A, 10, 10000 )
		Click( 489,85 )
		Wait( 500 )
		Click( 489,85 )
		Wait( 500 )
		
		Loop, 10
		{
			FindClick( A_ScriptDir . "\close.png", "o5" )
			FindClick( A_ScriptDir . "\close2.png", "o5" )
			Click( 517,88 )
			if ( WaitForColor( 505,82,0x53361C, 10, 100 ) )
			{
				return
			}
		}
	}
	
}

;;-----------------------------------------------------------------------------------------------------------------------
;; ResetToQuestPanel
;;-----------------------------------------------------------------------------------------------------------------------

ResetToQuestPanel()
{
	; if done questing
	if ( FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\2000.png", "o5 n" ) )
	{
		reload
	}
	ReloadAndFinishLoad()
	Wait( 500 )
	Send, q
	Wait( 1000 )
	WaitForColor( 663,142,0xE7D6B6, 10, 3000 )

}

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoQuestAndBattle
;;-----------------------------------------------------------------------------------------------------------------------

AutoQuestAndBattle()
{

	Loop
	{
		state := GetProperQuestState()
		
		if ( state[3] == 4 )
		{
			ScrollToTheBottomOfQuest()
			
			; Click the fight button
			X:=0
			SearchForColor( 445,366,488,456, X, Y, 0xA15B26, 5, 5000 )
			if( X != 0 )
			{
				Click( X, Y )
				wait( 500 )
			}
			
			AutoFight()
		
			; Cancel the quest now
			SearchForColor( 222,570,267,693, X3, Y3, 0x82281C, 5, 3000 )
			if( X3 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X3, Y3 )
				wait( 500 )
			}
		}
		else
		{
			X:=0
			SearchForColor( 444,461,482,554, X, Y, 0xA15B26, 5, 5000 )
			if( X != 0 )
			{
				Click( X, Y )
				wait( 500 )
			}

			AutoFight()
			
			ScrollToTheBottomOfQuest()
			
			; Cancel the quest now
			SearchForColor( 219,186,398,230, X3, Y3, 0x82281C, 5, 3000 )
			if( X3 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X3, Y3 )
				wait( 500 )
			}
			
			
		}
		
		

		
		
	}
}

;;-----------------------------------------------------------------------------------------------------------------------
;; Tabs
;;-----------------------------------------------------------------------------------------------------------------------

Tabs()
{
	Send %A_Tab%
	Send %A_Tab%
	Send %A_Tab%
}

;;-----------------------------------------------------------------------------------------------------------------------
;; GetProperQuestState
;;-----------------------------------------------------------------------------------------------------------------------

GetProperQuestState()
{
	Loop
	{
		; Click the top panel of quest
		Click( 25,148 )
		
		; First of all, put the quest in the right order
		; Close the quest panel
		ValidateLoopFunc( 626,167,0xCAA555, 2000, "ResetToQuestPanel", "Tabs" )
		Wait( 500 )
		
		start := A_TickCount
		Loop{
		
			if ( (  A_TickCount - start ) > 5000 )
			{
				ResetToQuestPanel()
			}
			if ( Clipboard == "" )
			{
				wait( 25 )
			}
			else
			{
				break
			}
		}
		questsArray := []
		quests := []
		questsText := Clipboard
		Clipboard := ""
		Loop, Parse, questsText, % "|"
		{
			quest := A_LoopField
			questsArray.Push( IsAGoodQuest( quest ) )
			quests.Push( quest )
		}
		;msgbox, % questsArray[1] questsArray[2] questsArray[3]
		if ( ( questsArray[1] == 1 ) or ( questsArray[2] == 1 ) or ( questsArray[3] == 1 ) )
		{
			X1:=0
			ValidateLoopFunc( 626,167,0xCAA555, 2000, "ResetToQuestPanel", "Tabs" )
			Wait( 500 )
			
			; Collect rewards
			SearchForColor( 514,279,639,415, X1, Y1, 0x537F1D, 5, 100 )		
			
			if( X1 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X1, Y1 )
			}
			
			continue
		}
		

		if ( DoesQuestNeedToBeCancel( questsArray, questsArray[1] ) )
		{
			X2:=0
			SearchForColor( 225,317,267,571, X2, Y2, 0x82281C, 5, 100 )
			if( X2 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X2, Y2 )
			}
			
			continue
		}
		; if second quest is visible, cancel it
		if ( ( DoesQuestNeedToBeCancel( questsArray, questsArray[2] ) ) and ( IsQuestALongOne( quests[1] ) == 0 ) and ( IsQuestALongOne( quests[2] ) == 0 ) )
		{
			X3:=0
			SearchForColor( 222,570,267,693, X3, Y3, 0x82281C, 5, 100 )
			if( X3 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X3, Y3 )
			}
			
			continue
		}
		; second quest isn't visible so we need to scroll down
		else if ( DoesQuestNeedToBeCancel( questsArray, questsArray[2] ) )
		{
			; Scroll down a little
			Click( 655,391 )
			Wait( 500 ) 
			SearchForColor( 224,480,267,693, X3, Y3, 0x82281C, 5, 100 )
			if( X3 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X3, Y3 )
			}
			
			continue
		}
		
		if( DoesQuestNeedToBeCancel( questsArray, questsArray[3] ) )
		{
			ScrollToTheBottomOfQuest()
			SearchForColor( 222,550,267,693, X4, Y4, 0x82281C, 5, 100 )
			if( X4 != 0 )
			{
				ValidateLoopClipFunc( 2000, "ResetToQuestPanel", "Click", X4, Y4 )
			}
			
			continue
		
		}
		
		ValidateLoopFunc( 626,167,0xCAA555, 2000, "ResetToQuestPanel", "Tabs" )
		Wait( 500 )
		
		return questsArray
		
	}
	
}

;;-----------------------------------------------------------------------------------------------------------------------
;; ScrollToTheBottomOfQuest
;;-----------------------------------------------------------------------------------------------------------------------


ScrollToTheBottomOfQuest()
{
	; Scroll down to the bottom
	ValidateLoopFunc( 655,656,0x848FA5, 2000, "ResetToQuestPanel", "Click", 657,668 )
	Wait( 500 )
}

;;-----------------------------------------------------------------------------------------------------------------------
;; IsAGoodQuest
;;-----------------------------------------------------------------------------------------------------------------------

IsAGoodQuest( quest )
{		
	if ( InStr( quest, "collectReward") > 0 )
	{
		return 1
	}
	
	if ( ( InStr( quest, "933131") > 0 ) or ( InStr( quest, "933132") > 0 ) )
	{
		if ( InStr( quest, "progress" ) > 0 )
		{
			return 0
		}
		return 4
	}
	if ( ( InStr( quest, "933122") > 0 ) or ( InStr( quest, "933125") > 0 ) )
	{
		return 2
	}
	return 0
}

;;-----------------------------------------------------------------------------------------------------------------------
;; IsQuestALongOne
;;-----------------------------------------------------------------------------------------------------------------------

IsQuestALongOne( quest )
{
	if ( ( InStr( quest, "933127") > 0 ) or ( InStr( quest, "933131") > 0 ) or ( InStr( quest, "933132") > 0 ) or ( InStr( quest, "933124") > 0 ) )
	{
		return 1
	}
	return 0
}

;;-----------------------------------------------------------------------------------------------------------------------
;; DoesQuestNeedToBeCancel
;;-----------------------------------------------------------------------------------------------------------------------

DoesQuestNeedToBeCancel( questsArray, quest )
{
	; Only when two battle quests are present + 1 good quest
	if ( ( ( questsArray[1] + questsArray[2] + questsArray[3] ) > 8 ) and ( quest == 4 ) )
	{
		return 0
	}
	else if ( quest == 0 )
	{
		return 1
	}
	return 0

}

;;-----------------------------------------------------------------------------------------------------------------------
;; AutoFightGvG
;;-----------------------------------------------------------------------------------------------------------------------

AutoFightGvG( key )
{
	X:= 0
	Y:= 0
	MouseGetPos X, Y
	LASTGVG_X := X
	LASTGVG_Y := Y
	FightGvG( X, Y )
}

;;-----------------------------------------------------------------------------------------------------------------------
;; KeepFightingGvG
;;-----------------------------------------------------------------------------------------------------------------------

KeepFightingGvG( key )
{
	X:= LASTGVG_X
	Y:= LASTGVG_Y
	FightGvG( X, Y )
}

;;-----------------------------------------------------------------------------------------------------------------------
;; FightGvG
;;-----------------------------------------------------------------------------------------------------------------------

FightGvG(  X, Y )
{
 	Loop
	{
		Click( X, Y )
		if ( LookForColorAround( X+180,Y+14,0x573319, 50 ) )
		{
			Click( X+87, Y-14 )
			AutoFight()
			Send, {Escape}
			Send, {Escape}
			SaveConfigs()
		}
		if ( LookForColorAround( 633,600,0x3D50AC, 50 ) )
		{
			AutoFight()
			Send, {Escape}
			Send, {Escape}
			SaveConfigs()
		}
		
		; Pour une erreur c'est produite
		if ( LookForColorAround( 804,492,0x5A2013, 50 ) )
		{
			Click( 971,672 )
		}
		
	}
}


;;-----------------------------------------------------------------------------------------------------------------------
;; AutoDefendGvG
;;-----------------------------------------------------------------------------------------------------------------------

AutoDefendGvG()
{
	Loop{
		Loop
		{
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Attacked.png", "o10 x0 y+50 Center", X, Y )
			;Click( X, Y - 25 )
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\secteur1.png", "o10 x0 y0 Center" )
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\secteur2.png", "o10 x0 y0 Center" )
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\secteur3.png", "o10 x0 y0 Center" )

			if ( LookForColorAround( 633,600,0x3D50AC, 50 ) )
			{
				break
			}
			
			if ( Mod( A_Index, 5 ) == 0 )
			{
				Send, {Escape}
				Send, {Escape}
				Send, {Escape}
			}
		}

		
		AutoFight()
		Send, {Escape}
		;Wait( 50 )
		Send, {Escape}
		;Wait( 50 )
	}
}



;;-----------------------------------------------------------------------------------------------------------------------
;; AutoDefendGvG
;;-----------------------------------------------------------------------------------------------------------------------

AutoOpenAndFightGvG()
{
	Loop{
		Loop
		{
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\secteur1.png", "o10 x0 y0 Center" )
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\secteur2.png", "o10 x0 y0 Center" )
			FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\secteur3.png", "o10 x0 y0 Center" )

			if ( LookForColorAround( 633,600,0x3D50AC, 50 ) )
			{
				break
			}
		}

		
		AutoFight()
		Send, {Escape}
		;Wait( 50 )
		Send, {Escape}
		;Wait( 50 )
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
		ValidateLoop( 774,974,0x5B3A1E, 2000, "Click", 741,925 )
		Wait( 100 )
		
		;; Click remove friend
		ValidateLoop( 871,611,0xE3D3A9, 2000, "Click", 886,968 )
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
	Direction := "Down"
	StartTime := A_TickCount
	Loop{
		;; Search for the button
		if ( SearchForColor( 1227,620, 1256,698, X, Y, 0x975321, 10, 500 ) )
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
			if ( LookForColorAround( 950,581,0x5A3A1E, 500 ) )
			{
				if ( A_TickCount > (StartTime + 2000) )
				{
					; If you reached the top, go back down
					if ( LookForColorAround( 1361,637,0x848FA5, 1000 ) )
					{
						Direction := "Down"
					}
					
					; If you reached the bottom, go back up
					if ( LookForColorAround( 1361,794,0x848FA5, 1000 ) )
					{
						Direction := "Up"
					}
					
					if ( Direction == "Up" )
					{
						Click( 1361,624 )
						Click( 1361,624 )
						Click( 1361,624 )
						Click( 1361,624 )
						StartTime := A_TickCount
					}
					else
					{
						Click( 1363,808 )
						Click( 1363,808 )
						Click( 1363,808 )
						Click( 1363,808 )
						StartTime := A_TickCount
					
					}
					
					
				}
			}
		}
		
		if ( LookForColorAround( 777,672,0xBC9C6B, 500 ) )
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

5MinProductionLoop2()
{
	Loop
	{
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Coconut.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Coconut.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Coconut.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Mog.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Mog.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Mog.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Sleep.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Sleep.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Sleep.png", "o5 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Box.png", "o5 x0 y+80" )
		Send, 1
		Sleep, 500
		if ( Mod( A_Index, 2 )== 0 )
		{
			Send, {esc}
		}
		
	}

}

5MinProductionLoop()
{
	Loop
	{
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\coins.png", "o10 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\coins2.png", "o10 x0 y+80" )
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Sleep.png", "o10 x0 y+80" )
		
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\supplies.png", "o10 x-20 y+80" )
		Send, 1
		Sleep, 550
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\supplies2.png", "o10 x-20 y+80" )
		Send, 1
		Sleep, 550
		
		FindClick( "C:\Users\Danik\Documents\GitHub\foe_helper\Box.png", "o5 x0 y+40" )
		Send, 1
		Sleep, 50
		if ( Mod( A_Index, 10 )== 0 )
		{
			Send, {esc}
		}
		
		if ( Mod( A_Index, 1500 )== 0 )
		{
			;ReloadAndFinishLoad()
		}
		
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
;; FriendsLoop()
;;-----------------------------------------------------------------------------------------------------------------------

FriendsLoop()
{
	ReloadAndFinishLoad()
	
	friends := GetNumberOfFriendsToAdd()
	if ( friends == 0 )
	{	
		return
	}
	
	Loop, 10
	{
		Loop, 20
		{
			; Go to friend list
			ValidateLoop( 850,902,0x394359, 500, "Click",867,899 )
			
			; Go to the start of the friend list
			Click( 248,1011 )
			Wait( 25 )
			Click( 248,1011 )
			Wait( 500 )
			
			HelpAll()
			
			Loop, 10
			{
				Click( 487,79 )
				if ( WaitForColor( 522,87,0x55381E,10,50 ) )
				{
					break
				}
			}
			
			if ( WaitForColor( 275,1026,0x301A09,10,50 ) )
			{
				break
			}
			
		}
		
		ReloadAndFinishLoad()
		friendsLeft := GetNumberOfFriendsToAdd()
	
		if ( friendsLeft == 0 )
		{		
			break
		}
	
	}

	; Go to friend list
	ValidateLoop( 850,902,0x394359, 500, "Click",867,899 )
	
	; Go to the end of the friend list
	Click( 915,1011 )
	Wait( 25 )
	Click( 915,1011 )
	Wait( 25 )
	
	FRIENDS_TO_REMOVE := friends
	
	PutFPS()
	
	Wait( 500 )
	
	; Go to the end of the friend list
	Click( 915,1011 )
	Wait( 500 )
	Click( 915,1011 )
	Wait( 500 )
	Click( 915,1011 )
	Wait( 500 )
	Click( 915,1011 )
	Wait( 500 )
	
	RemoveFriendsSmallScreen()
	
	ResetFriendsCount()
}


GetNumberOfFriendsToAdd()
{
	clipText := Clipboard
	Loop, Parse, clipText, % "|"
	{
		text := A_LoopField
		if ( ( InStr( text, "Friends:") > 0 ) )
		{
			NewStr := SubStr(text, 9)
			NewStr := NewStr + 0
			return NewStr
		}

	}
	return -1
}

ResetFriendsCount()
{
    oWhr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oWhr.Open("PUT", IP . "ResetFriends", false)
    oWhr.Send()
}

AreFriendsReady()
{
	oWhr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oWhr.Open("GET", IP . "AreFriendsReady", false)
    oWhr.Send()
    return oWhr.ResponseText
}


CheckForFriends()
{
	Loop
	{
		ToolTip , "Waiting for friends to be ready...", 10, 10
		if ( AreFriendsReady() == "true" )
		{
			ToolTip , "Working on friends in 2 min", 10, 10
			Wait( 120000 )
			ToolTip , "Working on friends", 10, 10
			FriendsLoop()
		}
		Wait( 10000 )
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
	if ( ValidateLoop( 642,373,0x5F2216, 500, "Click", x,y ) == -1 )
	{
		return
	}
	Wait( 500 )
	
	; Click the first gm
	if ( ValidateLoop( 604,275,0x652518, 500, "Click", 1191,472 ) == -1 )
	{
		return
	}
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



PutReinforcementsWhileKeyDown( key )
{
	while GetKeyState(key)
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
	if ( LookForColorAround( X,Y,0x945025, 20 ) )
	{
		Click( X,Y )
		Click( X,Y )
		return 1
	}
	return 0
}


FixOracleSaves()
{
    oWhr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oWhr.Open("PUT", IP . "FixOracleSaves", false)
    oWhr.Send()
}

;;-----------------------------------------------------------------------------------------------------------------------
;; CustomFunction
;;-----------------------------------------------------------------------------------------------------------------------

CustomFunction()
{
	FindClick()
	;FixOracleSaves()
	
	;CheckForFriends()

}



SelectNextPrize()
{
	
	if ( Clipboard == "1" )
	{
		Clipboard := ""
		Wait( 500 )
		ValidateLoop( 747,419,0x4E100B, 1000, "Click", 778,678 )
		ClosePrize()
	}
	if ( Clipboard == "2" )
	{
		Clipboard := ""
		Wait( 500 )
		ValidateLoop( 747,419,0x4E100B, 1000, "Click", 953,691 )
		ClosePrize()
	}
	if ( Clipboard == "3" )
	{
		Clipboard := ""
		Wait( 500 )
		ValidateLoop( 747,419,0x4E100B, 1000, "Click", 1145,674 )
		ClosePrize()
	}
	else
	{
		Click( 240,133 )
		Wait( 500 )
	}
}

ClosePrize()
{	
	ValidateLoop(908,548,0xA8C04D, 1000, "Click", 889,664 )
}








