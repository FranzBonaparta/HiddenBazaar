local Events={}
local Markets=require("markets")
local Resources=require("resources")
--[[
  {
    name="",
    description="",
    targets={},
    pricesEvolutions={},
    stocksEvolutions={}
  },
  ]]
Events.list={
  {
    name="posessions",
    description="some locals are reporting cases of possession",
    targets={2,3,4,5,9},
    pricesEvolutions={1.25,1.25,1.25,1.25,1.25},
    stocksEvolutions={0.5,0.5,0.5,0.5,0.5,0.5}
  },
  {
    name="Inquisition",
    description="The inquisitor was dispatched to the city",
    targets={2,3,11,10,13},
    pricesEvolutions={0.5,0.5,0.5,1.5,1.5},
    stocksEvolutions={1.5,1.5,1.5,0.5,0.5}
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
function Events.applyEvent(eventId,market)
  local event=Events.getEvent(eventId)
  for index,target in ipairs(event.targets) do
    local article=Markets.getArticle(market.id,target)
    if not target or not article then return end
    local name=Resources.getResource(article.id).name
    --print(name,article.price)
    local price=event.pricesEvolutions[index]*article.price
    local lastPrice=article.price
    local quantity=event.stocksEvolutions[index]
    quantity=quantity<1 and -quantity*article.quantity or article.quantity*quantity
    Markets.updateMarketArticle(market.id,target,quantity,price)    
  --print(name,lastPrice,event.pricesEvolutions[index],price)
  end
end
return Events