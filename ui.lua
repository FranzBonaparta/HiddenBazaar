local UI = {}
local Player = require("player")
local Globals = require("globals")
local Locations = require("locations")
local Markets = require("markets")
local Resources = require("resources")
local Events=require("events")
UI.canvas = nil
UI.width, UI.height = 0, 0
UI.fontH = 0
function UI.init()
  UI.fontH = love.graphics.getFont():getHeight("A")
  UI.width, UI.height = love.graphics.getDimensions()
  UI.canvas = love.graphics.newCanvas(UI.width, UI.height)
end

function UI.setCanvas(list)
  love.graphics.setCanvas(UI.canvas)
  love.graphics.clear(0, 0, 0)
  love.graphics.setColor(1, 1, 1)
  for key, value in pairs(list) do
    if value == true then
      UI[key]()
    end
  end
  UI.printForeignMarkets()
  UI.printEvents()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas()
end

function UI.printCoins()
  local offsetY = 10
  love.graphics.setColor(Globals.colors.yellow)
  love.graphics.circle("fill", 20, 20, 10)
  love.graphics.setColor(Globals.fontColor)
  love.graphics.print(tostring(Player.coins).." Coins", 40, offsetY)
end

function UI.printLocation()
  love.graphics.setColor(Globals.fontColor)
  local text = "Actual Location: "
  text = text .. Locations.list[Player.location].name
  local width = Globals.font:getWidth(text)
  love.graphics.print(text, math.floor((UI.width - width) / 2), 10)
end

function UI.printTimer()
  love.graphics.setColor(Globals.fontColor)
  local text = "Days Remaining: "
  text = text .. Player.daysRemaining
  local width = Globals.font:getWidth(text)
  love.graphics.print(text, UI.width - width - 10, 10)
end

