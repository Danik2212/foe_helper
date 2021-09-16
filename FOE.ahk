SetWorkingDir %A_ScriptDir%
#NoEnv
#MaxThreadsPerHotkey 1
#SingleInstance, force

;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------

;;  INCLUDES

;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------

#include %A_LineFile%\..\FOE_Globals.ahk
#Include %A_LineFile%\..\FOE_HELPER.ahk

;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------

;; Main Functions

;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------

Init(){
	ElevateAdministrator()
	LoadConfigs()
	InitGui()
	
}

; -------


ElevateAdministrator() {
	if(A_IsAdmin)
	{
		return
	}
	ret := "", hToken := "", ReturnLength := ""
	DllCall("SetLastError", "UInt", 0)
	ret := DllCall("Advapi32.dll\OpenProcessToken", "UInt", DllCall("GetCurrentProcess"), "UInt", 0x0008, "UIntP", hToken)
	DllCall("SetLastError", "UInt", 0)
	DllCall("Advapi32.dll\GetTokenInformation", "UInt", hToken, "UInt", 18, "Int", 0, "Int", 0, "UIntP", ReturnLength)
	sizeof_elevationType := VarSetCapacity(elevationType, ReturnLength, 0)
	DllCall("SetLastError", "UInt", 0)
	DllCall("Advapi32.dll\GetTokenInformation", "UInt", hToken, "UInt", 18, "UIntP", elevationType, "Int", sizeof_elevationType, "UIntP", ReturnLength)
	if (elevationType == 3) {
		full_command_line := DllCall("GetCommandLine", "str")
		if not (RegExMatch(full_command_line, " /restart(?!\S)")) {
			if(A_IsCompiled) {
				Run *RunAs "%A_ScriptFullPath%" /restart,, UseErrorLevel
			} else {
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%",, UseErrorLevel
			}
			ExitApp
		}
	} 
	if (hToken)
		DllCall("CloseHandle", "UInt", hToken)
	return
}

; -------

