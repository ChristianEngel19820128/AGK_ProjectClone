
// ---------------------------------------------------------------------------------
//
// ---------------------------------------------------------------------------------

Function MapSectorTileNeighborsCount(MapSector Ref As TMapSectorData,x,y,z,Enable_State)
	
	local Found as integer
	
	Found = 0
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		
		If MapSectorTileIsValid(MapSector,x-1,y,z) = Enable_State then Inc Found
		If MapSectorTileIsValid(MapSector,x+1,y,z) = Enable_State then Inc Found
		If MapSectorTileIsValid(MapSector,x,y,z-1) = Enable_State then Inc Found
		If MapSectorTileIsValid(MapSector,x,y,z+1) = Enable_State then Inc Found
		
	endif

EndFunction Found

// ---------------------------------------------------------------------------------
// 
// ---------------------------------------------------------------------------------

function MapSectorTileNeighborIsCorner(MapSector Ref As TMapSectorData,x,y,z)
	
	local Found as integer
	
	Found = FALSE
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE		
		if MapSectorTileNeighborsCount(MapSector,x,y,z,TRUE) = 2
			
			Found = TRUE
			
			If MapSectorTileIsValid(MapSector,x-1,y,z) = TRUE
				If MapSectorTileIsValid(MapSector,x+1,y,z) = TRUE
					Found = FALSE
				endif
			endif
			
			If MapSectorTileIsValid(MapSector,x,y,z-1) = TRUE
				If MapSectorTileIsValid(MapSector,x,y,z+1) = TRUE
					Found = FALSE
				endif
			endif
			
		endif		
	endif
	
endfunction Found

// ---------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------

Function MapSectorTerrainNeighborsCliffCount(MapSector Ref As TMapSectorData,x,y,z)

	local Found as integer
		
		
	// check south west corner
	if MapSectorTerrainTileCliff(MapSector,x-1,y,z,CSouthEast) > 0
		inc Found
	else
		if MapSectorTerrainTileCliff(MapSector,x,y,z-1,CNorthWest) > 0
			inc Found
		endif
	endif
			
	// check south east corner
	if MapSectorTerrainTileCliff(MapSector,x+1,y,z,CSouthWest) > 0
		inc Found
	else
		if MapSectorTerrainTileCliff(MapSector,x,y,z-1,CNorthEast) > 0
			inc Found
		endif
	endif
		
	// check north east corner
	if MapSectorTerrainTileCliff(MapSector,x+1,y,z,CNorthWest) > 0
		inc Found
	else
		if MapSectorTerrainTileCliff(MapSector,x,y,z+1,CSouthEast) > 0
			inc Found
		endif
	endif
		
	// check north west corner
	if MapSectorTerrainTileCliff(MapSector,x-1,y,z,CNorthEast) > 0
		inc Found
	else
		if MapSectorTerrainTileCliff(MapSector,x,y,z+1,CSouthWest) > 0
			inc Found
		endif
	endif
	
	
endfunction Found

// ---------------------------------------------------------------------------------
// 
// ---------------------------------------------------------------------------------

Function MapSectorTerrainNeighborsCheck(MapSector Ref As TMapSectorData,Neighbors ref as integer[],x,y,z)

	local i as integer
	local Found as integer
	
	Found = 0
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
			
		if Neighbors	.Length = 8
			
			for i = 0 to 8
				Neighbors[i] = 0
			next i
			
			// check south west corner
			if MapSectorTerrainTileCliff(MapSector,x-1,y,z,CSouthEast) > 0 then inc Neighbors[CSouthWest]
			if MapSectorTerrainTileCliff(MapSector,x,y,z-1,CNorthWest) > 0 then inc Neighbors[CSouthWest]
			
			// check south east corner
			if MapSectorTerrainTileCliff(MapSector,x+1,y,z,CSouthWest) > 0 then inc Neighbors[CSouthEast]
			if MapSectorTerrainTileCliff(MapSector,x,y,z-1,CNorthEast) > 0 then inc Neighbors[CSouthEast]
			
			// check north east corner
			if MapSectorTerrainTileCliff(MapSector,x+1,y,z,CNorthWest) > 0 then inc Neighbors[CNorthEast]
			if MapSectorTerrainTileCliff(MapSector,x,y,z+1,CSouthEast) > 0 then inc Neighbors[CNorthEast]
			
			// check north west corner
			if MapSectorTerrainTileCliff(MapSector,x-1,y,z,CNorthEast) > 0 then inc Neighbors[CNorthWest]
			if MapSectorTerrainTileCliff(MapSector,x,y,z+1,CSouthWest) > 0 then inc Neighbors[CNorthWest]
			
			// check 
			Neighbors[CNorth] = MapSectorTerrainTileCliff(MapSector,x,y,z+1,CSouth)
			Neighbors[CSouth] = MapSectorTerrainTileCliff(MapSector,x,y,z-1,CNorth)
			Neighbors[CEast] = MapSectorTerrainTileCliff(MapSector,x+1,y,z,CWest)
			Neighbors[CWest] = MapSectorTerrainTileCliff(MapSector,x-1,y,z,CEast)
			
			for i = 1 to 4
				if Neighbors[i*2-1] > 0 then inc Neighbors[0]
			next i
			
			Found = Neighbors[0]
			
		endif
		
	endif

EndFunction Found

// ---------------------------------------------------------------------------------
//
// ---------------------------------------------------------------------------------

Function MapSectorTerrainTileCliff(MapSector Ref As TMapSectorData,x,y,z,Direction)
	
	local Found as integer
	
	Found = FALSE
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		Found = MapSector.Tile[x,y,z].Data.TileCliff[Direction]	
	endif
			
EndFunction Found



