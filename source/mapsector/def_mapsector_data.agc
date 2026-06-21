
//----------------------------------------------------------------------
// sector properties
//----------------------------------------------------------------------

type TMapSectorProperties
	
	Climate as string
	TerrainType as string
	
	Altitude as integer
	
endtype

//----------------------------------------------------------------------
// data of texture
//----------------------------------------------------------------------

type TMapSectorTextureData
	
	ImageID as integer
	PositionX as integer
	PositionY as integer
	
endtype

//----------------------------------------------------------------------
// data of cliff
//----------------------------------------------------------------------

type TMapSectorCliffData
	
	Enabled as integer
	
	// full, southwest, northwest ..
	CliffType as integer
	CliffDirection as integer
	
	CliffIndex as integer

	Texture as TMapSectorTextureData
	
endtype

//----------------------------------------------------------------------
// data of each map tile
//----------------------------------------------------------------------

type TMapSectorTileData
	
	// plane, ramp, corner, notch
	// north, south, northwest ..
	TileType as integer
	TileDirection as integer
	TileCliff as integer[8]
	
	// cliff data
	Cliff as TMapSectorCliffData[8]
	
	// type natural, urban ..
	// index of grass, earth .. element from ground list
	GroundType as integer
	GroundElementIndex as integer
	
	// > 0 have a border of a heigher ground element
	// north (z+1), east (x+1) ..
	GroundBorder as integer[8]
	
	Texture as TMapSectorTextureData
	
endtype

//----------------------------------------------------------------------
// data of floor objects
//----------------------------------------------------------------------

type TFloorObjectData
	
	Enabled as integer
	RefObjectID as integer
	RefSubObjectsID as integer[-1]
	FloorObjectType as integer
	
endtype


//----------------------------------------------------------------------
// data of ambient objects
//----------------------------------------------------------------------

type TAmbientObjectData
	
	Enabled as integer
	RefObjectID as integer[-1]
	AmbientObjectType as integer
	
endtype

//----------------------------------------------------------------------
// data of each map tile
//----------------------------------------------------------------------

type TMapSectorTile

	// tile is enabled
	Enabled as integer
	
	// references of plane per tile
	RefObjectID as integer
	
	RefMeshGround as integer
	
	RefMeshCliffNorth as integer
	RefMeshCliffEast as integer
	RefMeshCliffSouth as integer
	RefMeshCliffWest as integer
	
	Data as TMapSectorTileData
	
	FloorObject as TFloorObjectData
	AmbientObject as TAmbientObjectData
	
endtype

//----------------------------------------------------------------------
// data of each cluster
//----------------------------------------------------------------------

type TMapSectorCluster

	// meshed object of the cluster
	ObjectID as integer

endtype

//----------------------------------------------------------------------
// entry point of neighbour map
//----------------------------------------------------------------------

type TMapSectorEntryPointData
	
	Enabled as integer
	
	Properties as TMapSectorProperties
	
	TerrainData as TMapSectorTileData[-1]
	TerrainHeight as integer[-1]
		
endtype

//----------------------------------------------------------------------
// data of the map
//----------------------------------------------------------------------

type TMapSectorData
	
	Properties as TMapSectorProperties
	
	ClipImageID as integer
	CursorImageStandardID as integer
	CursorImageSelectedID as integer
	
	// borders if map based on neighbour maps if exists
	
	EntryPoint as TMapSectorEntryPointData[8]
	
	// count of tiles in the full map

	MapSizeX as integer
	MapSizeY as integer
	MapSizeZ as integer
	
	// count of tiles of one cluster
	
	ClusterSizeX as integer
	ClusterSizeZ as integer
	
	// count of clusters in the full map
	
	ClusterCountX as integer // size of one cluster x
	ClusterCountZ as integer // size of one cluster z
	
	// world definition
	
	// tile size in world units
	
	TileSize as float
	TileHeight as float
	
	// world view options
	// cluster is only visible up to this height
	
	ClipHeight as integer
		
	// world data
	
	HighestTileTop as integer
	
	Tile as TMapSectorTile[-1,-1,-1]
	Cluster as TMapSectorCluster[-1,-1,-1]
	
	Source as TFilePath
	DataSource as TMapSectorDataSource
	TextureImages as TMapSectorTexture
	
	SkyBox as TMapSectorSkyBox
	Camera as TMapSectorCameraData
	
	FloorObjectImages as TFloorObjectImages[-1]
	FloorObjectTypes as TFloorObjectTypeData[-1]
	AmbientObjectTypes as TAmbientObjectTypeData[-1]
	
	
endtype
