
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTextureImageCalcTileDimensions(TextureImage ref as TMapSectorTextureImageData)
	
	TextureImage.Width = GetImageWidth(TextureImage.ImageID)
	TextureImage.Height = GetImageHeight(TextureImage.ImageID)
	
	if TextureImage.TileCountX > 1
		TextureImage.TileWidth = Floor(TextureImage.Width / TextureImage.TileCountX)
		if TextureImage.Width <> TextureImage.TileCountX * TextureImage.TileWidth
			TextureImage.TileCountX = 1
			TextureImage.TileWidth = TextureImage.Width
			//TextureImage.Enabled = FALSE
		endif
	else
		TextureImage.TileCountX = 1
		TextureImage.TileWidth = TextureImage.Width
	endif
	
	
	if TextureImage.TileCountY > 1
		TextureImage.TileHeight = Floor(TextureImage.Height / TextureImage.TileCountY)
		if TextureImage.Height <> TextureImage.TileCountY * TextureImage.TileHeight
			TextureImage.TileCountY = 1
			TextureImage.TileHeight = TextureImage.Height
			//TextureImage.Enabled = FALSE
		endif	
	else
		TextureImage.TileCountY = 1
		TextureImage.TileHeight = TextureImage.Height
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTextureImageLoad(TextureImage ref as TMapSectorTextureImageData)
	
	TextureImage.Enabled = FALSE
	
	if TextureImage.ImageID > 0 then DeleteImage(TextureImage.ImageID)

	if FilePathSetAndCheck(TextureImage.Source) = 1

		TextureImage.ImageID = LoadImage(TextureImage.Source.File)
				
		if TextureImage.ImageID > 0
			TextureImage.Enabled = TRUE
			MapSectorTextureImageCalcTileDimensions(TextureImage)
		endif
		
	endif

EndFunction TextureImage.Enabled

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTextureImageLoadAll(TextureElements ref as TMapSectorTextureElement[])
	
	local i as integer
	local k as integer
	
	// ground natural
	for i = 0 to TextureElements.Length
		MapSectorTextureImageLoad(TextureElements[i].Image)
	next i
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorTexturesLoad(MapSector ref as TMapSectorData)

	if FilePathSetAndCheck(MapSector.DataSource.Ground) = 1
		MapSector.TextureImages.Ground.Load(MapSector.DataSource.Ground.File)
		MapSectorTextureImageLoadAll(MapSector.TextureImages.Ground)
	endif
	
	if FilePathSetAndCheck(MapSector.DataSource.GroundNatural) = 1
		MapSector.TextureImages.GroundNatural.Load(MapSector.DataSource.GroundNatural.File)
		MapSectorTextureImageLoadAll(MapSector.TextureImages.GroundNatural)
	endif
	
	if FilePathSetAndCheck(MapSector.DataSource.GroundUrban) = 1
		MapSector.TextureImages.GroundUrban.Load(MapSector.DataSource.GroundUrban.File)
		MapSectorTextureImageLoadAll(MapSector.TextureImages.GroundUrban)
	endif
	
	if FilePathSetAndCheck(MapSector.DataSource.Cliff) = 1
		MapSector.TextureImages.Cliff.Load(MapSector.DataSource.Cliff.File)
		MapSectorTextureImageLoadAll(MapSector.TextureImages.Cliff)
	endif

endfunction



