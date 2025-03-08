
//----------------------------------------------------------------------
// terrain tile type set
//----------------------------------------------------------------------

function MapSectorTerrainTileTypePlaneSet(MapSector Ref As TMapSectorData,x,y,z)
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		
		MapSector.Tile[x,y,z].Data.TileType = CPlane
		MapSector.Tile[x,y,z].Data.TileDirection = CNone
		
		MapSector.Tile[x,y,z].Data.TileCliff[0] = 4
		MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
		MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 2
		MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
		MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 2
		MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
		MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 2
		MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
		MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 2
		
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeRampSet(MapSector Ref As TMapSectorData,x,y,z,Direction)
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if Direction > 0
			
			MapSector.Tile[x,y,z].Data.TileType = CRamp
			MapSector.Tile[x,y,z].Data.TileDirection = Direction
			
			Select Direction
				case CSouth
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 1
				endcase
				case CEast
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 2
				endcase
				case CNorth
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 1
				endcase
				case CWest
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 0
				endcase
			endselect
		
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeCornerSet(MapSector Ref As TMapSectorData,x,y,z,Direction)
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if Direction > 0
			
			MapSector.Tile[x,y,z].Data.TileType = CCorner
			MapSector.Tile[x,y,z].Data.TileDirection = Direction
			
			Select Direction
				case CSouthWest
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 0
				endcase
				case CSouthEast
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 1
				endcase
				case CNorthEast
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 1
				endcase
				case CNorthWest
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 0
				endcase
			endselect
		
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeNotchSet(MapSector Ref As TMapSectorData,x,y,z,Direction)
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if Direction > 0
			
			MapSector.Tile[x,y,z].Data.TileType = CNotch
			MapSector.Tile[x,y,z].Data.TileDirection = Direction
			
			Select Direction
				case CSouthWest
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 3
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 1
				endcase
				case CSouthEast
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 3
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 2
				endcase
				case CNorthEast
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 3
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 2
				endcase
				case CNorthWest
					MapSector.Tile[x,y,z].Data.TileCliff[0] = 3
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthWest] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CSouth] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CSouthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CEast] = 2
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthEast] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorth] = 1
					MapSector.Tile[x,y,z].Data.TileCliff[CNorthWest] = 0
					MapSector.Tile[x,y,z].Data.TileCliff[CWest] = 1
				endcase
			endselect
		
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeRampDirectionRandomize(MapSector Ref As TMapSectorData,x,y,z)
	
	local NeighborCliffs as integer[8]
	local Cliffs as integer[-1]
	local Direction as integer
		
	Direction = 0
	
	MapSectorTerrainNeighborsCheck(MapSector,NeighborCliffs,x,y,z)
	
	if NeighborCliffs[CSouth] = 2 and NeighborCliffs[CNorth] = 0 then Cliffs.Insert(CNorth)
	if NeighborCliffs[CNorth] = 2 and NeighborCliffs[CSouth] = 0 then Cliffs.Insert(CSouth)
	if NeighborCliffs[CEast] = 2 and NeighborCliffs[CWest] = 0 then Cliffs.Insert(CWest)
	if NeighborCliffs[CWest] = 2 and NeighborCliffs[CEast] = 0 then Cliffs.Insert(CEast)
	
	if NeighborCliffs[CSouthWest] > 0 and NeighborCliffs[CNorthWest] > 0 and NeighborCliffs[CSouthEast] = 0 and NeighborCliffs[CNorthEast] = 0 then Cliffs.Insert(CEast)
	if NeighborCliffs[CSouthEast] > 0 and NeighborCliffs[CNorthEast] > 0 and NeighborCliffs[CSouthWest] = 0 and NeighborCliffs[CNorthWest] = 0 then Cliffs.Insert(CWest)
	if NeighborCliffs[CSouthWest] > 0 and NeighborCliffs[CSouthEast] > 0 and NeighborCliffs[CNorthWest] = 0 and NeighborCliffs[CNorthEast] = 0 then Cliffs.Insert(CNorth)
	if NeighborCliffs[CNorthWest] > 0 and NeighborCliffs[CNorthEast] > 0 and NeighborCliffs[CSouthWest] = 0 and NeighborCliffs[CSouthEast] = 0 then Cliffs.Insert(CSouth)
	
	if Cliffs.Length >= 0
		Direction = Cliffs[Random(0,Cliffs.Length)]
	endif
	
