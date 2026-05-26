local Markets = {}
local Resources = require("resources")
local Locations = require("locations")
local Globals = require("globals")

Markets.marketsList = {}

function Markets.initList()
  local resources = Resources.sort()
  --init markets
  for index, location in ipairs(Locations.list) do
    table.insert(Markets.marketsList, { id = index, name=location.name, articles = {} })
  end
  --add articles
  for index, market in ipairs(Markets.marketsList) do
    local modifiers = Locations.list[index].marketModifiers
    for _, resource in ipairs(resources) do
      local modifier = modifiers[resource.type] or 1
      local price = math.floor(modifier * resource.basePrice)
      local quantity = math.random(0, math.floor(20 / (resource.rarity + 1)))
      table.insert(market.articles, { id = resource.id, price = price, quantity = quantity })
    end
  end
end

function Markets.getMarket(id)
  for _, market in ipairs(Markets.marketsList) do
    if market.id == id then
      return market
    end
  end
end

function Markets.updateMarketArticle(marketId, articleId, quantity)
  for _, market in ipairs(Markets.marketsList) do
    if market.id == marketId then
      for _, article in ipairs(market.articles) do
        if article.id == articleId then
          article.quantity = article.quantity + quantity
          return
        end
      end
    end
  end
end

function Markets.getArticle(marketId, articleId)
  local market = Markets.getMarket(marketId)
  if market then
    for _, article in ipairs(market.articles) do
      if article.id == articleId then
        return article
      end
    end
  end
end

function Markets.callBuy(id, player)
  for _, article in ipairs(Globals.market.articles) do
    local resource = Resources.getResource(article.id)
    if not resource then return false end
    local articleName = resource.name
    if article.id == id and article.quantity <= 0 then
      Globals.msg = "No stock available for " .. articleName
      return false
    elseif article.id == id and article.quantity > 0 then
      if article.price > player.coins then
        Globals.msg = "You can't buy any " .. articleName
        return false
      end
      return true
    end
  end
end

function Markets.callSell(playerStock)
  local resource=Resources.getResource(playerStock.id)
  local min=Globals.selected=="inputId" and 0 or tonumber(Globals.inputQuantity)
  if  playerStock.quantity >= min then
    Globals.msg = ""
    return true
  else
    Globals.msg = resource.name.." is no more present in your stock!"
    return false
  end
end

function Markets.getArticlesRange(offset)
  offset = offset or Globals.marketOffset

  local articles = Globals.market.articles
  local list = {}

  for i = offset, offset + Globals.marketRange - 1 do
    if not articles[i] then break end
    table.insert(list, articles[i])
  end

  return list
end

function Markets.makeBuyOrder(id, player, quantity)
  local bool, msg = false, ""
  for index, article in ipairs(Globals.market.articles) do
    if article.id == id then
      if article.quantity >= quantity then
        if player.coins >= quantity * article.price then
          bool = true
          Globals.estimatedPrice = -(quantity * article.price)
        else
          msg = "Not enought coins in your wallet"
        end
        break
      else
        local articleName = Resources.getResource(tonumber(Globals.inputId)).name
        msg = "Not enought " .. articleName .. " in stock!"
        break
      end
    end
  end
  if not bool then
    Globals.estimatedPrice = 0
  end
  return bool, msg
end

function Markets.makeSellOrder(id, player, quantity)
  local bool, msg = false, ""
  local price = 0
  --search the article actual price
  for _, article in ipairs(Globals.market.articles) do
    if article.id == id then
      price = article.price
      break
    end
  end
  --then simulate operation
  for _, article in ipairs(player.inventory) do
    if article.id == id then
      if article.quantity >= quantity then
        bool = true
        Globals.estimatedPrice = quantity * price
      else
        local articleName = Resources.getResource(tonumber(Globals.inputId)).name
        msg = "Not enought " .. articleName .. " in your stock!"
      end
    end
  end
  return bool, msg
end

--function to get articles pool to print in the scrollBox
function Markets.moveArticlesPool(change)
  local maxOffset = math.max(1, #Globals.market.articles - Globals.marketRange + 1)

  Globals.marketOffset = math.max(
    1,
    math.min(Globals.marketOffset + change, maxOffset)
  )

  Globals.articles = Markets.getArticlesRange()
end

return Markets