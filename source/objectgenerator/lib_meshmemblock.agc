//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

// lib_meshmemblock
// Version: 1.0

// lib for creating low poly mesh elements to load from memblock to an object
// if connected in an object a low poly map is possible
// split the full map into clusters of multi meshed objects if use
// that will increase the performance
// object clusters of 10 x 10 mesh elements are good for a big map
// it is possible to use more than 20 x 20 mesh elements
// but it depends of view range and mesh size

//----------------------------------------------------------------------
// test code for copy to main file
// creates a simple plane
//----------------------------------------------------------------------

/*

#option_explicit

#include "lib_meshmemblock.agc"

function TestPlane(ObjectID,ImageID)

	local x as integer
	local z as integer
	
	local TextureData as TMeshTexture
	local Mesh as TMesh
	local MeshIndex as integer
	
	for x = 0 to 3
	for z = 0 to 3
		
		TextureData.Count = 4 // = 4x4 possible example textures for this mesh
		TextureData.PosX = Random(0,3) // pos starts at 0
		TextureData.PosY = Random(0,3) // pos ends at count - 1
		
		MeshMemBlockInit(Mesh,1,1,1,x*5,0,z*5,5,5,TextureData)
		
		select Random(0,3)
			case 0
				MeshMemBlockPlane(Mesh)
			endcase
			case 1
				MeshMemBlockRampSouth(Mesh)
			endcase
			case 2
				MeshMemBlockCornerSouthWest(Mesh)
			endcase
			case 3
				MeshMemBlockNotchSouthWest(Mesh)
			endcase
		endselect
		
		MeshMemBlockCreate(Mesh)
		
		if ObjectID = 0
			ObjectID = CreateObjectFromMeshMemblock(Mesh.MemBlockID)
		else
			AddObjectMeshFromMemblock(ObjectID,Mesh.MemBlockID)
		endif
		
		MeshIndex = GetObjectNumMeshes(ObjectID)
		SetObjectMeshImage(ObjectID,MeshIndex,ImageID,0)

	next z
	next x

	DeleteMemblock(Mesh.MemBlockID)

endfunction

// main start

SetCameraPosition(1,-15,15,-15)
SetCameraLookAt(1,0,0,0,0)

global img as integer
global obj as integer

img = LoadImage("tex.png")

TestPlane(obj,img)

*/

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TMeshVertexPosition
	
	x as float
	y as float
	z as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TMeshVertexNormal
	
	x as float
	y as float
	z as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TMeshVertexUV
	
	u as float
	v as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TMeshVertexColor
	
	Red as integer
	Green as integer
	Blue as integer
	Alpha as integer
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TMeshVertex
	
	Position as TMeshVertexPosition	
	Normal as TMeshVertexNormal
	UV as TMeshVertexUV
	Color as TMeshVertexColor
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TMeshAttributes
	
	Offset as integer
	Size as integer
	
	DataType as integer
	ComponentCount as integer
	NormalizeFlag as integer
	StringLength as integer
	
endtype

//----------------------------------------------------------------------
// mesh header
//----------------------------------------------------------------------

type TMeshMemblockHeader
	
	// main header
	Vertices as integer
	Indices as integer
	Attributes as integer
	VertexSize as integer
	VertexOffset as integer
	IndexSize as integer
	IndexOffset as integer
	
	// attribute data
	Position as TMeshAttributes
	Normal as TMeshAttributes
	UV as TMeshAttributes
	Color as TMeshAttributes
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMeshAttributesData
	
	Normal as integer
	UV as integer
	Color as integer
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMeshTextureData
	
	CountX as integer
	CountY as integer
	SizeX as float
	SizeY as float
	PosX as integer
	PosY as integer
	
endtype

//----------------------------------------------------------------------
// mesh basic type
//----------------------------------------------------------------------

type TMeshData
	
	x as float
	y as float
	z as float
	
	Size as float
	Height as float
	
endtype

//----------------------------------------------------------------------
// mesh basic type
//----------------------------------------------------------------------

