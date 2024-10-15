-- Loading these after init to ensure the game engine is fully initialised
local GameUI, HUDToggler

local function updateHUD()
  if GameUI.IsVehicle() then
    HUDToggler.ToggleHUD("vehicle")
  else
    HUDToggler.ToggleHUD("onFoot")
  end
end

registerForEvent("onInit", function()
  GameUI = require("GameUI")
  HUDToggler = require("HUDToggler")

  HUDToggler.LoadData()

  updateHUD()

  GameUI.Listen(GameUI.Event.VehicleEnter, function()
    HUDToggler.ToggleHUD("vehicle")
	end)

  GameUI.Listen(GameUI.Event.VehicleExit, function()
    HUDToggler.ToggleHUD("onFoot")
	end)
end)

registerForEvent("onOverlayOpen", function()
  HUDToggler.isCETOpen = true
end)

registerForEvent("onOverlayClose", function()
  HUDToggler.isCETOpen = false

  updateHUD()

  HUDToggler.SaveData()
end)

registerForEvent("onDraw", function()
  HUDToggler.DrawMenu()
end)

registerInput("input_toggle_all_hud", "Toggle all HUD on/off", function (keypress)
  if not keypress or not HUDToggler then return end

  HUDToggler.ToggleHUD(nil)
end)

return HUDToggler