InitGui(){

	bigScreen := WhichScreenIsIt()
	

	Gui, Main:New
	
	Gui, Add, Text, x10 y12 w80 h20 , Current mode:
	Gui, Add, DropDownList, x90 y10 w90 h100 gSaveEvent_CURRENT_MODE vCURRENT_MODE Choose%CURRENT_MODE% AltSubmit, Helper|GvG
	
	Gui, Add, Text, x190 y12 w80 h20 , Current screen: 
	Gui, Add, Text, x270 y12 w80 h20 , %bigScreen%
	
	Gui, Add, Text, x372 y9 w210 h20 , Alt + Q to restart
	Gui, Add, Tab, x5 y40 w460 h235 , Helper Config||Helper Hotkeys|GVG Hotkeys
	
	;Helper Config tab
	
	Gui, Tab, 1
	
		; Left side
		Gui, Add, Text,         x20  y70  w110 h20 , General section
		
								
		Gui, Add, Text,         x20  y95 w110 h20 , Construction slot:
		Gui, Add, Edit,         x130 y95 w90  h20   gSaveEvent_EDIT_CONSTRUCTION_SLOTS ,
		Gui, Add, UpDown,       x200 y95 w20  h20   gSaveEvent_UD_CONSTRUCTION_SLOTS vCONSTRUCTION_SLOTS Range1-4, % CONSTRUCTION_SLOTS
		
								

		
		Gui, Add, CheckBox,     x20  y220 w200 h20   gSaveEvent_RED_DOT vRED_DOT Checked%RED_DOT%, Red dot
		
		Gui, Add, CheckBox,     x20  y245 w200 h20   gSaveEvent_NO_RANKS vNO_RANKS Checked%NO_RANKS%, No ranks
		
		; Right side
		
		Gui, Add, Text,         x245 y70 w120 h20 , GBG section
		
		Gui, Add, Text,         x245 y95  w110 h20, Number of rogues:
		Gui, Add, Edit,         x355 y95  w90  h20  gSaveEvent_EDIT_ROGUES_NUMBER, 
		Gui, Add, UpDown,       x415 y95  w20  h20  gSaveEvent_UD_ROGUES_NUMBER vROGUES_NUMBER, % ROGUES_NUMBER
								
		Gui, Add, Text,         x245 y120  w110 h20 , Number of units:
		Gui, Add, Edit,         x355 y120  w90  h20 gSaveEvent_EDIT_UNITS_NUMBER, 
		Gui, Add, UpDown,       x415 y120  w20  h20 gSaveEvent_UD_UNITS_NUMBER vUNITS_NUMBER, % UNITS_NUMBER
		
		Gui, Add, Text,         x245 y145 w120 h20  , Type of unit:
		Gui, Add, DropDownList, x355 y145 w90  h200 gSaveEvent_DD_UNIT_TYPE vUNIT_TYPE Choose%UNIT_TYPE%  AltSubmit, Fast|Heavy|Light|Artillery|Distance
							
		Gui, Add, Text,         x245 y170  w110 h40, Autofight time to wait(ms):
		Gui, Add, Edit,         x355 y170  w90  h20  gSaveEvent_EDIT_WAIT_TIME, 
		Gui, Add, UpDown,       x415 y170  w20  h20  gSaveEvent_UD_WAIT_TIME vWAIT_TIME Range0-10000, % WAIT_TIME
		
		Gui, Add, Text,         x245 y225 w120 h20 , GvG section
									
		Gui, Add, Text,         x245 y250 w120 h20 , Siege age:
		Gui, Add, DropDownList, x355 y250 w90  h200 gSaveEvent_DD_SIEGE_AGE vSIEGE_AGE Choose%SIEGE_AGE%  AltSubmit, TLA|Others
	
	
	Gui, Tab, 2
		functions := GetHelperFunctionsList()
		Gui, Add, Hotkey,			x20  y70 w200 h20  gSaveEvent_HELPER_HOTKEY_1 vHELPER_HOTKEY_1, %HELPER_HOTKEY_1%
		Gui, Add, DropDownList,     x245 y70 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_1 vHELPER_HOTKEY_FUNCTION_1 Choose%HELPER_HOTKEY_FUNCTION_1% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y95 w200 h20  gSaveEvent_HELPER_HOTKEY_2 vHELPER_HOTKEY_2, %HELPER_HOTKEY_2%
		Gui, Add, DropDownList,     x245 y95 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_2 vHELPER_HOTKEY_FUNCTION_2 Choose%HELPER_HOTKEY_FUNCTION_2% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y120 w200 h20  gSaveEvent_HELPER_HOTKEY_3 vHELPER_HOTKEY_3, %HELPER_HOTKEY_3%
		Gui, Add, DropDownList,     x245 y120 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_3 vHELPER_HOTKEY_FUNCTION_3 Choose%HELPER_HOTKEY_FUNCTION_3% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y145 w200 h20  gSaveEvent_HELPER_HOTKEY_4 vHELPER_HOTKEY_4, %HELPER_HOTKEY_4%
		Gui, Add, DropDownList,     x245 y145 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_4 vHELPER_HOTKEY_FUNCTION_4 Choose%HELPER_HOTKEY_FUNCTION_4% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y170 w200 h20  gSaveEvent_HELPER_HOTKEY_5 vHELPER_HOTKEY_5, %HELPER_HOTKEY_5%
		Gui, Add, DropDownList,     x245 y170 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_5 vHELPER_HOTKEY_FUNCTION_5 Choose%HELPER_HOTKEY_FUNCTION_5% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y195 w200 h20  gSaveEvent_HELPER_HOTKEY_6 vHELPER_HOTKEY_6, %HELPER_HOTKEY_6%
		Gui, Add, DropDownList,     x245 y195 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_6 vHELPER_HOTKEY_FUNCTION_6 Choose%HELPER_HOTKEY_FUNCTION_6% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y220 w200 h20  gSaveEvent_HELPER_HOTKEY_7 vHELPER_HOTKEY_7, %HELPER_HOTKEY_7%
		Gui, Add, DropDownList,     x245 y220 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_7 vHELPER_HOTKEY_FUNCTION_7 Choose%HELPER_HOTKEY_FUNCTION_7% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y245 w200 h20  gSaveEvent_HELPER_HOTKEY_8 vHELPER_HOTKEY_8, %HELPER_HOTKEY_8%
		Gui, Add, DropDownList,     x245 y245 w200 h200 gSaveEvent_HELPER_HOTKEY_FUNCTION_8 vHELPER_HOTKEY_FUNCTION_8 Choose%HELPER_HOTKEY_FUNCTION_8% AltSubmit, %functions%
		
	Gui, Tab, 3
		functions := GetGVGFunctionsList()
		Gui, Add, Hotkey,			x20  y70 w200 h20  gSaveEvent_GVG_HOTKEY_1 vGVG_HOTKEY_1, %GVG_HOTKEY_1%
		Gui, Add, DropDownList,     x245 y70 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_1 vGVG_HOTKEY_FUNCTION_1 Choose%GVG_HOTKEY_FUNCTION_1% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y95 w200 h20  gSaveEvent_GVG_HOTKEY_2 vGVG_HOTKEY_2, %GVG_HOTKEY_2%
		Gui, Add, DropDownList,     x245 y95 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_2 vGVG_HOTKEY_FUNCTION_2 Choose%GVG_HOTKEY_FUNCTION_2% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y120 w200 h20  gSaveEvent_GVG_HOTKEY_3 vGVG_HOTKEY_3, %GVG_HOTKEY_3%
		Gui, Add, DropDownList,     x245 y120 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_3 vGVG_HOTKEY_FUNCTION_3 Choose%GVG_HOTKEY_FUNCTION_3% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y145 w200 h20  gSaveEvent_GVG_HOTKEY_4 vGVG_HOTKEY_4, %GVG_HOTKEY_4%
		Gui, Add, DropDownList,     x245 y145 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_4 vGVG_HOTKEY_FUNCTION_4 Choose%GVG_HOTKEY_FUNCTION_4% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y170 w200 h20  gSaveEvent_GVG_HOTKEY_5 vGVG_HOTKEY_5, %GVG_HOTKEY_5%
		Gui, Add, DropDownList,     x245 y170 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_5 vGVG_HOTKEY_FUNCTION_5 Choose%GVG_HOTKEY_FUNCTION_5% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y195 w200 h20  gSaveEvent_GVG_HOTKEY_6 vGVG_HOTKEY_6, %GVG_HOTKEY_6%
		Gui, Add, DropDownList,     x245 y195 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_6 vGVG_HOTKEY_FUNCTION_6 Choose%GVG_HOTKEY_FUNCTION_6% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y220 w200 h20  gSaveEvent_GVG_HOTKEY_7 vGVG_HOTKEY_7, %GVG_HOTKEY_7%
		Gui, Add, DropDownList,     x245 y220 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_7 vGVG_HOTKEY_FUNCTION_7 Choose%GVG_HOTKEY_FUNCTION_7% AltSubmit, %functions%
		
		Gui, Add, Hotkey,			x20  y245 w200 h20  gSaveEvent_GVG_HOTKEY_8 vGVG_HOTKEY_8, %GVG_HOTKEY_8%
		Gui, Add, DropDownList,     x245 y245 w200 h200 gSaveEvent_GVG_HOTKEY_FUNCTION_8 vGVG_HOTKEY_FUNCTION_8 Choose%GVG_HOTKEY_FUNCTION_8% AltSubmit, %functions%
	
	Gui, RedDot:New, +toolwindow -resize -caption +alwaysontop
	Gui, color , ff0000  ; set color value RGB
	Gui, RedDot:show,w4 h4 x561 y794
	
	if ( RED_DOT == 0 )
	{
		Gui, RedDot:hide
	}
	
	SysGet, mon, MonitorWorkArea
	width := monRight - monLeft
	
	if( width > 1980 )
	{
		Gui, Main:Show, x3500 y400 h280 w470, FOE
	}
	else
	{
		Gui, Main:Show, x100 y100 h280 w470, FOE
	}
	
}

