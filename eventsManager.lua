local EventManager = {}
local Events = require("events")
local Markets = require("markets")

function EventManager.init()
  Events.makeList()
end

function EventManager.randomizeEvents()
  for key, market in pairs(Markets.marketsList) do
    --we can adjust the rate
    local rand = math.random(1, 20)
    if rand == 1 then
      local eventId = Events.getRandomEvent()
      Markets.addEvent(market.id, eventId, 5)
      local event = Events.getEvent(eventId)
      --print(event.name .. " occurs on " .. market.name)
      Markets.marketsList[key] = market
    end
  end
end

function EventManager.updateStocksModification()
  for marketId, market in pairs(Markets.marketsList) do
    for eventId, event in pairs(market.activeEvents) do
      if event.remainingDays >= 1 then
        local sourceEvent = Events.getEvent(eventId)
        local targetsStocksModified = false
        for articleId, target in pairs(sourceEvent.targets) do
          if target then
            Events.getModifiedStock(marketId, articleId)
            if targetsStocksModified == false then
              targetsStocksModified = true
            end
          end
        end
        if targetsStocksModified and not event.initiated then
          event.remainingDays = event.remainingDays - 1
        end
      elseif event.remainingDays < 1 then
        Markets.marketsList[marketId].activeEvents[eventId] = nil
      end
      if event.initiated then
        Markets.marketsList[marketId].activeEvents[eventId].initiated = false
      end
    end
  end
end

return EventManager
