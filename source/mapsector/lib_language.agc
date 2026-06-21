
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TText
	
	DE as string
	EN as string
	FR as string
	ES as string
	PT as string
	EO as string
	IT as string
	PL as string
	CZ as String
	RU as string
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TTextStrings
	
	Identifier as string
	Name as TText
	Description as TText
	
endtype

//----------------------------------------------------------------------
// if text is empty switch language back to EN or DE
//----------------------------------------------------------------------

function SwitchTextLanguage(Text as TText,SelectedText as string)
	
	local Value as string
	
	Value = "emptystring"
	
	if SelectedText = ""
		if Text.EN = ""
			if Text.DE = ""
				Value = "placeholder"	
			else
				Value = Text.DE
			endif
		else
			Value = Text.EN
		endif
	else
		Value = SelectedText
	endif
	
endfunction Value

//----------------------------------------------------------------------
// get text language of selected language
//----------------------------------------------------------------------

function GetText(Text as TText,Language as string)
	
	local Value as string
	
	if Language = "DE" then Value = SwitchTextLanguage(Text,Text.DE)
	if Language = "EN" then Value = SwitchTextLanguage(Text,Text.EN)
	if Language = "FR" then Value = SwitchTextLanguage(Text,Text.FR)
	if Language = "ES" then Value = SwitchTextLanguage(Text,Text.ES)
	if Language = "PT" then Value = SwitchTextLanguage(Text,Text.PT)
	if Language = "EO" then Value = SwitchTextLanguage(Text,Text.EO)
	if Language = "IT" then Value = SwitchTextLanguage(Text,Text.IT)
	if Language = "PL" then Value = SwitchTextLanguage(Text,Text.PL)
	if Language = "CZ" then Value = SwitchTextLanguage(Text,Text.CZ)
	if Language = "RU" then Value = SwitchTextLanguage(Text,Text.RU)
	
		
endfunction Value
