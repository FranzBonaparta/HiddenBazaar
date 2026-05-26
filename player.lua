local Player = {}
local Locations = require("locations")
local Resources = require("resources")
local Markets = require("markets")
local Globals = require("globals")
Player.coins = 280
Player.inventory = {

}
Player.maxSizeInventory = 10
Player.location = 1
Player.daysRemaining = 30

function Player.getLocation()
  return Locations.list[Player.location]
end

function Player.addCoins(amount)
  Player.coins = Player.coins + amount
  return ""
end

function Player.useCoins(amount)
  local msg = Player.coins >= amount and "" or "Not enough money!"
  if Player.coins >= amount then
    Player.coins = Player.coins - amount
  end
  return msg
end

function Player.initInventory()
  local resources = Resources.sort()

  --add articles

  for _, resource in ipairs(resources) do
    local didHave = math.random(2)
    local quantity = (didHave > 1 and resource.rarity < 3) and math.random(math.floor(20 / (resource.rarity + 1))) or 0
    table.insert(Player.inventory, { id = resource.id, quantity = quantity })
  end
end

function Player.getArticle(id)
  for _, article in ipairs(Player.inventory) do
    if article.id == id then
      return article
    end
  end
end

function Player.travel(destinationId)
  if Player.location ~= destinationId then
    Globals.market = Markets.getMarket(destinationId)
    Globals.articles = Markets.getArticlesRange()
    Globals.inputQuantity = ""
    local diff = (Player.location - destinationId) >= 0 and (Player.location - destinationId) or
        (destinationId - Player.location)
    Player.daysRemaining = math.max(0, Player.daysRemaining - diff)
    Player.location = destinationId
    Globals.msg=string.format("You traveled to %s, %d days remaining!",Globals.market.name,Player.daysRemaining)
  end
end

function Player.updateArticle(id, quantity)
  local marketOrder = Globals.mode == "buy" and Markets.callBuy(id, Player) or Markets.callSell(Player.getArticle(id))
    if not marketOrder then return end
  for _, art in ipairs(Player.inventory) do
    if art.id == id then
      art.quantity = art.quantity + quantity
    end
  end
  local marketArticle = Markets.getArticle(Player.location, id)
  local price = marketArticle.price * quantity
  Player.coins = Player.coins - price
  Markets.updateMarketArticle(Player.location, id, -quantity)
end

return Player