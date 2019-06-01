
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

--physics.setDrawMode("hybrid")
local bgMusic = audio.loadSound("assets/audio/music/chefe.mp3")

local vitoriaMusic = audio.loadSound("assets/audio/music/vitoria.mp3")

local damageSound = audio.loadSound("assets/audio/sounds/beep.mp3")

audio.reserveChannels(1)
audio.setVolume(0.4, {channel = 1})

local function onClose( event )
    audio.stop();
end

local function gotoNext()
    
    composer.removeScene("fase5")
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end


local died = false -- Variavel para controlar as mortes do jogador

local caindo = true -- variavel para controlar movimento do inimigo

local vaiEvolta = true

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local vidasText 

local clockText

local skullLoopTimer 

-- Criando e carregando as imagens de fundo para a fase --

local background = display.newImageRect(backGroup, "assets/images/backgrounds/castelo.gif", 1200, 600)
background.x = display.contentCenterX
background.y = display.contentCenterY

 -- loading frasco de sangue---

 ------------Elementos do Cenario Fase 2 -------------------------------------------------------------------------------------------




 --loading UI TOP elements-------------------------------------

 local imgVida = display.newImageRect(backGroup, "assets/images/backgrounds/menutopo.png", 960, 190)
imgVida.x = display.contentCenterX-1
imgVida.y = display.contentHeight -568
imgVida.xScale = 1.1
imgVida.yScale = 1.1

local bordaSuperior = display.newImageRect(backGroup, "assets/images/backgrounds/menutopo.png", 1200, 190)
bordaSuperior.x = display.contentCenterX
bordaSuperior.y = display.contentHeight-650
bordaSuperior.isVisible = false
bordaSuperior.isBodyActive = true

local bordaLateral = display.newImageRect(backGroup, "assets/images/backgrounds/menutopo.png", 30, 2000)
bordaLateral.x = display.contentCenterX-500
bordaLateral.y = display.contentCenterY+240

bordaLateral.isBodyActive = true
bordaLateral.isVisible = false

local bordaLateralFim = display.newImageRect(backGroup, "assets/images/backgrounds/menutopo.png", 20, 2000)
bordaLateralFim.x = display.contentCenterX+520
bordaLateralFim.y = display.contentCenterY+240

bordaLateralFim.isBodyActive = true
bordaLateralFim.isVisible = false

local bordaEmbaixo = display.newImageRect(backGroup, "assets/images/backgrounds/menutopo.png", 2000, 30)
bordaEmbaixo.x = display.contentCenterX
bordaEmbaixo.y = display.contentHeight-75
bordaEmbaixo.isBodyActive = true
bordaEmbaixo.isVisible = false  

----------------------------------------------------------------------------------------------------
-- Countdown Timer = 12 Minutos Para o Fim do jogo

local secondsLeft -- = 650

local clockText = display.newText(uiGroup, tostring(secondsLeft), display.contentCenterX, display.contentHeight-615, native.systemFont, 32)

local qtdPotSangue = 10

local xTotalSangue 
----- Folha de sprites do morcego e seus inimigos ---------------------------------------

---Morcego---------------------------
local sheetOptions = 
{
    width = 48,
    height = 45,
    numFrames = 4
}

local morcego_sheet = graphics.newImageSheet("assets/images/backgrounds/vampiro.png", sheetOptions )

local sequenceVoar = {
    {
        name = "voar",
        start = 1,
        count = 4,
        time = 900,
        loopCount = 1,
        loopDirection = "forward"
    }


}

local morcegoCostas = graphics.newImageSheet("assets/images/backgrounds/vampiroCostas.png", sheetOptions)

local sequenceVoarCostas = {

        name = "voarCostas",
        start = 1,
        count = 4,
        time = 900,
        loopCount = 1,
        loopDirection = "backward"
}

local voo = display.newSprite(mainGroup, morcego_sheet, sequenceVoar)
local vooCostas = display.newSprite(mainGroup, morcegoCostas, sequenceVoarCostas)

    voo.x = display.contentCenterX-460
    voo.y = display.contentCenterY
    voo.isVisible = true
    voo.xScale = 2.3
    voo.yScale = 2.3
    voo:setSequence("voar")
    voo:play()
    voo.isBodyActive = true

    vooCostas.x = voo.x
    vooCostas.y = voo.y
    vooCostas.isVisible = false
    vooCostas.xScale = 2.3
    vooCostas.yScale = 2.3
    vooCostas:setSequence("voarEsquerda")
    vooCostas:play()
	vooCostas.isBodyActive = false
	
