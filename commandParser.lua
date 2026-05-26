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

function CommandParser.gotoLobby()
    Globals.mode = "lobby"
    Globals.inputId = ""
    Globals.inputQuantity = ""
end

function CommandParser.gotoPreviousMenu(placeholder)
    Globals.selected = "inputId"
    Globals.inputQuantity = ""
    Globals.placeholder = placeholder
end

function CommandParser.deleteChar()
    local selected = tostring(Globals[Globals.selected])
    if #selected > 0 then
        Globals[Globals.selected] = string.sub(selected, 1,
            #selected - 1)
    end
end

function CommandParser.validateInput(player, markets)
    if Globals.mode == "lobby" then return end
    local id = tonumber(Globals.inputId)
    if Globals.selected == "inputId" and #Globals.inputId > 0 then
        local canProcede = Globals.mode == "buy" and markets.callBuy(id, player) or
        markets.callSell(player.getArticle(id))
        if canProcede then
            Globals.selected = "inputQuantity"
        end
    elseif Globals.selected == "inputQuantity" and #Globals.inputQuantity > 0 then
        local quantity = tonumber(Globals.inputQuantity)
        quantity = Globals.mode == "buy" and quantity or quantity * (-1)
        local canProcede = Globals.mode == "buy" and true or markets.callSell(player.getArticle(id))
        if canProcede then
            player.updateArticle(id, quantity)
        end
    end
end

function CommandParser.keypressed(key)
    if not key then return end

    local keys = { "escape", "f1", "f2", "f3", "f4", "b", "s", "h", "backspace", "return" }
    local actions = {
        function()
            if Globals.mode ~= "lobby" then
                if Globals.selected == "inputId" then
                    CommandParser.toPrint.printPrompt = false
                    CommandParser.toPrint.printInput = false
                    CommandParser.gotoLobby()
                else
                    local resource = Resources.getResource(tonumber(Globals.inputId))
                    local placeholder = resource.name
                    CommandParser.gotoPreviousMenu(placeholder)
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
            CommandParser.deleteChar()
        end,
        function()
            CommandParser.validateInput(Player, Markets)
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
            local functionOrder = Globals.mode == "buy" and Markets.makeBuyOrder or Markets.makeSellOrder

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
