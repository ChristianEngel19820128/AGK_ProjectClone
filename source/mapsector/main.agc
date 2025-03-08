
// Project: mapsector 
// Created: 25-03-05

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "mapsector" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 0 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 0, 0, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

#option_explicit

#include "def_global.agc"
#include "lib_meshmemblock.agc"
#include "inc_mapsector.agc"

local TextureImage as integer
local ClipImage as integer
local CliffImage as integer

TextureImage = LoadImage("tex.png")
ClipImage = LoadImage("clip.png")
CliffImage = LoadImage("cliff.png")

local Map as TMapSectorData

MapSectorSizeSet(Map,30,5,30,10,10)

Map.TileSize = 2
Map.TileHeight = 1
Map.ClipHeight = 2

Map.Properties.Altitude = 75

Map.ClipImageID = ClipImage

Print("generate terrain")
sync()
MapSectorTerrainGenerate(Map)
MapSectorTerrainTypeGenerate(Map)

local x as integer
local y as integer
local z as integer

for x = 0 to Map.MapSizeX - 1
for y = 0 to Map.MapSizeY - 1
for z = 0 to Map.MapSizeZ - 1
	if MapSectorTileIsValid(Map,x,y,z) = TRUE
		if MapSectorTileIsTopTile(Map,x,y,z) = TRUE
			map.Tile[x,y,z].Data.Texture.ImageID = TextureImage
		else
			map.Tile[x,y,z].Data.Texture.ImageID = Map.ClipImageID
		endif
		if map.Tile[x,y,z].Data.Cliff[CSouth].Enabled = TRUE
			map.Tile[x,y,z].Data.Cliff[CSouth].Texture.ImageID = CliffImage
		endif
		if map.Tile[x,y,z].Data.Cliff[CNorth].Enabled = TRUE
			map.Tile[x,y,z].Data.Cliff[CNorth].Texture.ImageID = CliffImage
		endif
		if map.Tile[x,y,z].Data.Cliff[CEast].Enabled = TRUE
			map.Tile[x,y,z].Data.Cliff[CEast].Texture.ImageID = CliffImage
		endif
		if map.Tile[x,y,z].Data.Cliff[CWest].Enabled = TRUE
			map.Tile[x,y,z].Data.Cliff[CWest].Texture.ImageID = CliffImage
		endif
	endif
next z
next y
next x

Print("generate map object")
sync()
MapSectorObject3DGenerate(Map)

SetCameraPosition(1,-15,25,-15)
SetCameraLookAt(1,50,0,50,0)
SetCameraRange(1,1,150)

SetSunActive(1)
SetSunColor(255,255,0)
SetSunDirection(-1,-0.25,-1)
SetSkyBoxSunColor(255,255,0)
SetSkyBoxSunVisible(1)
SetSkyBoxVisible(1)

SetShadowMappingMode(1)

SetFogMode(1)
SetFogRange(0,750)
SetFogColor(200,200,200)
SetFogSunColor(255,255,0)

do
    Print( ScreenFPS() )
    Sync()
loop
