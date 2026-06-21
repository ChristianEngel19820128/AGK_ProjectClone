
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureDataSet(Texture ref as TMapSectorTextureData,ImageList as TMapSectorTextureElement[],Data ref as TMapSectorTextureImageIndexData)
	
	if Data.Set = FALSE or Data.PosX < 0 or Data.PosX >= ImageList[Data.CliffIndex].Image.TileCountX or Data.PosY < 0 or Data.PosY >= ImageList[Data.CliffIndex].Image.TileCountY
		
		Data.Set = TRUE
		Data.CliffIndex = Random(0,ImageList.Length)
		
		if ImageList[Data.CliffIndex].Image.TileCountX >= 2
			Data.PosX = Random(0,ImageList[Data.CliffIndex].Image.TileCountX-2)
		else
			Data.PosX = Random(0,ImageList[Data.CliffIndex].Image.TileCountX-1)
		endif
		
		if ImageList[Data.CliffIndex].Image.TileCountY >= 2
			Data.PosY = Random(0,ImageList[Data.CliffIndex].Image.TileCountY-2)
		else
			Data.PosY = Random(0,ImageList[Data.CliffIndex].Image.TileCountY-1)
		endif
		
	endif
			
	Texture.ImageID = ImageList[Data.CliffIndex].Image.ImageID
	Texture.PositionX = Data.PosX
	Texture.PositionY = Data.PosY

