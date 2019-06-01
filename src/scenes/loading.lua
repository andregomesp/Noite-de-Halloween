
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local bgMusic = audio.loadSound("musica.mp3")


audio.reserveChannels(1)
audio.setVolume(0.4, {channel = 1})

local function onClose( event )
    audio.stop();
end

local function gotoGame()
	composer.gotoScene( "game", { time=900, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )
	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )
	local fundo = display.newImageRect( backGroup, "assets/images/backgrounds/loading.png", 820, 450 )
	fundo.x = display.contentCenterX
	fundo.y = display.contentCenterY
	fundo.xScale = 1.3
	fundo.yScale = 1.3

	local AvancarText = display.newText(mainGroup, "Clique no botão para avançar", display.contentCenterX+305, display.contentHeight-130, native.systemFont, 12)

    local botao = display.newImageRect(mainGroup, "assets/images/buttons/bbutton.png", 50,50 )
    botao.x = display.contentCenterX+310
    botao.y = display.contentHeight-170

    botao.isVisible = true

	botao:addEventListener("tap", gotoGame)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play(bgMusic, {channel = 1, loops = -1})

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		onClose()
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
