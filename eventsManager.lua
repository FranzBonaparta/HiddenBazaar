local EventManager = {}
local Events = require("events")
local Markets = require("markets")

function EventManager.init()
  Events.makeList()
end

function EventManager.randomizeEvents()
  for key,market in pairs(Markets.marketsList) do
    local rand = math.random()
    if rand > 0.5 then
      local eventId = Events.getRandomEvent()
      Events.applyEvent(eventId, market)
      local event=Events.getEvent(eventId)
      print(event.name.." occurs on "..market.name)
      Markets.marketsList[key]=market
    end
  end
end

return EventManager
