import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "scenes/chase"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

class('Menu').extends(gfx.sprite)


local myInputHandlers = {
    AButtonDown = function()
        SCENE_MANAGER:switchScene(Chase)
    end,
}

function Menu:init()
    pd.inputHandlers.push(myInputHandlers)
end


function Menu:update()
end
