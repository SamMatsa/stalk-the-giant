import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/crank"

--Scenes
import "scenes/score"

--Sprites
import "sprites/building"
import "sprites/truck"
import "sprites/giantLeg"
import "sprites/warning"
import "sprites/player"
import "sprites/coffee"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

--Z-Index
local Z_INDEX_BUILDING = 5
local Z_INDEX_TRUCK = 10
local Z_INDEX_LEG = 150
local Z_INDEX_PLAYER = 200
local Z_INDEX_CLOUD = 200
local Z_INDEX_UI = 1000

--Constants
local PLAYER_START_POSITION_X = 40
local PLAYER_START_POSITION_Y = 220
local ROAD_START_POSITION_X = 200
local ROAD_START_POSITION_Y = 220
local CLOUD_START_POSITION_X = 200
local CLOUD_START_POSITION_Y = 15
local BUILDING_START_POSITION_X = 50
local BUILDING_START_POSITION_Y = 0
local LEG_START_POSITION_X = 250
local LEG_START_POSITION_Y = 120

--Images
local image_road = gfx.image.new("images/road")
local image_cloud = gfx.image.new("images/cloud")

--Variables
local sprite_road_1 = nil
local sprite_road_2 = nil
local player = nil
local sprite_cloud_1 = nil
local sprite_cloud_2 = nil
local buildings = {}
local truck = nil
local leg_r = nil
local leg_l = nil
local tickBuffer = 0
local warning = nil
local panel = nil


local coffeeCounter = 10

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
    moveClouds()
    moveGiant()
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
        buildings[i] = Building(BUILDING_START_POSITION_X + 100 * (i - 1), BUILDING_START_POSITION_Y)
        buildings[i]:setZIndex(Z_INDEX_BUILDING)
        --buildings[i]:setScale(2)
    end
    --Player
    player = Player(PLAYER_START_POSITION_X, PLAYER_START_POSITION_Y)
    player:setZIndex(Z_INDEX_PLAYER)
    --Cloud
    sprite_cloud_1 = gfx.sprite.new(image_cloud)
    sprite_cloud_2 = gfx.sprite.new(image_cloud)
    sprite_cloud_1:add()
    sprite_cloud_2:add()
    sprite_cloud_1:setZIndex(Z_INDEX_CLOUD)
    sprite_cloud_2:setZIndex(Z_INDEX_CLOUD)
    sprite_cloud_1:moveTo(CLOUD_START_POSITION_X, CLOUD_START_POSITION_Y)
    sprite_cloud_2:moveTo(CLOUD_START_POSITION_X * 3, CLOUD_START_POSITION_Y)
    --Truck
    truck = Truck(150,210)
    truck:setZIndex(Z_INDEX_TRUCK)
    --leg
    leg_r = Leg(LEG_START_POSITION_X, LEG_START_POSITION_Y)
    leg_r:setZIndex(Z_INDEX_LEG)
    leg_l = Leg(LEG_START_POSITION_X + 30, LEG_START_POSITION_Y)
    leg_l:setZIndex(Z_INDEX_LEG - 1)
    --warning
    warning = Warning(300,60)
    warning:setZIndex(Z_INDEX_UI)
    warning:setVisible(false)
    --panel

end

function Chase:checkCrank()
    local ticks = playdate.getCrankTicks(360)
    if ticks > tickBuffer then
        tickBuffer = ticks
        if tickBuffer > 30 then
            tickBuffer = 30
        end
    end
    if tickBuffer > 0 then
        moveWorld(math.floor(tickBuffer / 6))
        tickBuffer = tickBuffer - 1
    end
end

function Chase:checkScrollingSprites()
    self:checkRoad()
    self:checkCloud()
    self:checkBuildings()
    self:checkGiant()
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
        --coffeeCounter
        local type = "BUILDING"
        if coffeeCounter > 10 then
            type = "COFFEE"
            coffeeCounter = 0
        else
            coffeeCounter = coffeeCounter + 1
        end
        --Create New Building
        buildings[10] = Building(BUILDING_START_POSITION_X + 100 * 9, BUILDING_START_POSITION_Y, type)
        --Rearrange array
        for i = 1, 9 do
            buildings[i] = buildings[i+1]
            buildings[i]:moveTo(BUILDING_START_POSITION_X + 100 * (i - 1), BUILDING_START_POSITION_Y)
            buildings[i]:setZIndex(Z_INDEX_BUILDING)
            --buildings[i]:setScale(2)
        end
        buildings[10] = nil
    end
end

function Chase:checkGiant()
    local legPositionX, legPositionY = leg_l:getPosition()
    if legPositionX > 450 then
        warning:setVisible(true)
    else
        warning:setVisible(false)
    end
    if legPositionX > LEG_START_POSITION_X * 3 then
        --SCENE_MANAGER:switchScene(Score)
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
    --truck
    local x_truck, y_truck = truck:getPosition()
    truck:moveTo(x_truck - ticks, y_truck)
    --giant
    local x_legL, y_legL = leg_l:getPosition()
    leg_l:moveTo(x_legL - ticks, y_legL)
    local x_legR, y_legR = leg_r:getPosition()
    leg_r:moveTo(x_legR - ticks, y_legR)
end

function moveClouds()
    local x_cloud_1, y_cloud_1 = sprite_cloud_1:getPosition()
    sprite_cloud_1:moveTo(x_cloud_1 - 1, y_cloud_1)
    local x_cloud_2, y_cloud_2 = sprite_cloud_2:getPosition()
    sprite_cloud_2:moveTo(x_cloud_2 - 1, y_cloud_2)
end

function moveGiant()
    local x_legL, y_legL = leg_l:getPosition()
    leg_l:moveTo(x_legL + 2, y_legL)
    local x_legR, y_legR = leg_r:getPosition()
    leg_r:moveTo(x_legR + 2, y_legR)
end