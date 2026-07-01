
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxInit(SkyBox ref as TMapSectorSkyBox,MapSector ref as TMapSectorData,Camera as TMapSectorCameraData)
	
	//SkyBox.Center = Camera.Orbiter.Position
	//SkyBox.Center.Y = SkyBox.Center.Y +50

	SkyBox.Center.x = MapSector.TileSize * MapSector.MapSizeX * 0.5
	SkyBox.Center.y = 0
	SkyBox.Center.z = MapSector.TileSize * MapSector.MapSizeY * 0.5

	SkyBox.Distance = Camera.Range * 0.50
	SkyBox.Diameter = SkyBox.Distance * 2.0	
	
	SetSkyBoxVisible(1)
	SetSkyBoxSkyColor(0,150,255)
	SetSkyBoxHorizonSize(10,0)
	SetSkyBoxHorizonColor(255,55,75)
	
	//SetAmbientColor(55,55,55)//125,125,125)
	
	ClearPointLights()
	
	
	/*
	SkyBox.Sphere = CreateObjectSphere(SkyBox.Diameter,15,15)
	SetObjectPosition(SkyBox.Sphere,SkyBox.Center.x,SkyBox.Center.y,SkyBox.Center.z)
	
	SetObjectColor(SkyBox.Sphere,0,0,0,0)
	SetObjectCullMode(SkyBox.Sphere,2)
	SetObjectCollisionMode(SkyBox.Sphere,0)
	SetObjectLightMode(SkyBox.Sphere,0)
	SetObjectCastShadow(SkyBox.Sphere,0)
	SetObjectReceiveShadow(SkyBox.Sphere,0)

	SetObjectTransparency(SkyBox.Sphere,1)
	SetObjectAlpha(SkyBox.Sphere,255)
	*/
	
	
	MapSectorSkyBoxSunInit(SkyBox,Camera)
	MapSectorSkyBoxMoonInit(SkyBox,Camera)
	MapSectorSkyBoxFogInit(SkyBox,Camera)	
	MapSectorSkyBoxStarsInit(SkyBox,Camera)
	MapSectorSkyBoxCloudsInit(SkyBox,Camera)
	
endfunction


