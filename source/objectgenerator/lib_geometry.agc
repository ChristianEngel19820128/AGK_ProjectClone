
//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TPoint
	
	X as float
	Y as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TVector
	
	X as float
	Y as float
	Z as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TOrbiter
	
	Center as TVector
	Position as TVector
	Radius as float
	Alpha as float
	Beta as float
	Gamma as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TLine
	
	A as TPoint
	B as TPoint
	Length as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TBox
	
	A as TPoint
	B as TPoint
	C as TPoint
	D as TPoint
	M as TPoint
	X1 as float
	X2 as float
	Y1 as float
	Y2 as float
	Width as float
	Height as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TCircle
	
	M as TPoint
	R as float
	D as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TEllipse
	
	M as TPoint
	W as float
	H as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function SetBox(Box ref as TBox,X as float,Y as float,Width as float,Height as float)
	
	Box.A.X = X
	Box.A.Y = Y
	
	Box.B.X = X + Width
	Box.B.Y = Y
	
	Box.C.X = X + Width
	Box.C.Y = Y + Height
	
	Box.D.X = X
	Box.D.Y = Y + Height
	
	Box.X1 = X
	Box.X2 = X + Width
	Box.Y1 = Y
	Box.Y2 = Y + Height
	
	Box.M.X = X + Width / 2
	Box.M.Y = Y + Height / 2

	Box.Width = Width
	Box.Height = Height
	
endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function XYInBox(x as float,y as float,Box as TBox)

	local Value as integer

	Value = 0
	
	if X >= Box.X1 and X <= Box.X2
		if Y >= Box.Y1 and Y <= Box.Y2
			Value = 1
		endif
	endif

endfunction Value

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function PointInBox(Point as TPoint,Box as TBox)

	local Value as integer

	Value = 0
	
	if Point.X >= Box.X1 and Point.X <= Box.X2
		if Point.Y >= Box.Y1 and Point.Y <= Box.Y2
			Value = 1
		endif
	endif

endfunction Value

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function BoxInBox(Box1 as TBox,Box2 as TBox)

	local Value as integer
	
	Value = 0
	
	if Box1.X1 < Box2.X2
		if Box1.X2 > Box2.X1
			if Box1.Y1 < Box2.Y2
				if Box1.Y2 > Box2.Y1
					Value = 1
				endif
			endif
		endif
	endif
	
endfunction Value

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function CircleInCircle(Circle1 as TCircle,Circle2 as TCircle)
	
	local Value as integer
	
	local dx as float
	local dy as float
	local Distance as float
	
	Value = 0
	
	dx = Circle1.M.X - Circle2.M.X
	dy = Circle1.M.Y - Circle2.M.Y
	
	Distance = sqrt(dx * dx + dy * dy)
	
	if Distance < Circle1.R + Circle2.R
		Value = 1
	endif
	
endfunction Value


//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetKathete(c as float,a as float)

	local b as float
		
	b = sqrt(c^2-a^2)

endfunction b

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetHypotenuse(a as float,b as float)

	local c as float
		
	c = sqrt(a^2+b^2)

endfunction c

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetAlphaByACBC(a as float,b as float)
	
	local Alpha as float
	
	Alpha = ATan(a/b)

endfunction Alpha

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetAlphaByBCAB(a as float,c as float)
	
	local Alpha as float
	
	Alpha = ASin(a/c)

endfunction Alpha

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetAlphaByACAB(b as float,c as float)
	
	local Alpha as float
	
	Alpha = ACos(b/c)

endfunction Alpha

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetPointDirectionP1P2(P1 as TPoint,P2 as TPoint)
	
	local Point as TPoint
	
	Point.X = (P1.X-P2.X)
	Point.Y = (P1.Y-P2.Y)
	
endfunction Point

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetVetorDirectionP1P2(P1 as TVector,P2 as TVector)
	
	local Vector as TVector
	
	Vector.X = (P1.X-P2.X)
	Vector.Y = (P1.Y-P2.Y)
	Vector.Z = (P1.Z-P2.Z)
	
endfunction Vector

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetVetorNormalsP1P2(P1 as TVector,P2 as TVector)
	
	local Vector as TVector
	local v as float
	
	Vector.X = 0
	Vector.Y = 0
	Vector.Z = 0
	
	v = GetVectorRadius(P1,P2) //sqrt((P1.X-P2.X)^2+(P1.Y-P2.Y)^2+(P1.Z-P2.Z)^2)
	
	if v > 0
		Vector.X = (P1.X-P2.X)/v * 1.0
		Vector.Y = (P1.Y-P2.Y)/v * 1.0
		Vector.Z = (P1.Z-P2.Z)/v * 1.0
	endif
	
