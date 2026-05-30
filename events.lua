local Events={}

Events.list={
  {
    name="",
    description="",
    targets={},
    pricesEvolutions={},
    stocksEvolutions={}
  },
  {
    name="",
    description="",
    targets={},
    pricesEvolutions={},
    stocksEvolutions={}
  },
  {
    name="",
    description="",
    targets={},
    pricesEvolutions={},
    stocksEvolutions={}
  },
  {
    name="",
    description="",
    targets={},
    pricesEvolutions={},
    stocksEvolutions={}
  },
  {
    name="",
    description="",
    targets={},
    pricesEvolutions={},
    stocksEvolutions={}
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
return Events