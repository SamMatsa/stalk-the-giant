import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

--constants
local BAR_WIDTH = 150
local BAR_HEIGHT = 10

--font
local fontSmall = gfx.font.new('font/Roobert-9-Mono-Condensed-table-8-14')
local image = nil
class('Panel2').extends(gfx.sprite)

function Panel2:init(x, y)
    Panel2.super.init(self)
    self:setImage(self:getImage())
    self:add()
    self:moveTo(x,y)
end

function Panel2:update()
   self:updateImage()
end

function Panel2:getImage()
    image = gfx.image.new("images/panel2")
    gfx.pushContext(image)
        --METERS
        gfx.setFont(fontSmall)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextInRect(tostring(math.floor(METERS/40)) .. " m", 20, 5, 50, 30, nil, nil, kTextAlignment.right)
    gfx.popContext()
    return image
end

function Panel2:updateImage()
    self:setImage(self:getImage())
end