//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxFogInit(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)
	
	SetFogMode(1)
	SetFogRange(-1,1500)
	SetFogColor(255,255,255)
	SetFogSunColor(255,155,155)

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxSunInit(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)
	
	local x as float
	local y as float
	local z as float
	local Range as float
	local pos as TVector
	
	Range = SkyBox.Distance*0.75
	
	SkyBox.Sun.Orbiter = GetOrbiterPosition(SkyBox.Center,Range,0,65)
	TimeSet(SkyBox.Sun.TransTime,50,1)
	
	/*
	SkyBox.Sun.Sphere = CreateObjectSphere(GetSizePerDistance(3.5,Range),15,15)
	SetObjectPosition(SkyBox.Sun.Sphere,SkyBox.Sun.Orbiter.Position.X,SkyBox.Sun.Orbiter.Position.Y,SkyBox.Sun.Orbiter.Position.Z)
	
	SetObjectColor(SkyBox.Sun.Sphere,255,255,255,255)
	SetObjectCullMode(SkyBox.Sun.Sphere,1)
	SetObjectCollisionMode(SkyBox.Sun.Sphere,0)
	SetObjectLightMode(SkyBox.Sun.Sphere,0)
	SetObjectCastShadow(SkyBox.Sun.Sphere,0)
	SetObjectReceiveShadow(SkyBox.Sun.Sphere,0)
	SetObjectTransparency(SkyBox.Sun.Sphere,0)
	
	SkyBox.Sun.Img = LoadImage("/media/gfx/mapsector/sky/Sun.png")
	SetObjectImage(SkyBox.Sun.Sphere,SkyBox.Sun.Img,0)
	*/
	
	SetShadowMappingMode(2)
	SetShadowMapSize(1024,1024)
	SetShadowBias(0.001)
	SetShadowRange(Camera.Range*0.8)
	SetShadowLightStepSize(1)
	SetShadowSmoothing(4)
	SetShadowCascadeValues(0.7,0.8,0.9)
		
	pos = GetVetorNormalsP1P2(SkyBox.Sun.Orbiter.Position,SkyBox.Center)
		
	SetSunDirection(pos.x,pos.y,pos.z)
	
	SetSkyBoxSunSize(10,25)
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxMoonInit(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)
	

	
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxStarsInit(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)
	

	
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxCloudsInit(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)
	

	
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxRecalc(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)

	local x as float
	local y as float
	local z as float
	
	if SkyBox.Center.X <> Camera.Orbiter.Position.X or SkyBox.Center.Y <> Camera.Orbiter.Position.Y or SkyBox.Center.Z <> Camera.Orbiter.Position.Z
		
		SkyBox.Center = Camera.Orbiter.Position		
		
		SkyBox.Sun.Orbiter = GetOrbiterPositionRefresh(SkyBox.Sun.Orbiter,SkyBox.Center)
		
		//SetObjectPosition(SkyBox.Sun.Sphere,SkyBox.Sun.Orbiter.Position.X,SkyBox.Sun.Orbiter.Position.Y,SkyBox.Sun.Orbiter.Position.Z)
				
		x = -(SkyBox.Sun.Orbiter.Position.X-SkyBox.Sun.Orbiter.Center.X)
		y = -(SkyBox.Sun.Orbiter.Position.Y-SkyBox.Sun.Orbiter.Center.Y)
		z = -(SkyBox.Sun.Orbiter.Position.Z-SkyBox.Sun.Orbiter.Center.Z)
		
		SetSunDirection(x,y,z)
		//SetSunColor(SkyBox.Sun.Color.Red,SkyBox.Sun.Color.Green,SkyBox.Sun.Color.Blue)
		
	endif

endfunction


