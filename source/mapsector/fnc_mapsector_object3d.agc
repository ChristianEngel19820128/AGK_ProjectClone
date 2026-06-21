
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorClusterObjectSetDefaultProperties(MultiMeshObject,x as float,y as float,z as float)
			
	if MultiMeshObject > 0
		// set default properties of the given object	
		SetObjectPosition(MultiMeshObject,x,y,z)
		SetObjectCollisionMode(MultiMeshObject,0)
		SetObjectCullMode(MultiMeshObject,1)
		SetObjectLightMode(MultiMeshObject,1)	
		SetObjectCastShadow(MultiMeshObject,1)
		SetObjectReceiveShadow(MultiMeshObject,1)
		SetObjectFogMode(MultiMeshObject,1)
	endif	
				
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorObjectMeshCreate(Mesh ref as TMesh,Tile ref as TMapSectorTile,MultiMeshObject,ImageID)

	local ObjectID as integer
	
	if Mesh.MemBlockID > 0
		
		ObjectID = MultiMeshObject
		
		if ObjectID = 0
			// create object
			ObjectID = CreateObjectFromMeshMemblock(Mesh.MemBlockID)
		else
			// add mesh to object
			AddObjectMeshFromMemblock(ObjectID,Mesh.MemBlockID)
		endif
		
		MapSectorLastObjectMeshTileGroundDataSet(Tile,ObjectID,ImageID)
		
		if Mesh.MemBlockID > 0
			DeleteMemblock(Mesh.MemBlockID)
	 		Mesh.MemBlockID = 0
 		endif
 		
	endif
	
endfunction ObjectID

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorLastObjectMeshTileGroundDataSet(Tile ref as TMapSectorTile,MultiMeshObject,ImageID)
	
	local MeshCount as integer
	
	if MultiMeshObject > 0
		// get last mesh index
		MeshCount = GetObjectNumMeshes(MultiMeshObject)
		// set mesh texture image
		SetObjectMeshImage(MultiMeshObject,MeshCount,ImageID,0)
		// set mesh options
		SetObjectMeshCastShadow(MultiMeshObject,MeshCount,1)
		SetObjectMeshCollisionMode(MultiMeshObject,MeshCount,0)
		// set the tile reference ids for the object and mesh
		Tile.RefObjectID = MultiMeshObject
		Tile.RefMeshGround = MeshCount
	endif

endfunction MeshCount

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorTileTypeMeshAdd(Mesh ref as TMesh,Tile ref as TMapSectorTile)
	
	local Found as integer
	
	Found = TRUE
	
	select Tile.Data.TileType
		case CPlane
			MeshMemBlockPlane(Mesh)
		endcase
		case CRamp
			Select Tile.Data.TileDirection
				case CSouth
					MeshMemBlockRampSouth(Mesh)
				endcase
				case CEast
					MeshMemBlockRampEast(Mesh)
				endcase
				case CNorth
					MeshMemBlockRampNorth(Mesh)
				endcase
				case CWest
					MeshMemBlockRampWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case CCorner
			Select Tile.Data.TileDirection
				case CSouthWest
					MeshMemBlockCornerSouthWest(Mesh)
				endcase
				case CSouthEast
					MeshMemBlockCornerSouthEast(Mesh)
				endcase
				case CNorthEast
					MeshMemBlockCornerNorthEast(Mesh)
				endcase
				case CNorthWest
					MeshMemBlockCornerNorthWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case CNotch
			Select Tile.Data.TileDirection
				case CSouthWest
					MeshMemBlockNotchSouthWest(Mesh)
				endcase
				case CSouthEast
					MeshMemBlockNotchSouthEast(Mesh)
				endcase
				case CNorthEast
					MeshMemBlockNotchNorthEast(Mesh)
				endcase
				case CNorthWest
					MeshMemBlockNotchNorthWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case default
			Found = FALSE
		endcase
	endselect

