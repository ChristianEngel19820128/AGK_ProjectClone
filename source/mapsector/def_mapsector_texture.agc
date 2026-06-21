
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMapSectorTextureImageIndexData
	
	Set as integer
	CliffIndex as integer
	PosX as integer
	PosY as integer

endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMapSectorTextureImageData
	
	Enabled as integer
	
	Source as TFilePath
	
	ImageID as integer
	
	Width as integer
	Height as integer

	TileCountX as integer
	TileCountY as integer
	
	Border as integer
	
	TileWidth as integer
	TileHeight as integer

endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMapSectorTextureElement

	Identifier as string
	Name as TText
	Description as TText
		
	Image as TMapSectorTextureImageData
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMapSectorTexture
	
	Ground as TMapSectorTextureElement[-1]
	GroundNatural as TMapSectorTextureElement[-1]
	GroundUrban as TMapSectorTextureElement[-1]
	Cliff as TMapSectorTextureElement[-1]

endtype

