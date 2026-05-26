local Player = require("player")
local Markets = require("markets")
local UI = require("ui")
local Globals = require("globals")
local timer = 0
local CommandParser = require("commandParser")
-- Function called only once at the beginning
function love.load()
    -- Initialization of resources (images, sounds, variables)
    love.graphics.setFont(Globals.font)
    UI.init()
    Markets.initList()
    Player.initInventory()
    Globals.market = Markets.getMarket(Player.location)
    Globals.marketOffset = 1
    Globals.articles = Markets.getArticlesRange()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1) -- dark grey background
    UI.setCanvas(CommandParser.toPrint)
end

-- Function called at each frame, it updates the logic of the game
function love.update(dt)
    -- dt = delta time = time since last frame
    if timer > 0 and #Globals.msg > 0 then
        timer = timer - dt
    elseif timer <= 0 then
        Globals.msg = ""
        timer = 3
    end
    -- Used for fluid movements
end

-- Function called after each update to draw on screen
function love.draw()
    -- Everything that needs to be displayed passes here
    love.graphics.draw(UI.canvas, 0, 0)
    if timer > 0 and #Globals.msg > 0 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print(Globals.msg, 60, UI.height-60)
        love.graphics.setColor(1,1,1)
    end
end

-- Function called at each touch
function love.keypressed(key)
    -- Example: exit the game with Escape
    
    CommandParser.keypressed(key)
end

function love.textinput(text)
    CommandParser.textinput(text)
end
function love.wheelmoved(x, y)
    if y > 0 then
        return CommandParser.wheelmoved(-1)
    elseif y < 0 then
        return CommandParser.wheelmoved(1)
    end
end