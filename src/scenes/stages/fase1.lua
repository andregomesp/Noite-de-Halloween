
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require("physics")
physics.setGravity = ( 0 )

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()



local heroi = require("src.heroi.heroi")
local fundo = require("src.fases.fase1")
local controle = require("src.display.joystick")

local parametros = { motionx = 0, motiony = 0, speed = 3.0, hero = heroi }

local parametrosFase = { grupo = backGroup }
local parametrosHeroi = { grupo = mainGroup, fisica = physics }
local parametrosControle = { grupo = uiGroup }
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup:insert(backGroup)
    sceneGroup:insert(mainGroup)
    sceneGroup:insert(uiGroup)

    physics.pause()

    fundo.fundo(parametrosFase)
    heroi:new(o,parametrosHeroi)
    controle:new(o,parametrosControle)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        physics.start()
        local direita = function() heroi.voo.direita(parametros) end
        local cima = function() heroi.voo.cima(parametros) end
        --local parar = function() heroi.voo.parar() end
        controle.right:addEventListener("tap",direita ) --heroi.voo.direita(parametros))
        controle.up:addEventListener("tap", cima)
        controle.botaoA:addEventListener("tap", heroi.voo.parar)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
