
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

local bgMusic = audio.loadSound("assets/audio/music/musica2.mp3")

local pickupSound = audio.loadStream( "assets/audio/sounds/chimes.wav" )

audio.reserveChannels(1)
audio.setVolume(0.4, {channel = 1})

local function onClose( event )
    audio.stop();
end

local heroi = require("src/heroi/heroi")
local controle = require("src/display/joystick")

local function gotoNext()
    
    composer.removeScene("game")
	composer.gotoScene( "fase2", { time=800, effect="crossFade" } )
end

local died = false -- Variavel para controlar as mortes do jogador

local pegaPote = false -- variavel para controlar a captura de potes

local caindo = true -- variavel para controlar movimento do inimigo

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Criando e carregando as imagens de fundo para a fase --

local background = display.newImageRect(backGroup, "assets/images/backgrounds/BG.png", 1800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterY

 --loading caixa
 local caixa = display.newImageRect(mainGroup, "assets/images/objects/Crate.png", 98, 79  )
 caixa.x = display.contentCenterX
 caixa.y = display.contentHeight-130
 physics.addBody(caixa, "static")

 --loading skull
 local skull = display.newImageRect(mainGroup, "assets/images/objects/cav.png", 40, 40)
 skull.x = 596
 skull.y = display.contentHeight-120
 skull.xScale = 1.8
 skull.yScale = 1.8

 -- loading frasco de sangue
local  potSangue = display.newImageRect(mainGroup, "assets/images/objects/potsangue.png", 30, 30)
 potSangue.x = 510
 potSangue.y = display.contentHeight-190
 potSangue.xScale = 1.5
 potSangue.yScale = 1.5
 potSangue.name = "1Pote"
 physics.addBody(potSangue, "static", {density = 5.0, radius= 33, bounce = 0})
 potSangue.isSensor = true
 

 --loading gato
local gato = display.newImageRect(mainGroup, "assets/images/objects/gato.png", 40, 40)
 gato.x = 420
 gato.y = display.contentHeight-130
 gato.xScale = 2.0
 gato.yScale = 2.0   


 --loading UI TOP elements-------------------------------------

 local imgVida = display.newImageRect(backGroup, "assets/images/ui/menutopo.png", 960, 190)
imgVida.x = display.contentCenterX-1
imgVida.y = display.contentHeight -568
imgVida.xScale = 1.1
imgVida.yScale = 1.1

local bordaSuperior = display.newImageRect(backGroup, "assets/images/ui/menutopo.png", 1200, 190)
bordaSuperior.x = display.contentCenterX
bordaSuperior.y = display.contentHeight-650
physics.addBody(bordaSuperior, "static")
bordaSuperior.isVisible = false
bordaSuperior.isBodyActive = true

local bordaLateral = display.newImageRect(backGroup, "assets/images/ui/menutopo.png", 30, 2000)
bordaLateral.x = display.contentCenterX-500
bordaLateral.y = display.contentCenterY+240
physics.addBody(bordaLateral, "static")
bordaLateral.isBodyActive = true
bordaLateral.isVisible = false

local bordaLateralFim = display.newImageRect(backGroup, "assets/images/ui/menutopo.png", 20, 2000)
bordaLateralFim.x = display.contentCenterX+520
bordaLateralFim.y = display.contentCenterY+240
physics.addBody(bordaLateralFim, "static")
bordaLateralFim.isBodyActive = true
bordaLateralFim.isVisible = false

local bordaEmbaixo = display.newImageRect(backGroup, "assets/images/ui/menutopo.png", 2000, 30)
bordaEmbaixo.x = display.contentCenterX
bordaEmbaixo.y = display.contentCenterY+295
physics.addBody(bordaEmbaixo, "static")
bordaEmbaixo.isBodyActive = true
bordaEmbaixo.isVisible = false  

----------------------------------------------------------------------------------------------------
-- Countdown Timer = 12 Minutos Para o Fim do jogo
local secondsLeft = 300

local clockText = display.newText(uiGroup, "05:00", display.contentCenterX, display.contentHeight-615, native.systemFont, 32)

--UI Topo Informacao potes de sangue total
local qtdPotSangue = 0
local xTotalSangue = display.newText(uiGroup, tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )


--local vidas = 5
local vidasText = display.newText(uiGroup, heroi:getVidas(), display.contentCenterX-412, display.contentHeight-618, native.systemFont, 42)


local parametros = { motionx = 0, motiony = 0, speed = 3.0, hero = heroi }
----- Folha de sprites do morcego e seus inimigos ---------------------------------------

---Morcego---------------------------
	
-----------Fantasma ---------------------------------------------

local fantasma = display.newImageRect(mainGroup, "assets/images/enemies/fantasma.png", 96, 77)
fantasma.x = 500
fantasma.y = display.contentHeight-500
physics.addBody(fantasma,"kinematic", {density = 14, radius = 40, bounce = 0.0})
fantasma.myName = "fantasma"

local caindo = true

local function subiredescer()  
        if(caindo)then
            caindo= false
            transition.to(fantasma, {y = display.contentCenterY+180, time = 2000,onComplete=subiredescer  })
        else
            caindo = true
            transition.to(fantasma, {y = display.contentCenterY-180, time = 2000,onComplete=subiredescer  })
        end
    end

subiredescer()
 
--------------Controllers----------------------------------------------------------------------
    
--------------------------------------------------------------------------------------------------
----Set Up Para Movimentacao do Morcego --------------------------

----Functions do Jogo -----------------------------------------------

local function UpdateTime( event ) ---- Funcao Decrementa o Tempo
    secondsLeft = secondsLeft - 1
    
    local minutes = math.floor( secondsLeft / 60)
    local seconds = secondsLeft % 60

    local timeDisplay = string.format("%02d:%02d", minutes, seconds)

    clockText.text = timeDisplay
    return(timer)
end

local countDownTimer = timer.performWithDelay(1000, UpdateTime, secondsLeft)

local function timeOut (event)
    if (secondsLeft < 10) then
        clockText:setFillColor( 1, 0, 0 )
    end
    
    if(secondsLeft == 0) then
        composer.removeScene("game")
           composer.gotoScene("over")
    end
end


voo:addEventListener( "enterFrame", start );

vooCostas:addEventListener("enterFrame", start);

local function moveMorcego(event)

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


controle.left:addEventListener("tap",heroi.voo.esquerda(parametros))
controle.right:addEventListener("tap", heroi.voo.direita(parametros))
controle.down:addEventListener("tap", heroi.voo.baixo(parametros))
controle.up:addEventListener("tap", heroi.voo.cima(parametros))

controle.botaoA:addEventListener("tap", heroi.voo.parar(parametros))


local function bPegaPote(event)
    if(event.phase =="began") then
        if (event.target == obj2 or event.target == obj4 and event.other == obj1) then
            pegaPote = true
        timer.performWithDelay(850, function()
            pegaPote = false
        end)
			return (pegaPote) 
		end
	end
end

voo:addEventListener("collision", bPegaPote)

vooCostas:addEventListener("collision", bPegaPote)


local function capturar(event)
        if (pegaPote)  then
            
			audio.play( pickupSound )
            obj1:removeSelf()
             local plus = display.newImageRect(mainGroup, "assets/images/misc/plus1.png", 90, 90)
                plus.x = 510
                plus.y = display.contentHeight-190
                plus.xScale = 0.5
                plus.yScale = 0.5
                physics.addBody(plus, "kinematic")
                plus:setLinearVelocity(0, -35 )

                timer.performWithDelay (300, function()
                display.remove(plus)
                --display.remove(xTotalSangue)
                qtdPotSangue = qtdPotSangue + 1
                xTotalSangue.text = qtdPotSangue --display.newText(tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )
                plus:removeSelf()
                pegaPote = false
                end )
        end
end

b:addEventListener("tap", capturar)

-------------Colisao com Inimigo ----------------------------------- 

local function enemyCollision(event)
	if(event.phase =="began") then
		if(event.target == obj2 and event.other == obj3) then
			died = true
		--	display.remove(vidasText)
			vidas = vidas - 1   
            if(vidas > -1) then
            
			vidasText.text =  vidas --display.newText(tostring(vidas), display.contentCenterX-412, display.contentHeight-618, native.systemFont, 42)
			obj2.isVisible = false

				local minushp = display.newImageRect( mainGroup, "assets/images/misc/minuslife.png", 90, 90)
				minushp.x = obj2.x
				minushp.y = obj2.y
				minushp.xScale = 0.8                    minushp.yScale = 0.8
				timer.performWithDelay(700, function()
				display.remove(minushp)
				end)
				timer.performWithDelay(500, function()
				obj2.x = display.contentCenterX-420
				obj2.y = display.contentCenterY
				obj2.isVisible = true 

				obj4.x = obj2.x
				obj4.y = obj2.y
				obj4.isVisible = false

				end)     
			motionx = 0
			motiony = 0
            else
                
                composer.removeScene("game")

                composer.gotoScene("over")
			end
		end
	end
end 

local function caixaCollision(event)
    if (event.phase =="began")then
        if(event.target == obj2 and event.other == caixa) then
            pegaPote = false
            motionx = 0
            motiony = 0 
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

local function bordaCollisionFim(event)
    if(event.phase == "began") then
        if (event.target == obj2 and event.other == bordaLateralFim) then
                motionx = 0
                motiony = 0
            if(qtdPotSangue == 1) then
                    --composer.removeScene("game")
                    local parametros = { tempo = secondsLeft, life = vidas }
                        
                    composer.gotoScene("fase2", {params = parametros})
                
            end
        end
    end
end

---------------------------------------------------------------------
-----Event Listeners ------------------------------------------------
voo:addEventListener("collision", caixaCollision)

--vooCostas:addEventListener("collision", caixaCollision)

voo:addEventListener("collision", enemyCollision)

voo:addEventListener("collision", bordaCollision)

voo:addEventListener("collision", bordaCollisionFim)

Runtime:addEventListener("enterFrame", timeOut)



--vooCostas:addEventListener("collision", enemyCollision)

--vooCostas:addEventListener("collision", bordaCollision)

------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	sceneGroup:insert( backGroup )
	sceneGroup:insert( mainGroup )
    sceneGroup:insert (uiGroup)

    physics.addBody(potSangue, "static", {density = 5.0, radius= 28, bounce = 0})
    
    
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
        Runtime:removeEventListener("enterFrame", timeOut) 
        Runtime:removeEventListener("enterFrame", moveMorcego ); 
        
      elseif ( phase == "did" ) then
        Runtime:removeEventListener("enterFrame", timeOut) 
        Runtime:removeEventListener("enterFrame", moveMorcego ); 
        sceneGroup:remove( mainGroup )
	    sceneGroup:remove (uiGroup)
        physics.pause()
        composer.removeScene( "game" )
        
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
