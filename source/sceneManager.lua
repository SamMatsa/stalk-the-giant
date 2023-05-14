local pd <const> = playdate
local gfx <const> = pd.graphics

class('SceneManager').extends()

local scene = nil
local prevSceneName = nil

function SceneManager:switchScene(newScene)
    if MUSIC ~= nil then
        MUSIC:stop()
    end

    self.newScene = newScene
    self:loadNewScene()

    prevSceneName = newScene.className
end

function SceneManager:loadNewScene()
    self:cleanup()
    scene = self.newScene()
end

function SceneManager:update()
    scene:update()
end


function SceneManager:cleanup()
    playdate.inputHandlers.pop()
    gfx.sprite.removeAll() --Only works if everything is a sprite
    self:removeAllTimers()
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end
