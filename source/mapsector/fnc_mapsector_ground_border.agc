
//----------------------------------------------------------------------
// calculate terrain border
//----------------------------------------------------------------------

function MapSectorGroundBorderSet(MapSector ref as TMapSectorData)
		
	local y as integer
	
	for y = 0 to MapSectorGetHighestTile(MapSector)
		MapSectorGroundBorderSetInLevel(MapSector,y)
	next y
	
endfunction

//----------------------------------------------------------------------
// calculate terrain border in level of height
//----------------------------------------------------------------------

function MapSectorGroundBorderSetInLevel(MapSector ref as TMapSectorData,HeightLevel)
	
	local x as integer
	local z as integer
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
	
		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
			if MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundNatural
				if MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex > 0
					
					// north
					if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z+1) = TRUE
						if MapSector.Tile[x,HeightLevel,z+1].Data.GroundType = CGroundNatural
							if MapSector.Tile[x,HeightLevel,z+1].Data.GroundElementIndex = MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex - 1
								MapSector.Tile[x,HeightLevel,z].Data.GroundBorder[CNorth] = TRUE
							endif
						endif
					endif
					
					// east
					if MapSectorTileIsTopTile(MapSector,x+1,HeightLevel,z) = TRUE
						if MapSector.Tile[x+1,HeightLevel,z].Data.GroundType = CGroundNatural
							if MapSector.Tile[x+1,HeightLevel,z].Data.GroundElementIndex = MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex - 1
								MapSector.Tile[x,HeightLevel,z].Data.GroundBorder[CEast] = TRUE
							endif
						endif
					endif
					
					// south
					if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z-1) = TRUE
						if MapSector.Tile[x,HeightLevel,z-1].Data.GroundType = CGroundNatural
							if MapSector.Tile[x,HeightLevel,z-1].Data.GroundElementIndex = MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex - 1
								MapSector.Tile[x,HeightLevel,z].Data.GroundBorder[CSouth] = TRUE
							endif
						endif
					endif
					
					// west
					if MapSectorTileIsTopTile(MapSector,x-1,HeightLevel,z) = TRUE
						if MapSector.Tile[x-1,HeightLevel,z].Data.GroundType = CGroundNatural
							if MapSector.Tile[x-1,HeightLevel,z].Data.GroundElementIndex = MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex - 1
								MapSector.Tile[x,HeightLevel,z].Data.GroundBorder[CWest] = TRUE
							endif
						endif
					endif
				
				endif
			endif
		endif
		
	next z
	next x
	
endfunction