endfunction Vector

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOppositeLedge(c as float,Alpha as float)
	
	local b as float
	
	b = Sin(Alpha)*c
	
endfunction b

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetAttachedLedge(c as float,Alpha as float)
	
	local b as float
	
	b = Cos(Alpha)*c
	
endfunction b

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetHypotenuseA(a as float,Alpha as float)
	
	local c as float

	c = a/Sin(Alpha)

endfunction c

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetHypotenuseB(b as float,Alpha as float)
	
	local c as float

	c = b/Cos(Alpha)

endfunction c

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetSizePerDistance(Size as float,Distance as float)
	
	local CalculatedSize as float
	
	CalculatedSize = Size * Distance * 0.01
	
endfunction CalculatedSize

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetVectorRadius(P1 as TVector,P2 as TVector)

	local Vector as TVector
	local Radius as float
	local R1 as float
	
	/*
	Vector = GetVetorDirectionP1P2(P1,P2)
	
	R1 = GetHypotenuse(Vector.X,Vector.Z)
	Radius = GetHypotenuse(Vector.Y,R1)
	*/
	
	Radius = sqrt((P1.X-P2.X)^2+(P1.Y-P2.Y)^2+(P1.Z-P2.Z)^2)
	
endfunction Radius

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetVectorBeta(P1 as TVector,P2 as TVector)

	local Vector as TVector
	local Beta as float
	local R1 as float
	local Point1 as TPoint
	local Point2 as TPoint
	
	/*
	Vector = GetVetorDirectionP1P2(P1,P2)
	
	R1 = GetHypotenuse(Vector.X,Vector.Z)
	Beta = ATan(Vector.Y/R1)
	*/
		
	Point1.X = P1.Z
	Point1.Y = P1.Y
	
	Point2.X = P2.Z
	Point2.Y = P2.Y
	
	Beta = SetAngle(CalcAngle(Point1,Point2),0)
	
endfunction Beta

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetVectorAlpha(P1 as TVector,P2 as TVector)

	local Vector as TVector
	local Alpha as float
	local Point1 as TPoint
	local Point2 as TPoint
	
	/*
	Vector = GetVetorDirectionP1P2(P1,P2)
	Alpha = ATan(Vector.Z/Vector.X)
	*/
	
	Point1.X = P1.X
	Point1.Y = P1.Z
	
	Point2.X = P2.X
	Point2.Y = P2.Z
	
	Alpha = SetAngle(CalcAngle(Point1,Point2),0)
	
endfunction Alpha

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetNewVetorA(P1 as TVector,Length as float,Alpha as float)
	
	local Vector as TVector
	local a as float
	local b as float
	local Point as TPoint
	
	/*
	a = GetAttachedLedge(Length,Alpha)
	b = GetOppositeLedge(Length,Alpha)
	
	Vector.X = P1.X+a
	Vector.Y = P1.Y
	Vector.Z = P1.Z+b
	*/
	Point.X = P1.X
	Point.Y = P1.Z
	
	Vector.X = CalcPositionX(Point.X,Alpha,Length)
	Vector.Y = P1.Y
	Vector.Z = CalcPositionY(Point.Y,Alpha,Length)
	
endfunction Vector

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetNewVetorALeft(P1 as TVector,Length as float,Alpha as float)
	
	local Vector as TVector
	local a as float
	local b as float
	local Point as TPoint
	local NewAngle as float
	
	/*
	a = -GetOppositeLedge(Length,Alpha)
	b = GetAttachedLedge(Length,Alpha)
	
	Vector.X = P1.X+a
	Vector.Y = P1.Y
	Vector.Z = P1.Z+b
	
	Point.X = P1.X
	Point.Y = P1.Z
	*/
	
	Point.X = P1.X
	Point.Y = P1.Z
	
	NewAngle = SetAngle(Alpha,90)
	
	Vector.X = CalcPositionX(Point.X,NewAngle,Length)
	Vector.Y = P1.Y
	Vector.Z = CalcPositionY(Point.Y,NewAngle,Length)
	
endfunction Vector

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetNewVetorARight(P1 as TVector,Length as float,Alpha as float)
	
	local Vector as TVector
	local a as float
	local b as float
	local Point as TPoint
	local NewAngle as float
	
	/*
	a = GetOppositeLedge(Length,Alpha)
	b = -GetAttachedLedge(Length,Alpha)
	
	Vector.X = P1.X+a
	Vector.Y = P1.Y
	Vector.Z = P1.Z+b
	*/
	
	Point.X = P1.X
	Point.Y = P1.Z
	
	NewAngle = SetAngle(Alpha,-90)
	
	Vector.X = CalcPositionX(Point.X,NewAngle,Length)
	Vector.Y = P1.Y
	Vector.Z = CalcPositionY(Point.Y,NewAngle,Length)
	
