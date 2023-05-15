import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

--BUILDING IMAGE CASHE
BUILDINGS = {}
TRUCKS = {}

--SPECIAL BUILDING IMAGE CASHE
IMAGE_BUILDING = nil
IMAGE_COFFEE_SHOP = nil
IMAGE_PIZZA_SHOP = nil
IMAGE_CUP = nil

MONEY = 0
ENERGY_MAX = 100
ENERGY = ENERGY_MAX
METERS = 0

--MUSIC
MUSIC = nil

DEATH_REASON = "ESCAPE"

function loadImages()
    --1. buildings array
    table.insert(BUILDINGS, gfx.image.new("images/building"))
    table.insert(BUILDINGS, gfx.image.new("images/building2"))
    table.insert(BUILDINGS, gfx.image.new("images/building3"))
    table.insert(BUILDINGS, gfx.image.new("images/building4"))
    table.insert(BUILDINGS, gfx.image.new("images/building5"))
    --2. special buildings
    IMAGE_BUILDING = gfx.image.new("images/building")
    IMAGE_COFFEE_SHOP = gfx.image.new("images/coffeeShop")
    IMAGE_PIZZA_SHOP = gfx.image.new("images/pizzaShop")
    --3. TRUCKS
    table.insert(TRUCKS, gfx.image.new("images/truck"))
    -- ETC
    IMAGE_CUP = gfx.image.new("images/cup")
end