endfunction Found

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorTileMeshAdd(Tile ref as TMapSectorTile,Texture ref as TMapSectorTextureImageData,MultiMeshObject,MeshData as TMeshData)

	local Mesh as TMesh
	
	local MeshIndex as integer
	
	local ObjectID as integer
	local ImageID as integer
		
	local AttributesData as TMeshAttributesData
	local TextureData as TMeshTextureData
	
	AttributesData.Normal = 1
	AttributesData.UV = 1
	AttributesData.Color = 1
	
	ImageID = Tile.Data.Texture.ImageID

	TextureData.CountX = Texture.TileCountX
	TextureData.CountY = Texture.TileCountY
	
	TextureData.PosX = Tile.Data.Texture.PositionX
	TextureData.PosY = Tile.Data.Texture.PositionY
	
	// init mesh data
	MeshMemBlockInit(Mesh,AttributesData,MeshData,TextureData)
	if MapSectorTileTypeMeshAdd(Mesh,Tile) = TRUE
		MeshMemBlockCreate(Mesh)
	endif 
	
	ObjectID = MultiMeshObject
	ObjectID = MapSectorObjectMeshCreate(Mesh,Tile,ObjectID,ImageID)

endfunction ObjectID

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorCliffSouthTypeMeshAdd(Mesh ref as TMesh,Tile ref as TMapSectorTile)
	
	local Found as integer
	
	Found = TRUE
	
	select Tile.Data.Cliff[CSouth].CliffType
		case CCliff
			MeshMemBlockCliffSouth(Mesh)
		endcase
		case CCliffHalf
			Select Tile.Data.Cliff[CSouth].CliffDirection
				case CSouthEast
					MeshMemBlockCliffHalfSouthToEast(Mesh)
				endcase
				case CSouthWest
					MeshMemBlockCliffHalfSouthToWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case CCliffBevel
			Select Tile.Data.Cliff[CSouth].CliffDirection
				case CSouthEast
					MeshMemBlockBevelSouthToEast(Mesh)
				endcase
				case CSouthWest
					MeshMemBlockBevelSouthToWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case default
			Found = FALSE
		endcase
	endselect