//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxDo(SkyBox ref as TMapSectorSkyBox,Camera as TMapSectorCameraData)

	local alpha as float
	local beta as float
	local gamma as float
	local range as float
	local r1 as float
	local g1 as float
	local b1 as float
	local r2 as float
	local g2 as float
	local b2 as float
	local r3 as float
	local g3 as float
	local b3 as float
	local pos as TVector

	if TimeGet(SkyBox.Sun.TransTime,GetMilliseconds()) > 0
		
		alpha = 1.5
		beta = sin(SkyBox.Sun.Orbiter.Alpha)
		gamma = SetRad(SkyBox.Sun.Orbiter.Beta,0)
		range = SkyBox.Distance*0.75+(abs(gamma)*100/180)

		SkyBox.Sun.Orbiter = GetOrbiterPosition(SkyBox.Center,Range,SkyBox.Sun.Orbiter.Alpha,SkyBox.Sun.Orbiter.Beta)
		SkyBox.Sun.Orbiter = GetOrbiterRotate(SkyBox.Sun.Orbiter,alpha,beta)
		
		//SetObjectPosition(SkyBox.Sun.Sphere,SkyBox.Sun.Orbiter.Position.X,SkyBox.Sun.Orbiter.Position.Y,SkyBox.Sun.Orbiter.Position.Z)
		
		pos = GetVetorNormalsP1P2(SkyBox.Sun.Orbiter.Position,SkyBox.Center)
		
		SetSunDirection(pos.x,pos.y,pos.z)
		
		r1 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.5
		g1 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.5
		b1 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.5

		SkyBox.Sun.SphereColor.Red   = r1*255*0.25
		SkyBox.Sun.SphereColor.Green = g1*255*0.25
		SkyBox.Sun.SphereColor.Blue  = b1*255*0.25
		
		r2 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.5
		g2 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*1.75
		b2 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.25
		
		SkyBox.Sun.HorizonColor.Red   = r2*255*0.25
		SkyBox.Sun.HorizonColor.Green = g2*255*0.25
		SkyBox.Sun.HorizonColor.Blue  = b2*255*0.25
		
		if SkyBox.Sun.HorizonColor.Red < 0   then SkyBox.Sun.HorizonColor.Red = 0
		if SkyBox.Sun.HorizonColor.Green < 0 then SkyBox.Sun.HorizonColor.Green = 0
		if SkyBox.Sun.HorizonColor.Blue < 0  then SkyBox.Sun.HorizonColor.Blue = 0
		
		r3 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*1.0
		g3 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*1.75
		b3 = SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.55

		SkyBox.Sun.SkyColor.Red = r3*255*0.25
		SkyBox.Sun.SkyColor.Green = g3*255*0.25
		SkyBox.Sun.SkyColor.Blue = b3*255*0.25
		
		if pos.y > 0.25
			SetSunActive(0)
			SetSkyBoxSunVisible(0)
		else
			SetSunActive(1)
			SetSkyBoxSunVisible(1)
		endif
		
		/*
		print(str(SkyBox.Sun.SphereColor.Red))
		print(str(SkyBox.Sun.SphereColor.Green))
		print(str(SkyBox.Sun.SphereColor.Blue))
		*/
		
		SetSunColor(SkyBox.Sun.SphereColor.Red,SkyBox.Sun.SphereColor.Green,SkyBox.Sun.SphereColor.Blue)
		SetSkyBoxSunColor(SkyBox.Sun.SphereColor.Red,SkyBox.Sun.SphereColor.Green,SkyBox.Sun.SphereColor.Blue)
		SetFogSunColor(SkyBox.Sun.SphereColor.Red,SkyBox.Sun.SphereColor.Green,SkyBox.Sun.SphereColor.Blue)
		//if pos.y > 0.25 then SetSkyBoxSkyColor(SkyBox.Sun.Color.Red,SkyBox.Sun.Color.Green,SkyBox.Sun.Color.Blue)
		
		SetSkyBoxHorizonColor(SkyBox.Sun.HorizonColor.Red,SkyBox.Sun.HorizonColor.Green,SkyBox.Sun.HorizonColor.Blue)
		SetSkyBoxSkyColor(SkyBox.Sun.SkyColor.Red,SkyBox.Sun.SkyColor.Green,SkyBox.Sun.SkyColor.Blue)
		
		SetSkyBoxHorizonSize(SkyBox.Sun.Orbiter.Radius/SkyBox.Distance*2.5+5,0)
		
		/*
		if pos.y > 0
			SetSkyBoxHorizonSize(((abs(pos.y)))*15.0+10,0)
		else
			SetSkyBoxHorizonSize(((abs(pos.y)))*15.0+10,0)
		endif
		*/
		
		TimeReset(SkyBox.Sun.TransTime,GetMilliseconds())
		
	endif

endfunction


