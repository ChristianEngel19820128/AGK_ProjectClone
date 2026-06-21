
//----------------------------------------------------------------------
// floor object
//----------------------------------------------------------------------

function MapSectorFloorImagesLoad(MapSector ref as TMapSectorData)
	
	local File as TFilePath
	local Img as TFloorObjectImages
	
	File.Path = "/media/gfx/mapsector/objects"
	File.File = "baum.png"
	if FilePathSetAndCheck(File) = 1
		Img.ImageID = loadimage(File.File)
		MapSector.FloorObjectImages.Insert(Img)
	endif
	File.File = "baum_leaf.png"
	if FilePathSetAndCheck(File) = 1
		Img.ImageID = loadimage(File.File)
		MapSector.FloorObjectImages.Insert(Img)
	endif
	
endfunction

//----------------------------------------------------------------------
// floor object
//----------------------------------------------------------------------

function MapSectorFloorObjectsLoad(MapSector ref as TMapSectorData)
	
	if FilePathSetAndCheck(MapSector.DataSource.FloorObjects) = 1
		MapSector.FloorObjectTypes.Load(MapSector.DataSource.FloorObjects.File)
	endif
	
endfunction

//----------------------------------------------------------------------
// floor object
//----------------------------------------------------------------------

function MapSectorFloorObjectsGenerate(MapSector ref as TMapSectorData)
	
	local x as integer
	local y as integer
	local z as integer
	
	local i as integer
	
	local cx as float
	local cy as float
	local cz as float

	local t as integer
	local v as integer
	
	local ID as integer
	local Mesh as TMesh
	
	local SubObjectType as string
	
	local FilePath as TFilePath
	local FileID as integer
	local VertexCount as integer
	
	if MapSector.FloorObjectTypes.Length >= 0
		
		for x = 0 to MapSector.MapSizeX - 1
		for z = 0 to MapSector.MapSizeZ - 1
		for y = 0 to MapSector.MapSizeY - 1
			
			if MapSectorTileIsTopTile(MapSector,x,y,z) = TRUE
			if MapSector.Tile[x,y,z].Data.TileType = CPlane
				if random(0,100) < 25
					
					cx = x*MapSector.TileSize   + MapSector.TileSize * 0.5
					cy = y*MapSector.TileHeight + MapSector.TileHeight
					cz = z*MapSector.TileSize   + MapSector.TileSize * 0.5
					
					MapSector.Tile[x,y,z].FloorObject.Enabled = TRUE
					
					t = random(0,MapSector.FloorObjectTypes.Length)
										
					MapSector.Tile[x,y,z].FloorObject.FloorObjectType = t
					
					v = random(0,MapSector.FloorObjectTypes[t].Variants.Length)
					
					FilePath.Path = "/media"
					FilePath.File = "flora_" + str(t) + "_" + str(v) + ".obj"
					
					FileID = 0
					VertexCount = 0
					
					for i = 0 to MapSector.FloorObjectTypes[t].Variants[v].SubObject.Length

						MapSectorFloorObjectGenerate(MapSector,MapSector.FloorObjectTypes[t].Variants[v].SubObject[i],Mesh)
						
						//FileID = MeshMemSaveToFile(FileID,FilePath,Mesh,i,VertexCount)
						//VertexCount = VertexCount + Mesh.Vertices.Length +1
						
						if Mesh.MemBlockID > 0
							
							if MapSector.Tile[x,y,z].FloorObject.RefObjectID = 0
								MapSector.Tile[x,y,z].FloorObject.RefObjectID = CreateObjectFromMeshMemblock(Mesh.MemBlockID)
							else
								AddObjectMeshFromMemblock(MapSector.Tile[x,y,z].FloorObject.RefObjectID,Mesh.MemBlockID)
							endif
							
							select MapSector.FloorObjectTypes[t].Variants[v].SubObject[i].Texture
								case "bole"
									SetObjectMeshImage(MapSector.Tile[x,y,z].FloorObject.RefObjectID,GetObjectNumMeshes(MapSector.Tile[x,y,z].FloorObject.RefObjectID),MapSector.FloorObjectImages[0].ImageID,0)
								endcase
								case "leaf"
									SetObjectMeshImage(MapSector.Tile[x,y,z].FloorObject.RefObjectID,GetObjectNumMeshes(MapSector.Tile[x,y,z].FloorObject.RefObjectID),MapSector.FloorObjectImages[1].ImageID,0)
								endcase
							endselect
							
							MeshMemBlockClear(Mesh)
							
						endif
						
					next i
					
					MapSectorFloorObjectSet(MapSector,MapSector.Tile[x,y,z].FloorObject,v,cx,cy,cz)
					
				endif
			
			endif
			endif
			
		next y
		next z
		next x

	endif
		