endfunction Found

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorCliffNorthTypeMeshAdd(Mesh ref as TMesh,Tile ref as TMapSectorTile)
	
	local Found as integer
	
	Found = TRUE
	
	select Tile.Data.Cliff[CNorth].CliffType
		case CCliff
			MeshMemBlockCliffNorth(Mesh)
		endcase
		case CCliffHalf
			Select Tile.Data.Cliff[CNorth].CliffDirection
				case CNorthEast
					MeshMemBlockCliffHalfNorthToEast(Mesh)
				endcase
				case CNorthWest
					MeshMemBlockCliffHalfNorthToWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case CCliffBevel
			Select Tile.Data.Cliff[CNorth].CliffDirection
				case CNorthEast
					MeshMemBlockBevelNorthToEast(Mesh)
				endcase
				case CNorthWest
					MeshMemBlockBevelNorthToWest(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case default
			Found = FALSE
		endcase
	endselect

endfunction Found

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorCliffWestTypeMeshAdd(Mesh ref as TMesh,Tile ref as TMapSectorTile)
	
	local Found as integer
	
	Found = TRUE
	
	select Tile.Data.Cliff[CWest].CliffType
		case CCliff
			MeshMemBlockCliffWest(Mesh)
		endcase
		case CCliffHalf
			Select Tile.Data.Cliff[CWest].CliffDirection
				case CNorthWest
					MeshMemBlockCliffHalfWestToNorth(Mesh)
				endcase
				case CSouthWest
					MeshMemBlockCliffHalfWestToSouth(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case CCliffBevel
			Select Tile.Data.Cliff[CWest].CliffDirection
				case CNorthWest
					MeshMemBlockBevelWestToNorth(Mesh)
				endcase
				case CSouthWest
					MeshMemBlockBevelWestToSouth(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case default
			Found = FALSE
		endcase
	endselect

endfunction Found

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorCliffEastTypeMeshAdd(Mesh ref as TMesh,Tile ref as TMapSectorTile)
	
	local Found as integer
	
	Found = TRUE
	
	select Tile.Data.Cliff[CEast].CliffType
		case CCliff
			MeshMemBlockCliffEast(Mesh)
		endcase
		case CCliffHalf
			Select Tile.Data.Cliff[CEast].CliffDirection
				case CNorthEast
					MeshMemBlockCliffHalfEastToNorth(Mesh)
				endcase
				case CSouthEast
					MeshMemBlockCliffHalfEastToSouth(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case CCliffBevel
			Select Tile.Data.Cliff[CEast].CliffDirection
				case CNorthEast
					MeshMemBlockBevelEastToNorth(Mesh)
				endcase
				case CSouthEast
					MeshMemBlockBevelEastToSouth(Mesh)
				endcase
				case default
					Found = FALSE
				endcase
			endselect
		endcase
		case default
			Found = FALSE
		endcase
	endselect

endfunction Found

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorCliffMeshAdd(Tile ref as TMapSectorTile,Direction,Texture ref as TMapSectorTextureImageData,MultiMeshObject,MeshData as TMeshData)

	local Mesh as TMesh
	
	local MeshIndex as integer
	
	local ObjectID as integer
	local ImageID as integer
	
	local AttributesData as TMeshAttributesData
	local TextureData as TMeshTextureData
		
	local Found as integer
	
	AttributesData.Normal = 1
	AttributesData.UV = 1
	AttributesData.Color = 1
	
	ImageID = Tile.Data.Cliff[Direction].Texture.ImageID
	
	TextureData.CountX = Texture.TileCountX
	TextureData.CountY = Texture.TileCountY
	
	TextureData.PosX = Tile.Data.Cliff[Direction].Texture.PositionX
	TextureData.PosY = Tile.Data.Cliff[Direction].Texture.PositionY
	
	// init mesh data
	MeshMemBlockInit(Mesh,AttributesData,MeshData,TextureData)
	
	Found = 0
	select Direction
		case CSouth
			Found = MapSectorCliffSouthTypeMeshAdd(Mesh,Tile)
		endcase
		case CNorth
			Found = MapSectorCliffNorthTypeMeshAdd(Mesh,Tile)
		endcase
		case CWest
			Found = MapSectorCliffWestTypeMeshAdd(Mesh,Tile)
		endcase
		case CEast
			Found = MapSectorCliffEastTypeMeshAdd(Mesh,Tile)
		endcase
	endselect
	
	if Found = TRUE then MeshMemBlockCreate(Mesh)
	
	ObjectID = MultiMeshObject
	ObjectID = MapSectorObjectMeshCreate(Mesh,Tile,ObjectID,ImageID)

endfunction ObjectID

//----------------------------------------------------------------------
// create the selected cluster object
//----------------------------------------------------------------------

function MapSectorClusterObjectCreate(MapSector ref as TMapSectorData,cx,cy,cz)
	
	local x as float
	local y as float
	local z as float
	
	local ctx as integer
	local ctz as integer
	
	local tx as integer
	local ty as integer
	local tz as integer
	
	local MeshData as TMeshData
	local ImageData as TMapSectorTextureImageData
	local CliffIndex as integer
	
	local MultiMeshObject as integer
	
	MultiMeshObject = 0
	
	// set all meshes for cluster

	// for each tile in the cluster
	for ctx = 0 to MapSector.ClusterSizeX - 1
	for ctz = 0 to MapSector.ClusterSizeZ - 1
		
		// position of tile in the array
		tx = cx * MapSector.ClusterSizeX + ctx
		ty = cy
		tz = cz * MapSector.ClusterSizeZ + ctz

		// size of each tile
		MeshData.Size = MapSector.TileSize
		MeshData.Height = MapSector.TileHeight
		
		// set position of mesh in the object
		MeshData.x = ctx * MapSector.TileSize
		MeshData.y = 0
		MeshData.z = ctz * MapSector.TileSize
		
		if MapSectorTileIsValid(MapSector,tx,ty,tz) = TRUE
			
			// Plane
			select MapSector.Tile[tx,ty,tz].Data.GroundType
				case CGroundClip
					ImageData = MapSector.TextureImages.GroundNatural[MapSector.Tile[tx,ty,tz].Data.GroundElementIndex].Image
				endcase
				case CGroundNatural
					ImageData = MapSector.TextureImages.GroundNatural[MapSector.Tile[tx,ty,tz].Data.GroundElementIndex].Image
				endcase
				case CGroundUrban
					ImageData = MapSector.TextureImages.GroundUrban[MapSector.Tile[tx,ty,tz].Data.GroundElementIndex].Image
				endcase
			endselect
			
			MultiMeshObject = MapSectorTileMeshAdd(MapSector.Tile[tx,ty,tz],ImageData,MultiMeshObject,MeshData)
			
			// Cliff
			if MapSector.Tile[tx,ty,tz].Data.Cliff[CSouth].Enabled = TRUE
				CliffIndex = MapSector.Tile[tx,ty,tz].Data.Cliff[CSouth].CliffIndex
				ImageData = MapSector.TextureImages.Cliff[CliffIndex].Image
				MultiMeshObject = MapSectorCliffMeshAdd(MapSector.Tile[tx,ty,tz],CSouth,ImageData,MultiMeshObject,MeshData)
			endif
			if MapSector.Tile[tx,ty,tz].Data.Cliff[CNorth].Enabled = TRUE
				ImageData = MapSector.TextureImages.Cliff[MapSector.Tile[tx,ty,tz].Data.Cliff[CNorth].CliffIndex].Image
				MultiMeshObject = MapSectorCliffMeshAdd(MapSector.Tile[tx,ty,tz],CNorth,ImageData,MultiMeshObject,MeshData)
			endif
			if MapSector.Tile[tx,ty,tz].Data.Cliff[CWest].Enabled = TRUE
				ImageData = MapSector.TextureImages.Cliff[MapSector.Tile[tx,ty,tz].Data.Cliff[CWest].CliffIndex].Image
				MultiMeshObject = MapSectorCliffMeshAdd(MapSector.Tile[tx,ty,tz],CWest,ImageData,MultiMeshObject,MeshData)
			endif
			if MapSector.Tile[tx,ty,tz].Data.Cliff[CEast].Enabled = TRUE
				ImageData = MapSector.TextureImages.Cliff[MapSector.Tile[tx,ty,tz].Data.Cliff[CEast].CliffIndex].Image
				MultiMeshObject = MapSectorCliffMeshAdd(MapSector.Tile[tx,ty,tz],CEast,ImageData,MultiMeshObject,MeshData)
			endif
			
		endif
		
	next ctz
	next ctx
	
	x = cx * MapSector.ClusterSizeX * MapSector.TileSize
	y = cy * MapSector.TileHeight
	z = cz * MapSector.ClusterSizeZ * MapSector.TileSize
	
	// set default properties for the cluster object
	MapSectorClusterObjectSetDefaultProperties(MultiMeshObject,x,y,z)
	
endfunction MultiMeshObject

//----------------------------------------------------------------------
// build a map from scratch
//----------------------------------------------------------------------

function MapSectorObject3DGenerate(MapSector ref as TMapSectorData)
	
	local x as integer
	local y as integer
	local z as integer

	// for high
	for y = 0 to MapSector.MapSizeY - 1
			
	// for each cluster on ground level
	for x = 0 to MapSector.ClusterCountX - 1
	for z = 0 to MapSector.ClusterCountZ - 1
					
			// create one cluster
			MapSector.Cluster[x,y,z].ObjectID = MapSectorClusterObjectCreate(MapSector,x,y,z)

	next z
	next x
	
	next y
	
endfunction