
//----------------------------------------------------------------------
// data of floor subobject
//----------------------------------------------------------------------

type TFloorSubObject
	
	SubObjectType as String

	Color as TColor
	
	Texture as String

	PrecentCenterX as integer
	PrecentCenterY as integer
	PrecentCenterZ as integer
	
	PercentWidth as integer
	PercentHeight as integer
	PercentDiameter as integer
		
endtype

//----------------------------------------------------------------------
// data of floor objects variants
//----------------------------------------------------------------------

type TFloorObjectVariantData
	
	Color as TColor
	SubObject as TFloorSubObject[-1]
	
endtype

//----------------------------------------------------------------------
// data of floor objects types
//----------------------------------------------------------------------

type TFloorObjectTypeData
	
	Identifier as string
	Name as TText
	Description as TText
	
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
