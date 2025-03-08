
//----------------------------------------------------------------------
// get highest tile in map
//----------------------------------------------------------------------

function MapSectorGetHighestTile(MapSector Ref As TMapSectorData)
	
	local y as integer
	
	// if map tile top was calculated
	if MapSector.HighestTileTop > 0
		y = MapSector.HighestTileTop - 1
	else 
		y = MapSector.MapSizeY - 1
	endif
	
endfunction y

// ---------------------------------------------------------------------------------
// check if tile in world boundaries
// ---------------------------------------------------------------------------------

Function MapSectorTileInWorld(MapSector Ref As TMapSectorData,x,y,z)

	Local Value As Integer

	Value = FALSE

	If x >= 0 And x < MapSector.MapSizeX
		If y >= 0 And y < MapSector.MapSizeY
			If z >= 0 And z < MapSector.MapSizeZ
				Value = TRUE
			EndIf
		EndIf
	EndIf

EndFunction Value

//----------------------------------------------------------------------
// check if tile is valid
//----------------------------------------------------------------------

function MapSectorTileIsValid(MapSector Ref As TMapSectorData,x,y,z)
	
	Local Value As Integer

	Value = -1
	
	if MapSectorTileInWorld(MapSector,x,y,z) = TRUE
		Value = MapSector.Tile[x,y,z].Enabled
	EndIf

EndFunction Value

// ---------------------------------------------------------------------------------
// check if tile is a toplevel tile
// except that there can be higher tiles with free space
// ---------------------------------------------------------------------------------

Function MapSectorTileIsTopTile(MapSector Ref As TMapSectorData,x,y,z)

	Local Value As Integer

	Value = FALSE
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if MapSectorTileIsValid(MapSector,x,y+1,z) < TRUE
			Value = TRUE
		else
			Value = FALSE
		endif
	endif

EndFunction Value


