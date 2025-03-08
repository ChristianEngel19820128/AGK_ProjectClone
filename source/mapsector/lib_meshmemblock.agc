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
		TextureData.Posx = Random(0,3) // pos starts at 0
		TextureData.Posy = Random(0,3) // pos ends at count - 1
		
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

type TMeshTexture
	
	Count as integer
	Size as float
	Posx as integer
	Posy as integer
	
endtype
	
//----------------------------------------------------------------------
// mesh basic type
//----------------------------------------------------------------------

type TMesh
	
	// de-/activate
	Normal as integer
	UV as integer
	Color as integer
	
	// memblock object
	MemBlockID as integer
	MemBlockSize as integer
	MemBlockHeader as TMeshMemblockHeader
	
	x as float
	y as float
	z as float
	
	Size as float
	Height as float
	
	Vertices as TMeshVertex[-1]
	Indices as integer[-1]
	
	Texture as TMeshTexture
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MeshMemBlockInit(Mesh ref as TMesh,Normal,UV,Color,x as float,y as float,z as float,Size as float,Height as float,Texture as TMeshTexture)
	
	local i as integer
	local k as integer
	
	if Mesh.MemBlockID > 0
		DeleteMemblock(Mesh.MemBlockID)
		Mesh.MemBlockID = 0
	endif
	
	Mesh.MemBlockSize = 0
	
	Mesh.Normal = Normal
	Mesh.UV = UV
	Mesh.Color = Color
	
	Mesh.x = x
	Mesh.y = y
	Mesh.z = z
	
	Mesh.Size = Size
	Mesh.Height = Height
	if Height > Size then Mesh.Height = Size
	
	Mesh.Vertices.Length = -1
	Mesh.Indices.Length = -1
	
	Mesh.Texture = Texture
	if Mesh.Texture.Count = 0 then Mesh.Texture.Count = 1
	Mesh.Texture.Size = 1.0 / Mesh.Texture.Count
	if Mesh.Texture.Count = 1
		Mesh.Texture.Posx = 0
		Mesh.Texture.Posy = 0
	endif
	
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
	if Mesh.Normal = 1 then inc Mesh.MemBlockHeader.Attributes
	if Mesh.UV = 1 then inc Mesh.MemBlockHeader.Attributes
	if Mesh.Color = 1 then inc Mesh.MemBlockHeader.Attributes
	
	Mesh.MemBlockHeader.Position.Size = 4 + 12
	Mesh.MemBlockHeader.Position.Offset = 24
	Mesh.MemBlockHeader.VertexSize = 3 * 4
	Offset = Mesh.MemBlockHeader.Position.Offset + Mesh.MemBlockHeader.Position.Size
	
	Mesh.MemBlockHeader.Normal.Size = 4 + 8
	Mesh.MemBlockHeader.Normal.Offset = Mesh.Normal * Offset
	Mesh.MemBlockHeader.VertexSize = Mesh.MemBlockHeader.VertexSize + Mesh.Normal * 3 * 4
	Offset = Offset + Mesh.Normal * Mesh.MemBlockHeader.Normal.Size

	Mesh.MemBlockHeader.UV.Size = 4 + 4
	Mesh.MemBlockHeader.UV.Offset = Mesh.UV * Offset
	Mesh.MemBlockHeader.VertexSize = Mesh.MemBlockHeader.VertexSize + Mesh.UV * 2 * 4
	Offset = Offset + Mesh.UV * Mesh.MemBlockHeader.UV.Size
	
	Mesh.MemBlockHeader.Color.Size = 4 + 8
	Mesh.MemBlockHeader.Color.Offset = Mesh.Color * Offset
	Mesh.MemBlockHeader.VertexSize = Mesh.MemBlockHeader.VertexSize + Mesh.Color * 4
	Offset = Offset + Mesh.Color * Mesh.MemBlockHeader.Color.Size
	
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
			if Mesh.Normal > 0
				
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
			if Mesh.UV > 0
				
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
			if Mesh.Color > 0
				
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
								
				if Mesh.Normal = 1
					nx = Mesh.Vertices[i].Normal.x
					ny = Mesh.Vertices[i].Normal.y
					nz = Mesh.Vertices[i].Normal.z
					SetMeshMemblockVertexNormal(ID,i,nx,ny,nz)
				endif
				
				if Mesh.UV = 1
					u = Mesh.Vertices[i].UV.u
					v = Mesh.Vertices[i].UV.v
					SetMeshMemblockVertexUV(ID,i,u,v)
				endif
					
				if Mesh.Color = 1
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

	Vertex.Position.x = Mesh.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z
	
	Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
	Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	
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

	Vertex.Position.x = Mesh.x + Mesh.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z
	
	Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
	Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	
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

	Vertex.Position.x = Mesh.x + Mesh.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z + Mesh.Size
	
	Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
	Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
	
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

	Vertex.Position.x = Mesh.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z + Mesh.Size
	
	Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
	Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
	
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
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampSouth(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Height / Mesh.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampNorth(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Height / Mesh.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockRampWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = -1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerSouthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Height / Mesh.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	
	Normal.x = -1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerSouthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Height / Mesh.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
	Normal.x = 1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerNorthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = -1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Height / Mesh.Size
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockCornerNorthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Height / Mesh.Size
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchSouthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = -1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Height / Mesh.Size
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchSouthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
	Normal.x = 0
	Normal.y = 1.0
	Normal.z = -1.0 * Mesh.Height / Mesh.Size
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchNorthWest(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Height / Mesh.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	
	Normal.x = -1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockNotchNorthEast(Mesh ref as TMesh)

	local Normal as TMeshVertexNormal

	Normal.x = 0
	Normal.y = 1.0
	Normal.z = 1.0 * Mesh.Height / Mesh.Size
	
	// triangle 1
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	
	Normal.x = 1.0 * Mesh.Height / Mesh.Size
	Normal.y = 1.0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexNorthWest(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexSouthVerticalSouthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z
	
	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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

	Vertex.Position.x = Mesh.x + Mesh.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z

	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Height,Normal)
	
	Normal.x = 0
	Normal.y = 0
	Normal.z = -1.0
	
	// triangle 2
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,0,Normal)
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexSouthVerticalSouthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexSouthVerticalSouthWest(Mesh,Mesh.Height,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexNorthVerticalNorthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z + Mesh.Size
	
	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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

	Vertex.Position.x = Mesh.x + Mesh.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z + Mesh.Size

	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Height,Normal)
	
	Normal.x = 0
	Normal.y = 0
	Normal.z = 1.0
	
	// triangle 2
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,0,Normal)
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Height,Normal)	
	
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
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexNorthVerticalNorthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexNorthVerticalNorthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexEastVerticalSouthEast(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.x + Mesh.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z
	
	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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

	Vertex.Position.x = Mesh.x + Mesh.Size
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z + Mesh.Size

	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Height,Normal)
	
	Normal.x = 1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Height,Normal)	
	
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
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,0,Normal)	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,0,Normal)	
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexEastVerticalNorthEast(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexEastVerticalSouthEast(Mesh,0,Normal)
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MeshMemBlockVertexWestVerticalSouthWest(Mesh ref as TMesh,Height as float,Normal as TMeshVertexNormal)
	
	local Vertex as TMeshVertex

	Vertex.Position.x = Mesh.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z
	
	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx + Mesh.Texture.Size
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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

	Vertex.Position.x = Mesh.x
	Vertex.Position.y = Height
	Vertex.Position.z = Mesh.z + Mesh.Size

	if Height = 0
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy + Mesh.Texture.Size
	else
		Vertex.UV.u = Mesh.Texture.Size * Mesh.Texture.Posx
		Vertex.UV.v = Mesh.Texture.Size * Mesh.Texture.Posy
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
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Height,Normal)
	
	Normal.x = -1.0
	Normal.y = 0
	Normal.z = 0
	
	// triangle 2
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,0,Normal)
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Height,Normal)	
	
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
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Height,Normal)	
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Height,Normal)	
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,Mesh.Height,Normal)
	
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
	MeshMemBlockVertexWestVerticalSouthWest(Mesh,Mesh.Height,Normal)
	MeshMemBlockVertexWestVerticalNorthWest(Mesh,0,Normal)
	
endfunction











