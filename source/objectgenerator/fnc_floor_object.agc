
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

function FloorObjectsLoad(FloorObjectTypes ref as TFloorObjectTypeData[])
	
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
	
	FilePath.Path = "/media/data"
	FilePath.Name = "floorobjects.json"
	
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
// 
//----------------------------------------------------------------------

function FloorObjectsGenerate(ObjectData ref as TObjectData,FloorObjectTypes ref as TFloorObjectTypeData[],ObjectID ref as integer[])
	
	local CurrentObjectID as integer

	local i as integer
	local r as integer
	
	local t as integer
	local v as integer
	
	local Mesh as TMesh
	
	local FilePath as TFilePath
	local FileID as integer
	local VertexCount as integer
	
	if FloorObjectTypes.Length >= 0
		
		
		for t = 0 to FloorObjectTypes.Length
		for v = 0 to FloorObjectTypes[t].Variants.Length
			
			FilePath.Path = "/media"
			FilePath.Name = "flora_" + str(t) + "_" + str(v) + "_" + ".obj"
			
			FileID = 0
			VertexCount = 0
			CurrentObjectID = 0
			
			for i = 0 to FloorObjectTypes[t].Variants[v].SubObject.Length -1
				
				if FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Enabled = 0
					FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Columns = random(5,8)
					FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Rows = random(5,8)
					FloorObjectTypes[t].Variants[v].SubObject[i].Detail.Segments = random(5,8)
				endif
				
				FloorObjectGenerate(ObjectData,FloorObjectTypes[t].Variants[v].SubObject[i],Mesh)
				
				FileID = MeshMemBlockSaveToFile(FileID,FilePath,Mesh,i,VertexCount)
				VertexCount = VertexCount + Mesh.Vertices.Length +1
				
				if Mesh.MemBlockID > 0
					
					if CurrentObjectID = 0
						CurrentObjectID = CreateObjectFromMeshMemblock(Mesh.MemBlockID)
						ObjectID.Insert(CurrentObjectID)
						SetObjectPosition(CurrentObjectID,t*ObjectData.TileSize*1,0,v*ObjectData.TileSize*1)
						SetObjectCullMode(CurrentObjectID,1)
						SetCameraLookAt(1,15,5,15,0)
					else
						AddObjectMeshFromMemblock(CurrentObjectID,Mesh.MemBlockID)
					endif
					
					SetObjectMeshImage(CurrentObjectID,GetObjectNumMeshes(CurrentObjectID),FloorObjectTypes[t].Textures[FloorObjectTypes[t].Variants[v].SubObject[i].TextureIndex].Image,0)
					
					MeshMemBlockClear(Mesh)
					
				endif
				
			next i
			
			//Sync()
			//Sleep(1000)
			
			SetObjectAlphaMask(CurrentObjectID,1)
			
			//DeleteObject(CurrentObjectID)
			//CurrentObjectID = 0
			
		next v
		next t

	endif
		
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function FloorObjectGenerate(ObjectData ref as TObjectData,SubObject ref as TFloorSubObject,Mesh ref as TMesh)

	local Data as TMeshData
	local MeshColor as TMeshVertexColor
	
	local ID as integer
	
	local sd as float
	local sw as float
	local sh as float
	
	local sx as float
	local sy as float
	local sz as float
	
	local Memblock as integer
			
	sd = SubObject.PercentDiameter * 0.01 * ObjectData.TileSize
	sw = SubObject.PercentWidth * 0.01 * ObjectData.TileSize
	sh = SubObject.PercentHeight * 0.01 * ObjectData.TileHeight
	
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
	
	sx = SubObject.PrecentCenterX * 0.01 * ObjectData.TileSize
	sy = SubObject.PrecentCenterY * 0.01 * ObjectData.TileHeight
	sz = SubObject.PrecentCenterZ * 0.01 * ObjectData.TileSize
	
	Data.x = sx
	Data.y = sy
	Data.z = sz
	
	Data.Size = ObjectData.TileSize
	Data.Height = ObjectData.TileHeight
	
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