GuiClose(GuiHwnd) {  ; Declaring this parameter is optional.
    MsgBox 4,, Are you sure you want to hide the GUI?
    IfMsgBox No
        return true  ; true = 1
}

; -------

SaveConfigs()
{
	Gui, Submit , NoHide
	fileLocation := A_ScriptDir . "\config.ini"
	
	;; GENERAL
	
	IniWrite, %CURRENT_MODE%, %fileLocation%, GeneralSection, CURRENT_MODE
	IniWrite, %CURRENT_SCREEN%, %fileLocation%, GeneralSection, CURRENT_SCREEN
	
	
	;; HELPER CONFIG
	
	; General Section 
	IniWrite, %RQ_PFS%, %fileLocation%, HelperGeneralSection, RQ_FPS
	IniWrite, %RQ_SLOTS%, %fileLocation%, HelperGeneralSection, RQ_SLOTS
	IniWrite, %CONSTRUCTION_SLOTS%, %fileLocation%, HelperGeneralSection, CONSTRUCTION_SLOTS
	IniWrite, %FRIENDS_TO_REMOVE%, %fileLocation%, HelperGeneralSection, FRIENDS_TO_REMOVE
	IniWrite, %SMART_FIGHTING%, %fileLocation%, HelperGeneralSection, SMART_FIGHTING
	IniWrite, %FIGHT_AGE%, %fileLocation%, HelperGeneralSection, FIGHT_AGE
	
	; GBG Section
	IniWrite, %ROGUES_NUMBER%, %fileLocation%, HelperGBGSection, ROGUES_NUMBER
	IniWrite, %UNITS_NUMBER%, %fileLocation%, HelperGBGSection, UNITS_NUMBER
	IniWrite, %UNIT_TYPE%, %fileLocation%, HelperGBGSection, UNIT_TYPE
	IniWrite, %NO_RANKS%, %fileLocation%, HelperGBGSection, NO_RANKS
	IniWrite, %WAIT_TIME%, %fileLocation%, HelperGBGSection, WAIT_TIME
	
	; GVG Section
	IniWrite, %SIEGE_AGE%, %fileLocation%, HelperGVGSection, SIEGE_AGE
	IniWrite, %RED_DOT%, %fileLocation%, HelperGVGSection, RED_DOT
	IniWrite, %LASTGVG_X%, %fileLocation%, HelperGVGSection, LASTGVG_X
	IniWrite, %LASTGVG_Y%, %fileLocation%, HelperGVGSection, LASTGVG_Y
	
	
	
	; Hotkeys Section
	IniWrite, %HELPER_HOTKEY_1%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_1
	IniWrite, %HELPER_HOTKEY_FUNCTION_1%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_1
	
	; Hotkeys Section
	IniWrite, %HELPER_HOTKEY_1%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_1
	IniWrite, %HELPER_HOTKEY_FUNCTION_1%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_1
	
	IniWrite, %HELPER_HOTKEY_2%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_2
	IniWrite, %HELPER_HOTKEY_FUNCTION_2%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_2
	
	IniWrite, %HELPER_HOTKEY_3%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_3
	IniWrite, %HELPER_HOTKEY_FUNCTION_3%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_3
	
	IniWrite, %HELPER_HOTKEY_4%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_4
	IniWrite, %HELPER_HOTKEY_FUNCTION_4%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_4
	
	IniWrite, %HELPER_HOTKEY_5%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_5
	IniWrite, %HELPER_HOTKEY_FUNCTION_5%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_5
	
	IniWrite, %HELPER_HOTKEY_6%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_6
	IniWrite, %HELPER_HOTKEY_FUNCTION_6%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_6
	
	IniWrite, %HELPER_HOTKEY_7%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_7
	IniWrite, %HELPER_HOTKEY_FUNCTION_7%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_7
	
	IniWrite, %HELPER_HOTKEY_8%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_8
	IniWrite, %HELPER_HOTKEY_FUNCTION_8%, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_8
	
	
	IniWrite, %GVG_HOTKEY_1%, %fileLocation%, HotkeysSection, GVG_HOTKEY_1
	IniWrite, %GVG_HOTKEY_FUNCTION_1%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_1
	
	IniWrite, %GVG_HOTKEY_2%, %fileLocation%, HotkeysSection, GVG_HOTKEY_2
	IniWrite, %GVG_HOTKEY_FUNCTION_2%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_2
	
	IniWrite, %GVG_HOTKEY_3%, %fileLocation%, HotkeysSection, GVG_HOTKEY_3
	IniWrite, %GVG_HOTKEY_FUNCTION_3%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_3
	
	IniWrite, %GVG_HOTKEY_4%, %fileLocation%, HotkeysSection, GVG_HOTKEY_4
	IniWrite, %GVG_HOTKEY_FUNCTION_4%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_4
	
	IniWrite, %GVG_HOTKEY_5%, %fileLocation%, HotkeysSection, GVG_HOTKEY_5
	IniWrite, %GVG_HOTKEY_FUNCTION_5%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_5
	
	IniWrite, %GVG_HOTKEY_6%, %fileLocation%, HotkeysSection, GVG_HOTKEY_6
	IniWrite, %GVG_HOTKEY_FUNCTION_6%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_6
	
	IniWrite, %GVG_HOTKEY_7%, %fileLocation%, HotkeysSection, GVG_HOTKEY_7
	IniWrite, %GVG_HOTKEY_FUNCTION_7%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_7
	
	IniWrite, %GVG_HOTKEY_8%, %fileLocation%, HotkeysSection, GVG_HOTKEY_8
	IniWrite, %GVG_HOTKEY_FUNCTION_8%, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_8
	
}

