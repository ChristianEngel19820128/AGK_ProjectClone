
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCameraInit(Camera ref as TMapSectorCameraData)
	 
	Camera.Range = 150

	SetCameraRange(1,1,Camera.Range)
	
	Camera.Center.X = 0
	Camera.Center.Y = 15
	Camera.Center.Z = 0
	
	Camera.Orbiter.Radius = 50
	Camera.Orbiter.Alpha = 0
	Camera.Orbiter.Beta = 90
	
	Camera.Orbiter = GetOrbiterPosition(Camera.Center,Camera.Orbiter.Radius,Camera.Orbiter.Alpha,Camera.Orbiter.Beta)
	
	Camera.Pivot = CreateObjectSphere(0.25,8,8)
	SetObjectCullMode(Camera.Pivot,1)
	SetObjectCollisionMode(Camera.Pivot,0)
	SetObjectLightMode(Camera.Pivot,0)
	SetObjectCastShadow(Camera.Pivot,0)
	SetObjectReceiveShadow(Camera.Pivot,0)
	SetObjectFogMode(Camera.Pivot,0)
	SetObjectVisible(Camera.Pivot,1)
	
	SetObjectPosition(Camera.Pivot,Camera.Center.X,Camera.Center.Y,Camera.Center.Z)
	SetCameraPosition(1,Camera.Orbiter.Position.X,Camera.Orbiter.Position.Y,Camera.Orbiter.Position.Z)

	SetCameraLookAt(1,Camera.Center.X,Camera.Center.Y,Camera.Center.Z,0)
	
	TimeSet(Camera.MoveTimer,35,1)
	
	Camera.RotationSpeed = 5
	Camera.MoveSpeed = 2
	
	Camera.LimitUp = 75
	Camera.LimitDown = 25
	Camera.LimitOut = 75
	Camera.LimitIn = 15
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCameraMove(Camera ref as TMapSectorCameraData)
	
	/*
	
	print(str(Camera.Center.x))
	print(str(Camera.Center.y))
	print(str(Camera.Center.z))
	
	print(str(Camera.Orbiter.Center.x))
	print(str(Camera.Orbiter.Center.y))
	print(str(Camera.Orbiter.Center.z))
	
	print(str(Camera.Orbiter.Position.x))
	print(str(Camera.Orbiter.Position.y))
	print(str(Camera.Orbiter.Position.z))
	
	print(str(Camera.Orbiter.Alpha))
	print(str(Camera.Orbiter.Beta))
	
	*/
	
	if TimeGet(Camera.MoveTimer,GetMilliseconds()) > 0
		
		if GetRawKeyState(KEY_W)			
			MapSectorCameraPositionCalc(Camera,CForward)
		else		
			if GetRawKeyState(KEY_S)
				MapSectorCameraPositionCalc(Camera,CBackward)
			endif
		endif
		
		if GetRawKeyState(KEY_D)
			MapSectorCameraPositionCalc(Camera,CRight)
		else		
			if GetRawKeyState(KEY_A)
				MapSectorCameraPositionCalc(Camera,CLeft)
			endif
		endif
		
		if GetRawKeyState(KEY_Q)
			MapSectorCameraRotationCalc(Camera,CRight)
		else
			if GetRawKeyState(KEY_E)
				MapSectorCameraRotationCalc(Camera,CLeft)
			endif
		endif
		
		if GetRawKeyState(KEY_R)
			MapSectorCameraPositionLift(Camera,CUp)
		else
			if GetRawKeyState(KEY_F)
				MapSectorCameraPositionLift(Camera,CDown)
			endif
		endif
		
		if GetRawKeyState(KEY_T)
			MapSectorCameraPositionZoom(Camera,CIn)
		else
			if GetRawKeyState(KEY_G)
				MapSectorCameraPositionZoom(Camera,COut)
			endif
		endif
		
		TimeReset(Camera.MoveTimer,GetMilliseconds())
		    
	endif
	
endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCameraPositionZoom(Camera ref as TMapSectorCameraData,Direction as integer)
	
	local Radius as float
		
	if Direction = COut then Radius = Camera.MoveTimer.CalcRange * Camera.MoveSpeed
	if Direction = CIn then Radius = -Camera.MoveTimer.CalcRange * Camera.MoveSpeed
	
	if (Camera.Orbiter.Radius + Radius < Camera.LimitOut and Direction = COut) or (Camera.Orbiter.Radius + Radius > Camera.LimitIn and Direction = CIn)
	
		if (Camera.Orbiter.Radius + Radius > Camera.LimitOut and Direction = COut) then Radius = Camera.LimitOut - Camera.Orbiter.Radius
		if (Camera.Orbiter.Radius + Radius < Camera.LimitIn and Direction = CIn) then Radius = Camera.LimitIn - Camera.Orbiter.Radius
	
		Camera.Orbiter = GetOrbiterZoom(Camera.Orbiter,Radius)
		SetCameraPosition(1,Camera.Orbiter.Position.X,Camera.Orbiter.Position.Y,Camera.Orbiter.Position.Z)
		SetCameraLookAt(1,Camera.Center.X,Camera.Center.Y,Camera.Center.Z,0)
	
	endif
		
endfunction
	
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCameraPositionLift(Camera ref as TMapSectorCameraData,Direction as integer)

	Length as float
		
	if Direction = CUp then Length = Camera.MoveTimer.CalcRange * Camera.MoveSpeed
	if Direction = CDown then Length = -Camera.MoveTimer.CalcRange * Camera.MoveSpeed
	
	if (Camera.Orbiter.Position.Y + Length < Camera.LimitUp and Direction = CUp) or (Camera.Orbiter.Position.Y + Length > Camera.LimitDown and Direction = CDown)
		
		if (Camera.Orbiter.Position.Y + Length > Camera.LimitUp and Direction = CUp) then Length = Camera.LimitUp - Camera.Orbiter.Position.Y
		if (Camera.Orbiter.Position.Y + Length < Camera.LimitDown and Direction = CDown) then Length = Camera.LimitDown - Camera.Orbiter.Position.Y
		
		Camera.Orbiter = GetOrbiterLift(Camera.Orbiter,Length)
		SetCameraPosition(1,Camera.Orbiter.Position.X,Camera.Orbiter.Position.Y,Camera.Orbiter.Position.Z)
		SetCameraLookAt(1,Camera.Center.X,Camera.Center.Y,Camera.Center.Z,0)
		
	endif
	
endfunction
	
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCameraPositionCalc(Camera ref as TMapSectorCameraData,Direction as integer)

	Length as float
	
	if Direction = CForward or Direction = CLeft or Direction = CRight then Length = -Camera.MoveTimer.CalcRange * Camera.MoveSpeed
	if Direction = CBackward then Length = Camera.MoveTimer.CalcRange * Camera.MoveSpeed
	
	if Direction = CForward or Direction = CBackward then Camera.Orbiter = GetOrbiterMove(Camera.Orbiter,Length)
	if Direction = CRight then Camera.Orbiter = GetOrbiterStrafeRight(Camera.Orbiter,Length)
	if Direction = CLeft then Camera.Orbiter = GetOrbiterStrafeLeft(Camera.Orbiter,Length)
	
	Camera.Center = Camera.Orbiter.Center
	SetObjectPosition(Camera.Pivot,Camera.Orbiter.Center.X,Camera.Orbiter.Center.Y,Camera.Orbiter.Center.Z)
	SetCameraPosition(1,Camera.Orbiter.Position.X,Camera.Orbiter.Position.Y,Camera.Orbiter.Position.Z)
	SetCameraLookAt(1,Camera.Center.X,Camera.Center.Y,Camera.Center.Z,0)

endfunction

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function MapSectorCameraRotationCalc(Camera ref as TMapSectorCameraData,Direction as integer)
	
	Alpha as float
	
	if Direction = CRight then Alpha = -Camera.MoveTimer.CalcRange * Camera.RotationSpeed
	if Direction = CLeft then Alpha = Camera.MoveTimer.CalcRange * Camera.RotationSpeed
	
	Camera.Orbiter = GetOrbiterRotate(Camera.Orbiter,Alpha,0)

	SetCameraPosition(1,Camera.Orbiter.Position.X,Camera.Orbiter.Position.Y,Camera.Orbiter.Position.Z)
	SetCameraLookAt(1,Camera.Center.X,Camera.Center.Y,Camera.Center.Z,0)
		
endfunction


