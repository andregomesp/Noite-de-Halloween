
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

physics.setDrawMode("hybrid")
local bgMusic = audio.loadSound("assets/audio/music/musica2.mp3")

local pickupSound = audio.loadStream( "assets/audio/sounds/chimes.wav" )

audio.reserveChannels(1)
audio.setVolume(0.4, {channel = 1})

local function onClose( event )
    audio.stop(bgMusic);
    display.remove(fantasma)
    display.remove(eskeleton)
    display.remove(eskeletonVoltar)
    timer.cancel(skullLoopTimer)
end

local function gotoNext()
    
    composer.removeScene("fase3")
	composer.gotoScene( "fase4", { time=800, effect="crossFade" } )
end


local died = false -- Variavel para controlar as mortes do jogador

local pegaPote = false -- variavel para controlar a captura de potes

local caindo = true -- variavel para controlar movimento do inimigo

local vaiEvolta = true

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local vidasText 

local clockText

local skullLoopTimer 

-- Criando e carregando as imagens de fundo para a fase --

local background = display.newImageRect(backGroup, "assets/images/backgrounds/fase3bg.png", 1200, 600)
background.x = display.contentCenterX
background.y = display.contentCenterY

 -- loading frasco de sangue
local  potSangue2 = display.newImageRect(mainGroup, "assets/images/backgrounds/potsangue.png", 30, 30)
 potSangue2.x = display.contentCenterX+225
 potSangue2.y = display.contentHeight-120
 potSangue2.xScale = 1.5
 potSangue2.yScale = 1.5
 potSangue2.name = "2Pote"

 local  potSangue = display.newImageRect(mainGroup, "assets/images/backgrounds/potsangue.png", 30, 30)
 potSangue.x = display.contentCenterX-110
 potSangue.y = display.contentHeight-120
 potSangue.xScale = 1.5
 potSangue.yScale = 1.5
 potSangue.name = "1Pote"
 
 local  potSangue3 = display.newImageRect(mainGroup, "assets/images/backgrounds/potsangue.png", 30, 30)
 potSangue3.x = display.contentCenterX+384
 potSangue3.y = display.contentHeight-452
 potSangue3.xScale = 1.5
 potSangue3.yScale = 1.5
 potSangue3.name = "3Pote"


 ------------Elementos do Cenario Fase 2 -------------------------------------------------------------------------------------------
 local placa = display.newImageRect(mainGroup, "assets/images/backgrounds/emfrente.png", 40, 40)
 placa.x = display.contentCenterX+470 
 placa.y = display.contentHeight-460
 placa.xScale = 1.3
 placa.yScale = 1.3
 

local terreno = display.newImageRect(mainGroup, "assets/images/backgrounds/terreno.jpg", 30, 50)
    terreno.x = display.contentCenterX+380
    terreno.y = display.contentHeight-390
    terreno.yScale = 1.8
    terreno.xScale = 1.8


local terreno1 = display.newImageRect(mainGroup, "assets/images/backgrounds/terreno.jpg", 30, 50)
    terreno1.x = display.contentCenterX+400
    terreno1.y = display.contentHeight-390
    terreno1.xScale = 1.8
    terreno1.yScale = 1.8


local terreno2 = display.newImageRect(mainGroup, "assets/images/backgrounds/terreno.jpg", 30, 50)
    terreno2.x = display.contentCenterX+435
    terreno2.y = display.contentHeight-390
    terreno2.xScale = 1.8
    terreno2.yScale = 1.8


local terreno3 = display.newImageRect(mainGroup, "assets/images/backgrounds/terreno.jpg", 30, 50)
    terreno3.x = display.contentCenterX+485
    terreno3.y = display.contentHeight-390
    terreno3.xScale = 1.8
    terreno3.yScale = 1.8


local tree = display.newImageRect(mainGroup, "assets/images/backgrounds/Tree.png", 60, 60)
    tree.x = display.contentCenterX-210
    tree.y = display.contentHeight-150
    tree.xScale = 2.8
    tree.yScale = 2.8




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

local qtdPotSangue = 3

local xTotalSangue 
----- Folha de sprites do morcego e seus inimigos ---------------------------------------

