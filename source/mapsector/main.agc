
// Project: mapsector 
// Created: 25-03-05

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "mapsector" )
SetWindowSize( 1200, 675, 0 )
SetWindowAllowResize( 0 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1200, 675 ) // doesn't have to match the window
SetOrientationAllowed( 0, 0, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

#option_explicit

#include "def_keys.agc"
#include "def_global.agc"

#include "lib_file.agc"
#include "lib_geometry.agc"
#include "lib_language.agc"
#include "lib_meshmemblock.agc"
#include "lib_string.agc"
#include "lib_timer.agc"
#include "lib_color.agc"

#include "inc_mapsector.agc"

local Map as TMapSectorData

MapSectorSizeSet(Map,30,4,30,15,15)

Map.TileSize = 4
Map.TileHeight = 2
Map.ClipHeight = 4

Map.Properties.Altitude = 75

Map.Source.Path = "/media/data/mapsector"
Map.Source.File = "mapsector.json"

Print("load data and textures")
sync()
MapSectorDataSourceLoad(Map)
MapSectorTexturesLoad(Map)
MapSectorFloorImagesLoad(Map)
MapSectorFloorObjectsLoad(Map)
MapSectorAmbientObjectsLoad(Map)

Print("generate heighmap")
sync()
MapSectorTerrainGenerate(Map)

Print("generate terrain")
sync()
MapSectorTerrainTypeGenerate(Map)

Print("generate ground")
sync()
MapSectorGroundGenerate(Map)

Print("generate textures")
sync()
MapSectorTextureSet(Map)

Print("generate map object")
sync()
MapSectorObject3DGenerate(Map)

Print("generate map floor objects")
sync()
MapSectorFloorObjectsGenerate(Map)

Print("init camera")
sync()
MapSectorCameraInit(Map.Camera)

Print("init skybox")
sync()
MapSectorSkyBoxInit(Map.SkyBox,Map.Camera)

repeat
	Print( ScreenFPS() )
	MapSectorCameraMove(Map.Camera)
	MapSectorSkyBoxRecalc(Map.SkyBox,Map.Camera)
	MapSectorSkyBoxDo(Map.SkyBox,Map.Camera)
	Sync()
until GetRawKeyState(Key_Escape) = 1
