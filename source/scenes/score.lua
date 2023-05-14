import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "scenes/chase"
import "scenes/menu"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

class('Score').extends(gfx.sprite)


local myInputHandlers = {
    AButtonDown = function()
        SCENE_MANAGER:switchScene(Chase)
    end,
    BButtonDown = function()
        SCENE_MANAGER:switchScene(Menu)
    end,
}

function Score:init()
    pd.inputHandlers.push(myInputHandlers)
end


function Score:update()
end
