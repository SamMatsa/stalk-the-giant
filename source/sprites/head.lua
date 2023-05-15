import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

local HEAD_X_START = 600
local HEAD_Y_START = -290
local HEAD_X_END = 300
local HEAD_Y_END = 10


local image = gfx.image.new("images/head")

class('Head').extends(gfx.sprite)

function Head:init(x, y)
    Head.super.init(self)
    self:setImage(image)
    self:add()
    self:moveTo(HEAD_X_START,HEAD_Y_START)
    self.animator = nil
end

function Head:update()
    if not (self.animator == nil) then
        self:moveTo(HEAD_X_START - self.animator:currentValue(), HEAD_Y_START + self.animator:currentValue())
    end
end

function Head:startAnimation()
    self.animator = gfx.animator.new(2000, 0, 300, pd.easingFunctions.outCubic)
    self.animator.reverses = true
end

function Head:canSeePlayer()
    if not (self.animator == null) then
        if self.animator:currentValue() > 290 then
            return true
        end
    end
    return false
end