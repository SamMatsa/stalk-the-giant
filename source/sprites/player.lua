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
    local collideX, collideY = self:getSize()
    self:setCollideRect(0,-5, collideX, collideY *2)
end

function Player:update()
    if #self:overlappingSprites() > 1 then
        printTable(self:overlappingSprites())
        print("There are Sprites")
    end
end

function Player:collisionResponse(other)
    printTable(other)
    if other.className == "Building" then
        print("building")
    end
    return gfx.sprite.kCollisionTypeOverlap
end