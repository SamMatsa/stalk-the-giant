import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound


local image_bike = gfx.image.new("images/bike")

class('Player').extends(gfx.sprite)

function Player:init(x, y)
    Player.super.init(self)
    self:setImage(image_bike)
    self:setScale(2)
    self:add()
    self:moveTo(x,y)
    self:setCollideRect(0,0, self:getSize())
end