LoadConfigs()
{
	fileLocation := A_ScriptDir . "\config.ini"

	;; GENERAL
	
	IniRead, CURRENT_MODE, %fileLocation%, GeneralSection, CURRENT_MODE
	IniRead, CURRENT_SCREEN, %fileLocation%, GeneralSection, CURRENT_SCREEN
	
	;; HELPER CONFIG
	
	; General Section 
	IniRead, RQ_PFS, %fileLocation%, HelperGeneralSection, RQ_FPS
	IniRead, RQ_SLOTS, %fileLocation%, HelperGeneralSection, RQ_SLOTS
	IniRead, CONSTRUCTION_SLOTS, %fileLocation%, HelperGeneralSection, CONSTRUCTION_SLOTS
	IniRead, FRIENDS_TO_REMOVE, %fileLocation%, HelperGeneralSection, FRIENDS_TO_REMOVE
	IniRead, SMART_FIGHTING, %fileLocation%, HelperGeneralSection, SMART_FIGHTING
	IniRead, FIGHT_AGE, %fileLocation%, HelperGeneralSection, FIGHT_AGE
	
	; GBG Section
	IniRead, ROGUES_NUMBER, %fileLocation%, HelperGBGSection, ROGUES_NUMBER
	IniRead, UNITS_NUMBER, %fileLocation%, HelperGBGSection, UNITS_NUMBER
	IniRead, UNIT_TYPE, %fileLocation%, HelperGBGSection, UNIT_TYPE
	IniRead, NO_RANKS, %fileLocation%, HelperGBGSection, NO_RANKS
	IniRead, WAIT_TIME, %fileLocation%, HelperGBGSection, WAIT_TIME
	
	; GVG Section
	IniRead, SIEGE_AGE, %fileLocation%, HelperGVGSection, SIEGE_AGE
	IniRead, RED_DOT, %fileLocation%, HelperGVGSection, RED_DOT
	IniRead, LASTGVG_X, %fileLocation%, HelperGVGSection, LASTGVG_X
	IniRead, LASTGVG_Y, %fileLocation%, HelperGVGSection, LASTGVG_Y
	
	
	; Hotkeys Section
	IniRead, HELPER_HOTKEY_1, %fileLocation%, HotkeysSection, HELPER_HOTKEY_1
	IniRead, HELPER_HOTKEY_FUNCTION_1, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_1
	
	IniRead, HELPER_HOTKEY_2, %fileLocation%, HotkeysSection, HELPER_HOTKEY_2
	IniRead, HELPER_HOTKEY_FUNCTION_2, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_2
	
	IniRead, HELPER_HOTKEY_3, %fileLocation%, HotkeysSection, HELPER_HOTKEY_3
	IniRead, HELPER_HOTKEY_FUNCTION_3, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_3
	
	IniRead, HELPER_HOTKEY_4, %fileLocation%, HotkeysSection, HELPER_HOTKEY_4
	IniRead, HELPER_HOTKEY_FUNCTION_4, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_4
	
	IniRead, HELPER_HOTKEY_5, %fileLocation%, HotkeysSection, HELPER_HOTKEY_5
	IniRead, HELPER_HOTKEY_FUNCTION_5, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_5
	
	IniRead, HELPER_HOTKEY_6, %fileLocation%, HotkeysSection, HELPER_HOTKEY_6
	IniRead, HELPER_HOTKEY_FUNCTION_6, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_6
	
	IniRead, HELPER_HOTKEY_7, %fileLocation%, HotkeysSection, HELPER_HOTKEY_7
	IniRead, HELPER_HOTKEY_FUNCTION_7, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_7
	
	IniRead, HELPER_HOTKEY_8, %fileLocation%, HotkeysSection, HELPER_HOTKEY_8
	IniRead, HELPER_HOTKEY_FUNCTION_8, %fileLocation%, HotkeysSection, HELPER_HOTKEY_FUNCTION_8
	
	
	IniRead, GVG_HOTKEY_1, %fileLocation%, HotkeysSection, GVG_HOTKEY_1
	IniRead, GVG_HOTKEY_FUNCTION_1, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_1
	
	IniRead, GVG_HOTKEY_2, %fileLocation%, HotkeysSection, GVG_HOTKEY_2
	IniRead, GVG_HOTKEY_FUNCTION_2, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_2
	
	IniRead, GVG_HOTKEY_3, %fileLocation%, HotkeysSection, GVG_HOTKEY_3
	IniRead, GVG_HOTKEY_FUNCTION_3, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_3
	
	IniRead, GVG_HOTKEY_4, %fileLocation%, HotkeysSection, GVG_HOTKEY_4
	IniRead, GVG_HOTKEY_FUNCTION_4, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_4
	
	IniRead, GVG_HOTKEY_5, %fileLocation%, HotkeysSection, GVG_HOTKEY_5
	IniRead, GVG_HOTKEY_FUNCTION_5, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_5
	
	IniRead, GVG_HOTKEY_6, %fileLocation%, HotkeysSection, GVG_HOTKEY_6
	IniRead, GVG_HOTKEY_FUNCTION_6, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_6
	
	IniRead, GVG_HOTKEY_7, %fileLocation%, HotkeysSection, GVG_HOTKEY_7
	IniRead, GVG_HOTKEY_FUNCTION_7, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_7
	
	IniRead, GVG_HOTKEY_8, %fileLocation%, HotkeysSection, GVG_HOTKEY_8
	IniRead, GVG_HOTKEY_FUNCTION_8, %fileLocation%, HotkeysSection, GVG_HOTKEY_FUNCTION_8
	
	AddHotkey( HELPER_HOTKEY_1, HELPER_HOTKEY_FUNCTION_1 )
	AddHotkey( HELPER_HOTKEY_2, HELPER_HOTKEY_FUNCTION_2 )
	AddHotkey( HELPER_HOTKEY_3, HELPER_HOTKEY_FUNCTION_3 )
	AddHotkey( HELPER_HOTKEY_4, HELPER_HOTKEY_FUNCTION_4 )
	AddHotkey( HELPER_HOTKEY_5, HELPER_HOTKEY_FUNCTION_5 )
	AddHotkey( HELPER_HOTKEY_6, HELPER_HOTKEY_FUNCTION_6 )
	AddHotkey( HELPER_HOTKEY_7, HELPER_HOTKEY_FUNCTION_7 )
	AddHotkey( HELPER_HOTKEY_8, HELPER_HOTKEY_FUNCTION_8 )
	
	AddHotkey( GVG_HOTKEY_1, GVG_HOTKEY_FUNCTION_1 )
	AddHotkey( GVG_HOTKEY_2, GVG_HOTKEY_FUNCTION_2 )
	AddHotkey( GVG_HOTKEY_3, GVG_HOTKEY_FUNCTION_3 )
	AddHotkey( GVG_HOTKEY_4, GVG_HOTKEY_FUNCTION_4 )
	AddHotkey( GVG_HOTKEY_5, GVG_HOTKEY_FUNCTION_5 )
	AddHotkey( GVG_HOTKEY_6, GVG_HOTKEY_FUNCTION_6 )
	AddHotkey( GVG_HOTKEY_7, GVG_HOTKEY_FUNCTION_7 )
	AddHotkey( GVG_HOTKEY_8, GVG_HOTKEY_FUNCTION_8 )
	
	
}

