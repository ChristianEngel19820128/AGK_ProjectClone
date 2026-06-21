
//----------------------------------------------------------------------
// clean up terrain
// change single fields to max Neighbor fields
//----------------------------------------------------------------------

function CleanUpMapGround(MapSector ref as TMapSectorData)
	
	local y as integer
	
	for y = 0 to MapSectorGetHighestTile(MapSector)
		MapSectorGroundCleanUpInLevel(MapSector,y)
	next y
	
endfunction

//----------------------------------------------------------------------
// clean up terrain
// change single fields to max Neighbor fields in level of height
// ignores highlevel differences
//----------------------------------------------------------------------

function MapSectorGroundCleanUpInLevel(MapSector ref as TMapSectorData,HeightLevel)
	
	local FieldsLeft as integer
	local Count as integer

	FieldsLeft = MapSectorGroundSetLowNeighborFields(MapSector,HeightLevel)
	Count = 0
	
	while FieldsLeft > 0 and Count < 2
		FieldsLeft = MapSectorGroundSetNewFieldsToNeighbor(MapSector,HeightLevel)
		inc Count
	endwhile
	
endfunction

//----------------------------------------------------------------------
// clean up terrain
// check if neighbor field is equal
//----------------------------------------------------------------------

function MapSectorGroundFieldCheck(MapSector ref as TMapSectorData,x,y,z,GroundType,GroundElementIndex)
	
	local Found as integer
	
	Found = FALSE

	if MapSectorTileIsTopTile(MapSector,x,y,z) = TRUE
		if MapSector.Tile[x,y,z].Data.GroundType = GroundType or MapSector.Tile[x,y,z].Data.GroundType = CGroundNew
			if MapSector.Tile[x,y,z].Data.GroundElementIndex = GroundElementIndex
				Found = TRUE
			endif
		endif
	else
		Found = TRUE
	endif

endfunction Found

//----------------------------------------------------------------------
// clean up terrain
// set terrain with less neighbors to new
//----------------------------------------------------------------------

function MapSectorGroundSetLowNeighborFields(MapSector ref as TMapSectorData,HeightLevel)

	local x as integer
	local z as integer
	
	local GroundType as integer
	local GroundElementIndex as integer
	
	local Found as integer
	local FieldsLeft as integer
	
	FieldsLeft = 0
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
			if MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundNatural
				
				GroundType = MapSector.Tile[x,HeightLevel,z].Data.GroundType
				GroundElementIndex = MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex
				
				Found = 0
				
				if MapSectorGroundFieldCheck(MapSector,x-1,HeightLevel,z,GroundType,GroundElementIndex) = TRUE then inc Found
				if MapSectorGroundFieldCheck(MapSector,x+1,HeightLevel,z,GroundType,GroundElementIndex) = TRUE then inc Found
				if MapSectorGroundFieldCheck(MapSector,x,HeightLevel,z-1,GroundType,GroundElementIndex) = TRUE then inc Found
				if MapSectorGroundFieldCheck(MapSector,x,HeightLevel,z+1,GroundType,GroundElementIndex) = TRUE then inc Found
				
				if Found < 2
					MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundNew
					inc FieldsLeft
				endif
				
			endif
		endif
		
	next z
	next x

endfunction FieldsLeft

//----------------------------------------------------------------------
// clean up terrain
// get neighbor field ground type index
//----------------------------------------------------------------------

function MapSectorGroundFieldIndexGet(MapSector ref as TMapSectorData,x,y,z)
	
	local GroundElementIndex as integer
	
	GroundElementIndex = -1
	
	if MapSectorTileIsTopTile(MapSector,x,y,z) = TRUE
		if MapSector.Tile[x,y,z].Data.GroundType = CGroundNatural
			GroundElementIndex = MapSector.Tile[x,y,z].Data.GroundElementIndex
		endif
	endif

endfunction GroundElementIndex

//----------------------------------------------------------------------
// clean up terrain
// get most neighbor field ground type index
//----------------------------------------------------------------------

function MapSectorGroundFieldMostNeighborIndexGet(GroundNeighborIndex as integer[])
	
	local GroundIndex as integer
	
	local GroundCount as integer[3]
		
	local i as integer
	local k as integer
	
	local HighestCount as integer
	local Position as integer
	local Found as integer

	// count all equal terrain types
	for i = 0 to 3
		GroundCount[i] = 0
		for k = 0 to 3
			if GroundNeighborIndex[i] > -1
				if GroundNeighborIndex[i] = GroundNeighborIndex[k] then inc GroundCount[i]
			endif
		next k
	next i
	
	// select the highest terrain type
	
	HighestCount = 0
	Position = 0
	
	for i = 0 to 3
		if GroundCount[i] > HighestCount
			HighestCount = GroundCount[i]
			Position = i
		endif
	next

	GroundIndex = -1
	if HighestCount > 0
		GroundIndex = GroundNeighborIndex[Position]
	endif

endfunction GroundIndex

//----------------------------------------------------------------------
// clean up terrain
// set the new marked fields to most neighbor field type
//----------------------------------------------------------------------

function MapSectorGroundSetNewFieldsToNeighbor(MapSector ref as TMapSectorData,HeightLevel)
	
	local x as integer
	local z as integer

	local GroundNeighborIndex as integer[3]
	local GroundElementIndex as integer
	
	local FieldsLeft as integer
	
	FieldsLeft = 0
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
			
			if MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundNew
				
				GroundNeighborIndex[0] = MapSectorGroundFieldIndexGet(MapSector,x-1,HeightLevel,z)
				GroundNeighborIndex[1] = MapSectorGroundFieldIndexGet(MapSector,x+1,HeightLevel,z)
				GroundNeighborIndex[2] = MapSectorGroundFieldIndexGet(MapSector,x,HeightLevel,z-1)
				GroundNeighborIndex[3] = MapSectorGroundFieldIndexGet(MapSector,x,HeightLevel,z+1)
				
				GroundElementIndex = MapSectorGroundFieldMostNeighborIndexGet(GroundNeighborIndex)
				if GroundElementIndex > -1
					MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundNatural
					MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex = GroundElementIndex
				else
					inc FieldsLeft
				endif
			
			endif
			
		endif
		
	next z
	next x

endfunction FieldsLeft


