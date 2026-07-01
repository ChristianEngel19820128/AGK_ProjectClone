
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TMapSectorSkyBox1
	
	Center as TVector
	Diameter as float
	Distance as float
	
	SkySphere as integer
	
	SunSphere as integer
	SunImg as integer
	SunOrbiter as TOrbiter
	SunTransTime as TTime
		
	MoonSphere as integer
	MoonImg as integer
	MoonOrbiter as TOrbiter
	MoonTransTime as TTime
	
	
	StarsSphere as integer
	StarsImg as integer
	
	CloudMax as integer
	CloudPlane as integer[3,1]
	CloudSphere as integer[-1]
	CloudImg as integer
	CloudTransTime as TTime[1]
	CloudAnim as float[3,1]
	
	SkyTrans as integer
	SkyTransTime as TTime
	
endtype

type TMapSectorSkyBox
	
	Center as TVector
	Diameter as float
	Distance as float
	
	Sphere as integer
	
	Sun as TOrbSphere
	
	Moon as TOrbSphere
	
	Stars as TOrbPlane[3]
	
	Cloud as TOrbPlane[3]
	
endtype

type TOrbSphere
	
	Sphere as integer
	SphereColor as TColor
	SkyColor as TColor
	HorizonColor as TColor
	Img as integer
	Orbiter as TOrbiter
	TransTime as TTime
	
endtype

type TOrbPlane
	
	Plane as integer
	Img as integer
	Orbiter as TOrbiter
	TransTime as TTime
	
endtype

