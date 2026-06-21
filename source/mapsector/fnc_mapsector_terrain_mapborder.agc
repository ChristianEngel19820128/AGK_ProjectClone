
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainMapBorderCliffTypeSetAll(MapSector Ref As TMapSectorData)

	Local x As Integer
	Local y As Integer
	Local z As Integer
	
	For x = 0 To MapSector.MapSizeX - 1
	For y = 1 To MapSector.MapSizeY - 1
	
		z = 0
		
		if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffType = CCliff
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffDirection = CNone
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffDirection = CSouthEast
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
				if MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffDirection = CSouthWest
				endif
			endif
			
		endif
		
		z = MapSector.MapSizeZ - 1
		
		if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffType = CCliff
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffDirection = CNone
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffDirection = CNorthWest
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
				if MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffDirection = CNorthEast
				endif
			endif
			
		endif
		
	next y
	next x
	
	For z = 0 To MapSector.MapSizeZ - 1
	For y = 1 To MapSector.MapSizeY - 1
		
		x = 0
		
		if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CWest].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffType = CCliff
					MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffDirection = CNone
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.Cliff[CWest].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffDirection = CSouthWest
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
				if MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CWest].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffDirection = CNorthWest
				endif
			endif
			
		endif
		
		x = MapSector.MapSizeX - 1
		
		if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CEast].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffType = CCliff
					MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffDirection = CNone
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
				if MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.Cliff[CEast].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffDirection = CNorthEast
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
				if MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.Cliff[CEast].Enabled = TRUE
					MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffType = CCliffBevel
					MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffDirection = CSouthEast
				endif
			endif
				
		endif
			
	next y
	next z

endfunction