endfunction Vector

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetNewVetorB(P1 as TVector,Length as float,Beta as float)
	
	local Vector as TVector
	local h as float
	
	/*
	h = GetOppositeLedge(Length,Beta)
		
	Vector.X = P1.X
	Vector.Y = P1.Y+h
	Vector.Z = P1.Z
	*/
	
endfunction Vector

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------

function CalcPosition(Position as TPoint,Angle as float,Radius as float)
	
	Position.X = CalcPositionX(Position.X,Angle,Radius)
	Position.Y = CalcPositionY(Position.Y,Angle,Radius)

endfunction Position

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------

function CalcPositionX(PositionX as float,Angle as float,Radius as float)
	
	local Value as float
	local NewAngle1 as float
	local NewAngle2 as float
	local CurrentAngle as float
	
	CurrentAngle = SetAngle(Angle,0)
	NewAngle1 = SetAngle(Angle,-90)
	NewAngle2 = SetAngle(Angle,90)
	
	if CurrentAngle >= 0 and CurrentAngle <= 90 then Value = PositionX + cos(NewAngle1) * Radius
	if CurrentAngle >= 90 and CurrentAngle <= 180 then Value = PositionX + cos(NewAngle1) * Radius
	if CurrentAngle >= 180 and CurrentAngle <= 270 then Value = PositionX - cos(NewAngle2) * Radius
	if CurrentAngle >= 270 and CurrentAngle <= 360 then Value = PositionX - cos(NewAngle2) * Radius

endfunction Value

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------

function CalcPositionY(PositionY as float,Angle as float,Radius as float)
	
	local Value as float
	local NewAngle1 as float
	local NewAngle2 as float
	local CurrentAngle as float
	
	CurrentAngle = SetAngle(Angle,0)
	NewAngle1 = SetAngle(Angle,-90)
	NewAngle2 = SetAngle(Angle,90)
	
	if CurrentAngle >= 0 and CurrentAngle <= 90 then Value = PositionY + sin(NewAngle1) * Radius
	if CurrentAngle >= 90 and CurrentAngle <= 180 then Value = PositionY + sin(NewAngle1) * Radius
	if CurrentAngle >= 180 and CurrentAngle <= 270 then Value = PositionY - sin(NewAngle2) * Radius
	if CurrentAngle >= 270 and CurrentAngle <= 360 then Value = PositionY - sin(NewAngle2) * Radius

endfunction Value

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------

function CalcRadius(AbsolutePosition as TPoint,TargetPosition as TPoint)
	
	local Value as float
	local x as float
	local y as float
	
	x = TargetPosition.X - AbsolutePosition.X
	y = TargetPosition.Y - AbsolutePosition.Y
		
	Value = sqrt((x^2)+(y^2))
	
endfunction Value

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------

function CalcAngle(AbsolutePosition as TPoint,TargetPosition as TPoint)
	
	local Value as float
	local Radius as float
	local x as float
	local y as float
	local ArcAngle as float
	
	Value = 0
	
	if AbsolutePosition.X <> TargetPosition.X or AbsolutePosition.Y <> TargetPosition.Y
		
		x = TargetPosition.X - AbsolutePosition.X
		y = TargetPosition.Y - AbsolutePosition.Y
		
		Value = SetAngle(atanfull(x,y),0)

	endif
	
endfunction Value

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetVectorPosition(Center as TVector,Radius as float,Alpha as float,Beta as float)
	
	local Vector1 as TVector
	local Vector2 as TVector
	local Vector as TVector
	
	local h as float
	local a as float
	local b as float

	local R1 as float
	
	/*
	R1 = GetAttachedLedge(Radius,Beta)
	a = GetAttachedLedge(R1,Alpha)
	b = GetOppositeLedge(R1,Alpha)
	h = GetKathete(Radius,R1)
	*/
	
	Vector.X = CalcPositionX(Center.X,Alpha,Radius)
	Vector.Y = CalcPositionY(Center.Y,Beta,Radius)
	Vector.Z = CalcPositionY(Center.Z,Alpha,Radius)
	
endfunction Vector

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function SetAngle(Alpha as float,Beta as Float)
	
	local NewAlpha as float
	
	NewAlpha = Alpha+Beta
	
	if NewAlpha <= -360 then NewAlpha = NewAlpha + floor(abs(NewAlpha) / 360) * 360
	if NewAlpha >= 360 then NewAlpha = NewAlpha - floor(NewAlpha / 360) * 360
	if NewAlpha < 0 then NewAlpha = NewAlpha + 360
	if NewAlpha > 360 then NewAlpha = NewAlpha - 360
	
