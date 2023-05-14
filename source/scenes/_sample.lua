import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

class('Sample').extends(gfx.sprite)


local myInputHandlers = {
    BButtonDown = function()
        SCENE_MANAGER:switchScene(OtherScene)
    end,
}

function Sample:init()
    pd.inputHandlers.push(myInputHandlers)
end


function Sample:update()
end
