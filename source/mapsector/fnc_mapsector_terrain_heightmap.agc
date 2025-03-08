
//----------------------------------------------------------------------
// clear all the MapTerrain
//----------------------------------------------------------------------

function MapSectorTerrainDelete(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	local i as integer

	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		for y = 0 to MapSector.MapSizeY - 1
			MapSector.Tile[x,y,z].Enabled = FALSE
			for i = 0 to 8
				MapSector.Tile[x,y,z].Data.Cliff[i].Enabled = FALSE
			next i		
		next y
		
	next z
	next x
	
	MapSector.HighestTileTop = 0

endfunction

//----------------------------------------------------------------------
// generate a flat MapTerrain
//----------------------------------------------------------------------

function MapSectorTerrainFlatGenerate(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1
		
		for y = 0 to MapSector.MapSizeY - 1
		
			if y = 0
				MapSector.Tile[x,y,z].Enabled = TRUE
			else
				MapSector.Tile[x,y,z].Enabled = FALSE
			endif		
	
		next y
		
	next z
	next x

endfunction

//----------------------------------------------------------------------
// generate highmap noise for MapTerrain
//----------------------------------------------------------------------

function MapSectorTerrainNoiseGenerate(MapSector ref as TMapSectorData,Noise)

	local x as integer
	local y as integer
	local z as integer
	
	for x = 0 to MapSector.MapSizeX - 1	
	for z = 0 to MapSector.MapSizeZ - 1
		
		for y = 1 to MapSector.MapSizeY - 1
		
			if MapSectorTileIsValid(MapSector,x,y-1,z) = TRUE
				if random(0,Noise) = Noise
					MapSector.Tile[x,y,z].Enabled = TRUE
				endif
			endif		

		next y
	
	next z
	next x
			
endfunction

// ---------------------------------------------------------------------------------
// set a mountain on base x line
// ---------------------------------------------------------------------------------

Function MapSectorTerrainMountainSet(MapSector ref As TMapSectorData,LineMode,Position1,Position2,S1,S2,Radius,Height)

	// line
	local i as integer
	// height
	local k as integer
	// radius
	local l as integer
	local j as integer	
	// radius per height
	local rh as integer
	// radius
	local r1 as integer
	local r2 as integer
	// line coords
	local xt as integer
	local yt as integer
	
	// for each position in line
	For i = Position1 To Position2
	// for each level of height
	For k = 1 To Height

		// randomize max radius for mountain per height level
		// the heigher so smaller the level radius
		rh = Random(1,1+Floor(Radius/k))

		// only if radius > 1
		If rh > 1

			// for each radius position in quad
			For j = -rh To rh
			For l = -rh To rh

				// randomize with length noise position
				// the heigher radius so smaller the chance for a heigher position
				// have a chance for redundant tile positions
				// chance to fill the inner circle completly
				r1 = 0
				If j < 0 Then r1 = -1 * Random(1,Abs(j))
				If j > 0 Then r1 = Random(1,j)

				r2 = 0
				If l < 0 Then r2 = -1 * Random(1,Abs(l))
				If l > 0 Then r2 = Random(1,l)

				// calculate x,z coords
				if LineMode = 0
					xt = i+r1
					yt = Floor(s1*i+s2)+r2
				else
					xt = Floor((i-s2)/s1)+r2
					yt = i+r1
				endif					

				if MapSectorTileInWorld(MapSector,xt,k,yt) = TRUE
					// enable tile
					if k = 0 
						MapSector.Tile[xt,k,yt].Enabled = TRUE
					else
						if MapSectorTileIsValid(MapSector,xt,k-1,yt) = TRUE then MapSector.Tile[xt,k,yt].Enabled = TRUE
					endif
				endif
				
			Next l
			Next j

		EndIf

	Next k
	Next i
	
endfunction

// ---------------------------------------------------------------------------------
// generate a large mountain
// ---------------------------------------------------------------------------------

Function MapSectorTerrainMountainGenerate(MapSector ref As TMapSectorData)

	Local x As Integer
	Local y As Integer
	
	Local x1 As Integer
	Local x2 As Integer
	Local y1 As Integer
	Local y2 As Integer

	Local s1 As Float
	Local s2 As Float

	Local h As Integer
	Local h1 As Integer
	Local h2 As Integer

	Local r As Integer
	Local r1 As Integer
	Local r2 As Integer

	// set init values

	if MapSector.MapSizeX > 10 and MapSector.MapSizeZ > 10

		// randomize line coords

		repeat	
			x1 = Random(0,MapSector.MapSizeX-1)
			x2 = Random(0,MapSector.MapSizeX-1)
			If x1 > x2
				x = x1
				x1 = x2
				x2 = x
			EndIf
		until x2 - x1 <> 0
		
		repeat
			y1 = Random(0,MapSector.MapSizeZ-1)
			y2 = Random(0,MapSector.MapSizeZ-1)
			If y1 > y2
				y = y1
				y1 = y2
				y2 = y
			EndIf
		until y2 - y1 <> 0
	
		// check coords
	
		if x1 < 0 then x1 = 0
		if x2 < 1 then x2 = 1
		
		if x1 > MapSector.MapSizeX-1 then x1 = MapSector.MapSizeX-1
		if x2 > MapSector.MapSizeX-1 then x2 = MapSector.MapSizeX-1
		
		if y1 < 0 then y1 = 0
		if y2 < 1 then y2 = 1
		
		if y1 > MapSector.MapSizeZ-1 then y1 = MapSector.MapSizeZ-1
		if y2 > MapSector.MapSizeZ-1 then y2 = MapSector.MapSizeZ-1
	
		// calculate increase	
		
		s1 = (y2 - y1) / (x2 - x1)
		s2 = y1 - x1 * s1
	
		// randomize max height
		
		h1 = Floor(MapSector.MapSizeY * MapSector.Properties.Altitude * 0.5 / 100)
		h2 = Floor(MapSector.MapSizeY * MapSector.Properties.Altitude / 100)
			
		h = Random(h1,h2)
		
		// randomize max radius

		r1 = Floor(MapSector.MapSizeY * MapSector.Properties.Altitude * 0.5 / 100)
		r2 = Floor(MapSector.MapSizeY * MapSector.Properties.Altitude * 2 / 100)
		r = Random(r1,r2)
	
		// draw mountain
	
		If x2 - x1 > y2 - y1	
			MapSectorTerrainMountainSet(MapSector,0,x1,x2,S1,S2,r,h)
		else
			MapSectorTerrainMountainSet(MapSector,1,y1,y2,S1,S2,r,h)
		endif

	endif

EndFunction

// ---------------------------------------------------------------------------------
// straighten the altitude of MapTerrain true for add / false to remove
// ---------------------------------------------------------------------------------

Function MapSectorTerrainAltitudeStraighten(MapSector ref As TMapSectorData,Enable_State)

	Local x As Integer
	Local y As Integer
	Local z As Integer
	Local Found As Integer

	For x = 0 To MapSector.MapSizeX - 1
	For y = 0 To MapSector.MapSizeY - 1
	For z = 0 To MapSector.MapSizeZ - 1

		Found = 0

		If MapSectorTileIsValid(MapSector,x-1,y,z) = Enable_State then Inc Found
		If MapSectorTileIsValid(MapSector,x+1,y,z) = Enable_State then Inc Found
		If MapSectorTileIsValid(MapSector,x,y,z-1) = Enable_State then Inc Found
		If MapSectorTileIsValid(MapSector,x,y,z+1) = Enable_State then Inc Found

		If Found > 2
			MapSector.Tile[x,y,z].Enabled = Enable_State
		EndIf

	Next z
	Next y
	Next x

EndFunction

// ---------------------------------------------------------------------------------
// delete or enable hidden tiles
// ---------------------------------------------------------------------------------

Function MapSectorTerrainAltitudeCleanUp(MapSector Ref As TMapSectorData,Enable_State)

	Local x As Integer
	Local y As Integer
	Local z As Integer
	
	Local i As Integer
	local Found as integer

	For x = 0 To MapSector.MapSizeX - 1
	For y = 0 To MapSector.MapSizeY - 1
	For z = 0 To MapSector.MapSizeZ - 1
		
		if MapSectorTileInWorld(MapSector,x,y,z)
					
			Found = FALSE
			i = y + 1
			
			while Found = FALSE and i < MapSector.MapSizeY
				
				if MapSectorTileisValid(MapSector,x,i,z) = TRUE then Found = TRUE
				inc i

			endwhile
			
			if Found = TRUE then MapSector.Tile[x,y,z].Enabled = Enable_State
			
		endif
		
	Next z
	Next y
	Next x
	
EndFunction

// ---------------------------------------------------------------------------------
// calculate highest tile in map
// ---------------------------------------------------------------------------------

Function MapSectorHighestTileCalculate(MapSector Ref As TMapSectorData)

	Local x As Integer
	Local y As Integer
	Local z As Integer

	for x = 0 to MapSector.MapSizeX - 1	
	for z = 0 to MapSector.MapSizeZ - 1
		
		for y = 0 to MapSector.MapSizeY - 1
		
			if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
				if MapSector.HighestTileTop < y + 1 then MapSector.HighestTileTop = y + 1
			endif
			
		next y
	
	next z
	next x

EndFunction

//----------------------------------------------------------------------
// generate MapTerrain
//----------------------------------------------------------------------

function MapSectorTerrainGenerate(MapSector ref as TMapSectorData)
	
	local i as integer
	
	MapSectorTerrainFlatGenerate(MapSector)
	//MapSectorTerrainNoiseGenerate(MapSector,2)
	for i = 0 to Floor(MapSector.Properties.Altitude/10)
		MapSectorTerrainMountainGenerate(MapSector)
	next i
	MapSectorTerrainAltitudeStraighten(MapSector,TRUE)
	//MapSectorTerrainAltitudeStraighten(MapSector,FALSE)
	//MapSectorTerrainAltitudeCleanUp(MapSector,TRUE)
	
endfunction