endfunction Direction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeCornerDirectionRandomize(MapSector Ref As TMapSectorData,x,y,z)
	
	local NeighborCliffs as integer[8]
	local Cliffs as integer[-1]
	local Direction as integer
		
	Direction = 0
	
	MapSectorTerrainNeighborsCheck(MapSector,NeighborCliffs,x,y,z)
	
	if NeighborCliffs[CSouthWest] > 0 and NeighborCliffs[CNorthEast] = 0 and NeighborCliffs[CNorthWest] = 0 and NeighborCliffs[CSouthEast] = 0 then Cliffs.Insert(CNorthEast)
	if NeighborCliffs[CSouthEast] > 0 and NeighborCliffs[CNorthWest] = 0 and NeighborCliffs[CNorthEast] = 0 and NeighborCliffs[CSouthWest] = 0 then Cliffs.Insert(CNorthWest)
	if NeighborCliffs[CNorthEast] > 0 and NeighborCliffs[CSouthWest] = 0 and NeighborCliffs[CNorthWest] = 0 and NeighborCliffs[CSouthEast] = 0 then Cliffs.Insert(CSouthWest)
	if NeighborCliffs[CNorthWest] > 0 and NeighborCliffs[CSouthEast] = 0 and NeighborCliffs[CNorthEast] = 0 and NeighborCliffs[CSouthWest] = 0 then Cliffs.Insert(CSouthEast)
	
	if Cliffs.Length >= 0
		Direction = Cliffs[Random(0,Cliffs.Length)]
	endif
	
endfunction Direction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeNotchDirectionRandomize(MapSector Ref As TMapSectorData,x,y,z)
	
	local NeighborCliffs as integer[8]
	local Cliffs as integer[-1]
	local Direction as integer
		
	Direction = 0
	
	MapSectorTerrainNeighborsCheck(MapSector,NeighborCliffs,x,y,z)
	
	if NeighborCliffs[CSouthWest] > 0 and NeighborCliffs[CNorthWest] > 0 and NeighborCliffs[CSouthEast] > 0 and NeighborCliffs[CNorthEast] = 0 then Cliffs.Insert(CNorthEast)
	if NeighborCliffs[CSouthEast] > 0 and NeighborCliffs[CNorthEast] > 0 and NeighborCliffs[CSouthWest] > 0 and NeighborCliffs[CNorthWest] = 0 then Cliffs.Insert(CNorthWest)
	if NeighborCliffs[CNorthEast] > 0 and NeighborCliffs[CNorthWest] > 0 and NeighborCliffs[CSouthEast] > 0 and NeighborCliffs[CSouthWest] = 0 then Cliffs.Insert(CSouthWest)
	if NeighborCliffs[CNorthWest] > 0 and NeighborCliffs[CNorthEast] > 0 and NeighborCliffs[CSouthWest] > 0 and NeighborCliffs[CSouthEast] = 0 then Cliffs.Insert(CSouthEast)
	
	if Cliffs.Length >= 0
		Direction = Cliffs[Random(0,Cliffs.Length)]
	endif
	
endfunction Direction

//----------------------------------------------------------------------
//	terrain tile type rules
//----------------------------------------------------------------------

