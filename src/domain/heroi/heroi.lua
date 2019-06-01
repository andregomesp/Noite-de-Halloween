local imagens = require("src.domain.heroi.spriteHeroi")
local movimento = require("src.domain.heroi.movimento")

local Heroi = { voarPerfil = nil, voarCostas = nil, died = false, vidas = 5, voo = movimento  }

function Heroi:new(o,parametros)
    o = o or {}
    setmetatable(o, self);
    self.__index = self;
    --self.voarPerfil = 
    self:voarDePerfil(parametros)--imagens.carregarVooPerfil(parametros)
    --self.voarCostas = 
    self:voarDeCostas(parametros)--imagens.carregarVooCostas(parametros)
    return o
end


function Heroi:getVidas()

    return self.vidas;
end

function Heroi:setVidas(valor)

    self.vidas = valor;
end

function Heroi:voarDePerfil(parametros)

    self.voarPerfil = imagens.carregarVooPerfil(parametros)
    self.voarPerfil.x = display.contentCenterX * 0.2
    self.voarPerfil.y = display.contentCenterY
    self.voarPerfil.isVisible = true
    self.voarPerfil.xScale = 4.0
    self.voarPerfil.yScale = 4.0
    parametros.fisica.addBody(self.voarPerfil, "dynamic", {density = 10, radius = 40, bounce = -1, isSensor = true})
    self.voarPerfil.isBodyActive = true
    self.voarPerfil:setSequence("voar")
    self.voarPerfil:play()
end

function Heroi:voarDeCostas(parametros)

    self.voarCostas = imagens.carregarVooCostas(parametros)
    self.voarCostas.x = self.voarPerfil.x
    self.voarCostas.y = self.voarPerfil.y
    self.voarCostas.xScale = 4.0
    self.voarCostas.yScale = 4.0
    parametros.fisica.addBody(self.voarCostas, "dynamic", {density = 10, radius = 30, bounce = -1, isSensor = true})
    self.voarCostas.isVisible = false
    self.voarCostas:setSequence("voarCostas")
    self.voarCostas:play()
	self.voarCostas.isBodyActive = false
end

return Heroi