import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

local imageLeg = gfx.image.new("images/leg")
local LEG_START_POSITION_Y = 120

class('Leg').extends(gfx.sprite)

function Leg:init(x, y, delay)
    Leg.super.init(self)
    self:setImage(imageLeg)
    self:add()
    self:moveTo(x,y)
    self:setCollideRect(0,0, self:getSize())
    self.type = "GIANT"
    self.delay = delay
    self.animator = gfx.animator.new(300, 0, 50, pd.easingFunctions.linear)
    self.animator.reverses = true
    self.animator.repeatCount = 30000
    self.wait = false
end

function Leg:update()
    if not wait then
        self:animate()
    end
end

function Leg:animate()
    local x,y = self:getPosition() 
    if self.delay then
        self:moveTo(x, LEG_START_POSITION_Y - 50 + self.animator:currentValue())
    else
        self:moveTo(x, LEG_START_POSITION_Y - self.animator:currentValue())
    end
end

function Leg:wait()
    self.wait = true
end