-----------Fantasma ---------------------------------------------




local sheetOptionsRei = 
{
    width = 48,
    height = 65,
    numFrames = 4
}

local rei_sheet = graphics.newImageSheet("assets/images/backgrounds/reiVamp.png", sheetOptionsRei)

local reiAndar = {
    {
        name = "esqAndar",
        start = 4,
        count = 6,
        time = 700,
        loopCount = 0,
        loopDirection = "backward"
    }
}


    
local rei= display.newSprite(mainGroup, rei_sheet, reiAndar)
 rei.x = display.contentCenterX+470
 rei.y = display.contentHeight-2000
 rei.xScale = 2.8
 rei.yScale = 2.8
 rei.isVisible = true
 rei.isBodyActive = false
 rei:setSequence("esqAndar")

rei.myName = "reiVamp"
rei:play()

 
local caindo = true
 
 local function subiredescer()  
         if(caindo)then
             caindo= false
             transition.to(rei, {y = display.contentCenterY+100, time = 2000,onComplete=subiredescer  })
         else
             caindo = true
             transition.to(rei, {y = display.contentCenterY-130, time = 2000,onComplete=subiredescer  })
         end
 end
 

----------------------------------------------------------------------------------------------

local function createSkull()
    local skull = display.newImageRect(mainGroup, "assets/images/backgrounds/skull.png", 60, 60)
      skull.x = rei.x
      skull.y = rei.y
      skull.xScale = 1.0
      skull.yScale = 1.0
      skull:toBack()
      skull.myName = "skull"
      physics.addBody(skull,"static", {density = 14, radius = 40, bounce = 0.0, isSensor = false})
      transition.to(skull, {x = -70, time = 4000, onComplete = function()
         display.remove(skull) end })
     end
 
local skullLoopTimer = timer.performWithDelay(3000, createSkull, 0)
--------------Controllers----------------------------------------------------------------------
    local left = display.newImageRect(mainGroup, "assets/images/backgrounds/larrow.png", 90, 90)
    left.x = display.contentCenterX-450
    left.y = display.contentHeight-162
    left.xScale = 0.6
    left.yScale = 0.6

    local right = display.newImageRect(mainGroup, "assets/images/backgrounds/rightarrow.png", 90, 90)
    right.x = display.contentCenterX-320
    right.y = display.contentHeight-162
    right.xScale = 0.6
    right.yScale = 0.6

    local down = display.newImageRect(mainGroup, "assets/images/backgrounds/downarrow.png", 90, 90)
    down.x = display.contentCenterX-384
    down.y = display.contentHeight-130
    down.xScale = 0.6
    down.yScale = 0.6

    local up = display.newImageRect(mainGroup, "assets/images/backgrounds/uparrow.png", 90, 90)
    up.x = display.contentCenterX-384
    up.y = display.contentHeight-210
    up.xScale = 0.6
    up.yScale = 0.6
    
    local a = display.newImageRect(mainGroup, "assets/images/backgrounds/abutton.png", 90, 90)
    a.x = display.contentCenterX+320
    a.y = display.contentHeight-141
    a.xScale = 0.7
    a.yScale = 0.7

    local b = display.newImageRect(mainGroup, "assets/images/backgrounds/bbutton.png", 90, 90)
    b.x = display.contentCenterX+430
    b.y = display.contentHeight-141
    b.xScale = 0.7
    b.yScale = 0.7
    
--------------------------------------------------------------------------------------------------
----Set Up Para Movimentacao do Morcego --------------------------

local motionx = 0
local speed = 3.0
local motiony = 0



----Functions do Jogo -----------------------------------------------

local function UpdateTime( event ) ---- Funcao Decrementa o Tempo
    secondsLeft = secondsLeft - 1
    
    local minutes = math.floor( secondsLeft / 60)
    local seconds = secondsLeft % 60

    local timeDisplay = string.format("%02d:%02d", minutes, seconds)

    clockText.text = timeDisplay
    --return(timer)
