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


return Globals