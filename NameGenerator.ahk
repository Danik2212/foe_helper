#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




PreM := []
PreF := []
PostM := []
PostF := []
PreM.Push("Cassius", "Jovien", "Cyrys", "Titus", "Apollonios", "Asandros", "Severus", "Marcus", "Antiochos", "Vortigem", "Arthur", "Vortimer", "Amalaric", "Antigone", "Damon", "Alexandre", "Arcadius", "Anastase", "Valamir", "Avitus", "Castor", "Adrien", "Darius", "Robert", "Henri", "Remenis")
PreF.Push("Fulvia", "Olympe", "Amitis", "Solon", "Mathilde", "Didon", "Octavie", "Victoire", "Athanase", "Apollonie", "Honoria", "Nyah", "Anne")

PostM.Push("le Cruel", "le Courageux", "le Belliqueux", "le Noble", "le Hardi", "le Loyal", "le Juste", "le Judicieux", "le Pacifiste", "le Sauveur", "le Chasseur", "le Rouge", "le Glorieux", "le Dur Cuire", "le Lion", "le Puissant", "le Guerrier", "le Grand", "le Pillard", "le Malfaisant", "le Vertueux")
PostF.Push("la Loyale", "la Juste", "la Hardie", "la Judicieuse", "la Pacifiste", "la Cruelle", "la Courageuse", "la Belliqueuse", "la Noble", "la Sauveuse", "la Chasseuse", "la Rouge", "la Glorieuse", "la Dure Cuire", "la Lionne", "la Puissante", "la Grande", "la Pillarde", "la Malfaisante", "la Vertueuse")


GetRandomName()
{
	global PreM, PreF, PostM, PostF 
	Random, Sex, 0, 2
	Random, Numb, 100, 9999
	if ( Sex > 0 )
	{
		Random, PreIndex, 0, PreM.Length()
		Random, PostIndex, 0, PostM.Length()
		return PreM[PreIndex] . " " . Numb . " " . PostM[PostIndex]
	}
	else
	{
		Random, PreIndex, 0, PreF.Length()
		Random, PostIndex, 0, PostF.Length()
		return PreF[PreIndex] . " " . Numb . " " . PostF[PostIndex]