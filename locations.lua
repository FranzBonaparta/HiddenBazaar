local Locations = {}

Locations.list = {
  {
    name = "Apre", --aprum=sanglier / city
    marketModifiers = {
      mineral = 1.3,
      consumable = 0.9,
      divination_tool = 1.4,
      effigy = 1.1,
      artifact = 1.4
    }
  },
  {
    name = "Tria Maria Port",
    marketModifiers = {
      mineral = 1.2,
      consumable = 0.9,
      divination_tool = 1.2,
      spirit_vessel = 1.2,
      effigy = 0.9,
      artifact = 1.1
    }
  },
  {
    name = "Quietis Mount Abbey", --quietis=rest
    marketModifiers = {
      mineral = 0.6,
      grimoire = 1.1,
      consumable = 1.1,
      spirit_vessel = 1.3,
    }
  },
  {
    name = "Palgus", --palude unguibus=swamp claw
    marketModifiers = {
      grimoire = 1.8,
      divination_tool = 0.9,
      spirit_vessel = 0.6,
      effigy = 0.8,
      artifact = 1.3
    }
  }
}

return Locations