//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxInit1(SkyBox ref as TMapSectorSkyBox1,Camera as TMapSectorCameraData)
	
	local r as integer
	local i as integer
	
	SetSunActive(1)
	SetSunColor(255,155,155)
	SetSunDirection(-1,-0.35,-1)
	SetShadowMappingMode(1)
	
	SkyBox.Center = Camera.Orbiter.Position
	SkyBox.Center.Y = SkyBox.Center.Y +50

	SkyBox.Distance = (Camera.Range) * 0.9
	SkyBox.Diameter = SkyBox.Distance * 2

	// sky color sphere
	SkyBox.SkySphere = CreateObjectSphere(SkyBox.Diameter,15,15)
	SetObjectPosition(SkyBox.SkySphere,SkyBox.Center.x,SkyBox.Center.y,SkyBox.Center.z)
	
	SetObjectColor(SkyBox.SkySphere,0,0,0,0)
	SetObjectCullMode(SkyBox.SkySphere,2)
	SetObjectCollisionMode(SkyBox.SkySphere,0)
	SetObjectLightMode(SkyBox.SkySphere,0)
	SetObjectCastShadow(SkyBox.SkySphere,0)

	SetObjectTransparency(SkyBox.SkySphere,1)
	SetObjectAlpha(SkyBox.SkySphere,0)
	
	// stars sphere
	SkyBox.StarsSphere = CreateObjectSphere(SkyBox.Diameter*0.95,15,15)
	SetObjectPosition(SkyBox.StarsSphere,SkyBox.Center.x,SkyBox.Center.y,SkyBox.Center.z)

	SetObjectColor(SkyBox.StarsSphere,255,255,255,255)
	SetObjectCullMode(SkyBox.StarsSphere,2)
	SetObjectCollisionMode(SkyBox.StarsSphere,0)
	SetObjectLightMode(SkyBox.StarsSphere,0)
	SetObjectCastShadow(SkyBox.StarsSphere,0)
	
	SkyBox.StarsImg = LoadImage("/media/gfx/mapsector/sky/stars.png")
	SetObjectImage(SkyBox.StarsSphere,SkyBox.StarsImg,0)
	
	SetObjectTransparency(SkyBox.StarsSphere,1)
	SetObjectAlpha(SkyBox.StarsSphere,0)
	
	// cloud sphere		
	SkyBox.CloudMax = 3
	//SkyBox.CloudSphere.Length = SkyBox.CloudMax-1
	//SkyBox.CloudTransTime.Length = SkyBox.CloudMax-1
	SkyBox.CloudImg = LoadImage("/media/gfx/mapsector/sky/cloud2.png")
	
	for i = 0 to 1
		
		TimeSet(SkyBox.CloudTransTime[i],100+50*i,1)
		
		SkyBox.CloudAnim[0,i] = 0
		
		SkyBox.CloudPlane[0,i] = CreateObjectPlane(SkyBox.Distance,SkyBox.Distance)
		SetObjectPosition(SkyBox.CloudPlane[0,i],SkyBox.Center.x,SkyBox.Center.y,SkyBox.Center.z+SkyBox.Distance*0.6+i)
		SetObjectRotation(SkyBox.CloudPlane[0,i],0,0,0)
		
		SetObjectColor(SkyBox.CloudPlane[0,i],55,55,55,255)
		SetObjectCullMode(SkyBox.CloudPlane[0,i],1)
		SetObjectCollisionMode(SkyBox.CloudPlane[0,i],0)
		SetObjectLightMode(SkyBox.CloudPlane[0,i],0)
		SetObjectCastShadow(SkyBox.CloudPlane[0,i],0)
		
		SetObjectImage(SkyBox.CloudPlane[0,i],SkyBox.CloudImg,0)
		
		SetObjectTransparency(SkyBox.CloudPlane[0,i],0)
		SetObjectAlpha(SkyBox.CloudPlane[0,i],125+25*i)
		
		SkyBox.CloudPlane[1,i] = CreateObjectPlane(SkyBox.Distance,SkyBox.Distance)
		SetObjectPosition(SkyBox.CloudPlane[1,i],SkyBox.Center.x-SkyBox.Distance*0.856,SkyBox.Center.y,SkyBox.Center.z+SkyBox.Distance*0.246+i)
		SetObjectRotation(SkyBox.CloudPlane[1,i],0,-45,0)
		
		SetObjectColor(SkyBox.CloudPlane[1,i],55,55,55,255)
		SetObjectCullMode(SkyBox.CloudPlane[1,i],1)
		SetObjectCollisionMode(SkyBox.CloudPlane[1,i],0)
		SetObjectLightMode(SkyBox.CloudPlane[1,i],0)
		SetObjectCastShadow(SkyBox.CloudPlane[1,i],0)
		
		SetObjectImage(SkyBox.CloudPlane[1,i],SkyBox.CloudImg,0)
		
		SetObjectTransparency(SkyBox.CloudPlane[1,i],0)
		SetObjectAlpha(SkyBox.CloudPlane[1,i],125+25*i)
		
	next i
	
	/*
	for i = 0 to SkyBox.CloudMax - 1
		
		
		TimeSet(SkyBox.CloudTransTime[i],100+50*i,1)
		
		SkyBox.CloudSphere[i] = CreateObjectSphere(SkyBox.Diameter*0.7-i*0.5,15,15)
		SetObjectPosition(SkyBox.CloudSphere[i],SkyBox.Center.x,SkyBox.Center.y,SkyBox.Center.z)
	
		SetObjectColor(SkyBox.CloudSphere[i],55,55,55,255)
		SetObjectCullMode(SkyBox.CloudSphere[i],2)
		SetObjectCollisionMode(SkyBox.CloudSphere[i],0)
		SetObjectLightMode(SkyBox.CloudSphere[i],0)
		SetObjectCastShadow(SkyBox.CloudSphere[i],0)
		
		SetObjectImage(SkyBox.CloudSphere[i],SkyBox.CloudImg,0)
		
		SetObjectTransparency(SkyBox.CloudSphere[i],1)
		SetObjectAlpha(SkyBox.CloudSphere[i],125+25*i)
		
	next i
	*/
	
	// moon sphere
	r = SkyBox.Distance*0.8
	
	SkyBox.MoonOrbiter = GetOrbiterPosition(SkyBox.Center,r,45,-25)
	TimeSet(SkyBox.MoonTransTime,100,1)
	
	SkyBox.MoonSphere = CreateObjectSphere(GetSizePerDistance(4,r),15,15)
	SetObjectPosition(SkyBox.MoonSphere,SkyBox.MoonOrbiter.Position.X,SkyBox.MoonOrbiter.Position.Y,SkyBox.MoonOrbiter.Position.Z)
	
	SetObjectColor(SkyBox.MoonSphere,255,255,255,255)
	SetObjectCullMode(SkyBox.MoonSphere,1)
	SetObjectCollisionMode(SkyBox.MoonSphere,0)
	SetObjectLightMode(SkyBox.MoonSphere,0)
	SetObjectCastShadow(SkyBox.MoonSphere,0)
	
	SetObjectTransparency(SkyBox.MoonSphere,0)
		
	SkyBox.MoonImg = LoadImage("/media/gfx/mapsector/sky/moon.png")
	SetObjectImage(SkyBox.MoonSphere,SkyBox.MoonImg,0)
	
	// sun sphere	
	r = SkyBox.Distance*0.85
	
	SkyBox.SunOrbiter = GetOrbiterPosition(SkyBox.Center,r,45,-15)
	TimeSet(SkyBox.SunTransTime,100,1)
	
	SkyBox.SunSphere = CreateObjectSphere(GetSizePerDistance(3.5,r),15,15)
	SetObjectPosition(SkyBox.SunSphere,SkyBox.SunOrbiter.Position.X,SkyBox.SunOrbiter.Position.Y,SkyBox.SunOrbiter.Position.Z)
	
	SetObjectColor(SkyBox.SunSphere,255,255,255,255)
	SetObjectCullMode(SkyBox.SunSphere,1)
	SetObjectCollisionMode(SkyBox.SunSphere,0)
	SetObjectLightMode(SkyBox.SunSphere,0)
	SetObjectCastShadow(SkyBox.SunSphere,0)

	SetObjectTransparency(SkyBox.SunSphere,0)
	
	SkyBox.SunImg = LoadImage("/media/gfx/mapsector/sky/Sun.png")
	SetObjectImage(SkyBox.SunSphere,SkyBox.SunImg,0)

	// timer
	TimeSet(SkyBox.SkyTransTime,2000,1)
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorSkyBoxDo1(SkyBox ref as TMapSectorSkyBox1,Camera as TMapSectorCameraData)
	
	local i as integer
	
	if SkyBox.Center.X <> Camera.Orbiter.Position.X or SkyBox.Center.Y <> Camera.Orbiter.Position.Y or SkyBox.Center.Z <> Camera.Orbiter.Position.Z
			
		SkyBox.Center = Camera.Orbiter.Position
		SkyBox.Center.Y = SkyBox.Center.Y +50

		SetObjectPosition(SkyBox.SkySphere,SkyBox.Center.X,SkyBox.Center.Y,SkyBox.Center.Z)
		SetObjectPosition(SkyBox.StarsSphere,SkyBox.Center.X,SkyBox.Center.Y,SkyBox.Center.Z)
		
		/*
		for i = 0 to SkyBox.CloudMax - 1
			SetObjectPosition(SkyBox.CloudSphere[i],SkyBox.Center.X,SkyBox.Center.Y,SkyBox.Center.Z)
		next i
		*/
		
		SkyBox.MoonOrbiter = GetOrbiterPositionRefresh(SkyBox.MoonOrbiter,SkyBox.Center)
		SetObjectPosition(SkyBox.MoonSphere,SkyBox.MoonOrbiter.Position.X,SkyBox.MoonOrbiter.Position.Y,SkyBox.MoonOrbiter.Position.Z)
		
		SkyBox.SunOrbiter = GetOrbiterPositionRefresh(SkyBox.SunOrbiter,SkyBox.Center)
		SetObjectPosition(SkyBox.SunSphere,SkyBox.SunOrbiter.Position.X,SkyBox.SunOrbiter.Position.Y,SkyBox.SunOrbiter.Position.Z)
		
	endif
	
	
	if TimeGet(SkyBox.MoonTransTime,GetMilliseconds()) > 0
		SkyBox.MoonOrbiter = GetOrbiterRotate(SkyBox.MoonOrbiter,1.5,0)
		SetObjectPosition(SkyBox.MoonSphere,SkyBox.MoonOrbiter.Position.X,SkyBox.MoonOrbiter.Position.Y,SkyBox.MoonOrbiter.Position.Z)
		TimeReset(SkyBox.MoonTransTime,GetMilliseconds())
	endif
	
	if TimeGet(SkyBox.SunTransTime,GetMilliseconds()) > 0
		SkyBox.SunOrbiter = GetOrbiterRotate(SkyBox.SunOrbiter,1,0)
		SetObjectPosition(SkyBox.SunSphere,SkyBox.SunOrbiter.Position.X,SkyBox.SunOrbiter.Position.Y,SkyBox.SunOrbiter.Position.Z)
		TimeReset(SkyBox.SunTransTime,GetMilliseconds())
	endif
	
	for i = 0 to SkyBox.CloudTransTime.Length
		
		if TimeGet(SkyBox.CloudTransTime[i],GetMilliseconds()) > 0
			//RotateObjectLocalY(SkyBox.CloudSphere[i],0.1+0.1*SkyBox.CloudTransTime.Length-0.1*i)
			SkyBox.CloudAnim[0,i] = SkyBox.CloudAnim[0,i]+0.01+0.01*i
			if SkyBox.CloudAnim[0,i] > 1 then SkyBox.CloudAnim[0,i] = 0
			SetObjectUVOffset(SkyBox.CloudPlane[0,i],0,-0.25+SkyBox.CloudAnim[0,i],0)
			SetObjectUVScale(SkyBox.CloudPlane[0,i],0,SkyBox.CloudAnim[0,i]+0.25,1)
			TimeReset(SkyBox.CloudTransTime[i],GetMilliseconds())
		endif
		
	next i
		
	if TimeGet(SkyBox.SkyTransTime,GetMilliseconds()) > 0
		
		if SkyBox.SkyTrans < 255
			
			SkyBox.SkyTrans = SkyBox.SkyTrans + 1
			//SetObjectColor(SkyBox.SkySphere,SkyBox.SkyTrans*0.55,SkyBox.SkyTrans*0.65,SkyBox.SkyTrans,255)
			
			//if GetObjectAlpha(SkyBox.StarsSphere) > 0 then SetObjectAlpha(SkyBox.StarsSphere,Floor(GetObjectAlpha(SkyBox.StarsSphere)*0.99))
			TimeReset(SkyBox.SkyTransTime,GetMilliseconds())
		endif
		
	endif
	
endfunction


