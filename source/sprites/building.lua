import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

class('Building').extends(gfx.sprite)

function Building:init(x, y, type)
    Building.super.init(self)
    if type == nil then
        self.type = "BUILDING"
    else
        self.type = type
    end
    self:setImage(self:getBuildingImage())
    self:add()
    self:moveTo(x,y)
    local playerSizeX, playerSizeY = self:getSize()
    self:setCollideRect(0,0, playerSizeX * 2, playerSizeY)
end

function Building:getBuildingImage()
    if self.type == "BUILDING" then
        math.randomseed(playdate.getSecondsSinceEpoch())
        local randomNumber = math.random(1,5)
        return BUILDINGS[randomNumber]
    end
    if self.type == "COFFEE" then
        return IMAGE_COFFE_SHOP
    end
    if self.type == "PIZZA" then
        return IMAGE_PIZZA_SHOP
    end
end