
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTextureDelete(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	local i as integer

	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		for y = 0 to MapSector.MapSizeY - 1
			MapSector.Tile[x,y,z].Data.TileType = CNone
			MapSector.Tile[x,y,z].Data.Texture.ImageID = CNone
			for i = 0 to 8
				MapSector.Tile[x,y,z].Data.Cliff[i].CliffType = CNone
				MapSector.Tile[x,y,z].Data.Cliff[i].Texture.ImageID = CNone
			next i		
		next y
		
	next z
	next x

endfunction

//----------------------------------------------------------------------
// set the texture data for each tile
//----------------------------------------------------------------------

function MapSectorTextureSet(MapSector ref as TMapSectorData)
	
	MapSectorGroundTextureSet(MapSector)
	
	MapSectorCliffTextureSetNorth(MapSector)
	MapSectorCliffTextureSetSouth(MapSector)
	MapSectorCliffTextureSetEast(MapSector)
	MapSectorCliffTextureSetWest(MapSector)
	
endfunction



