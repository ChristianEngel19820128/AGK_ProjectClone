
// Project: objectgenerator 
// Created: 26-06-22

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "objectgenerator" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

#option_explicit

#include "def_global.agc"
#include "def_keys.agc"
#include "def_floor_object.agc"

#include "lib_file.agc"
#include "lib_color.agc"
#include "lib_language.agc"
#include "lib_geometry.agc"
#include "lib_meshmemblock.agc"

#include "fnc_floor_object.agc"

local FloorObjectTypes as TFloorObjectTypeData[-1]

local ObjectData as TObjectData

ObjectData.TileSize = 4
ObjectData.TileHeight = 2

local ObjectID as integer[-1]

FloorObjectsLoad(FloorObjectTypes)
FloorObjectsGenerate(ObjectData,FloorObjectTypes,ObjectID)

local i as integer
local r as integer

repeat
	
	Print(ScreenFPS())
			
	inc r,2
	
	if r > 180 then r = -180
		
	for i = 0 to ObjectID.Length
		SetObjectRotation(ObjectID[i],0,r,0)
	next i
	
	Sync()
until GetRawKeyState(Key_Escape) = 1
