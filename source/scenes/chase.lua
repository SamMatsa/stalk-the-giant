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
import "sprites/panel"
import "sprites/pizza"
import "sprites/clown"
import "sprites/head"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = pd.sound

--Z-Index
local Z_INDEX_BUILDING = 5
local Z_INDEX_HIDDEN = 8
local Z_INDEX_TRUCK = 10
local Z_INDEX_HINT = 15
local Z_INDEX_LEG = 150
local Z_INDEX_HEAD = 180
local Z_INDEX_PLAYER = 200
local Z_INDEX_CLOUD = 200
local Z_INDEX_UI = 1000

--Constants
local GIANT_SPEED = 2
local PLAYER_START_POSITION_X = 70
local PLAYER_START_POSITION_Y = 220
local ROAD_START_POSITION_X = 200
local ROAD_START_POSITION_Y = 220
local CLOUD_START_POSITION_X = 200
local CLOUD_START_POSITION_Y = 15
local BUILDING_START_POSITION_X = 50
local BUILDING_START_POSITION_Y = 0
local LEG_START_POSITION_X = 250
local LEG_START_POSITION_Y = 120
local TRUCK_START_POSITION_X = 150
local TRUCK_START_POSITION_Y = 210
local CLOWN_START_POSITION_X = 400
local CLOWN_START_POSITION_Y = 210
local COFFEE_PRICE = 15
local HINT_Y = 75
local HINT_X = -60

--timer
local coffeeBreakTimer = nil

--Images
local image_road = gfx.image.new("images/road2")
local image_cloud = gfx.image.new("images/cloud")
local image_pizza_hint = gfx.image.new("images/hint_pizza_delivery")
local image_coffe_hint = gfx.image.new("images/hint_coffee")
local image_pizza_clown = gfx.image.new("images/pizza_clown")

--Variables
local sprite_road_1 = nil
local sprite_road_2 = nil
local player = nil
local sprite_cloud_1 = nil
local sprite_cloud_2 = nil
local buildings = {}
local truck = nil
local truck2 = nil
local leg_r = nil
local leg_l = nil
local tickBuffer = 0
local warning = nil
local panel = nil
local pizzas = {}
local clown = nil
local clown_2 = nil
local clown_3 = nil
local head = nil

local hint_pizza_delivery = nil
local hint_coffee = nil


local coffeeCounter = 10
local pizzaCounter = 6


local pizzaInBackpack = 0


local moveClownTrigger = false
local moveTruckTrigger = false
local moveTruckTrigger2 = false


local truck_InFront = false

local susCounter = 2
--1 Giant sus timer
local giant_moves = true
--Random after 1 or max 3 trucks the giant starts sussing
-- He stands still shortly after the last truck that made him suspisoi


class('Chase').extends(gfx.sprite)


local myInputHandlers = {
    AButtonDown = function()
        if player:canBuyCoffee() then
            buyCoffee()
        end
        if player:canGetPizza() then
            getPizza()
        end
        if player:canDeliverPizza() then
            deliverPizza()
        end
    end,
    BButtonDown = function()
        if player:canHide() and (not player.hidden) then
            canHide, truckSprite = player:canHide()
            hide(truckSprite:getPosition())
        elseif player.hidden then
            unhide()
        end
    end,
}

function Chase:init()
    resetGame()
    -- MUSIC
    MUSIC = sound.sampleplayer.new('music/chase')
    MUSIC:play(0)
    
    self:initSprites()
    reduceEnergy()
    pd.inputHandlers.push(myInputHandlers)
    pd.timer.performAfterDelay(60000, increaseDifficulty)
end


