local EventManager = {}
local Events = require("events")
local Markets = require("markets")

function EventManager.init()
  Events.makeList()
end

function EventManager.randomizeEvents()
  for key,market in pairs(Markets.marketsList) do
    --we can adjust the rate
    local rand = math.random(1,20)
    if rand ==1 then
      local eventId = Events.getRandomEvent()
      Markets.addEvent(market.id,eventId,5)
      local event=Events.getEvent(eventId)
      print(event.name.." occurs on "..market.name)
      Markets.marketsList[key]=market
    end
  end
end

return EventManager
