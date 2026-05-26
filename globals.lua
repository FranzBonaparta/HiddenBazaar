local Globals = {}
Globals.font = love.graphics.newFont("fonts/PrintChar21.ttf", 12)
--Globals.font:setFilter("nearest")
Globals.msg = ""
Globals.market = nil
Globals.marketOffset = 1
Globals.marketRange = 5
Globals.articles = {}

Globals.colors = {
  green = { love.math.colorFromBytes(64, 222, 0) },
  red = { love.math.colorFromBytes(219, 31, 66) },
  blue = { love.math.colorFromBytes(57, 61, 255) },
  yellow = { love.math.colorFromBytes(254, 254, 0) },
  white = { love.math.colorFromBytes(255, 255, 255) },
  purple = { love.math.colorFromBytes(220, 67, 225) }
}
Globals.fontColor = Globals.colors.green
Globals.rarityColors = { Globals.colors.green, Globals.colors.blue, Globals.colors.red, Globals.colors.purple, Globals
    .colors.yellow }
Globals.mode = "lobby"
Globals.tradingId = 0
Globals.selected = nil
Globals.inputId = ""
Globals.inputQuantity = ""
Globals.prompt = ""
Globals.placeholder = ""
Globals.orderMessage = ""
Globals.estimatedPrice = 0
Globals.help =
"Type 'F1'..to 'F4' in order to travel. Type [B] to place a buying order, [S] to place a selling order. [ESC] to quit an order place and quit the game. [H] to hide or show this 'Help' message."

function Globals.gotoLobby()
  Globals.mode = "lobby"
  Globals.inputId = ""
  Globals.inputQuantity = ""
end

function Globals.gotoPreviousMenu(placeholder)
  Globals.selected = "inputId"
  Globals.inputQuantity = ""
  Globals.placeholder = placeholder
end

function Globals.deleteChar()
  local selected = tostring(Globals[Globals.selected])
  if #selected > 0 then
    Globals[Globals.selected] = string.sub(selected, 1,
      #selected - 1)
  end
end

function Globals.validateInput(player, markets)
  if Globals.mode == "lobby" then return end
  local id = tonumber(Globals.inputId)
  if Globals.selected == "inputId" and #Globals.inputId > 0 then
    local canProcede=Globals.mode=="buy" and markets.callBuy(id, player) or markets.callSell(player.getArticle(id))
    if canProcede then
      Globals.selected = "inputQuantity"
    end
  elseif Globals.selected == "inputQuantity" and #Globals.inputQuantity > 0 then
    local quantity = tonumber(Globals.inputQuantity)
    quantity = Globals.mode == "buy" and quantity or quantity * (-1)
    local canProcede=Globals.mode=="buy" and true or markets.callSell(player.getArticle(id))
    if canProcede then
      player.updateArticle(id, quantity)
    end
    
  end
end

return Globals