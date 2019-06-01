
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local bgMusic = audio.loadSound("musica.mp3")

local btnAudio = audio.loadSound("assets/audio/sounds/chimes.wav")

audio.reserveChannels(1)
audio.setVolume(0.4, {channel = 1})

local function onClose( event )
    audio.stop();
end

local function gotoLoading()
	composer.gotoScene( "loading", { time=100, effect="crossFade" } )
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
	local fundo = display.newImageRect( backGroup, "assets/images/backgrounds/telaInicio.png", 820, 480 )
	fundo.x = display.contentCenterX
	fundo.y = display.contentCenterY
	fundo.xScale = 1.3
	fundo.yScale = 1.3


	local start = display.newImageRect( mainGroup, "assets/images/ui/start.png", 120, 90)
	start.x = display.contentCenterX
	start.y = display.contentHeight-190
	start.xScale = 1.3
	start.yScale = 1.3
	start.alpha = 1.0
	start.isVisible = false
	startSound = false
	timer.performWithDelay(1230, function()
		start.isVisible = true
		startSound = true
	   end)

	start:addEventListener( "tap", gotoLoading )
	
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
		onClose()
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
