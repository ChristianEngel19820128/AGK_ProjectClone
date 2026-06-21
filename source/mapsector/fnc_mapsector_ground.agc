
//----------------------------------------------------------------------
// generate terrain
//----------------------------------------------------------------------

function MapSectorGroundGenerate(MapSector ref as TMapSectorData)

	MapSectorGroundFill(MapSector,CGroundNatural,0)		
	MapSectorGroundGenerateNoise(MapSector,CGroundNatural,1,5)
	MapSectorGroundExplode(MapSector,CGroundNatural,1,1,5)
	
	CleanUpMapGround(MapSector)
	//MapSectorGroundCleanUpByBorderRules(MapSector)
	MapSectorGroundBorderSet(MapSector)
	
endfunction

