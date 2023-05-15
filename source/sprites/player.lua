import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound


local image_bike = gfx.image.new("images/bike")
local image_bike_hidden = gfx.image.new("images/bike_hidden")

class('Player').extends(gfx.sprite)

function Player:init(x, y)
    Player.super.init(self)
    self:setImage(image_bike)
    self:add()
    self:moveTo(x,y)
    local collideX, collideY = self:getSize()
    self:setCollideRect(0,-5, collideX, collideY *2)
    self.hidden = false
    self.canMove = true
end

function Player:update()
   -- printTable(self:overlappingSprites())
end

function Player:canBuyCoffee()
    return self:searchForCollision("COFFEE")
end

function Player:canGetPizza()
    local canGetPizza, pizzaPlace = self:searchForCollision("PIZZA")
    if canGetPizza then
        if pizzaPlace == self.currentPizzaPlace then
            return false
        else
            self.currentPizzaPlace = pizzaPlace
        end
    end
    return canGetPizza
end

function Player:canDeliverPizza()
    return self:searchForCollision("CLOWN")
end

function Player:canHide()
    return self:searchForCollision("TRUCK")
end

function Player:giantTouch()
    return self:searchForCollision("GIANT")
end

function Player:searchForCollision(spriteType)
    if #self:overlappingSprites() > 0 then
        local sprites = self:overlappingSprites()
        for i = 1, #self:overlappingSprites() do
            local sprite = sprites[i]
            if sprite.type == spriteType then
                return true, sprite
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

function Player:setHideSprite()
    self:setImage(image_bike_hidden)
end

function Player:setUnhideSprite()
    self:setImage(image_bike)
end