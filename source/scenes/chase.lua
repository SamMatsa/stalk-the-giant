import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "scenes/score"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

--Images
local image_road = gfx.image.new("images/road")

--Variables
local sprite_road_1 = nil
local sprite_road_2 = nil


class('Chase').extends(gfx.sprite)


local myInputHandlers = {
    AButtonDown = function()
        SCENE_MANAGER:switchScene(Chase)
    end,
}

function Chase:init()
    self:initSprites()
    pd.inputHandlers.push(myInputHandlers)
end


function Chase:update()

end


function Chase:initSprites ()
    sprite_road_1 = gfx.sprite.new(image_road)
    sprite_road_2 = gfx.sprite.new(image_road)
    sprite_road_1:add()
    sprite_road_2:add()
end