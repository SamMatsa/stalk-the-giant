import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

local imageLeg = gfx.image.new("images/leg")

class('Leg').extends(gfx.sprite)

function Leg:init(x, y)
    Leg.super.init(self)
    self:setImage(imageLeg)
    self:add()
    self:moveTo(x,y)
    self:setCollideRect(0,0, self:getSize())
    self.type = "GIANT"
end