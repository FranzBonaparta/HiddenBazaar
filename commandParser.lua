local CommandParser = {}
local UI = require("ui")
local Player = require("player")
local Globals = require("globals")
local Markets = require("markets")
local Resources = require("resources")
local Prompt = require("prompt")
CommandParser.toPrint = {
    printCoins = true,
    printLocation = true,
    printTimer = true,
    printMarket = true,
    printPrompt = false,
    printInput = false,
    printHelpMessage = true
}

function CommandParser.keypressed(key)
    if not key then return end

    local keys = { "escape", "f1", "f2", "f3", "f4", "b", "s", "h", "backspace", "return" }
    local actions = {
        function()
            if Globals.mode ~= "lobby" then
                if Globals.selected == "inputId" then
                    CommandParser.toPrint.printPrompt = false
                    CommandParser.toPrint.printInput = false
                    Globals.gotoLobby()
                else
                    local resource = Resources.getResource(tonumber(Globals.inputId))
                    local placeholder = resource.name
                    Globals.gotoPreviousMenu(placeholder)
                    Prompt.updatePrompt(Globals.mode)
                end
            else
                love.event.quit()
                return
            end
        end,
        function() Player.travel(1) end,
        function() Player.travel(2) end,
        function() Player.travel(3) end,
        function() Player.travel(4) end,
        function()
            Globals.selected = "inputId"
            CommandParser.setMarketCounter("buy")
        end,
        function()
            Globals.selected = "inputId"
            CommandParser.setMarketCounter("sell")
        end,
        function() CommandParser.toPrint.printHelpMessage = not CommandParser.toPrint.printHelpMessage end,
        function()
            Globals.deleteChar()
        end,
        function()
            Globals.validateInput(Player, Markets)
            Prompt.updatePrompt(Globals.mode)
        end
    }
    for index, k in ipairs(keys) do
        if key == k then
            actions[index]()
            UI.setCanvas(CommandParser.toPrint)
            return
        end
    end
end

function CommandParser.textinput(text)
    local car = string.match(text, "%d")

    if CommandParser.toPrint.printInput and car then
        local input = Globals.selected
        if input == "inputId" then
            local id = tonumber(Globals.inputId .. car)
            local resource = Resources.getResource(id)
            if not resource then return end
                Globals[input] = Globals[input] .. car

                Globals.placeholder = resource.name
                UI.setCanvas(CommandParser.toPrint)
     
        elseif input == "inputQuantity" then
            local id = tonumber(Globals.inputId)
            local msg = ""
            local canOperate = false
            local functionOrder=Globals.mode=="buy" and Markets.makeBuyOrder or Markets.makeSellOrder
            
            canOperate, msg = functionOrder(id, Player, tonumber(Globals.inputQuantity .. car))
            if canOperate then
                Globals.inputQuantity = Globals.inputQuantity .. car
            else
                Globals.msg = msg
            end


            UI.setCanvas(CommandParser.toPrint)
        end
    end
end

function CommandParser.setMarketCounter(mode)
    if not CommandParser.toPrint.printPrompt and not CommandParser.toPrint.printInput then
        Globals.mode = mode
        Prompt.updatePrompt(mode)
        CommandParser.toPrint.printPrompt = true
        CommandParser.toPrint.printInput = true
    end
end

function CommandParser.wheelmoved(y)
    Markets.moveArticlesPool(y)
    UI.setCanvas(CommandParser.toPrint)
end

return CommandParser