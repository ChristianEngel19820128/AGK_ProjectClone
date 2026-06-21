
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTextureElementIndexGet(TextureElement ref as TMapSectorTextureElement[],Identifier as string)
	
	local i as integer
	local Found as integer
	local Index as integer
	
	Index = -1	
	i = 0
	Found = FALSE
	while Found = FALSE and i <= TextureElement.Length
		
		if TextureElement[i].Identifier = Identifier
			Index = i
			Found = TRUE
		else
			inc i
		endif
		
	endwhile
	
endfunction Index

