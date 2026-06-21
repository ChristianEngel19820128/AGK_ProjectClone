
//----------------------------------------------------------------------
// set the texture data for each ground tile
//----------------------------------------------------------------------

function MapSectorGroundTextureSet(MapSector ref as TMapSectorData)

	local x as integer
	local y as integer
	local z as integer
	
	local GroundType as integer
	local GroundElementIndex as integer
	
	for x = 0 to MapSector.MapSizeX - 1
	for y = 0 to MapSectorGetHighestTile(MapSector)
	for z = 0 to MapSector.MapSizeZ - 1
		
		if MapSectorTileisValid(MapSector,x,y,z) = TRUE
				
			GroundType = MapSector.Tile[x,y,z].Data.GroundType
			GroundElementIndex = MapSector.Tile[x,y,z].Data.GroundElementIndex
			
			select GroundType
				
				case CGroundClip
					if MapSector.TextureImages.Ground[GroundElementIndex].Image.Enabled = TRUE
						MapSector.Tile[x,y,z].Data.Texture.ImageID = MapSector.TextureImages.Ground[GroundElementIndex].Image.ImageID
						MapSector.Tile[x,y,z].Data.Texture.PositionX = 0
						MapSector.Tile[x,y,z].Data.Texture.PositionY = 0
					endif
				endcase
				
				case CGroundNatural
					if MapSector.TextureImages.GroundNatural[GroundElementIndex].Image.Enabled = TRUE
						MapSector.Tile[x,y,z].Data.Texture.ImageID = MapSector.TextureImages.GroundNatural[GroundElementIndex].Image.ImageID
						MapSectorGroundNaturalSetRandomTexturePosition(MapSector,x,y,z)
					endif
				endcase
				
				case CGroundUrban
				endcase
			
			endselect
						
		endif
		
	next z
	next y
	next x
	
endfunction

//----------------------------------------------------------------------
// set random texture for ground natural
//----------------------------------------------------------------------

function MapSectorGroundNaturalSetRandomTexturePosition(MapSector ref as TMapSectorData,x,y,z)

	local GroundElementIndex as integer
	local Position as integer
	local TileCountX as integer
	local TileCountY as integer

	GroundElementIndex = MapSector.Tile[x,y,z].Data.GroundElementIndex
	
	TileCountX = MapSector.TextureImages.GroundNatural[GroundElementIndex].Image.TileCountX
	TileCountY = MapSector.TextureImages.GroundNatural[GroundElementIndex].Image.TileCountY

	if TileCountX > 1 or TileCountY > 1
		if MapSector.TextureImages.GroundNatural[GroundElementIndex].Image.Border = TRUE
			
			Position = 0
			if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE then Position = 3
			if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE then Position = 4
			if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE then Position = 5
			if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE then Position = 6
			
			if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE
					Position = 7
				endif
			endif
			if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE
					Position = 8
				endif
			endif
			if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE
					Position = 9
				endif
			endif
			if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE
					Position = 10
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE
					if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE
						Position = 11
					endif
				endif
			endif
			if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE
					if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE
						Position = 12
					endif
				endif
			endif
			if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE
					if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE
						Position = 13
					endif
				endif
			endif
			if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE
					if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE
						Position = 14
					endif
				endif
			endif
			
			if MapSector.Tile[x,y,z].Data.GroundBorder[CNorth] = TRUE
				if MapSector.Tile[x,y,z].Data.GroundBorder[CEast] = TRUE
					if MapSector.Tile[x,y,z].Data.GroundBorder[CSouth] = TRUE
						if MapSector.Tile[x,y,z].Data.GroundBorder[CWest] = TRUE
							Position = 15
						endif
					endif
				endif
			endif
			
			MapSector.Tile[x,y,z].Data.Texture.PositionX = Random(0,TileCountX - 1)
			if Position = 0
				MapSector.Tile[x,y,z].Data.Texture.PositionY = Random(0,2)
			else
				MapSector.Tile[x,y,z].Data.Texture.PositionY = Position
			endif
		
		else
			MapSector.Tile[x,y,z].Data.Texture.PositionX = Random(0,TileCountX - 1)
			MapSector.Tile[x,y,z].Data.Texture.PositionY = Random(0,TileCountY - 1)
		endif
	else
		MapSector.Tile[x,y,z].Data.Texture.PositionX = 0
		MapSector.Tile[x,y,z].Data.Texture.PositionY = 0
	endif

endfunction



