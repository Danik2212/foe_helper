

RGBColor:= "0x7F271C"

RGBColorDec += RGBColor


R := (0x00ff0000 & RGBColorDec) >> 16
G := (0x0000ff00 & RGBColorDec) >> 8
B := 0x000000ff & RGBColorDec




Msgbox, %RGBColorDec% %R% %G% %B%