endfunction NewALpha

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function SetRad(Alpha as float,Beta as Float)
	
	local NewAlpha as float

	NewAlpha = SetAngle(Alpha,Beta)
	
	if NewAlpha < -180 then NewAlpha = NewAlpha + 180
	if NewAlpha > 180 then NewAlpha = NewAlpha - 180
	
endfunction NewALpha

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterPosition(Center as TVector,Radius as float,Alpha as float,Beta as float)
	
	local LOrbiter as TOrbiter
	
	LOrbiter.Center = Center
	LOrbiter.Radius = Radius
	LOrbiter.Alpha = Alpha
	LOrbiter.Beta = Beta
	
	LOrbiter.Position = GetVectorPosition(Center,Radius,Alpha,Beta)
	
endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterPositionRefresh(POrbiter as TOrbiter,Center as TVector)
	
	local LOrbiter as TOrbiter
	
	LOrbiter = GetOrbiterPosition(Center,POrbiter.Radius,POrbiter.Alpha,POrbiter.Beta)
	
endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterAngleRefresh(POrbiter as TOrbiter,NewPosition as TVector)
	
	local LOrbiter as TOrbiter
	local Point1 as TPoint
	local Point2 as TPoint
	local Radius as float
	
	LOrbiter.Center = POrbiter.Center
	LOrbiter.Position = NewPosition
	LOrbiter.Radius = GetVectorRadius(LOrbiter.Center,LOrbiter.Position)
	
	Point2.X = LOrbiter.Position.X
	Point2.Y = LOrbiter.Position.Z
	
	Point1.X = LOrbiter.Center.X
	Point1.Y = LOrbiter.Center.Z
	
	LOrbiter.Alpha = CalcAngle(Point1,Point2)
	
	Radius = CalcRadius(Point1,Point2)
	
	Point2.X = Radius
	Point2.Y = LOrbiter.Position.Y
	
	Point1.X = 0
	Point1.Y = LOrbiter.Center.Y
		
	LOrbiter.Beta = CalcAngle(Point1,Point2)
	
	
endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterRotate(POrbiter as TOrbiter,Alpha as float,Beta as float)
	
	local LOrbiter as TOrbiter
	local NewAlpha as float
	local NewBeta as float
	
	NewAlpha = SetAngle(POrbiter.Alpha,Alpha)
	NewBeta = SetAngle(POrbiter.Beta,Beta)
	
	LOrbiter = GetOrbiterPosition(POrbiter.Center,POrbiter.Radius,NewAlpha,NewBeta)
	
endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterZoom(POrbiter as TOrbiter,Radius as float)

	local LOrbiter as TOrbiter
	local NewRadius as float
	
	NewRadius = POrbiter.Radius+Radius

	LOrbiter = GetOrbiterPosition(POrbiter.Center,NewRadius,POrbiter.Alpha,POrbiter.Beta)

endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterLift(POrbiter as TOrbiter,Length as float)

	local LOrbiter as TOrbiter
	local NewPosition as TVector
	
	NewPosition = POrbiter.Position
	NewPosition.Y = POrbiter.Position.Y+Length
	
	LOrbiter = GetOrbiterAngleRefresh(POrbiter,NewPosition)

endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterMove(POrbiter as TOrbiter,Length as float)

	local LOrbiter as TOrbiter
		
	LOrbiter = POrbiter
	
	LOrbiter.Center = GetNewVetorA(POrbiter.Center,Length,LOrbiter.Alpha)
	LOrbiter = GetOrbiterPosition(LOrbiter.Center,LOrbiter.Radius,LOrbiter.Alpha,LOrbiter.Beta)
	
endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterStrafeRight(POrbiter as TOrbiter,Length as float)

	local LOrbiter as TOrbiter
		
	LOrbiter = POrbiter
	
	LOrbiter.Center = GetNewVetorARight(POrbiter.Center,Length,LOrbiter.Alpha)
	LOrbiter = GetOrbiterPosition(LOrbiter.Center,LOrbiter.Radius,LOrbiter.Alpha,LOrbiter.Beta)

endfunction LOrbiter

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function GetOrbiterStrafeLeft(POrbiter as TOrbiter,Length as float)

	local LOrbiter as TOrbiter
		
	LOrbiter = POrbiter

	LOrbiter.Center = GetNewVetorALeft(POrbiter.Center,Length,LOrbiter.Alpha)
	LOrbiter = GetOrbiterPosition(LOrbiter.Center,LOrbiter.Radius,LOrbiter.Alpha,LOrbiter.Beta)
	
endfunction LOrbiter




