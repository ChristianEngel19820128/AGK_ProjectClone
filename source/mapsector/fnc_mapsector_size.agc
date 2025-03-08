
//----------------------------------------------------------------------
// recalc map array
//----------------------------------------------------------------------

function MapSectorTileArrayRecalc(MapSector ref as TMapSectorData)
	
	local x as integer
	local y as integer
	
	// if array to small	
	
	if MapSector.MapSizeX < MapSector.ClusterCountX then MapSector.MapSizeX = MapSector.ClusterCountX
	if MapSector.MapSizeZ < MapSector.ClusterCountZ then MapSector.MapSizeZ = MapSector.ClusterCountZ
	
	// tile array dimension 1
	
	if MapSector.MapSizeX - 1 <> MapSector.Tile.Length		
		MapSector.Tile.Length = MapSector.MapSizeX - 1
	endif
	
	// tile array dimension 2
			
	for x = 0 to MapSector.MapSizeX - 1
		if MapSector.MapSizeY - 1 <> MapSector.Tile[x].Length
			MapSector.Tile[x].Length = MapSector.MapSizeY - 1
		endif
	next x
	
	// tile array dimension 3
	
	for x = 0 to MapSector.MapSizeX - 1
	for y = 0 to MapSector.MapSizeY - 1
		if MapSector.MapSizeZ - 1 <> MapSector.Tile[x,y].Length
			MapSector.Tile[x,y].Length = MapSector.MapSizeZ - 1
		endif
	next y
	next x

endfunction

//----------------------------------------------------------------------
// recalc cluster array
//----------------------------------------------------------------------

function MapSectorClusterArrayRecalc(MapSector ref as TMapSectorData)
	
	local x as integer
	local y as integer
	
	// if array to small
	
	// cluster array dimension 1
	
	if MapSector.ClusterCountX - 1 <> MapSector.Cluster.Length	
		MapSector.Cluster.Length = MapSector.ClusterCountX - 1
	endif
	
	// cluster array dimension 2
	// for max y map size y is used
		
	for x = 0 to MapSector.ClusterCountX - 1
		if MapSector.MapSizeY - 1 <> MapSector.Cluster[x].Length
			MapSector.Cluster[x].Length = MapSector.MapSizeY - 1
		endif
	next x
	
	// cluster array dimension 3
	
	for x = 0 to MapSector.ClusterCountX - 1
	for y = 0 to MapSector.MapSizeY - 1
		if MapSector.ClusterCountZ - 1 <> MapSector.Cluster[x,y].Length
			MapSector.Cluster[x,y].Length = MapSector.ClusterCountZ - 1
		endif
	next y
	next x
	
endfunction

//----------------------------------------------------------------------
// set map an cluster size
//----------------------------------------------------------------------

function MapSectorSizeSet(MapSector ref as TMapSectorData,MapX,MapY,MapZ,ClusterX,ClusterZ)
	
	// set map size
	MapSector.MapSizeX = MapX
	MapSector.MapSizeY = MapY
	MapSector.MapSizeZ = MapZ
		
	MapSector.ClusterSizeX = ClusterX
	MapSector.ClusterSizeZ = ClusterZ
	
	// set cluster count
	MapSector.ClusterCountX = Floor(MapSector.MapSizeX / MapSector.ClusterSizeX)
	MapSector.ClusterCountZ = Floor(MapSector.MapSizeZ / MapSector.ClusterSizeZ)
	
	// if map tile count bigger then the cluster count recalc map tile count
	if MapSector.MapSizeX / MapSector.ClusterSizeX > MapSector.ClusterCountX then MapSector.MapSizeX = MapSector.ClusterCountX * MapSector.ClusterSizeX
	if MapSector.MapSizeZ / MapSector.ClusterSizeZ > MapSector.ClusterCountZ then MapSector.MapSizeZ = MapSector.ClusterCountZ * MapSector.ClusterSizeZ	
		
	// if array to small	
	
	MapSectorTileArrayRecalc(MapSector)
	MapSectorClusterArrayRecalc(MapSector)
		
endfunction