function Chase:update()
    self:checkCrank()
    self:checkScrollingSprites()
    self:checkPizzas()
    moveClouds()
    if not giant_moves then
        if not (head.animator == nil) and head.animator:ended() then
            startGiant()
        end
    else
        moveGiant()
    end
    print(head:canSeePlayer())
    checkGameOver()
    checkGiantSus()
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
    truck2 = Truck(320,210)
    truck2:setZIndex(Z_INDEX_TRUCK)
    --Clown
    clown_2 = Clown(-40,210)
    clown_2:setZIndex(Z_INDEX_TRUCK)
    clown_3 = Clown(-40,210)
    clown_3:setZIndex(Z_INDEX_TRUCK)
    clown = Clown(400,210)
    clown:setZIndex(Z_INDEX_TRUCK)
    --leg
    leg_r = Leg(LEG_START_POSITION_X, LEG_START_POSITION_Y - 50, true)
    leg_r:setZIndex(Z_INDEX_LEG)
    leg_l = Leg(LEG_START_POSITION_X + 30, LEG_START_POSITION_Y, false)
    leg_l:setZIndex(Z_INDEX_LEG - 1)
    --warning
    warning = Warning(300,60)
    warning:setZIndex(Z_INDEX_UI)
    warning:setVisible(false)
    --panel
    panel = Panel(200, 15)
    panel:setZIndex(Z_INDEX_UI)
    --pizza
    for i = 1, 3 do
        table.insert(pizzas, Pizza(20, 10 + 32*i))
        pizzas[i]:setZIndex(Z_INDEX_UI)
    end
    --head
    head = Head(HEAD_X_START,HEAD_Y_START)
    head:setZIndex(Z_INDEX_HEAD)
    --hint
    hint_pizza_delivery = gfx.sprite.new(image_pizza_hint)
    hint_coffee = gfx.sprite.new(image_coffe_hint)
    hint_pizza_delivery:add()
    hint_coffee:add()
    hint_pizza_delivery:setZIndex(Z_INDEX_HINT)
    hint_coffee:setZIndex(Z_INDEX_HINT)
    hint_pizza_delivery:moveTo(HINT_X, HINT_Y)
    hint_coffee:moveTo(HINT_X, HINT_Y)
    --piizaclown
    hint_pizza_clown = gfx.sprite.new(image_pizza_clown)
    hint_pizza_clown:add()
    hint_pizza_clown:setZIndex(Z_INDEX_HINT)
    clownX, clownY = clown:getPosition()
    hint_pizza_clown:moveTo(clownX, clownY - 60)
end

function Chase:checkCrank()
    if player.canMove then
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
    else
        tickBuffer = 0
    end
end

function Chase:checkScrollingSprites()
    self:checkRoad()
    self:checkCloud()
    self:checkBuildings()
    self:checkGiant()
    self:checkClown()
    self:checkTruck()
    self:checkTruck2()
end

function Chase:checkClown()
    local x_clown, y_clown = clown:getPosition()
    if x_clown <= -200 then
        moveClownTrigger = true
    end
end

function Chase:checkTruck()
    local x_truck, y_truck = truck:getPosition()
    if x_truck <= -300 then
        moveTruckTrigger = true
    end
end

function Chase:checkTruck2()
    local x_truck2, y_truck2 = truck2:getPosition()
    if x_truck2 <= -40 then
        moveTruckTrigger2 = true
    end
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
        elseif pizzaCounter > 6 then
            type = "PIZZA"
            pizzaCounter = 0
        else
            pizzaCounter = pizzaCounter + 1
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
        if buildings[9].type == "COFFEE" then
            local positionX, positionY = buildings[9]:getPosition()
            hint_coffee:moveTo(positionX, HINT_Y)
        end
        if buildings[9].type == "PIZZA" then
            local positionX, positionY = buildings[9]:getPosition()
            hint_pizza_delivery:moveTo(positionX, HINT_Y)
        end
        --Trigger
        if moveTruckTrigger and type == "BUILDING" then
            print("MOVE TRUCK")
            x,y = buildings[9]:getPosition()
            truck:moveTo(x, TRUCK_START_POSITION_Y)
            moveTruckTrigger = false
        elseif moveTruckTrigger2 and type == "BUILDING" then
            print("MOVE TRUCK 2")
            x,y = buildings[9]:getPosition()
            truck2:moveTo(x, TRUCK_START_POSITION_Y)
            moveTruckTrigger2 = false
        elseif moveClownTrigger and type == "BUILDING" then
            print("MOVE CLOWN")
            x,y = buildings[9]:getPosition()
            clown:moveTo(x, CLOWN_START_POSITION_Y)
            clown_2:moveTo(x + 10, CLOWN_START_POSITION_Y - 4)
            clown_3:moveTo(x - 10, CLOWN_START_POSITION_Y - 4)
            moveClownTrigger = false
        end
        --Delete dublicate Building
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
end

