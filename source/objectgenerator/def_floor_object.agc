

//----------------------------------------------------------------------
// data
//----------------------------------------------------------------------

type TObjectData
	
	TileSize as float
	TileHeight as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TDetail
	
	Enabled as integer
	Rows as integer
	Columns as integer
	Segments as integer
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TAngle
	
	Enabled as integer
	Alpha as float
	Beta as float
	Gamma as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TTexture
	
	Identifier as string
	Image as integer
	FilePath as TFilePath
	
endtype

//----------------------------------------------------------------------
// data of floor subobject
//----------------------------------------------------------------------

type TFloorSubObject
	
	SubObjectType as String

	Color as TColor
	
	Detail as TDetail
	Angle as TAngle
	TopLight as integer
	
	Texture as String
	TextureIndex as integer
	
	PrecentCenterX as float
	PrecentCenterY as float
	PrecentCenterZ as float
	
	PercentWidth as float
	PercentHeight as float
	PercentDiameter as float
		
endtype

//----------------------------------------------------------------------
// data of floor objects variants
//----------------------------------------------------------------------

type TFloorObjectVariantData
	
	Color as TColor
	LoopTexture as integer
	SubObject as TFloorSubObject[-1]
	
endtype

//----------------------------------------------------------------------
// data of floor objects types
//----------------------------------------------------------------------

type TFloorObjectTypeData
	
	Identifier as string
	Name as TText
	Description as TText
	Textures as TTexture[-1]
	Variants as TFloorObjectVariantData[-1]
	
endtype

//----------------------------------------------------------------------
// data of floor objects types
//----------------------------------------------------------------------

type TFloorObjectImages

	Enabled as integer
	
	ImageID as integer
	Source as TFilePath
	Identifier as string

endtype