type TMesh
	
	// memblock object
	MemBlockID as integer
	MemBlockSize as integer
	MemBlockHeader as TMeshMemblockHeader
	
	// de-/activate
	Attributes as TMeshAttributesData
	
	// position and size
	Data as TMeshData
	
	// vertex data
	Vertices as TMeshVertex[-1]
	OriginalVertices as TMeshVertex[-1]
	Indices as integer[-1]
	
	// texture image data
	TextureData as TMeshTextureData
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockInit(Mesh ref as TMesh,Attributes as TMeshAttributesData,Data as TMeshData,TextureData as TMeshTextureData)
	
	if Mesh.MemBlockID > 0
		DeleteMemblock(Mesh.MemBlockID)
		Mesh.MemBlockID = 0
	endif
	
	Mesh.MemBlockSize = 0
	
	Mesh.Attributes = Attributes

	Mesh.Data = Data
	
	if Data.Height > Data.Size then Mesh.Data.Height = Data.Size
	
	Mesh.Vertices.Length = -1
	Mesh.Indices.Length = -1
	
	Mesh.TextureData = TextureData

	if Mesh.TextureData.CountX = 0 then Mesh.TextureData.CountX = 1
	Mesh.TextureData.SizeX = 1.0 / Mesh.TextureData.CountX
	if Mesh.TextureData.CountX = 1 then Mesh.TextureData.PosX = 0
	
	if Mesh.TextureData.CountY = 0 then Mesh.TextureData.CountY = 1
	Mesh.TextureData.SizeY = 1.0 / Mesh.TextureData.CountY
	if Mesh.TextureData.CountY = 1 then Mesh.TextureData.PosY = 0
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockCheckAndCreate(Mesh ref as TMesh)
	
	if Mesh.MemBlockID > 0
		DeleteMemblock(Mesh.MemBlockID)
		Mesh.MemBlockID = 0
	endif
	
	if Mesh.MemBlockSize > 0
		Mesh.MemBlockID = CreateMemblock(Mesh.MemBlockSize)
	endif		
		
