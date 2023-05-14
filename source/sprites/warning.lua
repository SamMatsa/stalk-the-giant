import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

--font
local fontSmall = gfx.font.new('font/Roobert-9-Mono-Condensed-table-8-14')
local image = gfx.image.new("images/warning")

class('Warning').extends(gfx.sprite)

function Warning:init(x, y)
    Warning.super.init(self)
    self:setImage(self:getImage())
    self:add()
    self:moveTo(x,y)
end

function Warning:getImage()
    gfx.pushContext(image)
        gfx.setFont(fontSmall)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextInRect("CHASE HIM!", 7, 10, 100, 40, nil, nil, kTextAlignment.left)
    gfx.popContext()
    return image
end