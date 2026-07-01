
//----------------------------------------------------------------------
// "Deep Copy" einer Variante
//----------------------------------------------------------------------

function CopyFloorObjectVariant(Target ref as TFloorObjectVariantData,Source as TFloorObjectVariantData)

	local j as integer
	
	Target.Color = Source.Color
	Target.LoopTexture = Source.LoopTexture
	
	// Sub-Array physisch neu dimensionieren und kopieren
	Target.SubObject.Length = Source.SubObject.Length
	for j = 0 to Source.SubObject.Length
		Target.SubObject[j].SubObjectType   = Source.SubObject[j].SubObjectType
		Target.SubObject[j].Color           = Source.SubObject[j].Color
		Target.SubObject[j].Texture         = Source.SubObject[j].Texture
		Target.SubObject[j].PrecentCenterX  = Source.SubObject[j].PrecentCenterX
		Target.SubObject[j].PrecentCenterY  = Source.SubObject[j].PrecentCenterY
		Target.SubObject[j].PrecentCenterZ  = Source.SubObject[j].PrecentCenterZ
		Target.SubObject[j].PercentWidth    = Source.SubObject[j].PercentWidth
		Target.SubObject[j].PercentHeight   = Source.SubObject[j].PercentHeight
		Target.SubObject[j].PercentDiameter = Source.SubObject[j].PercentDiameter
		Target.SubObject[j].Angle           = Source.SubObject[j].Angle
		Target.SubObject[j].TopLight        = Source.SubObject[j].TopLight
		Target.SubObject[j].TextureIndex    = -1 // Initialisieren
	next j
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function MapSectorFloorObjectsLoad(FloorObjectTypes ref as TFloorObjectTypeData[])
	
	local FilePath as TFilePath
	local FileTexture as TFilePath
	local i as integer
	local k as integer
	local m as integer
	local j as integer
	local l as integer
	local null as string
	local LoopTexture as integer
	local SearchTextureName as string
	
	FilePath.Path = "/media/data/mapsector"
	FilePath.Name = "mapsector_floorobjects.json"
	
	FloorObjectTypes.Length = -1
	
	if FilePathSetAndCheck(FilePath) = 1
		FloorObjectTypes.Load(FilePath.Name)
	endif
	
	for i = 0 to FloorObjectTypes.Length
		for k = 0 to FloorObjectTypes[i].Textures.Length
			FileTexture.Path = FloorObjectTypes[i].Textures[k].FilePath.Path
			FileTexture.Name = FloorObjectTypes[i].Textures[k].FilePath.Name
			FloorObjectTypes[i].Textures[k].Image = LoadImage(GetFilePathSetAndCheck(FileTexture))
		next k
	next i
	
	// Temporäres Array für die bereinigten/erweiterten Varianten
	local TempVariants as TFloorObjectVariantData[]
	local NewVariant as TFloorObjectVariantData
	
	for i = 0 to FloorObjectTypes.Length
		
		// Temporäres Array für diesen Objekttyp leeren
		TempVariants.Length = -1
		
		// Wir gehen durch die im JSON definierten Varianten (beim Gras genau 1)
		for k = 0 to FloorObjectTypes[i].Variants.Length
			
			LoopTexture = FloorObjectTypes[i].Variants[k].LoopTexture
			if LoopTexture = 0 then LoopTexture = 1 // Mindestens 1 Durchlauf, wenn kein Loop
			
			for m = 1 to LoopTexture // Start bei 1 macht die Namensgebung einfacher
			
				// Erzeuge eine ECHTE, frische Kopie der JSON-Vorlage
				CopyFloorObjectVariant(NewVariant,FloorObjectTypes[i].Variants[k])
				
				null = ""
				if m < 10 then null = "0"
				
				// Subobjekte dieser neuen Variante verarbeiten
				for j = 0 to NewVariant.SubObject.Length
					
					if FloorObjectTypes[i].Variants[k].LoopTexture = 0
						// Fall A: Keine fortlaufenden Texturen, nutze den Namen aus dem JSON
						SearchTextureName = NewVariant.SubObject[j].Texture
					else
						// Fall B: Texturschleife aktiv -> Baue z.B. "weed_01" zusammen
						SearchTextureName = NewVariant.SubObject[j].Texture + "_" + null + str(m)
					endif
					
					// Passenden TexturIndex in den geladenen Texturen suchen
					for l = 0 to FloorObjectTypes[i].Textures.Length
						if FloorObjectTypes[i].Textures[l].Identifier = SearchTextureName
							NewVariant.SubObject[j].TextureIndex = l
							exit // Textur gefunden, Suche für dieses Subobjekt abbrechen
						endif
					next l
				
				next j
				
				// Die fertig verarbeitete, eigenständige Variante im Temp-Array ablegen
				TempVariants.Insert(NewVariant)
				
			next m
		next k
	
		// Das originale JSON-Array mit dem perfekt generierten Temp-Array überschreiben
		FloorObjectTypes[i].Variants.Length = TempVariants.Length
		for k = 0 to TempVariants.Length
			FloorObjectTypes[i].Variants[k].SubObject.Length =-1
			FloorObjectTypes[i].Variants[k] = TempVariants[k]
			for j = 0 to TempVariants[k].SubObject.Length
				FloorObjectTypes[i].Variants[k].SubObject.Insert(TempVariants[k].SubObject[j])
			next j
		next k
	
	next i

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
				if random(0,100) < 45
					
					cx = x*MapSector.TileSize   + MapSector.TileSize * 0.5
					cy = y*MapSector.TileHeight + MapSector.TileHeight
					cz = z*MapSector.TileSize   + MapSector.TileSize * 0.5
					
					MapSector.Tile[x,y,z].FloorObject.Enabled = TRUE
					
					t = random(0,MapSector.FloorObjectTypes.Length)
										
					MapSector.Tile[x,y,z].FloorObject.FloorObjectType = t
					
					v = random(0,MapSector.FloorObjectTypes[t].Variants.Length)
					
					FilePath.Path = "/media"
					FilePath.Name = "flora_" + str(t) + "_" + str(v) + ".obj"
					
					FileID = 0
					VertexCount = 0
					
					for i = 0 to MapSector.FloorObjectTypes[t].Variants[v].SubObject.Length

						MapSector.FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Columns = random(5,8)
						MapSector.FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Rows = random(5,8)
						MapSector.FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Segments = random(5,8)
				
						MapSectorFloorObjectGenerate(MapSector,MapSector.FloorObjectTypes[t].Variants[v].SubObject[i],Mesh)
						
						//FileID = MeshMemBlockSaveToFile(FileID,FilePath,Mesh,i,VertexCount)
						//VertexCount = VertexCount + Mesh.Vertices.Length +1
						
						if Mesh.MemBlockID > 0
							
							if MapSector.Tile[x,y,z].FloorObject.RefObjectID = 0
								MapSector.Tile[x,y,z].FloorObject.RefObjectID = CreateObjectFromMeshMemblock(Mesh.MemBlockID)
							else
								AddObjectMeshFromMemblock(MapSector.Tile[x,y,z].FloorObject.RefObjectID,Mesh.MemBlockID)
							endif
							
							SetObjectMeshImage(MapSector.Tile[x,y,z].FloorObject.RefObjectID,GetObjectNumMeshes(MapSector.Tile[x,y,z].FloorObject.RefObjectID),Mapsector.FloorObjectTypes[t].Textures[Mapsector.FloorObjectTypes[t].Variants[v].SubObject[i].TextureIndex].Image,0)
							
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
	SetObjectAlphaMask(ID,1)
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
			
	sd = SubObject.PercentDiameter * 0.01 * MapSector.TileSize
	sw = SubObject.PercentWidth * 0.01 * MapSector.TileSize
	sh = SubObject.PercentHeight * 0.01 * MapSector.TileHeight
	
	
	select SubObject.SubObjectType
		case "sphere"
			ID = CreateObjectSphere(sd,SubObject.Detail.Rows,SubObject.Detail.Columns)
		endcase
		case "cone"
			ID = CreateObjectCone(sh,sd,SubObject.Detail.Segments)
		endcase
		case "cylinder"
			ID = CreateObjectCylinder(sh,sd,SubObject.Detail.Segments)
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
	
	if SubObject.Angle.Enabled = 0 then SubObject.Angle.Alpha = Random(0,4)*45
	
	MeshMemBlockRotate(Mesh,SubObject.Angle.Alpha,SubObject.Angle.Beta,SubObject.Angle.Gamma)
	
	if SubObject.SubObjectType = "plane" then MeshMemblockUVMirror(Mesh)
	if SubObject.TopLight = 1 then MeshMemblockSetTopLight(Mesh)
	
	
endfunction