end

local countDownTimer = timer.performWithDelay(1000, UpdateTime, secondsLeft)

local function timeOut (event)
    if (secondsLeft < 10) then
        clockText:setFillColor( 1, 0, 0 )
    end
    
    if(secondsLeft == 0) then
         composer.removeScene("fase2")
           composer.gotoScene("over")
    end
end

local function start( event ) --starta a movimentacao do sprite do morcego

    --  audio.play( musicaFundo, { loops = -1 } );
      voo.isVisible = true;
      voo:setSequence("voar")
      voo:play()
      Runtime:addEventListener( "enterFrame", move )
      vooCostas.isVisible = false
      vooCostas:setSequence("voarEsquerda")
      vooCostas:play()
      Runtime:addEventListener("enterFrame", move)
  
  end


voo:addEventListener( "enterFrame", start );

vooCostas:addEventListener("enterFrame", start);

local function moveMorcego(event)
    voo.x = voo.x + motionx
    voo.y = voo.y + motiony
    vooCostas.x = vooCostas.x + motionx
    vooCostas.y = vooCostas.y + motiony

end

Runtime:addEventListener("enterFrame", moveMorcego)


local function spriteListener( event )
 
    local morcego_voando = event.target  
 
    if ( event.phase == "ended" ) then 
        morcego_voando:setSequence( "voar", "voarEsquerda" )  
        morcego_voando:play()  
        
    end
end

voo:addEventListener( "sprite", spriteListener )

vooCostas:addEventListener("sprite", spriteListener)



local function esquerda()
    motionx = -speed
    motiony = 0
    voo.isVisible = false
    voo.isBodyActive = false
    vooCostas.isVisible = true
    vooCostas.isBodyActive = true
end

left:addEventListener("touch", esquerda)

local function direita()
    motionx = speed
    motiony = 0
    vooCostas.isVisible = false
    vooCostas.isBodyActive = false
    voo.isVisible = true

end
right:addEventListener("touch", direita)
 
local function cima()
    motionx = 0
    motiony = -speed
    vooCostas.isVisible = false
    vooCostas.isBodyActive = false
    voo.isVisible = true
  
end

up:addEventListener("touch", cima)

local function baixo()
    motiony = speed
    motionx = 0
    vooCostas.isVisible = false
    voo.isVisible = true
    
end
down:addEventListener("touch", baixo)

local function parar()
    motionx = 0
    motiony = 0
end

a:addEventListener("touch", parar)

local function destroiSkull(self, event)
    local obj1 = event.target
    local obj2 = event.other
    if (event.phase=="began") then
    print(obj1.x)
        if (obj2.myName == "Fogo" and obj1.myName == "skull") then
            display.remove(obj2)
            display.remove(obj1)
        end
    end
end


local function atirar()

    local newBall = display.newImageRect(mainGroup, "assets/images/bullets/bloodball.png", 90, 90)
        physics.addBody(newBall, "dynamic", {alpha = 3.0, radius = 10, isSensor = true})
        newBall.isBullet = true
        newBall.isVisible = true
        newBall.myName ="Fogo"

        newBall.x = voo.x
        newBall.y = voo.y
        newBall:toFront()
        transition.to(newBall, {x=display.contentWidth+40, time = 2000,
        onComplete = function() display.remove(newBall) end
    })
    return (newball)
end

--skull.collision = destroiSkull
--skull:addEventListener("collision")


b:addEventListener("tap", atirar)


local chefaoVida = 5

function bossFinal (event)
    local obj2 = event.other

    if(event.phase == "began") then
        if(obj2.myName =="Fogo")then
            display.remove(obj2)
            chefaoVida = chefaoVida - 1

        if(chefaoVida == 0)then
            local vitoria = display.newImageRect(mainGroup, "assets/images/backgrounds/gamecomplete.png", 547, 347)
            vitoria.x = display.contentCenterX
            vitoria.y = display.contentCenterY
            onClose()
            audio.play(vitoriaMusic, {channel = 1, loops = -1})
            vitoria:addEventListener( "tap", gotoNext )
        end
    end
end
end

