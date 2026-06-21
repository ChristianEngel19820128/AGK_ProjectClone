
//----------------------------------------------------------------------
// trim left
//----------------------------------------------------------------------

function TrimLeft(Value As String,Char as String)

	Local i As Integer

	if Len(Char) = 0 then Char = " "
	
	repeat
		If Len(Value) > 0
			i = FindString(Value,Char)
		Else
			i = 0
		EndIf
		If i = 1
			Value = Right(Value,Len(Value)-1)
		else
			i = 0
		EndIf
	until i = 0

EndFunction Value

//----------------------------------------------------------------------
// trim rigth
//----------------------------------------------------------------------

function TrimRight(Value As String,Char as String)

	if Len(Char) = 0 then Char = " "
	Value = TrimString(Value,Char)

EndFunction Value

//----------------------------------------------------------------------
// trim
//----------------------------------------------------------------------

function Trim(Value As String,Char as String)

	Value = TrimLeft(Value,Char)
	Value = TrimRight(Value,Char)

EndFunction Value
