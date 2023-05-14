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
class('Panel').extends(gfx.sprite)

function Panel:init(x, y)
    Panel.super.init(self)
    self:setImage(self:getImage())
    self:add()
    self:moveTo(x,y)
end

function Panel:getImage()
    image = gfx.image.new("images/panel")
    gfx.pushContext(image)
        --MONEY
        gfx.setFont(fontSmall)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextInRect(tostring(MONEY) .. "$", 20, 5, 50, 30, nil, nil, kTextAlignment.right)
        --CUP ICON
        IMAGE_CUP:draw(250,-1)
    gfx.popContext()
    --HEALTHBAR
    local BAR_FILL_WIDTH = (ENERGY / ENERGY_MAX) * BAR_WIDTH
    local fillImage = gfx.image.new(BAR_WIDTH, BAR_HEIGHT)
    gfx.pushContext(fillImage)
        gfx.setColor(playdate.graphics.kColorBlack)
        -- if backwards then
        --     fillX = fillWidthMax - fillWidth
        -- end
        gfx.fillRect(0, 0, BAR_FILL_WIDTH, BAR_HEIGHT)
    gfx.popContext(fillImage)
    gfx.pushContext(image)
        fillImage:draw(100,10)
    gfx.popContext()
    return image
end

function Panel:updateImage()
    self:setImage(self:getImage())
end