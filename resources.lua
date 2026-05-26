local Resources = {}
Resources.byId={}
Resources.list = {
  {
    id=1,
    name = "Codex Sellionis",
    description = "An eye of amethyst and turquoise stares from the leather cover.",
    type = "grimoire",
    rarity = 5,
    basePrice=10000,
    cursed = true
  },
  {
    id=2,
    name = "Sacred Salt",
    description = "These salts were exorcised and blessed by a local priest.",
    type = "mineral",
    rarity = 1,
    basePrice=10
  },
  {
    id=3,
    name = "Exorcismus Manual",
    description = "The coat of arms of the Holy See is prominently displayed on the cover.",
    type = "grimoire",
    rarity = 2,
    basePrice=2000,
  },
  {
    id=4,
    name = "Prayer Incense",
    description = "They are commonly used for prayers or during funerals.",
    type = "consumable",
    rarity = 1,
    basePrice=20,
  },
  {
    id=5,
    name = "Tibetan Wax Candle",
    description = "Its sweet, delicate fragrance alone is enough to uplift your spirit.",
    type = "consumable",
    rarity = 3,
    basePrice=25,
  },
  {
    id=6,
    name = "Mercury Mirror",
    description = "The image reflected there, abnormally, appears not distorted, but slightly different.",
    type = "divination_tool",
    rarity = 2,
    basePrice=600,
    cursed = true
  },
  {
    id=7,
    name = "Breathing Chest",
    description = "An almost imperceptible whisper seems to emanate from within.",
    type = "spirit_vessel",
    rarity = 3,
    basePrice=800,
    cursed = true
  },
  {
    id=8,
    name = "Sweating Reliquary",
    description = "The reliquary is always damp and warm to the touch.",
    type = "spirit_vessel",
    rarity = 3,
    basePrice=1000,
    cursed = true
  },
  {
    id=9,
    name = "Black Salt",
    description = "It can be used as a condiment as well as for its cleansing properties.",
    type = "consumable",
    rarity = 2,
    basePrice=15,
  },
  {
    id=10,
    name = "Bohemian Tarot",
    description = "This edition of the tarot deck is commonly used by travelers.",
    type = "divination_tool",
    rarity = 1,
    basePrice=50,
  },
  {
    id=11,
    name = "Hand of Glory",
    description = "This dried and pickled hand is said to have come from a hanged man.",
    type = "consumable",
    rarity = 3,
    basePrice=200,
  },
  {
    id=12,
    name = "Lightning Stone",
    description = "This stone is a remnant of a lightning strike.",
    type = "artifact",
    rarity = 2,
    basePrice=50,
  },
  {
    id=13,
    name = "Exotic Doll",
    description = "This strange doll resembles no one and everyone at the same time.",
    type = "effigy",
    rarity = 1,
    basePrice=20,
  }
}

function Resources.sort()
  local list=Resources.list
  table.sort(list,function(a,b)return a.name<b.name  end)
  for index, value in ipairs(list) do
    if not  Resources.byId[value.id]then
    Resources.byId[value.id]=value
    end
  end
  return list
end

function Resources.getResource(id)
  return Resources.byId[id]
end
return Resources