function Chase:checkPizzas()
    for i = 1, 3 do
        pizzas[i]:setVisible(false)     
    end
    for i = 1, pizzaInBackpack do
        pizzas[i]:setVisible(true)     
    end
end

function moveWorld(ticks)
    --MeterCounter
    METERS = METERS + ticks
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
    --truck
    local x_truck2, y_truck2 = truck2:getPosition()
    truck2:moveTo(x_truck2 - ticks, y_truck2)
    --clown
    local x_clown, y_clown = clown:getPosition()
    clown:moveTo(x_clown - ticks, y_clown)
    local x_clown_2, y_clown_2 = clown_2:getPosition()
    clown_2:moveTo(x_clown_2 - ticks, y_clown_2)
    local x_clown_3, y_clown_3 = clown_3:getPosition()
    clown_3:moveTo(x_clown_3 - ticks, y_clown_3)
    --giant
    local x_legL, y_legL = leg_l:getPosition()
    leg_l:moveTo(x_legL - ticks, y_legL)
    local x_legR, y_legR = leg_r:getPosition()
    leg_r:moveTo(x_legR - ticks, y_legR)
    --hints
    local x_hint_c, y_hint_c = hint_coffee:getPosition()
    hint_coffee:moveTo(x_hint_c - ticks, y_hint_c)
    local x_hint_p, y_hint_p = hint_pizza_delivery:getPosition()
    hint_pizza_delivery:moveTo(x_hint_p - ticks, y_hint_p)
    --pizza clown
    local clownX, clownY = clown:getPosition()
    hint_pizza_clown:moveTo(clownX, clownY - 60)
end

function moveClouds()
    local x_cloud_1, y_cloud_1 = sprite_cloud_1:getPosition()
    sprite_cloud_1:moveTo(x_cloud_1 - 1, y_cloud_1)
    local x_cloud_2, y_cloud_2 = sprite_cloud_2:getPosition()
    sprite_cloud_2:moveTo(x_cloud_2 - 1, y_cloud_2)
end

function moveGiant()
    local x_legL, y_legL = leg_l:getPosition()
    leg_l:moveTo(x_legL + GIANT_SPEED, y_legL)
    local x_legR, y_legR = leg_r:getPosition()
    leg_r:moveTo(x_legR + GIANT_SPEED, y_legR)
end

function buyCoffee()
    if MONEY > COFFEE_PRICE then
        MONEY = MONEY - COFFEE_PRICE
        ENERGY = ENERGY + 30
        if ENERGY > ENERGY_MAX then
            ENERGY = ENERGY_MAX
        end
        panel:updateImage()
    end
end

function reduceEnergy()
    ENERGY = ENERGY - 5
    if ENERGY < 0 then
        ENERGY = 0
    end
    coffeeBreakTimer = pd.timer.performAfterDelay(5000, reduceEnergy)
    panel:updateImage()
end

function getPizza()
    if pizzaInBackpack < 3 then
        pizzaInBackpack = pizzaInBackpack + 1
    end
end

function deliverPizza()
    if pizzaInBackpack == 3 then
        MONEY = MONEY + 100
    elseif pizzaInBackpack == 2 then
        MONEY = MONEY + 50
    elseif pizzaInBackpack == 1 then
        MONEY = MONEY + 20
    end
    pizzaInBackpack = 0
    panel:updateImage()