---Morcego---------------------------
local sheetOptions = 
{
    width = 32,
    height = 32,
    numFrames = 4
}

local morcego_sheet = graphics.newImageSheet("assets/images/backgrounds/morcegoperfil.png", sheetOptions )

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

local morcegoCostas = graphics.newImageSheet("assets/images/backgrounds/morcegoperfilcostas.png", sheetOptions)

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
    voo.xScale = 3.0
    voo.yScale = 3.0
    voo:setSequence("voar")
    voo:play()
    voo.isBodyActive = true

    vooCostas.x = voo.x
    vooCostas.y = voo.y
    vooCostas.isVisible = false
    vooCostas.xScale = 3.0
    vooCostas.yScale = 3.0
    vooCostas:setSequence("voarEsquerda")
    vooCostas:play()
	vooCostas.isBodyActive = false
	
-----------Fantasma ---------------------------------------------

local fantasma = display.newImageRect(mainGroup, "assets/images/backgrounds/fantasma.png", 96, 77)
fantasma.x = display.contentCenterX+380
fantasma.y = display.contentHeight-470
fantasma.myName = "fantasma"

local caindo = true

local function subiredescer()  
        if(caindo)then
            caindo= false
            transition.to(fantasma, {y = display.contentCenterY+160, time = 2000,onComplete=subiredescer  })
        else
            caindo = true
            transition.to(fantasma, {y = display.contentCenterY-160, time = 2000,onComplete=subiredescer  })
        end
end



----------------------Eskeleto -----------------------------------------------------------------


local sheetOptionsEskeleto = 
{
    width = 32,
    height = 36,
    numFrames = 6
}

local esk_sheet = graphics.newImageSheet("assets/images/backgrounds/eskeleton.png", sheetOptionsEskeleto)

local eskeletoAndar = {
    {
        name = "esqAndar",
        start = 4,
        count = 6,
        time = 700,
        loopCount = 0,
        loopDirection = "backward"
    }
}

local eskeletonVoltar = {

{
    name = "voltar",
    start = 1,
    count = 3,
    time = 700,
    loopCount = 0,
    loopDirection = "forward"
}


}
    
local eskeleton = display.newSprite(mainGroup, esk_sheet, eskeletoAndar)
 eskeleton.x = display.contentCenterX+470
 eskeleton.y = display.contentHeight-170
 eskeleton.xScale = 2.2
 eskeleton.yScale = 2.2
 eskeleton.isVisible = true
 eskeleton.isBodyActive = false
 eskeleton:setSequence("esqAndar")

eskeleton.myName = "eskeleton"
eskeleton:play()



 local eskeletonVoltar = display.newSprite(mainGroup, esk_sheet, eskeletonVoltar)
 eskeletonVoltar.xScale = 2.2
 eskeletonVoltar.yScale = 2.2
 eskeletonVoltar.isVisible = false
 eskeletonVoltar.isBodyActive = false
 eskeletonVoltar:setSequence("voltar")
 eskeletonVoltar:play()


local function inverte()
    if(eskeleton.isVisible == true )then
        eskeletonVoltar.x = eskeleton.x
        eskeletonVoltar.y = eskeleton.y
       eskeletonVoltar.isVisible = true
        eskeletonVoltar.isBodyActive = true
        eskeleton.isVisible = false
        eskeleton.isBodyActive = false
    elseif( eskeleton.isVisible == false) then
        eskeleton.x = eskeletonVoltar.x
        eskeleton.y = eskeletonVoltar.y 
        eskeletonVoltar.isVisible = false
        eskeletonVoltar.isBodyActive = false
        eskeleton.isBodyActive = true
        eskeleton.isVisible = true
    end
end 
local function frenteTras()  
    if(vaiEvolta)then
        vaiEvolta = false
        transition.to(eskeleton, {x = display.contentCenterX+290, time = 5000, onComplete = function() inverte() frenteTras() end  })
        
    else
        vaiEvolta = true
        transition.to(eskeletonVoltar, {x = display.contentCenterX-280, time = 5000, onComplete = function() inverte() frenteTras() end   })
    end
end
--

--frenteTras()

----------------------------------------------------------------------------------------------

