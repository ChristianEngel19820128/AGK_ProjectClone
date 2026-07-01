
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorGenerate(MapSector ref as TMapSectorData)

	MapSectorSizeSet(MapSector,30,4,30,10,10)
	
	MapSector.TileSize = 4
	MapSector.TileHeight = 2
	MapSector.ClipHeight = 4
	
	MapSector.Properties.Altitude = 75
	
	MapSector.Source.Path = "/media/data/mapsector"
	MapSector.Source.Name = "mapsector.json"
	
	MapSectorDataSourceLoad(MapSector)
	MapSectorTexturesLoad(MapSector)
	MapSectorTerrainGenerate(MapSector)
	MapSectorTerrainTypeGenerate(MapSector)
	MapSectorGroundGenerate(MapSector)
	MapSectorTextureSet(MapSector)
	MapSectorObject3DGenerate(MapSector)
	
	MapSectorCameraInit(MapSector.Camera)
	MapSectorSkyBoxInit(MapSector.SkyBox,MapSector,MapSector.Camera)

endfunction


