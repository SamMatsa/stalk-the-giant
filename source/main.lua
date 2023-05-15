import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "sceneManager"
import "scenes/menu"
import "scenes/chase"

import "library"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sound <const> = playdate.sound

--Set Refresh Rate
pd.display.setRefreshRate(30)

--load images
loadImages()

--Global
SCENE_MANAGER = SceneManager()
SCENE_MANAGER:switchScene(Chase)

-- Update Function beeing called right before a frame is drawn
function pd.update()
	gfx.sprite.update() -- updates ALL Sprites
    pd.timer.updateTimers() --update ALL timers
    SCENE_MANAGER:update()  --update Scene
    --pd.drawFPS(0,0) -- FPS widget
end