local function createSkull()
    local skull = display.newImageRect(mainGroup, "assets/images/backgrounds/skull.png", 60, 60)
      skull.x = display.contentCenterX-212
      skull.y = display.contentHeight-160
      skull.xScale = 1.0
      skull.yScale = 1.0
      skull:toBack()
      skull.myName = "skull"
      physics.addBody(skull,"static", {density = 14, radius = 40, bounce = 0.0, isSensor = false})
      transition.to(skull, {y = 180, time = 4000, onComplete = function()
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

local obj1 = potSangue
local obj2 = voo 
local obj3 = fantasma
local obj4 = vooCostas


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


local function bPegaPote(event)
    if(event.phase =="began") then
        if((event.target == obj2 and event.other == obj1) or
         (event.target == obj1 and event.other == obj4)) then
            pegaPote = true
        timer.performWithDelay(850, function()
            pegaPote = false
        end)
			return (pegaPote) 
		end
	end
end

local function bpegapote2(event)
    if (event.phase == "began") then
      if((event.target == obj2 and event.other == potSangue2) or
         (event.target == potSangue2 and event.other == obj4)) then
             pegaPote2 = true
         timer.performWithDelay(950, function()
             pegaPote2 = false
         end)
         return (pegaPote2)
         end
    end 
end

local function bpegapote3(event)
    if (event.phase == "began") then
      if((event.target == obj2 and event.other == potSangue3) or
         (event.target == potSangue3 and event.other == obj4)) then
             pegaPote3 = true
         timer.performWithDelay(950, function()
             pegaPote3 = false
         end)
         return (pegaPote3)
     end
 end
end
 
voo:addEventListener("collision", bPegaPote)

vooCostas:addEventListener("collision", bPegaPote)

voo:addEventListener("collision", bpegapote2)

vooCostas:addEventListener("collision", bpegapote2)


voo:addEventListener("collision", bpegapote3)

vooCostas:addEventListener("collision", bpegapote3)



local function capturar(event)
        if (pegaPote)  then
            
			audio.play( pickupSound )
            display.remove(potSangue)
             local plus = display.newImageRect(mainGroup, "assets/images/backgrounds/plus1.png", 90, 90)
                plus.x = voo.x
                plus.y = voo.y
                plus.xScale = 0.5
                plus.yScale = 0.5
                --plus:setLinearVelocity(0, -35 )

                timer.performWithDelay (300, function()
                display.remove(plus)
               -- display.remove(xTotalSangue)
                qtdPotSangue = qtdPotSangue + 1
                xTotalSangue.text = qtdPotSangue --display.newText(tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )
                plus:removeSelf()
                pegaPote = false
                end )
        end
        if(pegaPote2) then
            audio.play( pickupSound )
            display.remove(potSangue2)
            local plus = display.newImageRect(mainGroup, "assets/images/backgrounds/plus1.png", 90, 90)
            plus.x = voo.x
            plus.y = voo.y
            plus.xScale = 0.5
            plus.yScale = 0.5
            physics.addBody(plus, "kinematic")
            --plus:setLinearVelocity(0, -35 )

            timer.performWithDelay (300, function()
            display.remove(plus)
            --display.remove(xTotalSangue)
            qtdPotSangue = qtdPotSangue + 1
            xTotalSangue.text = qtdPotSangue --display.newText(tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )
            physics.removeBody(plus)
            
            pegaPote2 = false
            end)
        end
        if(pegaPote3) then
            audio.play( pickupSound )
            display.remove(potSangue3)
            local plus = display.newImageRect(mainGroup, "assets/images/backgrounds/plus1.png", 90, 90)
            plus.x = voo.x
            plus.y = voo.y
            plus.xScale = 0.5
            plus.yScale = 0.5
            physics.addBody(plus, "kinematic")
            --plus:setLinearVelocity(0, -35 )

            timer.performWithDelay (300, function()
            display.remove(plus)
            --display.remove(xTotalSangue)
            qtdPotSangue = qtdPotSangue + 1
            xTotalSangue.text = qtdPotSangue --display.newText(tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )
            physics.removeBody(plus)
            
            pegaPote3 = false
            end)
        end
           
end

b:addEventListener("tap", capturar)

-------------Colisao com Inimigo ----------------------------------- 

local function enemyCollision(self, event)
    local obj1 = event.target
    local obj2 = event.other
    if(event.phase =="began") then
        if ((obj1 == voo and obj2.myName =="skull" or obj2 == fantasma) or
            (obj1 == voo and obj2 == eskeleton) or 
            (obj1 == voo and obj2 == eskeletonVoltar)) then
            died = true
            vidas = vidas - 1   
            --display.remove(vidasText)
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

				obj4.x = obj1.x
				obj4.y = obj1.y
				obj4.isVisible = false

				end)     
			motionx = 0
			motiony = 0
            else
                composer.removeScene("fase3")
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

function bordaCollisionFim(event)
    if(event.phase == "began") then
        if (event.target == obj2 and event.other == bordaLateralFim) then
                motionx = 0
                motiony = 0
            if(qtdPotSangue == 6) then
                    composer.removeScene("fase3")
                    local parametros2 = { tempo = secondsLeft, life = vidas }
                    composer.gotoScene("fase5", {params = parametros2 })
            end 
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
        
		-- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        physics.start()
        physics.addBody(vooCostas, "dynamic", {density = 10, radius = 40, bounce = -1, isSensor = true})
        physics.addBody(voo, "dynamic", {density = 10, radius = 40, bounce = -1, isSensor = true})

        physics.addBody(bordaEmbaixo, "static")
        physics.addBody(bordaLateralFim, "static")
        physics.addBody(bordaLateral, "static")
        physics.addBody(bordaSuperior, "static")

        physics.addBody(potSangue, "static", {density = 5.0, radius= 32, bounce = 0})

        physics.addBody(potSangue2, "static", {density = 5.0, radius= 32, bounce = 0, isSensor = true})

       physics.addBody(potSangue3, "static", {density = 5.0, radius= 32, bounce = 0, isSensor = true})
 
        physics.addBody(terreno, "static")
        
        physics.addBody(terreno1, "static")
        
        physics.addBody(terreno2, "static")
        
        physics.addBody(terreno3, "static")

        physics.addBody(fantasma,"static", {density = 14, radius = 30, bounce = 0.0, isSensor = false})
        
        physics.addBody(eskeleton,"static", {density = 14, radius = 30, bounce = 0.0, isSensor = false})
        
        physics.addBody(eskeletonVoltar, "kinematic", {density = 14, radius = 30, bounce = 0.0, isSensor = false})
     

--UI Topo Informacao potes de sangue total

        
        vidasText = display.newText(uiGroup, tostring(vidas), display.contentCenterX-412, display.contentHeight-618, native.systemFont, 42)
        xTotalSangue = display.newText(uiGroup, tostring(qtdPotSangue), display.contentCenterX+385, display.contentHeight-615, native.systemFont, 42 )

        --clockText = display.newText(uiGroup, tempo, display.contentCenterX, display.contentHeight-615, native.systemFont, 32)
        local countDownLoopTimer = timer.performWithDelay(1000, UpdateTime, secondsLeft)

        subiredescer()
        frenteTras()
 

		-- Code here runs when the scene is entirely on screen
        audio.play(bgMusic, {channel = 1, loops = -1})

  
        

            voo.collision = enemyCollision

            vooCostas.collision = enemyCollision

            voo:addEventListener("collision")

            vooCostas:addEventListener("collision")
    
            voo:addEventListener("collision", bordaCollision)
    
            voo:addEventListener("collision", bordaCollisionFim)
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

      elseif ( phase == "did" ) then
        Runtime:removeEventListener("enterFrame", timeOut) 
        Runtime:removeEventListener("enterFrame", moveMorcego ); 
        voo:removeEventListener("collision", enemyCollision)
        vooCostas:removeEventListener("collision", enemyCollision)
        voo:removeEventListener("collision", bordaCollision)
        voo:removeEventListener("collision", bordaCollisionFim)

        eskeleton:removeSelf()
        eskeletoAndar:removeSelf()
        sceneGroup:remove( mainGroup )
        sceneGroup:remove (uiGroup)
        sceneGroup:remove(backGroup)
        
        physics.pause()
        composer.removeScene( "fase3" )
  
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
