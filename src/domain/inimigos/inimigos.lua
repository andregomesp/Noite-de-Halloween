
local movimento = require("srch/heroi/movimento")
local imagens = require("src/carregarImagens")
local inimigo = {imagem = nil, mover = movimento, vidas = nil}

function inimigo:new(o,parametros)

    o = o or {}
    setmetatable(o, self);
    self.__index = self;
    self.imagem = imagens.carregarInimigo(parametros)
end


return inimigo