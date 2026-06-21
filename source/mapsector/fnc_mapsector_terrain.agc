
//----------------------------------------------------------------------
// generate MapTerrain
//----------------------------------------------------------------------

function MapSectorTerrainGenerate(MapSector ref as TMapSectorData)
	
	local i as integer
	
	MapSectorTerrainFlatGenerate(MapSector)
	//MapSectorTerrainNoiseGenerate(MapSector,2)
	for i = 0 to Floor(MapSector.Properties.Altitude*0.1)
		MapSectorTerrainMountainGenerate(MapSector)
	next i
	MapSectorTerrainAltitudeStraighten(MapSector,TRUE)
	//MapSectorTerrainAltitudeStraighten(MapSector,FALSE)
	//MapSectorTerrainAltitudeCleanUp(MapSector,TRUE)
	
endfunction

