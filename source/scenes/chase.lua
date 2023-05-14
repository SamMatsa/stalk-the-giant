import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/crank"

--Scenes
import "scenes/score"

--Sprites
import "sprites/building"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

--Constants
local ROAD_START_POSITION_X = 200
local ROAD_START_POSITION_Y = 220
local CLOUD_START_POSITION_X = 200
local CLOUD_START_POSITION_Y = 15
local BUILDING_START_POSITION_X = 25
local BUILDING_START_POSITION_Y = 100

--Images
local image_road = gfx.image.new("images/road")
local image_bike = gfx.image.new("images/bike")
local image_cloud = gfx.image.new("images/cloud")

--Variables
local sprite_road_1 = nil
local sprite_road_2 = nil
local sprite_player = nil
local sprite_cloud_1 = nil
local sprite_cloud_2 = nil
local buildings = {}

class('Chase').extends(gfx.sprite)


local myInputHandlers = {
    AButtonDown = function()
        --SCENE_MANAGER:switchScene(Menu)
    end,
}

function Chase:init()
    self:initSprites()
    pd.inputHandlers.push(myInputHandlers)
end


function Chase:update()
    self:checkCrank()
    self:checkScrollingSprites()
end


function Chase:initSprites ()
    --Road
    sprite_road_1 = gfx.sprite.new(image_road)
    sprite_road_2 = gfx.sprite.new(image_road)
    sprite_road_1:add()
    sprite_road_2:add()
    sprite_road_1:moveTo(ROAD_START_POSITION_X, ROAD_START_POSITION_Y)
    sprite_road_2:moveTo(ROAD_START_POSITION_X * 3, ROAD_START_POSITION_Y)
    --buildings
    for i = 1, 9 do
        buildings[i] = Building(BUILDING_START_POSITION_X + 50 * (i - 1), BUILDING_START_POSITION_Y)
    end
    --Player
    sprite_player = gfx.sprite.new(image_bike)
    sprite_player:setScale(2)
    sprite_player:add()
    sprite_player:moveTo(40,220)
    --Cloud
    sprite_cloud_1 = gfx.sprite.new(image_cloud)
    sprite_cloud_2 = gfx.sprite.new(image_cloud)
    sprite_cloud_1:add()
    sprite_cloud_2:add()
    sprite_cloud_1:setZIndex(2000)
    sprite_cloud_2:setZIndex(2000)
    sprite_cloud_1:moveTo(CLOUD_START_POSITION_X, CLOUD_START_POSITION_Y)
    sprite_cloud_2:moveTo(CLOUD_START_POSITION_X * 3, CLOUD_START_POSITION_Y)
end

function Chase:checkCrank()
    local ticks = playdate.getCrankTicks(60)
    if ticks > 1 then
        moveWorld(ticks)
    end
    moveClouds()
end

function Chase:checkScrollingSprites()
    self:checkRoad()
    self:checkCloud()
    self:checkBuildings()
end

function Chase:checkRoad()
    local x_road_2, y_road_2 = sprite_road_2:getPosition()
    if x_road_2 <= ROAD_START_POSITION_X then
        sprite_road_1:moveTo(ROAD_START_POSITION_X, ROAD_START_POSITION_Y)
        sprite_road_2:moveTo(ROAD_START_POSITION_X * 3, ROAD_START_POSITION_Y)
    end
end

function Chase:checkCloud()
    local x_cloud_2, y_cloud_2 = sprite_cloud_2:getPosition()
    if x_cloud_2 <= CLOUD_START_POSITION_X then
        sprite_cloud_1:moveTo(CLOUD_START_POSITION_X, CLOUD_START_POSITION_Y)
        sprite_cloud_2:moveTo(CLOUD_START_POSITION_X * 3, CLOUD_START_POSITION_Y)
    end
end

function Chase:checkBuildings()
    local firstBuilding = buildings[1]
    local x_building, y_building = firstBuilding:getPosition()
    if x_building <= (-BUILDING_START_POSITION_X) then
        --Create New Building
        buildings[10] = Building(BUILDING_START_POSITION_X + 50 * 9, BUILDING_START_POSITION_Y)
        --Rearrange array
        for i = 1, 9 do
            buildings[i] = buildings[i+1]
            buildings[i]:moveTo(BUILDING_START_POSITION_X + 50 * (i - 1), BUILDING_START_POSITION_Y)
            buildings[i]:setZIndex(1)
        end
        buildings[10] = nil
        printTable(buildings)
    end
end

function moveWorld(ticks)
    --road
    local x_road_1, y_road_1 = sprite_road_1:getPosition()
    sprite_road_1:moveTo(x_road_1 - ticks, y_road_1)
    local x_road_2, y_road_2 = sprite_road_2:getPosition()
    sprite_road_2:moveTo(x_road_2 - ticks, y_road_2)
    --cloud
    local x_cloud_1, y_cloud_1 = sprite_cloud_1:getPosition()
    sprite_cloud_1:moveTo(x_cloud_1 - ticks, y_cloud_1)
    local x_cloud_2, y_cloud_2 = sprite_cloud_2:getPosition()
    sprite_cloud_2:moveTo(x_cloud_2 - ticks, y_cloud_2)
    --buildings
    for i = 1, 9 do
        local building = buildings[i]
        local x_building, y_building = building:getPosition()
        buildings[i]:moveTo(x_building - ticks, y_building)
    end
end

function moveClouds()
    local x_cloud_1, y_cloud_1 = sprite_cloud_1:getPosition()
    sprite_cloud_1:moveTo(x_cloud_1 - 1, y_cloud_1)
    local x_cloud_2, y_cloud_2 = sprite_cloud_2:getPosition()
    sprite_cloud_2:moveTo(x_cloud_2 - 1, y_cloud_2)
end