rei:addEventListener("collision", bossFinal)


-------------Colisao com Inimigo ----------------------------------- 

local function enemyCollision(self, event)
    local obj1 = event.target
    local obj2 = event.other
    if(event.phase =="began") then
        if (obj2.myName =="skull")  then
            audio.play(damageSound, {channel = 1, loops = -1})
            died = true
            vidas = vidas - 1   
            display.remove(obj2)
           -- display.remove(vidasText)
            if(vidas > -1) then
        
            vidasText.text = tostring(vidas) --display.newText(tostring(vidas), display.contentCenterX-412, display.contentHeight-618, native.systemFont, 42)
			--obj2.isVisible = false

				local minushp = display.newImageRect(mainGroup, "assets/images/backgrounds/minuslife.png", 90, 90)
				minushp.x = voo.x
				minushp.y = voo.y
                minushp.xScale = 0.8         
                minushp.yScale = 0.8
				timer.performWithDelay(700, function()
				display.remove(minushp)
				end)
				timer.performWithDelay(500, function()
				obj1.x = display.contentCenterX-420
				obj1.y = display.contentCenterY
				obj1.isVisible = true 

				vooCostas.x = obj1.x
				vooCostas.y = obj1.y
				vooCostas.isVisible = false

				end)     
			motionx = 0
			motiony = 0
             else
                composer.removeScene("fase5")
                composer.gotoScene("over")
			end
		end
	end
end 


local function bordaCollision(event)
    if (event.phase =="began")then
        if((event.target == obj2 and event.other == bordaSuperior) or 
          (event.target == obj2 and event.other == bordaLateral) or 
          (event.target == obj2 and event.other == bordaEmbaixo)) then
            pegaPote = false
            motionx = 0
            motiony = 0 
        end
    end
end



---------------------------------------------------------------------
-----Event Listeners ------------------------------------------------

Runtime:addEventListener("enterFrame", timeOut)


------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    physics.pause()
	sceneGroup:insert( backGroup )
	sceneGroup:insert( mainGroup )
    sceneGroup:insert (uiGroup)
  
    local parametros = event.params

    secondsLeft = parametros.tempo
    vidas = parametros.life

    UpdateTime()

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
   
    
    if ( phase == "will" ) then
        
        onClose()
		-- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        physics.start()
        physics.addBody(vooCostas, "dynamic", {density = 10, radius = 40, bounce = -1, isSensor = true})
        physics.addBody(voo, "dynamic", {density = 10, radius = 40, bounce = -1, isSensor = true})

        physics.addBody(bordaEmbaixo, "static")
        physics.addBody(bordaLateral, "static")
        physics.addBody(bordaSuperior, "static")

        physics.addBody(rei, "static", { radius = 50})

        

--UI Topo Informacao potes de sangue total

        
        vidasText = display.newText(uiGroup, tostring(vidas), display.contentCenterX-412, display.contentHeight-618, native.systemFont, 42)
        xTotalSangue = display.newText(uiGroup, tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )

        --clockText = display.newText(uiGroup, tempo, display.contentCenterX, display.contentHeight-615, native.systemFont, 32)
        local countDownLoopTimer = timer.performWithDelay(1000, UpdateTime, secondsLeft)

            subiredescer()
 

		-- Code here runs when the scene is entirely on screen
            audio.play(bgMusic, {channel = 1, loops = -1})

  
        

            voo.collision = enemyCollision

            vooCostas.collision = enemyCollision

            voo:addEventListener("collision")

            vooCostas:addEventListener("collision")
    
            voo:addEventListener("collision", bordaCollision)
            vooCostas:addEventListener("collision", bordaCollision)
    
    end
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        onClose()
        timer.cancel(skullLoopTimer)
        timer.cancel(subiredescer)

        audio.stop()

      elseif ( phase == "did" ) then
        Runtime:removeEventListener("enterFrame", timeOut) 
        Runtime:removeEventListener("enterFrame", moveMorcego ); 
        sceneGroup:remove( mainGroup )
        sceneGroup:remove (uiGroup)
        sceneGroup:remove(backGroup)
        
        physics.pause()
        composer.removeScene( "fase5" )
  
		-- Code here runs immediately after the scene goes entirely off scree

        
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
