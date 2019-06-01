local Background = {image = nil}

function Background:new(o)
    o = o or {}
    setmetatable(o, self);
    self.__index = self;
    return o
end

function Background.drawBackground(parentGroup, imagePath)
    local background = display.newImage(parentGroup, imagePath, 0, 0)
    background.anchorX, background.anchorY = 0, 0
    background.width, background.height = display.contentWidth, display.contentHeight
    background.myName = "background"
end

return Background