function MapSectorTerrainTileTypePlaneSetAll(MapSector Ref As TMapSectorData)
	
	Local x As Integer
	Local y As Integer
	Local z As Integer

	For x = 0 To MapSector.MapSizeX - 1
	For z = 0 To MapSector.MapSizeZ - 1
		
		For y = 0 To MapSector.MapSizeY - 1
		
			if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
				MapSectorTerrainTileTypePlaneSet(MapSector,x,y,z)
			endif
		
		Next y
		
	Next z
	Next x
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeRampSetAll(MapSector Ref As TMapSectorData,Softness)
	
	Local x As Integer
	Local y As Integer
	Local z As Integer
	
	local Neighbors as integer
	local NeighborCliffs as integer[8]
	local Direction as integer
	
	local Smooth as integer

	For x = 0 To MapSector.MapSizeX - 1
	For z = 0 To MapSector.MapSizeZ - 1
		
		For y = 1 To MapSector.MapSizeY - 1
		
			if MapSectorTileIsTopTile(MapSector,x,y,z) = TRUE
				
				Smooth = Softness
				if Softness > 10000 then Smooth = 10000
				
				if Random(0,10000) < Smooth
					
					Neighbors = MapSectorTileNeighborsCount(MapSector,x,y,z,TRUE)
					
					if Random(0,10000) < Smooth
						Direction = MapSectorTerrainTileTypeRampDirectionRandomize(MapSector,x,y,z)
						MapSectorTerrainTileTypeRampSet(MapSector,x,y,z,Direction)
					endif
				
				endif
				
			endif
		
		Next y
		
	Next z
	Next x
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTileTypeEdgeSetAll(MapSector Ref As TMapSectorData,Softness)
	
	Local x As Integer
	Local y As Integer
	Local z As Integer
	local Direction as integer	
	local Neighbors as integer

	local Smooth as integer
	
	For x = 0 To MapSector.MapSizeX - 1
	For z = 0 To MapSector.MapSizeZ - 1
		
		For y = 1 To MapSector.MapSizeY - 1
		
			if MapSectorTileIsTopTile(MapSector,x,y,z) = TRUE
				
				Smooth = Softness
				if Softness > 10000 then Smooth = 10000
				
				if Random(0,10000) < Smooth
				
					Neighbors = MapSectorTileNeighborsCount(MapSector,x,y,z,TRUE)

					if Random(0,10000) < Smooth
						Direction = MapSectorTerrainTileTypeNotchDirectionRandomize(MapSector,x,y,z)
						MapSectorTerrainTileTypeNotchSet(MapSector,x,y,z,Direction)
					endif
					
					if Random(0,10000) < Smooth
						Direction = MapSectorTerrainTileTypeCornerDirectionRandomize(MapSector,x,y,z)
						MapSectorTerrainTileTypeCornerSet(MapSector,x,y,z,Direction)
					endif
				
				endif
				
			endif
		
		Next y
		
	Next z
	Next x
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
	
function MapSectorTerrainCliffTypeFromPlaneSet(Tile ref as TMapSectorTile,Direction,Neighbor ref as TMapSectorTile,TD1,TD2,ND1,ND2)
	
	if Neighbor.Enabled = FALSE
		Tile.Data.Cliff[Direction].Enabled = TRUE
		Tile.Data.Cliff[Direction].CliffType = CCliff
		Tile.Data.Cliff[Direction].CliffDirection = CNone
	else
		if Neighbor.Data.TileType > CPlane
			if Neighbor.Data.TileCliff[ND1] = 0
				if Neighbor.Data.TileCliff[ND2] = 0
					Tile.Data.Cliff[Direction].Enabled = TRUE
					Tile.Data.Cliff[Direction].CliffType = CCliff
					Tile.Data.Cliff[Direction].CliffDirection = CNone
				endif
			endif
			if Neighbor.Data.TileCliff[ND1] = 1
				if Neighbor.Data.TileCliff[ND2] = 0
					Tile.Data.Cliff[Direction].Enabled = TRUE
					Tile.Data.Cliff[Direction].CliffType = CCliffHalf
					Tile.Data.Cliff[Direction].CliffDirection = TD2
				endif
			endif
			if Neighbor.Data.TileCliff[ND1] = 0
				if Neighbor.Data.TileCliff[ND2] = 1
					Tile.Data.Cliff[Direction].Enabled = TRUE
					Tile.Data.Cliff[Direction].CliffType = CCliffHalf
					Tile.Data.Cliff[Direction].CliffDirection = TD1
				endif
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
	
