local M = {}

local parametersList = {
    [1] = {background="assets/images/backgrounds/BG.png", music=""},
    [2] = {background="", music=""},
    [3] = {background="", music=""},
    [4] = {background="", music=""},
    [5] = {background="", music=""},
}

function M.getParameters(stageNumber)
    return parametersList[stageNumber]
end

return M