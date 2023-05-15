import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

local image = gfx.image.new("images/clown")

class('Clown').extends(gfx.sprite)

function Clown:init(x, y)
    Clown.super.init(self)
    self:setImage(image)
    self:add()
    self:moveTo(x,y)
    local sizeX, sizeY = self:getSize()
    self:setCollideRect(-20,0, sizeX * 3, sizeY)
    self.type = "CLOWN"
end