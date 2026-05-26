local Prompt = {}
local Globals = require("globals")

function Prompt.updatePrompt(mode)
  local selecteds = { "inputId", "inputQuantity" }
  local prompts = {
    "Select a resource by typing its ID (e.g. 12) \nValidate with 'Enter' key; delete with 'Backspace' key.",
    "Write the quantity you want to " .. mode .. "" }
  for index, selected in ipairs(selecteds) do
    if Globals.selected == selected then
      Globals.prompt = prompts[index]
    end
  end
end

return Prompt
