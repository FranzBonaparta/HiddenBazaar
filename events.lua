local Events={}
local Markets=require("markets")
local Resources=require("resources")
--[[
  {
    name="",
    description="",
    targets={
    []={priceEvolution= , stockEvolution=}
    },
  },
  ]]
Events.list={
  {
    name="posessions",
    description="some locals are reporting cases of possession",
    targets={
      [2]={priceEvolution=0.25,stockEvolution=-2},
      [3]={priceEvolution=0.25 ,stockEvolution=-2 },
      [4]={priceEvolution=0.25 ,stockEvolution=-2 },
      [5]={priceEvolution=0.25 ,stockEvolution=-2 },
      [9]={priceEvolution=0.25 ,stockEvolution=-2 }
    }
  },
  {
    name="Inquisition",
    description="The inquisitor was dispatched to the city",
    targets={
      [2]={priceEvolution=-0.5 ,stockEvolution=5 },
      [3]={priceEvolution=-0.5 ,stockEvolution=5 },
      [11]={priceEvolution=-0.5 ,stockEvolution=5 },
      [10]={priceEvolution=0.5 ,stockEvolution=-5 },
      [13]={priceEvolution=0.5 ,stockEvolution=-5 }
    }
  },

}

Events.byId={}

function Events.makeList()
  Events.byId={}
  for index, event in ipairs(Events.list) do
    Events.byId[index]=event
  end
end

function Events.getEvent(id)
  return Events.byId[id]
end

function Events.getRandomEvent()
  local rand=math.random(1,#Events.list)
  return rand
end

function Events.getModifiedPrice(marketId,articleId)
  local price=math.floor(Markets.getArticle(marketId,articleId).price)
  local modifiedPrice=0
  local market=Markets.getMarket(marketId)
  for eventId, activeEvent in pairs(market.activeEvents) do
    local event=Events.getEvent(eventId)
    local target=event.targets[articleId]
    if target then
      modifiedPrice=modifiedPrice+math.floor(price*target.priceEvolution)
    end
  end
  
  return math.max(1,modifiedPrice+price)
end

function Events.getModifiedStock(marketId,articleId)
  --local quantity=Markets.getArticle(marketId,articleId).quantity
  local market=Markets.getMarket(marketId)
  for eventId, value in pairs(market.activeEvents) do
    local event=Events.getEvent(eventId)
    local target=event.targets[articleId]
    if target then
      --test add stockEvolution each turn
      Markets.updateMarketArticle(marketId,articleId,target.stockEvolution)
    end
  end
end
return Events