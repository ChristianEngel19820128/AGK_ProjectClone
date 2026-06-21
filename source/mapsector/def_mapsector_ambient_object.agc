
//----------------------------------------------------------------------
// image texture of ambient objects
//----------------------------------------------------------------------

type TAmbientObjectImageData
	
	Enabled as integer	
	
	Source as TFilePath
	
	Width as integer
	Height as integer
	
	ImageID as integer
	
endtype

//----------------------------------------------------------------------
// data of ambient objects types
//----------------------------------------------------------------------

type TAmbientObjectTypeData
	
	Identifier as string
	Name as TText
	Description as TText
	
	VariantImages as TAmbientObjectImageData[-1]
	
endtype