function UI.printMarket()
  love.graphics.setColor(Globals.fontColor)
  local availablesArticles = Globals.articles
  local offsetX = 100
  local offsetY = 50
  local font = Globals.font
  local args = { "Name", "Quantity", "In stock", "Price" }
  local xs = {}
  for _, arg in ipairs(args) do
    table.insert(xs, font:getWidth(arg) + 20)
  end
  local ys = { offsetY }
  if not availablesArticles then return end
  --define lines for the empty table
  for _, article in ipairs(availablesArticles) do
    offsetY = offsetY + font:getHeight("A") + 20
    table.insert(ys, offsetY)
    local playerItem = Player.getArticle(article.id)
    local articleDatas = Resources.getResource(article.id)
    local price=Events.getModifiedPrice(Player.location,article.id)
    local datas = { articleDatas.name, article.quantity, playerItem.quantity, Globals.round(price) }
    for index, data in ipairs(datas) do
      local length = font:getWidth(tostring(data)) + 20
      xs[index] = length > xs[index] and length or xs[index]
    end
  end
  --print the empty table
  local added = 0
  for _, x in ipairs(xs) do
    added = added + x
    love.graphics.line(offsetX + added, ys[1], offsetX + added, ys[#ys])
  end
  love.graphics.line(offsetX, ys[1], offsetX, ys[#ys])
  --print columns titles
  added = offsetX
  for index, arg in ipairs(args) do
    love.graphics.print(arg, added + 10, ys[1] - (font:getHeight(arg) + 5))
    added = added + xs[index]
  end
  --print data into the table
  local a = 1
  local sigmaXs = 0
  for _, article in ipairs(availablesArticles) do
    local playerItem = Player.getArticle(article.id)
    local articleDatas = Resources.getResource(article.id)
    local color = Globals.rarityColors[articleDatas.rarity]
    local text = "[" .. article.id .. "]"
    love.graphics.print(text, offsetX - font:getWidth(text), ys[a] + 10)
    love.graphics.setColor(color)
        local price=Events.getModifiedPrice(Player.location,article.id)

    local datas = { articleDatas.name, article.quantity, playerItem.quantity, Globals.round(price) }
    sigmaXs = offsetX + 10
    for index, data in ipairs(datas) do
      love.graphics.print(data, sigmaXs, ys[a] + 10)
      if index == 1 then
        love.graphics.setColor(Globals.fontColor)
      end
      sigmaXs = sigmaXs + xs[index]
    end
    sigmaXs = sigmaXs - 10
    love.graphics.line(offsetX, ys[a], sigmaXs, ys[a])
    a = a + 1
  end

  love.graphics.line(offsetX, ys[#ys], sigmaXs, ys[#ys])
  --print the lower legend
  local articlesAmount = Globals.marketRange
  local min = Globals.marketOffset
  local size = #Globals.market.articles
  local text = "[" .. tostring(min) .. "-" .. tostring(min + articlesAmount - 1) .. "]" .. "/" .. tostring(size)
  love.graphics.print(text, sigmaXs - xs[4], ys[#ys] + font:getHeight(text))
end
local function getWidth(text)
    return UI.width - Globals.font:getWidth(text) - 20
  end
function UI.printForeignMarkets()
  
  love.graphics.setColor(Globals.fontColor)
  local a = 1
  --make decoration
  local text = "Other Markets"
  local width = getWidth(text)
  love.graphics.print(text, width, 50 + Globals.font:getHeight("A") * a)
  love.graphics.line(width, 50 + (Globals.font:getHeight("A") * (a + 1)) + 10, UI.width - 20,
    50 + (Globals.font:getHeight("A") * (a + 1)) + 10)
  a = a + 1
  --print location's names
  for index, location in ipairs(Locations.list) do
    local market = Markets.getMarket(index)
    if not market then return end
    if market.id ~= Globals.market.id then
      a = a + 2
      text = "[F" .. tostring(market.id) .. "] " .. location.name
      width = getWidth(text)
      love.graphics.print(text, width, 50 + (Globals.font:getHeight("A") * a))
    end
  end
end

function UI.printPrompt()
  love.graphics.setColor(Globals.fontColor)
  love.graphics.line(0, UI.height - 200, UI.width, UI.height - 200)
  local height = Globals.font:getHeight("A")
  love.graphics.print(Globals.prompt, 100, UI.height - 200 + height)
end

function UI.printDetails()
  love.graphics.setColor(Globals.fontColor)
  local height = Globals.font:getHeight("A")
  love.graphics.printf(Globals.details, 100, UI.height - 100 + (height * 3), UI.width - 200)
end

function UI.printInput()
  love.graphics.setColor(Globals.fontColor)
  love.graphics.line(0, UI.height - 100, UI.width, UI.height - 100)
  local height = Globals.font:getHeight("A")
  local text = ""
  local selected = tostring(Globals[Globals.selected])
  if #selected > 0 then
    text = "[" .. selected .. "] "
    Globals.orderMessage = Globals.selected == "inputId" and text or selected
    love.graphics.print(Globals.orderMessage, 100, UI.height - 100 + height)
  end
  local id = tonumber(Globals.inputId)
  if id and id > 0 then
    local article = Globals.mode == "buy" and Markets.getArticle(Player.location, id) or Player.getArticle(id)
    local resource = Resources.getResource(id)
    if not article then return end
    local availableQuantity = article.quantity
    local endLabel = Globals.selected == "inputQuantity" and " (available: " .. availableQuantity .. " ) " or ""
    local price = (Globals.estimatedPrice ~= 0 and #Globals.inputQuantity > 0) and Globals.estimatedPrice or nil
    local priceText = price and " " .. tostring(Globals.round(price)) .. " coins" or ""
    Globals.placeholder = resource.name .. endLabel .. priceText
    if Globals.placeholder and #Globals.placeholder > 0 then
      love.graphics.print(Globals.placeholder, 100 + Globals.font:getWidth(text) + 20, UI.height - 100 + height)
    end
  end
end
function UI.printEvents()
  local market=Markets.getMarket(Player.location)
 
    local width=getWidth("Events")
    love.graphics.print("Events",width,200)
    local a=1
      love.graphics.line(width, 200 + (Globals.font:getHeight("A") * (a )) + 10, UI.width - 20,
200 + (Globals.font:getHeight("A") * (a)) + 10)
 if #market.activeEvents>0 then
  for eventId, value in pairs(market.activeEvents) do
    a=a+1
    local duration=value.remainingDays
    local event=Events.getEvent(eventId) 
    local text=string.format("%s (%i days)",event.name,duration)
    width=getWidth(text)
      love.graphics.print(text,width,200 + (Globals.font:getHeight("A") * (a )) + 10)
     end
  
  end
end
function UI.printHelpMessage()
  love.graphics.setColor(Globals.fontColor)

  love.graphics.printf(Globals.help, 100, UI.height - 250, 2 * (UI.width / 3))
end

return UI