endfunction

//----------------------------------------------------------------------
// floor object
//----------------------------------------------------------------------

function MapSectorFloorObjectSet(MapSector ref as TMapSectorData,FloorObject ref as TFloorObjectData,v,cx,cy,cz)
	
	local ID as integer
	
	local r as integer
	local g as integer
	local b as integer
	local a as integer
	
	local s as float
	
	ID = FloorObject.RefObjectID
	
	SetObjectPosition(ID,cx,cy,cz)
	
	r = MapSector.FloorObjectTypes[FloorObject.FloorObjectType].Variants[v].Color.Red
	g = MapSector.FloorObjectTypes[FloorObject.FloorObjectType].Variants[v].Color.Green
	b = MapSector.FloorObjectTypes[FloorObject.FloorObjectType].Variants[v].Color.Blue
	a = MapSector.FloorObjectTypes[FloorObject.FloorObjectType].Variants[v].Color.Alpha
	
	SetObjectRotation(ID,0,Random(-180,180),0)
	
	s = random(75,125)*0.01
	SetObjectScale(ID,s,s,s)
	
	//SetObjectColor(ID,r,g,b,a)
	
	SetObjectCollisionMode(ID,0)
	SetObjectCullMode(ID,1)
	SetObjectLightMode(ID,1)
	SetObjectCastShadow(ID,1)
	SetObjectReceiveShadow(ID,1)
	SetObjectFogMode(ID,1)
	
endfunction

//----------------------------------------------------------------------
// floor object
//----------------------------------------------------------------------

function MapSectorFloorObjectGenerate(MapSector ref as TMapSectorData,SubObject ref as TFloorSubObject,Mesh ref as TMesh)

	local Data as TMeshData
	local MeshColor as TMeshVertexColor
	
	local ID as integer
	
	local sd as float
	local sw as float
	local sh as float
	
	local sx as float
	local sy as float
	local sz as float
	
	local r as integer
	local g as integer
	local b as integer
	local a as integer
	
	local Memblock as integer
			
	sd = Random(SubObject.PercentDiameter-5,SubObject.PercentDiameter+5) * MapSector.TileSize * 0.01
	sw = Random(SubObject.PercentWidth-5,SubObject.PercentWidth+5) * MapSector.TileSize * 0.01
	sh = Random(SubObject.PercentHeight-5,SubObject.PercentHeight+5) * MapSector.TileHeight * 0.01
	
	
	select SubObject.SubObjectType
		case "sphere"
			ID = CreateObjectSphere(sd,random(5,8),random(5,8))
		endcase
		case "cone"
			ID = CreateObjectCone(sh,sd,random(5,8))
		endcase
		case "cylinder"
			ID = CreateObjectCylinder(sh,sd,random(5,8))
		endcase
		case "capsule"
			ID = CreateObjectCapsule(sd,sh,1)
		endcase
		case "box"
			ID = CreateObjectBox(sw,sh,sw)
		endcase
		case "plane"
			ID = CreateObjectPlane(sw,sh)
		endcase
	endselect
	
	r = SubObject.Color.Red
	g = SubObject.Color.Green
	b = SubObject.Color.Blue
	a = SubObject.Color.Alpha
	
	//SetObjectColor(ID,r,g,b,a)
	
	MeshMemBlockGetFromMeshObject(Mesh,ID,1)
	
	DeleteObject(ID)
	
	// subobject position
	
	sx = SubObject.PrecentCenterX * MapSector.TileSize * 0.01
	sy = SubObject.PrecentCenterY * MapSector.TileHeight * 0.01
	sz = SubObject.PrecentCenterZ * MapSector.TileSize * 0.01
	
	Data.x = sx
	Data.y = sy
	Data.z = sz
	
	Data.Size = MapSector.TileSize
	Data.Height = MapSector.TileHeight
	
	MeshColor.Red = SubObject.Color.Red
	MeshColor.Green = SubObject.Color.Green
	MeshColor.Blue = SubObject.Color.Blue
	MeshColor.Alpha = SubObject.Color.Alpha
	
	MeshMemBlockSetData(Mesh,Data,MeshColor)
	
endfunction Memblock

