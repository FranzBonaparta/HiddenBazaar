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
    Markets.marketsList[index] = { id = index, name = location.name, articles = {} }
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

function Markets.updateMarketArticle(marketId, articleId, quantity)
  local q = Markets.marketsList[marketId].articles[articleId].quantity
  Markets.marketsList[marketId].articles[articleId].quantity = q + quantity
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
    if article.price > player.coins then
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
function Markets.makeBuyOrder(id, player, quantity)
  local bool, msg = false, ""
  local article = Globals.market.articles[id]
  if article.quantity >= quantity then
    if player.coins >= quantity * article.price then
      bool = true
      Globals.estimatedPrice = -(quantity * article.price)
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
function Markets.makeSellOrder(id, player, quantity)
  local bool, msg = false, ""
  local price = 0
  --search the article actual price
  local article = Globals.market.articles[id]
  price = article.price

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

return Markets
