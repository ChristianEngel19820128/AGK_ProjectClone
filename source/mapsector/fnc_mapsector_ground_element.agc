
//----------------------------------------------------------------------
// clear all the ground
//----------------------------------------------------------------------

function MapSectorGroundDelete(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer

	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		for y = 0 to MapSectorGetHighestTile(MapSector)
			MapSector.Tile[x,y,z].Data.GroundType = CNone
		next y
		
	next z
	next x

endfunction

//----------------------------------------------------------------------
// set hole map terrain to value
//----------------------------------------------------------------------

function MapSectorGroundFill(MapSector ref as TMapSectorData,GroundType,GroundElementIndex)
	
	local y as integer
	
	for y = 0 to MapSectorGetHighestTile(MapSector)
		MapSectorGroundFillInLevel(MapSector,y,GroundType,GroundElementIndex)
	next y
	
endfunction

//----------------------------------------------------------------------
// set map terrain to value in the level of height
//----------------------------------------------------------------------

function MapSectorGroundFillInLevel(MapSector ref as TMapSectorData,HeightLevel,GroundType,GroundElementIndex)
	
	local x as integer
	local z as integer
	
	local Index as integer
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
				
			MapSector.Tile[x,HeightLevel,z].Data.GroundType = GroundType
			MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex = GroundElementIndex
			
		else
			if MapSectorTileisValid(MapSector,x,HeightLevel,z) = TRUE
				
				MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundClip
				Index = MapSectorTextureElementIndexGet(MapSector.TextureImages.Ground,"groundclipimage")
				if Index > -1
					MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex = Index
				endif
				
			endif
		endif
		
	next z
	next x
		
endfunction

//----------------------------------------------------------------------
// generate noise of terrain type
//----------------------------------------------------------------------

function MapSectorGroundGenerateNoise(MapSector ref as TMapSectorData,GroundType,GroundElementIndex,Noise)
	
	local y as integer
	
	for y = 0 to MapSectorGetHighestTile(MapSector)
		MapSectorGroundGenerateNoiseInLevel(MapSector,y,GroundType,GroundElementIndex,Noise)
	next y
	
endfunction

//----------------------------------------------------------------------
// generate noise of terrain type in level of height
// lower noise Value raise the effect
//----------------------------------------------------------------------

function MapSectorGroundGenerateNoiseInLevel(MapSector ref as TMapSectorData,HeightLevel,GroundType,GroundElementIndex,Noise)
	
	local x as integer
	local z as integer
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
			if Random(0,Noise) = Noise
				MapSector.Tile[x,HeightLevel,z].Data.GroundType = GroundType
				MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex = GroundElementIndex
			endif
		endif
	
	next z
	next x
		
endfunction

//----------------------------------------------------------------------
// explode fields of terrain type
//----------------------------------------------------------------------

function MapSectorGroundExplode(MapSector ref as TMapSectorData,GroundType,GroundElementIndex,RadiusMin,RadiusMax)
	
	local y as integer
	
	for y = 0 to MapSectorGetHighestTile(MapSector)
		MapSectorGroundExplodeInLevel(MapSector,y,GroundType,GroundElementIndex,RadiusMin,RadiusMax)
	next y
	
endfunction

//----------------------------------------------------------------------
// explode fields of terrain type in level of height
//----------------------------------------------------------------------

function MapSectorGroundExplodeInLevel(MapSector ref as TMapSectorData,HeightLevel,GroundType,GroundElementIndex,RadiusMin,RadiusMax)
	
	local x as integer
	local z as integer
	
	local Radius as integer
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1

		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
			if MapSector.Tile[x,HeightLevel,z].Data.GroundType = GroundType
				if MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex = GroundElementIndex
					
					Radius = Random(RadiusMin,RadiusMax)
					MapSectorGroundExplodeField(MapSector,x,HeightLevel,z,Radius,GroundType,GroundElementIndex)
				
				endif
			endif
		endif
		
	next z
	next x
	
	MapSectorGroundSetNewFields(MapSector,HeightLevel,GroundType,GroundElementIndex)

endfunction

//----------------------------------------------------------------------
// explode the field to random radius
//----------------------------------------------------------------------

function MapSectorGroundExplodeField(MapSector ref as TMapSectorData,x,y,z,Radius,GroundType,GroundElementIndex)
	
	local r as integer
	local r1 as integer
	local r2 as integer
	
	r = Random(1,Radius)
	
	MapSector.Tile[x,y,z].Data.GroundType = CGroundNew
	
	for r1 = -r to r
	for r2 = -r to r
		
		if Random(0,r+1) > Abs(r1) and Random(0,r+1) > Abs(r2)
			if MapSectorTileIsTopTile(MapSector,x+r1,y,z+r2) = TRUE
				if MapSector.Tile[x+r1,y,z+r2].Data.GroundType = GroundType
					if MapSector.Tile[x+r1,y,z+r2].Data.GroundElementIndex <> GroundElementIndex
						
						MapSector.Tile[x+r1,y,z+r2].Data.GroundType = CGroundNew
					
					endif
				endif
			endif
		endif
	
	next r2
	next r1
	
endfunction

//----------------------------------------------------------------------
// explode the field to random radius
//----------------------------------------------------------------------

function MapSectorGroundSetNewFields(MapSector ref as TMapSectorData,HeightLevel,GroundType,GroundElementIndex)

	local x as integer
	local z as integer

	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1

		if MapSectorTileIsTopTile(MapSector,x,HeightLevel,z) = TRUE
			if MapSector.Tile[x,HeightLevel,z].Data.GroundType = CGroundNew

				MapSector.Tile[x,HeightLevel,z].Data.GroundType = GroundType
				MapSector.Tile[x,HeightLevel,z].Data.GroundElementIndex = GroundElementIndex

			endif
		endif
		
	next z
	next x

endfunction