function MapSectorTerrainCliffTypeFromRampSet(Tile ref as TMapSectorTile,Direction,Neighbor ref as TMapSectorTile,TD1,TD2,ND1,ND2)
	
	if Neighbor.Enabled = FALSE
		if Tile.Data.TileCliff[TD1] = 1
			if Tile.Data.TileCliff[TD2] = 1
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliff
				Tile.Data.Cliff[Direction].CliffDirection = CNone
			endif
		endif
		if Tile.Data.TileCliff[TD1] = 1
			if Tile.Data.TileCliff[TD2] = 0
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliffBevel
				Tile.Data.Cliff[Direction].CliffDirection = TD2
			endif
		endif
		if Tile.Data.TileCliff[TD1] = 0
			if Tile.Data.TileCliff[TD2] = 1
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliffBevel
				Tile.Data.Cliff[Direction].CliffDirection = TD1
			endif
		endif
	else
		if Neighbor.Data.TileType > CPlane
			if Tile.Data.TileCliff[TD1] = 1
				if Tile.Data.TileCliff[TD2] = 1
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliff
							Tile.Data.Cliff[Direction].CliffDirection = CNone
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 1
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffHalf
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 1
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffHalf
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
				endif
			endif
			if Tile.Data.TileCliff[TD1] = 1
				if Tile.Data.TileCliff[TD2] = 0
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 1
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
				endif
			endif
			if Tile.Data.TileCliff[TD1] = 0
				if Tile.Data.TileCliff[TD2] = 1
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 1
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
				endif
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
	
function MapSectorTerrainCliffTypeFromCornerSet(Tile ref as TMapSectorTile,Direction,Neighbor ref as TMapSectorTile,TD1,TD2,ND1,ND2)

	if Neighbor.Enabled = FALSE
		if Tile.Data.TileCliff[TD1] = 1
			if Tile.Data.TileCliff[TD2] = 0
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliffBevel
				Tile.Data.Cliff[Direction].CliffDirection = TD2
			endif
		endif
		if Tile.Data.TileCliff[TD1] = 0
			if Tile.Data.TileCliff[TD2] = 1
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliffBevel
				Tile.Data.Cliff[Direction].CliffDirection = TD1
			endif
		endif
	else
		if Neighbor.Data.TileType > CPlane
			if Tile.Data.TileCliff[TD1] = 1
				if Tile.Data.TileCliff[TD2] = 1
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliff
							Tile.Data.Cliff[Direction].CliffDirection = CNone
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 1
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffHalf
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] =1
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffHalf
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
				endif
			endif
			if Tile.Data.TileCliff[TD1] = 1
				if Tile.Data.TileCliff[TD2] = 0
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 1
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
				endif
			endif
			if Tile.Data.TileCliff[TD1] = 0
				if Tile.Data.TileCliff[TD2] = 1
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 1
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
				endif
			endif
		endif
	endif

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
	
