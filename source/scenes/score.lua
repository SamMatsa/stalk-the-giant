import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "scenes/chase"
import "scenes/menu"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

class('Score').extends(gfx.sprite)

local text = "The giant escaped.. never to be seen again!"
local image_escapes = gfx.image.new("images/dead_escapes")

local image = image_escapes
local image_pancake = gfx.image.new("images/dead_pancake")
local image_seen = gfx.image.new("images/dead_seen")
local image_coffee = gfx.image.new("images/dead_coffee")

local myInputHandlers = {
    AButtonDown = function()
        SCENE_MANAGER:switchScene(Chase)
    end,
}

function Score:init()
    if DEATH_REASON == "ESCAPE" then
        image = image_escapes
        text = "The giant escaped.. never to be seen again!"
    end
    if DEATH_REASON == "PANCAKE" then
        image = image_pancake
        text = "You are a pancake now."
    end
    if DEATH_REASON == "SEEN" then
        image = image_seen
        text = "The giant saw you and is pretty upset."
    end
    if DEATH_REASON == "COFFEE" then
        image = image_coffee
        text = "You died from your caffeine addiction."
    end
    pd.inputHandlers.push(myInputHandlers)
end


function Score:update()
    image:draw(100,30)
    gfx.drawTextInRect("SCORE: " .. tostring(math.floor(METERS/40)) .. " m", 0, 150, 400, 240, nil, nil, kTextAlignment.center)
    gfx.drawTextInRect(text, 0, 190, 400, 240, nil, nil, kTextAlignment.center)
    gfx.drawTextInRect("(A) RETRY", 0, 220, 400, 240, nil, nil, kTextAlignment.center)
end