endfunction
	
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockCalcMemBlockSize(Mesh ref as TMesh)
	
	local Offset as integer
	
	Mesh.MemBlockHeader.Vertices = Mesh.Vertices.Length + 1
	Mesh.MemBlockHeader.Indices = Mesh.Indices.Length + 1
	
	Mesh.MemBlockHeader.Attributes = 1
	if Mesh.Attributes.Normal = 1 then inc Mesh.MemBlockHeader.Attributes
	if Mesh.Attributes.UV = 1 then inc Mesh.MemBlockHeader.Attributes
	if Mesh.Attributes.Color = 1 then inc Mesh.MemBlockHeader.Attributes
	
	Mesh.MemBlockHeader.Position.Size = 4 + 12
	Mesh.MemBlockHeader.Position.Offset = 24
	Mesh.MemBlockHeader.VertexSize = 3 * 4
	Offset = Mesh.MemBlockHeader.Position.Offset + Mesh.MemBlockHeader.Position.Size
	
	Mesh.MemBlockHeader.Normal.Size = 4 + 8
	Mesh.MemBlockHeader.Normal.Offset = Mesh.Attributes.Normal * Offset
	Mesh.MemBlockHeader.VertexSize = Mesh.MemBlockHeader.VertexSize + Mesh.Attributes.Normal * 3 * 4
	Offset = Offset + Mesh.Attributes.Normal * Mesh.MemBlockHeader.Normal.Size

	Mesh.MemBlockHeader.UV.Size = 4 + 4
	Mesh.MemBlockHeader.UV.Offset = Mesh.Attributes.UV * Offset
	Mesh.MemBlockHeader.VertexSize = Mesh.MemBlockHeader.VertexSize + Mesh.Attributes.UV * 2 * 4
	Offset = Offset + Mesh.Attributes.UV * Mesh.MemBlockHeader.UV.Size
	
	Mesh.MemBlockHeader.Color.Size = 4 + 8
	Mesh.MemBlockHeader.Color.Offset = Mesh.Attributes.Color * Offset
	Mesh.MemBlockHeader.VertexSize = Mesh.MemBlockHeader.VertexSize + Mesh.Attributes.Color * 4
	Offset = Offset + Mesh.Attributes.Color * Mesh.MemBlockHeader.Color.Size
	
	Mesh.MemBlockHeader.VertexOffset = Offset
	
	Mesh.MemBlockHeader.IndexSize = 4	
	Mesh.MemBlockHeader.IndexOffset = Mesh.MemBlockHeader.VertexOffset + Mesh.MemBlockHeader.VertexSize * Mesh.MemBlockHeader.Vertices
		
	Mesh.MemBlockSize = Mesh.MemBlockHeader.IndexOffset + Mesh.MemBlockHeader.IndexSize * Mesh.MemBlockHeader.Indices
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWritePosition(Mesh ref as TMesh)

	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			
			SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Position.Offset+0,0)
			SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Position.Offset+1,3)
			SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Position.Offset+2,0)
			SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Position.Offset+3,12)
			
			SetMemblockString(Mesh.MemBlockID,Mesh.MemBlockHeader.Position.Offset+4,"position")
			
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteNormal(Mesh ref as TMesh)

	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			if Mesh.Attributes.Normal > 0
				
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Normal.Offset+0,0)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Normal.Offset+1,3)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Normal.Offset+2,0)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Normal.Offset+3,8)
			
				SetMemblockString(Mesh.MemBlockID,Mesh.MemBlockHeader.Normal.Offset+4,"normal")
				
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteUV(Mesh ref as TMesh)

	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			if Mesh.Attributes.UV > 0
				
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.UV.Offset+0,0)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.UV.Offset+1,2)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.UV.Offset+2,0)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.UV.Offset+3,4)
			
				SetMemblockString(Mesh.MemBlockID,Mesh.MemBlockHeader.UV.Offset+4,"uv")
				
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteColor(Mesh ref as TMesh)

	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			if Mesh.Attributes.Color > 0
				
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Color.Offset+0,1)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Color.Offset+1,4)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Color.Offset+2,1)
				SetMemblockByte(Mesh.MemBlockID,Mesh.MemBlockHeader.Color.Offset+3,8)
			
				SetMemblockString(Mesh.MemBlockID,Mesh.MemBlockHeader.Color.Offset+4,"color")
				
			endif
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteAttributes(Mesh ref as TMesh)
	
	MeshMemBlockWritePosition(Mesh)
	MeshMemBlockWriteNormal(Mesh)
	MeshMemBlockWriteUV(Mesh)
	MeshMemBlockWriteColor(Mesh)
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteHeader(Mesh ref as TMesh)
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			
			SetMemblockInt(Mesh.MemBlockID,0,Mesh.MemBlockHeader.Vertices)
			SetMemblockInt(Mesh.MemBlockID,4,Mesh.MemBlockHeader.Indices) 
			SetMemblockInt(Mesh.MemBlockID,8,Mesh.MemBlockHeader.Attributes)
			SetMemblockInt(Mesh.MemBlockID,12,Mesh.MemBlockHeader.VertexSize)
			SetMemblockInt(Mesh.MemBlockID,16,Mesh.MemBlockHeader.VertexOffset)
			SetMemblockInt(Mesh.MemBlockID,20,Mesh.MemBlockHeader.IndexOffset)
			
			MeshMemBlockWriteAttributes(Mesh)
	
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteVertices(Mesh ref as TMesh)
	
	local ID as integer
		
	local vx as float
	local vy as float
	local vz as float
	
	local nx as float
	local ny as float
	local nz as float
	
	local u as float
	local v as float
	
	local r as integer
	local g as integer
	local b as integer
	local a as integer
	
	local i as integer
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			
			ID = Mesh.MemblockID
			
			for i = 0 to Mesh.Vertices.Length
				
				vx = Mesh.Vertices[i].Position.x
				vy = Mesh.Vertices[i].Position.y
				vz = Mesh.Vertices[i].Position.z
				
				SetMeshMemblockVertexPosition(ID,i,vx,vy,vz)
								
				if Mesh.Attributes.Normal = 1
					nx = Mesh.Vertices[i].Normal.x
					ny = Mesh.Vertices[i].Normal.y
					nz = Mesh.Vertices[i].Normal.z
					SetMeshMemblockVertexNormal(ID,i,nx,ny,nz)
				endif
				
				if Mesh.Attributes.UV = 1
					u = Mesh.Vertices[i].UV.u
					v = Mesh.Vertices[i].UV.v
					SetMeshMemblockVertexUV(ID,i,u,v)
				endif
					
				if Mesh.Attributes.Color = 1
					r = Mesh.Vertices[i].Color.Red
					g = Mesh.Vertices[i].Color.Green
					b = Mesh.Vertices[i].Color.Blue
					a = Mesh.Vertices[i].Color.Alpha
					SetMeshMemblockVertexColor(ID,i,r,g,b,a)
				endif
				
			next i
			
		endif
	endif
			
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockWriteIndices(Mesh ref as TMesh)

	local i as integer
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			
			for i = 0 to Mesh.Indices.Length
				SetMemblockInt(Mesh.MemBlockID,Mesh.MemBlockHeader.IndexOffset + i * 4,Mesh.Indices[i])
			next i
			
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCreate(Mesh ref as TMesh)
	
	MeshMemBlockCalcMemBlockSize(Mesh)
	MeshMemBlockCheckAndCreate(Mesh)
	MeshMemBlockWriteHeader(Mesh)
	MeshMemBlockWriteVertices(Mesh)
	MeshMemBlockWriteIndices(Mesh)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexSouthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex
	local obj as integer

	Vertex.Position.x = Mesh.Data.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z
	
	Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
	Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexSouthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x + Mesh.Data.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z
	
	Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
	Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexNorthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x + Mesh.Data.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z + Mesh.Data.Size
	
	Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
	Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexNorthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z + Mesh.Data.Size
	
	Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
	Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockPlane(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampSouth(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampNorth(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerSouthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerSouthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerNorthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerNorthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchSouthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchSouthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchNorthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	Normal.x = -1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchNorthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	
	Normal.x = 1.0 * Mesh.Data.Height / Mesh.Data.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexSouthVerticalSouthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z
	
	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexSouthVerticalSouthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x + Mesh.Data.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z

	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
		
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffSouth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 1
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 2
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfSouthToWest(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 1		
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfSouthToEast(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 1	
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelSouthToWest(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 1
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelSouthToEast(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 1
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexNorthVerticalNorthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z + Mesh.Data.Size
	
	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexNorthVerticalNorthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x + Mesh.Data.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z + Mesh.Data.Size

	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
		
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffNorth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 1
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,0,Normal)	
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 2
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)	
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfNorthToWest(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 1
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfNorthToEast(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 1
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelNorthToWest(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 1
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelNorthToEast(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 1	
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexEastVerticalSouthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x + Mesh.Data.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z
	
	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexEastVerticalNorthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x + Mesh.Data.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z + Mesh.Data.Size

	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
		
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffEast(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,0,Normal)	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)	
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfEastToNorth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfEastToSouth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,0,Normal)	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelEastToNorth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,0,Normal)	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelEastToSouth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexWestVerticalSouthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z
	
	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX + Mesh.TextureData.SizeX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
	
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexWestVerticalNorthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.Data.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.Data.z + Mesh.Data.Size

	if Height = 0
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY + Mesh.TextureData.SizeY
	else
		Vertex.UV.u = Mesh.TextureData.SizeX * Mesh.TextureData.PosX
		Vertex.UV.v = Mesh.TextureData.SizeY * Mesh.TextureData.PosY
	endif
		
	Vertex.Normal.x = Normal.x
	Vertex.Normal.y = Normal.y
	Vertex.Normal.z = Normal.z
	
	Vertex.Color.Red = 255
	Vertex.Color.Green = 255
	Vertex.Color.Blue = 255
	Vertex.Color.Alpha = 255
		
	Mesh.Vertices.Insert(Vertex)	
	Mesh.Indices.Insert(Mesh.Vertices.Length)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffWest(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,0,Normal)	
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	
	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)	
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfWestToSouth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)	
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCliffHalfWestToNorth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)	
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelWestToSouth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,0,Normal)	
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Data.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockBevelWestToNorth(Mesh ref as TMesh)
	
	local Normal as TMeshVertexNormal

	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 1	
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Data.Height,Normal)
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockGetFromMeshObject(Mesh ref as TMesh,ObjectID as integer,MeshID as integer)
	
	Mesh.MemBlockID = CreateMemblockFromObjectMesh(ObjectID,MeshID)
	
	if Mesh.MemBlockID > 0
		Mesh.MemBlockSize = GetMemblockSize(Mesh.MemBlockID)
		MeshMemBlockReadHeader(Mesh)
		MeshMemBlockReadData(Mesh)
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockReadHeader(Mesh ref as TMesh)
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			Mesh.MemBlockHeader.Vertices     = GetMemblockInt(Mesh.MemBlockID,0)
			Mesh.MemBlockHeader.Indices      = GetMemblockInt(Mesh.MemBlockID,4)
			Mesh.MemBlockHeader.Attributes   = GetMemblockInt(Mesh.MemBlockID,8)
			Mesh.MemBlockHeader.VertexSize   = GetMemblockInt(Mesh.MemBlockID,12)
			Mesh.MemBlockHeader.VertexOffset = GetMemblockInt(Mesh.MemBlockID,16)
			Mesh.MemBlockHeader.IndexOffset  = GetMemblockInt(Mesh.MemBlockID,20)
			Mesh.MemBlockHeader.IndexSize    = 4
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockReadData(Mesh ref as TMesh)
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			MeshMemBlockReadAttributesData(Mesh)
			MeshMemBlockReadVertices(Mesh)
			MeshMemBlockReadIndices(Mesh)
		endif
	endif
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockReadAttributesData(Mesh ref as TMesh)
	
	local Offset as integer
	local DataType as integer
	local ComponentCount as integer
	local NormalizeFlag as integer
	local StringLength as integer
	local AttributeName as string
	
	local i as integer
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
					
			Offset = 24
			
			for i = 0 to Mesh.MemBlockHeader.Attributes -1
				
				DataType = GetMemblockByte(Mesh.MemBlockID,Offset+0)
				ComponentCount = GetMemblockByte(Mesh.MemBlockID,Offset+1)
				NormalizeFlag = GetMemblockByte(Mesh.MemBlockID,Offset+2)
				StringLength = GetMemblockByte(Mesh.MemBlockID,Offset+3)
						
				AttributeName = GetMemblockString(Mesh.MemBlockID,Offset+4,StringLength)
				
				select AttributeName
					case "position"
						Mesh.MemBlockHeader.Position.Offset = Offset
						Mesh.MemBlockHeader.Position.Size = 4 + StringLength
						Mesh.MemBlockHeader.Position.DataType = DataType
						Mesh.MemBlockHeader.Position.ComponentCount = ComponentCount
						Mesh.MemBlockHeader.Position.NormalizeFlag = NormalizeFlag
						Mesh.MemBlockHeader.Position.StringLength = StringLength
					endcase
					case "normal"
						Mesh.MemBlockHeader.Normal.Offset = Offset
						Mesh.MemBlockHeader.Normal.Size = 4 + StringLength
						Mesh.MemBlockHeader.Normal.DataType = DataType
						Mesh.MemBlockHeader.Normal.ComponentCount = ComponentCount
						Mesh.MemBlockHeader.Normal.NormalizeFlag = NormalizeFlag
						Mesh.MemBlockHeader.Normal.StringLength = StringLength
						Mesh.Attributes.Normal = 1
					endcase
					case "uv"
						Mesh.MemBlockHeader.UV.Offset = Offset
						Mesh.MemBlockHeader.UV.Size = 4 + StringLength
						Mesh.MemBlockHeader.UV.DataType = DataType
						Mesh.MemBlockHeader.UV.ComponentCount = ComponentCount
						Mesh.MemBlockHeader.UV.NormalizeFlag = NormalizeFlag
						Mesh.MemBlockHeader.UV.StringLength = StringLength
						Mesh.Attributes.UV = 1
					endcase
					case "color"
						Mesh.MemBlockHeader.Color.Offset = Offset
						Mesh.MemBlockHeader.Color.Size = 4 + StringLength
						Mesh.MemBlockHeader.Color.DataType = DataType
						Mesh.MemBlockHeader.Color.ComponentCount = ComponentCount
						Mesh.MemBlockHeader.Color.NormalizeFlag = NormalizeFlag
						Mesh.MemBlockHeader.Color.StringLength = StringLength
						Mesh.Attributes.Color = 1
					endcase
				endselect
				
				
				Offset = Offset + 4 + StringLength
				
			next
			
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockReadVertices(Mesh ref as TMesh)
	
	local i as integer
	local Vertex as TMeshVertex
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			
			for i = 0 to Mesh.MemBlockHeader.Vertices -1
				
				Vertex.Position.x = GetMeshMemblockVertexX(Mesh.MemBlockID,i)
				Vertex.Position.y = GetMeshMemblockVertexY(Mesh.MemBlockID,i)
				Vertex.Position.z = GetMeshMemblockVertexZ(Mesh.MemBlockID,i)
				
				if Mesh.Attributes.Normal = 1
					Vertex.Normal.x = GetMeshMemblockVertexNormalX(Mesh.MemBlockID,i)
					Vertex.Normal.y = GetMeshMemblockVertexNormalY(Mesh.MemBlockID,i)
					Vertex.Normal.z = GetMeshMemblockVertexNormalZ(Mesh.MemBlockID,i)
				endif
				
				if Mesh.Attributes.UV = 1
					Vertex.UV.u = GetMeshMemblockVertexU(Mesh.MemBlockID,i)
					Vertex.UV.v = GetMeshMemblockVertexV(Mesh.MemBlockID,i)
				endif
				
				if Mesh.Attributes.Color = 1
					Vertex.Color.Red = GetMeshMemblockVertexRed(Mesh.MemBlockID,i)
					Vertex.Color.Green = GetMeshMemblockVertexGreen(Mesh.MemBlockID,i)
					Vertex.Color.Blue = GetMeshMemblockVertexBlue(Mesh.MemBlockID,i)
					Vertex.Color.Alpha = GetMeshMemblockVertexAlpha(Mesh.MemBlockID,i)
				endif
				
				Mesh.OriginalVertices.Insert(Vertex)
				
			next
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockReadIndices(Mesh ref as TMesh)
	
	local i as integer
	local Index as integer
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			for i = 0 to Mesh.MemBlockHeader.Indices - 1
				Index = GetMemblockInt(Mesh.MemBlockID,Mesh.MemBlockHeader.IndexOffset+i*Mesh.MemBlockHeader.IndexSize)
				Mesh.Indices.Insert(Index)
			next
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockSetData(Mesh ref as TMesh,Data ref as TMeshData,Color ref as TMeshVertexColor)
	
	local i as integer
	
	local Vertex as TMeshVertex
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
			
			Mesh.Data = Data
			Mesh.Attributes.Color = 1
						
			for i = 0 to Mesh.MemBlockHeader.Vertices -1
				
				Vertex = Mesh.OriginalVertices[i]
				
				Vertex.Position.x = Mesh.Data.x + Mesh.OriginalVertices[i].Position.x
				Vertex.Position.y = Mesh.Data.y + Mesh.OriginalVertices[i].Position.y
				Vertex.Position.z = Mesh.Data.z + Mesh.OriginalVertices[i].Position.z
				
				Vertex.Color = Color
				
				Mesh.Vertices.Insert(Vertex)
				
			next i
			
			MeshMemBlockCreate(Mesh)
			
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRotate(Mesh ref as TMesh,Alpha as float,Beta as float,Gamma as float)
	
	local i as integer
	local x as float
	local y as float
	local z as float
	local nx as float
	local ny as float
	local nz as float
	
	// 1. Sinus/Cosinus für LOKALE Rotation (Alpha = Y, Beta = X)
	local cosA as float, sinA as float
	cosA = cos(Alpha)
	sinA = sin(Alpha)
	
	local cosB as float, sinB as float
	cosB = cos(Beta)
	sinB = sin(Beta)
	
	// 2. Sinus/Cosinus für GLOBALE Rotation (Gamma = Y-Achse um den Ursprung 0,0,0)
	local cosG as float, sinG as float
	cosG = cos(Gamma)
	sinG = sin(Gamma)
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
	
			for i = 0 to Mesh.Vertices.Length
				
				// --- SCHRITT 1: LOKALE ROTATION UM DAS TEIL-ZENTRUM ---
				x = Mesh.OriginalVertices[i].Position.X
				y = Mesh.OriginalVertices[i].Position.Y
				z = Mesh.OriginalVertices[i].Position.Z
				
				// Lokal um Y (Alpha)
				local xLokalRotY as float
				local zLokalRotY as float
				xLokalRotY = x * cosA + z * sinA
				zLokalRotY = -x * sinA + z * cosA
				
				// Lokal um X (Beta)
				local xLokalNeu as float
				local yLokalNeu as float
				local zLokalNeu as float
				xLokalNeu = xLokalRotY
				yLokalNeu = y * cosB - zLokalRotY * sinB
				zLokalNeu = y * sinB + zLokalRotY * cosB
				
				// Verschiebung zum Teil-Zentrum (Mesh.Data), um die Weltposition des Teils zu erhalten
				local xWeltVorGamma as float
				local yWeltVorGamma as float
				local zWeltVorGamma as float
				xWeltVorGamma = Mesh.Data.x + xLokalNeu
				yWeltVorGamma = Mesh.Data.y + yLokalNeu
				zWeltVorGamma = Mesh.Data.z + zLokalNeu
				
				
				// --- SCHRITT 2: GLOBALE ROTATION (GAMMA) UM DEN URSPRUNG (0,0,0) ---
				// Da wir um den Ursprung kreisen, nutzen wir direkt die berechneten Weltkoordinaten
				Mesh.Vertices[i].Position.X = xWeltVorGamma * cosG + zWeltVorGamma * sinG
				Mesh.Vertices[i].Position.Y = yWeltVorGamma // Y bleibt bei Y-Achsenrotation unverändert
				Mesh.Vertices[i].Position.Z = -xWeltVorGamma * sinG + zWeltVorGamma * cosG
				
				
				// --- SCHRITT 3: NORMALEN ROTIEREN ---
				// Normalen sind Richtungen, keine Positionen. Sie ignorieren das Zentrum (Mesh.Data),
				// müssen aber nacheinander von Alpha/Beta UND Gamma gedreht werden.
				nx = Mesh.OriginalVertices[i].Normal.X
				ny = Mesh.OriginalVertices[i].Normal.Y
				nz = Mesh.OriginalVertices[i].Normal.Z
				
				// Lokal (Alpha)
				local nxLRotY as float, nzLRotY as float
				nxLRotY = nx * cosA + nz * sinA
				nzLRotY = -nx * sinA + nz * cosA
				
				// Lokal (Beta)
				local nxLNeu as float, nyLNeu as float, nzLNeu as float
				nxLNeu = nxLRotY
				nyLNeu = ny * cosB - nzLRotY * sinB
				nzLNeu = ny * sinB + nzLRotY * cosB
				
				// Global (Gamma) auf die bereits rotierten Normalen anwenden
				Mesh.Vertices[i].Normal.X = nxLNeu * cosG + nzLNeu * sinG
				Mesh.Vertices[i].Normal.Y = nyLNeu
				Mesh.Vertices[i].Normal.Z = -nxLNeu * sinG + nzLNeu * cosG
								
			next i
			
			MeshMemBlockWriteVertices(Mesh)
		
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemblockUVMirror(Mesh ref as TMesh)
	
	local i as integer
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
		
			for i = 0 to Mesh.Vertices.Length
				
				// --- 3. UV-KOORDINATEN SPIEGELN (FALLS RÜCKSEITE) ---
				// Wir prüfen das Original-Mesh: Zeigt die Ur-Normale nach hinten (Z < 0)?
				if Mesh.OriginalVertices[i].Normal.Z < 0.0
					// Rückseite: U-Koordinate horizontal flippen
					Mesh.Vertices[i].UV.u = 1.0 - Mesh.OriginalVertices[i].UV.u
				else
					// Vorderseite: Normale UV-Koordinate beibehalten
					Mesh.Vertices[i].UV.u = Mesh.OriginalVertices[i].UV.u
				endif
				
				// V-Koordinate bleibt vertikal immer gleich
				Mesh.Vertices[i].UV.v = Mesh.OriginalVertices[i].UV.v
				
			next i
			
			MeshMemBlockWriteVertices(Mesh)
			
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemblockSetTopLight(Mesh ref as TMesh)
	
	local i as integer
	
	if Mesh.MemBlockID > 0
		if Mesh.MemBlockSize > 0
		
			for i = 0 to Mesh.Vertices.Length
				Mesh.Vertices[i].Normal.X = 0
				Mesh.Vertices[i].Normal.Y = 1
				Mesh.Vertices[i].Normal.Z = 0
			next i
			
			MeshMemBlockWriteVertices(Mesh)
			
		endif
	endif
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockClear(Mesh ref as TMesh)
	
	Mesh.Data.x = 0
	Mesh.Data.y = 0
	Mesh.Data.z = 0
	
	Mesh.Data.Size = 0	
	Mesh.Data.Height = 0
	
	Mesh.MemBlockSize = 0
	
	Mesh.Attributes.Normal = 0
	Mesh.Attributes.UV = 0
	Mesh.Attributes.Color = 0
	
	Mesh.MemBlockHeader.Attributes = 0
	
	Mesh.MemBlockHeader.IndexOffset = 0
	Mesh.MemBlockHeader.IndexSize = 0
	Mesh.MemBlockHeader.Indices = 0
	Mesh.MemBlockHeader.VertexOffset = 0
	Mesh.MemBlockHeader.VertexSize = 0
	Mesh.MemBlockHeader.Vertices = 0
	
	Mesh.OriginalVertices.Length = -1
	Mesh.Vertices.Length = -1
	Mesh.Indices.Length = -1
	
	DeleteMemblock(Mesh.MemBlockID)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockSaveToFile(FileID as integer,FilePath ref as TFilePath,Mesh ref as TMesh,MeshCount as integer,VertexCount as integer)
	
	local s as string
	local i as integer
	
	if FilePathSet(FilePath) = TRUE
		
		if FileID = 0
			FileID = OpenToWrite(FilePath.Name,0)
		else
			OpenToWrite(FileID,FilePath.Name,1)
		endif
		
		s = "o Mesh_" + str(MeshCount)
		WriteLine(FileID,s)
		
		for i = 0 to Mesh.Vertices.Length
			s = "v " + str(Mesh.Vertices[i].Position.x) + " " + str(Mesh.Vertices[i].Position.y) + " " + str(-Mesh.Vertices[i].Position.z)
			WriteLine(FileID,s)
		next i
		
		for i = 0 to Mesh.Vertices.Length
			s = "vt " + str(Mesh.Vertices[i].UV.u) + " " + str(1.0-Mesh.Vertices[i].UV.v)
			WriteLine(FileID,s)
		next i
		
		for i = 0 to Mesh.Vertices.Length
			s = "vn " + str(Mesh.Vertices[i].Normal.x) + " " + str(Mesh.Vertices[i].Normal.y) + " " + str(-Mesh.Vertices[i].Normal.z)
			WriteLine(FileID,s)
		next i
		
		if Mesh.Indices.Length > -1
			for i = 0 to Mesh.Indices.Length step 3
				s = "f " +str(VertexCount+Mesh.Indices[i]+1) + "/" + str(VertexCount+Mesh.Indices[i]+1) + "/" + str(VertexCount+Mesh.Indices[i]+1)
				s = s + " " + str(VertexCount+Mesh.Indices[i+1]+1) + "/" + str(VertexCount+Mesh.Indices[i+1]+1) + "/" + str(VertexCount+Mesh.Indices[i+1]+1)
				s = s + " " + str(VertexCount+Mesh.Indices[i+2]+1) + "/" + str(VertexCount+Mesh.Indices[i+2]+1) + "/" + str(VertexCount+Mesh.Indices[i+2]+1)
				WriteLine(FileID,s)
			next i
		else
			for i = 1 to Mesh.Vertices.Length + 1 step 3
				s = "f " + str(VertexCount+i) + "/" + str(VertexCount+i) + "/" + str(VertexCount+i)
				s = s + " " + str(VertexCount+i+1) + "/" + str(VertexCount+i+1) + "/" + str(VertexCount+i+1)
				s = s + " " + str(VertexCount+i+2) + "/" + str(VertexCount+i+2) + "/" + str(VertexCount+i+2)
				WriteLine(FileID, s)
			next i
		endif
		
		CloseFile(FileID)
		
	endif
		
endfunction FileID

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------


