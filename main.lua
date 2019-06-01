-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local physics = require("physics")
physics.setGravity = ( 0 )
display.setStatusBar( display.HiddenStatusBar )

composer.gotoScene( "src.scenes.mainGameScene",
    {
        params = {
            stageNumber=1
        }
    })
--composer.gotoScene( "Menu Principal" )