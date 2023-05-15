import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

local image = gfx.image.new("images/pizza")

class('Pizza').extends(gfx.sprite)

function Pizza:init(x, y)
    Pizza.super.init(self)
    self:setImage(image)
    self:add()
    self:moveTo(x,y)
end