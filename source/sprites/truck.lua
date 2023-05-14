import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

class('Truck').extends(gfx.sprite)

function Truck:init(x, y)
    Truck.super.init(self)
    self:setImage(self:getTruckImage())
    self:add()
    self:moveTo(x,y)
end

function Truck:getTruckImage()
    math.randomseed(playdate.getSecondsSinceEpoch())
    local randomNumber = math.random(1,1)
    return TRUCKS[randomNumber]
end