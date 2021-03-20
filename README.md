 # Foe Helper Tool
 
 I made this tool to help me with Forge of empires using autohotkey and color detection. While I try to keep it updated, I can't garantee it will always work. The script was developped on FOE France. Some functions might not work in other regions. 
 
## How to get started:

1. Install autohotkey version 1.x from their website ( 32 bits or 64 bits doesn't matter ).
2. Launch FOE.ahk by double-clicking it. A program should open.
3. You need to be using chrome or firefox with a resolution of 1920x1080 and with the browser on your main monitor maximized.
4. Make sure you don't have a bookmark bar showing.
5. Be sure to set your hotkeys in the two tabs reserved for it.


## Helper section:

Contains functions to help with everything that is not GvG. Here's a quick summary of the available functions and how to use them :

* Buy : 
  * Conditions: The buy menu needs to be open
  * How to use: Simply put the mouse where you want the building to be build and press the hotkey.
* ConfirmSell : 
  * Conditions: The buy menu needs to be open
  * How to use: Simply put the mouse over the building you want to sell and press the hotkey.
* FillArmyWithSelectedUnits : 
  * Conditions: The panel for the units selection needs to be open
  * How to use: The script will fill all available slots in your army with the current units in the units selection panel.
* RemoveCurrentUnits : 
  * Conditions: The panel for the units selection needs to be open
  * How to use: The script will remove all units from your current army.
* ReplaceArmy : 
  * Conditions: The panel for the units selection needs to be open
  * How to use: The script will start by removing all units from your current army and then replace it with your selected army composition.
* AutoFightCDGLoop : 
  * Conditions: A province needs to be selected in the CDG map
  * How to use: The script will automaticaly fight and replace the army after every fight. Needs to be stopped by pressing Alt + Q
MouseClicksWhileKeyDown :
  * How to use: Pretty straightfoward, the script will keep clicking while the hotkey is down. Broken at the moment.

 ## GvG section:

Contains functions to help with GvG. Here's a quick summary of the available functions and how to use them :

* FillArmyWithSelectedUnits : 
  * Conditions: The panel for the units selection needs to be open
  * How to use: The script will fill all available slots in your army with the current units in the units selection panel.
* RemoveCurrentUnits : 
  * Conditions: The panel for the units selection needs to be open
  * How to use: The script will remove all units from your current army.
* ReplaceArmy : 
  * Conditions: The panel for the units selection needs to be open
  * How to use: The script will start by removing all units from your current army and then replace it with your selected army composition.
* PlaceSiege : 
  * Conditions: The panel where you can click on the orange arrow to place a siege needs to be open. No need to wait for the orange arrow to be available.
  * How to use: The script will click on the orange arrow as soon as it is available and confirm the siege army. The script will wait for a couple seconds and can be stopped by pressing alt + Q.
* AutoFightGvG :
  * Conditions: This one is a little bit more tricky to use. You need to click on a sector and place the mouse cursor on the end of the arrow of the panel ( the one with the the options to see the sector, guild panel or guild rank ) and then you can press the hotkey. Can also be used on sectors with no guilds.
  * How to use: The script will automaticaly click see the province, replace your army, fight and the repeat over until Alt + Q is pressed.
  * ![image](https://user-images.githubusercontent.com/7028006/111886135-5d6c0680-89a2-11eb-8605-899b1c204641.png)

  