endfunction Data.CliffIndex

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureFillNorth(MapSector ref as TMapSectorData,x,y,z,Data ref as TMapSectorTextureImageIndexData)
	
	local i as integer
	local DataNow as TMapSectorTextureImageIndexData[2]
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if MapSector.Tile[x,y,z].Data.Cliff[CNorth].Enabled = TRUE
			if MapSector.Tile[x,y,z].Data.Cliff[CNorth].Texture.ImageID = 0
				
				MapSector.Tile[x,y,z].Data.Cliff[CNorth].CliffIndex = MapSectorCliffTextureDataSet(MapSector.Tile[x,y,z].Data.Cliff[CNorth].Texture,MapSector.TextureImages.Cliff,Data)

				for i = 0 to 2
					DataNow[i] = Data
				next i
				
				if MapSectorTileIsValid(MapSector,x-1,y,z) = TRUE
					DataNow[0].PosX = Data.PosX+1
					MapSectorCliffTextureFillNorth(MapSector,x-1,y,z,DataNow[0])
				endif
				
				if MapSectorTileIsValid(MapSector,x,y+1,z) = TRUE
					DataNow[1].PosY = Data.PosY-1
					MapSectorCliffTextureFillNorth(MapSector,x,y+1,z,DataNow[1])
				endif
				
				if MapSectorTileIsValid(MapSector,x,y-1,z) = TRUE
					DataNow[2].PosY = Data.PosY+1
					MapSectorCliffTextureFillNorth(MapSector,x,y-1,z,DataNow[2])
				endif
						
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureSetNorth(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	
	local Data as TMapSectorTextureImageIndexData
	
	for x = MapSector.MapSizeX - 1 to 0 step -1
	for z = MapSector.MapSizeZ - 1 to 0 step -1

		for y = 0 to MapSectorGetHighestTile(MapSector)
			
			Data.Set = FALSE
			MapSectorCliffTextureFillNorth(MapSector,x,y,z,Data)
			
		next y	
			
	next z
	next x

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureFillSouth(MapSector ref as TMapSectorData,x,y,z,Data ref as TMapSectorTextureImageIndexData)
	
	local i as integer
	local DataNow as TMapSectorTextureImageIndexData[2]
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if MapSector.Tile[x,y,z].Data.Cliff[CSouth].Enabled = TRUE
			if MapSector.Tile[x,y,z].Data.Cliff[CSouth].Texture.ImageID = 0
				
				MapSector.Tile[x,y,z].Data.Cliff[CSouth].CliffIndex = MapSectorCliffTextureDataSet(MapSector.Tile[x,y,z].Data.Cliff[CSouth].Texture,MapSector.TextureImages.Cliff,Data)
				
				for i = 0 to 2
					DataNow[i] = Data
				next i
				
				DataNow[0].PosX = Data.PosX+1
				MapSectorCliffTextureFillSouth(MapSector,x+1,y,z,DataNow[0])
				
				DataNow[1].PosY = Data.PosY-1
				MapSectorCliffTextureFillSouth(MapSector,x,y+1,z,DataNow[1])
			
				DataNow[2].PosY = Data.PosY+1
				MapSectorCliffTextureFillSouth(MapSector,x,y-1,z,DataNow[2])
				
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureSetSouth(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	
	local Data as TMapSectorTextureImageIndexData
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1

		for y = 0 to MapSectorGetHighestTile(MapSector)
			
			Data.Set = FALSE
			MapSectorCliffTextureFillSouth(MapSector,x,y,z,Data)
			
		next y	
			
	next z
	next x

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureFillEast(MapSector ref as TMapSectorData,x,y,z,Data ref as TMapSectorTextureImageIndexData)
	
	local i as integer
	local DataNow as TMapSectorTextureImageIndexData[2]
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if MapSector.Tile[x,y,z].Data.Cliff[CEast].Enabled = TRUE
			if MapSector.Tile[x,y,z].Data.Cliff[CEast].Texture.ImageID = 0
				
				MapSector.Tile[x,y,z].Data.Cliff[CEast].CliffIndex = MapSectorCliffTextureDataSet(MapSector.Tile[x,y,z].Data.Cliff[CEast].Texture,MapSector.TextureImages.Cliff,Data)
				
				for i = 0 to 2
					DataNow[i] = Data
				next i
				
				if MapSectorTileIsValid(MapSector,x,y,z+1) = TRUE
					DataNow[0].PosX = Data.PosX+1
					MapSectorCliffTextureFillEast(MapSector,x,y,z+1,DataNow[0])
				endif
				
				if MapSectorTileIsValid(MapSector,x,y+1,z) = TRUE
					DataNow[1].PosY = Data.PosY-1
					MapSectorCliffTextureFillEast(MapSector,x,y+1,z,DataNow[1])
				endif
				
				if MapSectorTileIsValid(MapSector,x,y-1,z) = TRUE
					DataNow[2].PosY = Data.PosY+1
					MapSectorCliffTextureFillEast(MapSector,x,y-1,z,DataNow[2])
				endif
						
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureSetEast(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	
	local Data as TMapSectorTextureImageIndexData
	
	for x = 0 to MapSector.MapSizeX - 1
	for z = 0 to MapSector.MapSizeZ - 1

		for y = 0 to MapSectorGetHighestTile(MapSector)

			Data.Set = FALSE
			MapSectorCliffTextureFillEast(MapSector,x,y,z,Data)
			
		next y	
			
	next z
	next x

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureFillWest(MapSector ref as TMapSectorData,x,y,z,Data ref as TMapSectorTextureImageIndexData)
		
	local i as integer
	local DataNow as TMapSectorTextureImageIndexData[2]
	
	if MapSectorTileIsValid(MapSector,x,y,z) = TRUE
		if MapSector.Tile[x,y,z].Data.Cliff[CWest].Enabled = TRUE
			if MapSector.Tile[x,y,z].Data.Cliff[CWest].Texture.ImageID = 0
				
				MapSector.Tile[x,y,z].Data.Cliff[CWest].CliffIndex = MapSectorCliffTextureDataSet(MapSector.Tile[x,y,z].Data.Cliff[CWest].Texture,MapSector.TextureImages.Cliff,Data)
				
				for i = 0 to 2
					DataNow[i] = Data
				next i

				DataNow[0].PosX = Data.PosX+1
				MapSectorCliffTextureFillWest(MapSector,x,y,z-1,DataNow[0])
				
				DataNow[1].PosY = Data.PosY-1
				MapSectorCliffTextureFillWest(MapSector,x,y+1,z,DataNow[1])
				
				DataNow[2].PosY = Data.PosY+1
				MapSectorCliffTextureFillWest(MapSector,x,y-1,z,DataNow[2])
				
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCliffTextureSetWest(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	
	local Data as TMapSectorTextureImageIndexData
	
	for x = MapSector.MapSizeX - 1 to 0 step -1
	for z = MapSector.MapSizeZ - 1 to 0 step -1

		for y = 0 to MapSectorGetHighestTile(MapSector)

			Data.Set = FALSE
			MapSectorCliffTextureFillWest(MapSector,x,y,z,Data)
			
		next y	
			
	next z
	next x

endfunction



