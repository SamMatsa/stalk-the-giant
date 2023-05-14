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
    print(self:canHide())
end

function Player:canBuyCoffee()
    return self:searchForCollision("COFFEE")
end

function Player:canDeliverPizza()
    return self:searchForCollision("PIZZA")
end

function Player:canHide()
    return self:searchForCollision("TRUCK")
end

function Player:searchForCollision(spriteType)
    if #self:overlappingSprites() > 0 then
        local sprites = self:overlappingSprites()
        for i = 1, #self:overlappingSprites() do
            local sprite = sprites[i]
            if sprite.type == spriteType then
                return true
            end
        end
        return false
    else
        return false
    end
end


function Player:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end