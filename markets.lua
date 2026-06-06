local Markets = {}
local Resources = require("resources")
local Locations = require("locations")
local Globals = require("globals")

Markets.marketsList = {}
Markets.keys = {}

function Markets.initList()
  local resources = Resources.sort()
  --init markets
  for index, location in ipairs(Locations.list) do
    Markets.marketsList[index] = { id = index, name = location.name, articles = {}, activeEvents = {} }
  end
  local keysInitiated = false
  --add articles
  for key, market in pairs(Markets.marketsList) do
    local modifiers = Locations.list[key].marketModifiers
    for _, resource in ipairs(resources) do
      local modifier = modifiers[resource.type] or 1
      local price = math.floor(modifier * resource.basePrice)
      local quantity = math.random(0, math.floor(20 / (resource.rarity + 1)))
      market.articles[resource.id] = { id = resource.id, price = price, quantity = quantity }
      --initialize keys array just once !
      if not keysInitiated then
        table.insert(Markets.keys, resource.id)
      end
    end
    keysInitiated = true
  end
end

function Markets.getMarket(id)
  return Markets.marketsList[id]
end

--update on sale/purchase
function Markets.updateMarketArticle(marketId, articleId, quantity, price)
  local a = Markets.marketsList[marketId].articles[articleId]
  a.quantity = math.max(0, math.floor(a.quantity + quantity))
  a.price = price or a.price
  a.price = math.max(1, a.price)
  Markets.marketsList[marketId].articles[articleId] = a
end

function Markets.addEvent(marketId, eventId, duration)
  Markets.marketsList[marketId].activeEvents[eventId] =
  { id = eventId, initiated = true, remainingDays = duration }
end

function Markets.getArticle(marketId, articleId)
  local market = Markets.getMarket(marketId)
  if market then
    return market.articles[articleId]
  end
end

--check if the desired resource is available to be bought
function Markets.callBuy(id, player)
  local article = Globals.market.articles[id]
  local resource = Resources.getResource(id)
  if not resource then return false end
  local articleName = resource.name
  local msg, procede = "", false
  if article.quantity <= 0 then
    msg = "No stock available for " .. articleName
  elseif article.quantity > 0 then
    if Globals.round(article.price) > player.coins then
      msg = "You can't buy any " .. articleName
    else
      procede = true
    end
  end
  Globals.msg = msg
  return procede
end

--check if the player can sell the selected resource
function Markets.callSell(playerStock)
  local resource = Resources.getResource(playerStock.id)
  local min = Globals.selected == "inputId" and 0 or tonumber(Globals.inputQuantity)
  if playerStock.quantity >= min then
    Globals.msg = ""
    return true
  else
    Globals.msg = resource.name .. " is no more present in your stock!"
    return false
  end
end

--function to get the articles's pool to print in the scrollBox
function Markets.getArticlesRange(offset)
  offset = offset or Globals.marketOffset

  local articles = Globals.market.articles
  local list = {}

  for i = offset, offset + Globals.marketRange - 1 do
    if not articles[Markets.keys[i]] then break end
    table.insert(list, articles[Markets.keys[i]])
  end

  return list
end

--check if the player can buy and afford the desired resource and estimate the price
function Markets.makeBuyOrder(id, player, quantity, Events)
  local bool, msg = false, ""
  local article = Globals.market.articles[id]
  if article.quantity >= quantity then
    local price = Events.getModifiedPrice(player.location, id)
    if player.coins >= Globals.round(quantity * price) then
      bool = true
      Globals.estimatedPrice = -(quantity * price)
    else
      msg = "Not enought coins in your wallet"
    end
  else
    local articleName = Resources.getResource(tonumber(Globals.inputId)).name
    msg = "Not enought " .. articleName .. " in stock!"
  end

  if not bool then
    Globals.estimatedPrice = 0
  end
  return bool, msg
end

--check if the player can sell the desired resource and estimate the gain
function Markets.makeSellOrder(id, player, quantity, Events)
  local bool, msg = false, ""
  local price = Events.getModifiedPrice(player.location, id)

  --then simulate operation
  local playerArticle = player.getArticle(id)
  if playerArticle.quantity >= quantity then
    bool = true
    Globals.estimatedPrice = quantity * price
  else
    local articleName = Resources.getResource(tonumber(Globals.inputId)).name
    msg = "Not enought " .. articleName .. " in your stock!"
  end
  return bool, msg
end

--function to change the offset from the articles pool
function Markets.moveArticlesPool(change)
  local maxOffset = math.max(1, #Globals.market.articles - Globals.marketRange + 1)

  Globals.marketOffset = math.max(
    1,
    math.min(Globals.marketOffset + change, maxOffset)
  )

  Globals.articles = Markets.getArticlesRange()
end

function Markets.setNewPrice(player, id, quantity)
  local article = Markets.getArticle(player.location, id)
  local lastPrice = article.price
  --price/ratio=aug
  local ratio = quantity / 100
  local aug = ratio * lastPrice
  local newPrice = lastPrice + aug
  local resource = Resources.getResource(id)
  newPrice = math.max(1, newPrice)
  newPrice = math.min(newPrice, resource.basePrice * 3)
  Markets.updateMarketArticle(player.location, id, 0, newPrice)
end

function Markets.updateNaturalVariation()
  for marketId, market in pairs(Markets.marketsList) do
    for articleId, article in pairs(market.articles) do
      if math.random(1, 4) == 1 then
        local stockDelta = math.random(-1,1)
        Markets.updateMarketArticle(marketId, articleId, stockDelta)
      end
      if math.random(1, 4) == 4 then
        local priceDelta = math.random(-2, 2) / 100
        local newPrice = article.price * (1 + priceDelta)
        Markets.updateMarketArticle(marketId, articleId, 0, newPrice)
      end
    end
  end
end

return Markets
