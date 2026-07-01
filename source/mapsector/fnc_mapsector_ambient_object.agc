
//----------------------------------------------------------------------
// ambient object
//----------------------------------------------------------------------

function MapSectorAmbientObjectsLoad(MapSector ref as TMapSectorData)
	
	if FilePathSetAndCheck(MapSector.DataSource.AmbientObjects) = 1
		MapSector.AmbientObjectTypes.Load(MapSector.DataSource.AmbientObjects.Name)
	endif
	
endfunction

//----------------------------------------------------------------------
// ambient object
//----------------------------------------------------------------------

function MapSectorAmbientObjectsGenerate(MapSector ref as TMapSectorData)
	
	
	
endfunction
