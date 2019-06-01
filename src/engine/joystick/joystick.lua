

local controle = { left = nil, right = nil, down = nil, up = nil, botaoA = nil, botaoB = nil }

function controle:new(o,parametros)

    o = o or {}
    setmetatable(o,self)
    self.__index = self
    self.left = display.newImageRect(parametros.grupo, "assets/images/buttons/larrow.png", 90, 90)
    self.right = display.newImageRect(parametros.grupo, "assets/images/buttons/rightarrow.png", 90, 90)
    self.down = display.newImageRect(parametros.grupo, "assets/images/buttons/downarrow.png", 90, 90)
    self.up = display.newImageRect(parametros.grupo, "assets/images/buttons/uparrow.png", 90, 90)
    self.botaoA = display.newImageRect(parametros.grupo, "assets/images/buttons/abutton.png", 90, 90)
    self.botaoB = display.newImageRect(parametros.grupo, "assets/images/buttons/bbutton.png", 90, 90)
    self:inicia()
end

function controle:inicia()

    self.left.x = display.contentCenterX-450
    self.left.y = display.contentHeight-162
    self.left.xScale = 0.6
    self.left.yScale = 0.6

    self.right.x = display.contentCenterX-320
    self.right.y = display.contentHeight-162
    self.right.xScale = 0.6
    self.right.yScale = 0.6

    self.down.x = display.contentCenterX-384
    self.down.y = display.contentHeight-130
    self.down.xScale = 0.6
    self.down.yScale = 0.6

    self.up.x = display.contentCenterX-384
    self.up.y = display.contentHeight-210
    self.up.xScale = 0.6
    self.up.yScale = 0.6

    self.botaoA.x = display.contentCenterX+320
    self.botaoA.y = display.contentHeight-141
    self.botaoA.xScale = 0.7
    self.botaoA.yScale = 0.7

    self.botaoB.x = display.contentCenterX+430
    self.botaoB.y = display.contentHeight-141
    self.botaoB.xScale = 0.7
    self.botaoB.yScale = 0.7
end

return controle