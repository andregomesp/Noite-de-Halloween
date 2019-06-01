local M = {}
local function initiateGroups(sceneGroup)
    M.backGroup = display.newGroup()
    M.mainGroup = display.newGroup()
    M.uiGroup = display.newGroup()
    sceneGroup:insert(M.backGroup)
    sceneGroup:insert(M.mainGroup)
    sceneGroup:insert(M.uiGroup)
end

local function initiateBackground(stageNumber, stageParametersTable)
    local backgroundFactory = require("src.domain.background.background")
    local background = backgroundFactory:new(nil)
    background.drawBackground(M.backGroup, stageParametersTable.background)
end

local function initiateButtons()
    local joystickFactory = require("src.engine.joystick.joystick")
    local joystickParameters = { grupo = M.uiGroup }
    joystickFactory:new(nil, joystickParameters)
end

local function initiateEnemies()
end

local function initiateHero()
    local heroFactory = require("src.domain.heroi.heroi")
    local heroParameters = { grupo = M.mainGroup, fisica = physics }
    heroFactory:new(nil, heroParameters)
end

local function initiateUi()
end

function M.initiateStage(stageNumber, sceneGroup)
    local stageParameters = require("src.stages.stageParameters")
    local stageParametersTable = stageParameters.getParameters(stageNumber)

    initiateGroups(sceneGroup)
    initiateBackground(stageNumber, stageParametersTable)
    initiateHero()
    initiateButtons()
    initiateUi()
end

return M