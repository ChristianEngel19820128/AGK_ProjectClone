
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorDataSourceLoad(MapSector ref as TMapSectorData)

	local FileString as string

	FileString = ReadFileString(MapSector.Source)
	If Len(FileString) > 0
		MapSector.DataSource.fromJSON(FileString)
	endif
	
endfunction

