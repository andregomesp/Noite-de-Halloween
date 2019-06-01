
local movimento = { speed = 5000 }



function movimento.esquerda(parametros)

    parametros.motionx = -parametros.speed
    parametros.motiony = 0
    parametros.hero.voarPerfil.isVisible = false
    --parametros.hero.voarCostas.isVisible = true
    --parametros.hero.voarCostas.isBodyActive = true
end

function movimento.direita(parametros)

    parametros.hero.voarPerfil.isVisible = true
    transition.cancel("voo")
    transition.to(parametros.hero.voarPerfil,{x = display.contentWidth - 100, time = movimento.speed, tag = "voo"})
end

function movimento.cima(parametros)

    parametros.hero.voarPerfil.isVisible = true
    transition.cancel("voo")
    transition.to(parametros.hero.voarPerfil, {y = 100, time = movimento.speed/2, tag = "voo"})
end

function movimento.baixo(parametros)

    
    --parametros.hero.voarCostas.isVisible = false
    parametros.hero.voarPerfil.isVisible = true
end

function movimento.parar()

    --parametros.motionx = 0
    --parametros.motiony = 0
    transition.cancel("voo")
end

return movimento