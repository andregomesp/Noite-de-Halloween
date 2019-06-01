
local imagens = {}

local sheetOptions = 
{
    width = 32,
    height = 32,
    numFrames = 4
}

local morcego_sheet = graphics.newImageSheet("assets/images/characters/morcegoperfil.png", sheetOptions )

local sequenceVoar = {
    {
        name = "voar",
        start = 1,
        count = 4,
        time = 900,
        loopCount = 0,
        loopDirection = "forward"
    }


}

local morcegoCostas = graphics.newImageSheet("assets/images/characters/morcegoperfilcostas.png", sheetOptions )

local sequenceVoarCostas = {

        name = "voarCostas",
        start = 1,
        count = 4,
        time = 900,
        loopCount = 0,
        loopDirection = "forward"
}

function imagens.carregarVooPerfil(parametros)

    local vooPerfil =  display.newSprite(parametros.grupo, morcego_sheet, sequenceVoar)
    vooPerfil.myName = "heroi"
    --vooPerfil:setSequence("voar")
    --vooPerfil:play()
    
    return vooPerfil
end

function imagens.carregarVooCostas(parametros)

    local vooCostas = display.newSprite(parametros.grupo, morcegoCostas, sequenceVoarCostas)
    vooCostas.myName = "heroi"

    return vooCostas
end

return imagens