function MapSectorTerrainCliffTypeFromNotchSet(Tile ref as TMapSectorTile,Direction,Neighbor ref as TMapSectorTile,TD1,TD2,ND1,ND2)

	if Neighbor.Enabled = FALSE
		if Tile.Data.TileCliff[TD1] = 1
			if Tile.Data.TileCliff[TD2] = 1
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliff
				Tile.Data.Cliff[Direction].CliffDirection = CNone
			endif
		endif
		if Tile.Data.TileCliff[TD1] = 1
			if Tile.Data.TileCliff[TD2] = 0
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliffBevel
				Tile.Data.Cliff[Direction].CliffDirection = TD2
			endif
		endif
		if Tile.Data.TileCliff[TD1] = 0
			if Tile.Data.TileCliff[TD2] = 1
				Tile.Data.Cliff[Direction].Enabled = TRUE
				Tile.Data.Cliff[Direction].CliffType = CCliffBevel
				Tile.Data.Cliff[Direction].CliffDirection = TD1
			endif
		endif
	else
		if Neighbor.Data.TileType > CPlane
			if Tile.Data.TileCliff[TD1] = 1
				if Tile.Data.TileCliff[TD2] = 0
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 1
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD2
						endif
					endif
				endif
			endif
			if Tile.Data.TileCliff[TD1] = 0
				if Tile.Data.TileCliff[TD2] = 1
					if Neighbor.Data.TileCliff[ND1] = 0
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
					if Neighbor.Data.TileCliff[ND1] = 1
						if Neighbor.Data.TileCliff[ND2] = 0
							Tile.Data.Cliff[Direction].Enabled = TRUE
							Tile.Data.Cliff[Direction].CliffType = CCliffBevel
							Tile.Data.Cliff[Direction].CliffDirection = TD1
						endif
					endif
				endif
			endif
		endif
	endif

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
	
function MapSectorTerrainCliffTypeSet(MapSector Ref As TMapSectorData,x,y,z,Direction,x2,y2,z2,TD1,TD2,ND1,ND2)
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if MapSectorTileInWorld(MapSector,x2,y2,z2) = TRUE
			select MapSector.Tile[x,y,z].Data.TileType
				case CPlane
					MapSectorTerrainCliffTypeFromPlaneSet(MapSector.Tile[x,y,z],Direction,MapSector.Tile[x2,y2,z2],TD1,TD2,ND1,ND2)
				endcase
				case CRamp
					MapSectorTerrainCliffTypeFromRampSet(MapSector.Tile[x,y,z],Direction,MapSector.Tile[x2,y2,z2],TD1,TD2,ND1,ND2)
				endcase
				case CCorner
					MapSectorTerrainCliffTypeFromCornerSet(MapSector.Tile[x,y,z],Direction,MapSector.Tile[x2,y2,z2],TD1,TD2,ND1,ND2)
				endcase
				case CNotch
					MapSectorTerrainCliffTypeFromNotchSet(MapSector.Tile[x,y,z],Direction,MapSector.Tile[x2,y2,z2],TD1,TD2,ND1,ND2)
				endcase
			endselect
		endif
	endif

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainCliffTypeSetAll(MapSector Ref As TMapSectorData)
		
	Local x As Integer
	Local y As Integer
	Local z As Integer
	local Direction as integer	
	local Neighbors as integer

	For x = 0 To MapSector.MapSizeX - 1
	For z = 0 To MapSector.MapSizeZ - 1
		
		For y = 0 To MapSector.MapSizeY - 1
			
			MapSectorTerrainCliffTypeSet(MapSector,x,y,z,CSouth,x,y,z-1,CSouthWest,CSouthEast,CNorthWest,CNorthEast)
			MapSectorTerrainCliffTypeSet(MapSector,x,y,z,CNorth,x,y,z+1,CNorthWest,CNorthEast,CSouthWest,CSouthEast)
			MapSectorTerrainCliffTypeSet(MapSector,x,y,z,CWest,x-1,y,z,CNorthWest,CSouthWest,CNorthEast,CSouthEast)
			MapSectorTerrainCliffTypeSet(MapSector,x,y,z,CEast,x+1,y,z,CNorthEast,CSouthEast,CNorthWest,CSouthWest)
			
		Next y
		
	Next z
	Next x
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTerrainTypeGenerate(MapSector Ref As TMapSectorData)
	
	local i as integer
	// tile type
	MapSectorTerrainTileTypePlaneSetAll(MapSector)
	
	for i = 0 to 1
		MapSectorTerrainTileTypeRampSetAll(MapSector,2500)
	next i
	
	for i = 0 to 1
		MapSectorTerrainTileTypeEdgeSetAll(MapSector,5000)
	next i

	// cliff type
	MapSectorTerrainCliffTypeSetAll(MapSector)
	
endfunction