AddHotkey( hotkey, functionIndex )
{
	functionsList := GetHelperFunctionsList()
	functions := StrSplit(functionsList, "|")
	function := functions[functionIndex]
	if ( hotkey == "ERROR" || hotkey == "" || function == "ERROR" || function == "" )
	{
		return
	}
	Hotkey, %hotkey%, %function%, On

}


FOE_GVG( hotkey )
{
	switch hotkey
	{
		case "F13": ;1
		RemoveCurrentUnits()

		case "F14": ;2
		FillArmyWithSelectUnits()

		case "F15": ;3
		PlaceSiege()

		case "F16": ;Enter
		AutoOpenAndFightGvG()

		case "F17": ;4
		AutoFightGvG( "F17" )

		case "F18": ;5
		KeepFightingGvG( "F18" )

		case "F19": ;6
		
		

		case "F20": ;Super
		PutReinforcementsWhileKeyDown( "F20" )

		case "F21": ;7
		AutoDefendGvG()
		
		case "F22": ;8
		ReplaceArmy()
		
		case "F23": ;9
		MouseClicksWhileKeyDown()

	}
}

FOE_HELPER( hotkey )
{
	switch hotkey
	{
		
		case "F13": ;1
		RemoveCurrentUnits()

		case "F14": ;2
		FillArmyWithSelectUnits()

		case "F15": ;3
		HelpAll()

		case "F16": ;Enter
		NegoDoer()

		case "F17": ;4
		Buy()

		case "F18": ;5
		ConfirmSell()

		case "F19": ;6
		MouseClicksWhileKeyDown()

		case "F20": ;Super
		AutoFightCDGLoop()

		case "F21": ;7
		AutoFightCDGFastLoop()
		
		case "F22": ;8
		ReplaceArmy()
		
		case "F23": ;9
		CancelQuests()
		
		case "AF13": ;Alt & 1
		CustomFunction()
		
		case "AF14": ;Alt & 2
		Claim50Diamonds()
		
		case "AF15": ;Alt & 3

		
		case "AF16": ;Alt & Enter
		

	}
}