end

function hide(truckX, truckY)
    player.hidden = true
    pX, pY = player:getPosition()
    --Set Sprite
    player:moveTo(pX, truckY)
    player:setZIndex(Z_INDEX_HIDDEN)
    --player:setHideSprite()
    player.canMove = false
end

function unhide()
    player.hidden = false
    --Set Sprite
    player:moveTo(PLAYER_START_POSITION_X, PLAYER_START_POSITION_Y)
    player:setZIndex(Z_INDEX_PLAYER)
    --player:setUnhideSprite()
    player.canMove = true
end

function stopGiant()
    --Stop animation
    giant_moves = false
    leg_l.wait = true
    leg_r.wait = true
    --Start Head Animation
    head:startAnimation()
end

function startGiant()
    --Stop animation
    giant_moves = true
    leg_l.wait = false
    leg_r.wait = false
end

function checkGameOver()
    --Touches giant
    if player:giantTouch() then
        DEATH_REASON = "PANCAKE"
        SCENE_MANAGER:switchScene(Score)
    end
    --Player is seen by giant
    if player.hidden == false and head:canSeePlayer() then
        DEATH_REASON = "SEEN"
        SCENE_MANAGER:switchScene(Score)
    end
    --Player runs out of coffee
    if ENERGY <= 0 then
        DEATH_REASON = "COFFEE"
        SCENE_MANAGER:switchScene(Score)
    end
    --The giant "escapes" (yes this doesnt make any sense)
    local legPositionX, legPositionY = leg_l:getPosition()
    if legPositionX > LEG_START_POSITION_X * 3 then
        DEATH_REASON = "ESCAPE"
        SCENE_MANAGER:switchScene(Score)
    end
end

function checkGiantSus()
    --Check Truck
    if susCounter > 0 and giant_moves then
        truckPositionX, truckPositionY = truck:getPosition()
        legPositionX, legPositionY = leg_r:getPosition()
        if truckPositionX > legPositionX then
            truck_InFront = true
        end
        if truckPositionX < legPositionX and truck_InFront then
            susCounter = susCounter - 1 
            truck_InFront = false
        end
        --Sus Counter just became 0
        if susCounter == 0 then
            pd.timer.performAfterDelay(2000, stopGiant)
            math.randomseed(playdate.getSecondsSinceEpoch())
            susCounter = math.random(1,2)
        end
    end
end

function resetGame()
    coffeeBreakTimer = nil
    image_road = gfx.image.new("images/road2")
    image_cloud = gfx.image.new("images/cloud")
    image_pizza_hint = gfx.image.new("images/hint_pizza_delivery")
    image_coffe_hint = gfx.image.new("images/hint_coffee")
    image_pizza_clown = gfx.image.new("images/pizza_clown")
    sprite_road_1 = nil
    sprite_road_2 = nil
    player = nil
    sprite_cloud_1 = nil
    sprite_cloud_2 = nil
    buildings = {}
    truck = nil
    truck2 = nil
    leg_r = nil
    leg_l = nil
    tickBuffer = 0
    warning = nil
    panel = nil
    pizzas = {}
    clown = nil
    clown_2 = nil
    clown_3 = nil
    head = nil
    hint_pizza_delivery = nil
    hint_coffee = nil
    coffeeCounter = 10
    pizzaCounter = 6
    pizzaInBackpack = 0
    moveClownTrigger = false
    moveTruckTrigger = false
    moveTruckTrigger2 = false
    truck_InFront = false
    susCounter = 2
    giant_moves = true
    GIANT_SPEED = 2


    MONEY = 0
    ENERGY_MAX = 100
    ENERGY = ENERGY_MAX
    METERS = 0
    DEATH_REASON = "ESCAPE"
end

function increaseDifficulty()
    GIANT_SPEED = GIANT_SPEED + 1
    pd.timer.performAfterDelay(60000, increaseDifficulty)
end