HotkeyHandler( hotkey )
{
	Gui, RedDot:hide
	if ( CURRENT_MODE == 1 )
	{
		FOE_HELPER( hotkey )
	}
	
	if ( CURRENT_MODE == 2 )
	{
		FOE_GVG( hotkey )
	}
	
	if ( RED_DOT == 1 )
	{
		Gui, RedDot:show
	}
	
}


;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------



;; START THE PROGRAM
Init()



;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------

;; EVENTS

;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------
SaveEvent:
SaveEvent_CURRENT_MODE:

SaveEvent_UD_RQ_PFS:
SaveEvent_EDIT_RQ_PFS:
SaveEvent_UD_RQ_SLOTS:
SaveEvent_EDIT_RQ_SLOTS:
SaveEvent_UD_CONSTRUCTION_SLOTS:
SaveEvent_EDIT_CONSTRUCTION_SLOTS:
SaveEvent_UD_FRIENDS_TO_REMOVE:
SaveEvent_EDIT_FRIENDS_TO_REMOVE:
SaveEvent_CB_SMART_FIGHTING:
SaveEvent_RED_DOT:
SaveEvent_NO_RANKS:
SaveEvent_FIGHT_AGE:

SaveEvent_UD_ROGUES_NUMBER:
SaveEvent_EDIT_ROGUES_NUMBER:
SaveEvent_UD_UNITS_NUMBER:
SaveEvent_EDIT_UNITS_NUMBER:
SaveEvent_DD_UNIT_TYPE:

SaveEvent_DD_SIEGE_AGE:

SaveEvent_UD_LINES:
SaveEvent_EDIT_LINES:
SaveEvent_UD_ROWS:
SaveEvent_EDIT_ROWS:
SaveEvent_UD_WINDOWS:
SaveEvent_EDIT_WINDOWS:

SaveEvent_EDIT_WAIT_TIME:
SaveEvent_UD_WAIT_TIME:

SaveEvent_CURRENT_SCREEN:

SaveConfigs()
return

; -------

SaveEvent_HELPER_HOTKEY_1:
SaveEvent_HELPER_HOTKEY_FUNCTION_1:
AddHotkey( HELPER_HOTKEY_1, HELPER_HOTKEY_FUNCTION_1 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_2:
SaveEvent_HELPER_HOTKEY_FUNCTION_2:
AddHotkey( HELPER_HOTKEY_2, HELPER_HOTKEY_FUNCTION_2 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_3:
SaveEvent_HELPER_HOTKEY_FUNCTION_3:
AddHotkey( HELPER_HOTKEY_3, HELPER_HOTKEY_FUNCTION_3 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_4:
SaveEvent_HELPER_HOTKEY_FUNCTION_4:
AddHotkey( HELPER_HOTKEY_4, HELPER_HOTKEY_FUNCTION_4 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_5:
SaveEvent_HELPER_HOTKEY_FUNCTION_5:
AddHotkey( HELPER_HOTKEY_5, HELPER_HOTKEY_FUNCTION_5 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_6:
SaveEvent_HELPER_HOTKEY_FUNCTION_6:
AddHotkey( HELPER_HOTKEY_6, HELPER_HOTKEY_FUNCTION_6 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_7:
SaveEvent_HELPER_HOTKEY_FUNCTION_7:
AddHotkey( HELPER_HOTKEY_7, HELPER_HOTKEY_FUNCTION_7 )
SaveConfigs()
return

SaveEvent_HELPER_HOTKEY_8:
SaveEvent_HELPER_HOTKEY_FUNCTION_8:
AddHotkey( HELPER_HOTKEY_8, HELPER_HOTKEY_FUNCTION_8 )
SaveConfigs()
return

; -------

SaveEvent_GVG_HOTKEY_1:
SaveEvent_GVG_HOTKEY_FUNCTION_1:
AddHotkey( GVG_HOTKEY_1, GVG_HOTKEY_FUNCTION_1 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_2:
SaveEvent_GVG_HOTKEY_FUNCTION_2:
AddHotkey( GVG_HOTKEY_2, GVG_HOTKEY_FUNCTION_2 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_3:
SaveEvent_GVG_HOTKEY_FUNCTION_3:
AddHotkey( GVG_HOTKEY_3, GVG_HOTKEY_FUNCTION_3 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_4:
SaveEvent_GVG_HOTKEY_FUNCTION_4:
AddHotkey( GVG_HOTKEY_4, GVG_HOTKEY_FUNCTION_4 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_5:
SaveEvent_GVG_HOTKEY_FUNCTION_5:
AddHotkey( GVG_HOTKEY_5, GVG_HOTKEY_FUNCTION_5 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_6:
SaveEvent_GVG_HOTKEY_FUNCTION_6:
AddHotkey( GVG_HOTKEY_6, GVG_HOTKEY_FUNCTION_6 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_7:
SaveEvent_GVG_HOTKEY_FUNCTION_7:
AddHotkey( GVG_HOTKEY_7, GVG_HOTKEY_FUNCTION_7 )
SaveConfigs()
return

SaveEvent_GVG_HOTKEY_8:
SaveEvent_GVG_HOTKEY_FUNCTION_8:
AddHotkey( GVG_HOTKEY_8, GVG_HOTKEY_FUNCTION_8 )
SaveConfigs()
return



; -------


ChangeCurrentModeTo1:
GuiControl,Main:Choose,CURRENT_MODE, 1
CURRENT_MODE := 1
goSub, SaveEvent_CURRENT_MODE
return

; -------

ChangeCurrentModeTo2:
GuiControl,Main:Choose,CURRENT_MODE, 2
CURRENT_MODE := 2
goSub, SaveEvent_CURRENT_MODE
return

; -------------------------------------


GuiClose:
Gui, Submit , NoHide
SaveConfigs()
;ExitApp
return


;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------

;; HOTKEYS

;; ---------------------------------------------------------------------------------------------------------------------------------------------------------------



LAlt & Q::
BlockInput Off
Reload
return


Alt & F11::
gosub, ChangeCurrentModeTo1
return

Alt & F12::
gosub, ChangeCurrentModeTo2
return


LAlt & F13::
;Shift & 1::
HotkeyHandler( "AF13")
return

F13::
Ralt & 1::
HotkeyHandler( "F13")
return

LAlt & F14::
;Shift & 2::
HotkeyHandler( "AF14")
return

F14::
Ralt & 2::
Alt & D::
HotkeyHandler( "F14")
return

LAlt & F15::
;Shift & 3::
HotkeyHandler( "AF15")
return

F15::
Ralt & 3::
HotkeyHandler( "F15")
return

LAlt & F16::
;Shift & 9::
HotkeyHandler( "AF16")
return

F16::
Ralt & 9::
HotkeyHandler( "F16")
return

F17::
Ralt & 4::
HotkeyHandler( "F17")
return

F18::
Ralt & 5::
HotkeyHandler( "F18")
return

F19::
Ralt & 6::
HotkeyHandler( "F19")
return

F20::
Ralt & 0::
HotkeyHandler( "F20")
return

F21::
Ralt & 7::
HotkeyHandler( "F21")
return

F22::
Ralt & 8::
HotkeyHandler( "F22")
return

F23::
Ralt & -::
HotkeyHandler( "F23")
return

