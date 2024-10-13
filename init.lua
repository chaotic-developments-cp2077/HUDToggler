local GameUI = require("GameUI")
local HUDToggler = require("HUDToggler")

local function updateHUD()
  if GameUI.IsVehicle() then
    HUDToggler.UpdateVehicleHUD()
  else
    HUDToggler.UpdateOnFootHUD()
  end
end

registerForEvent("onInit", function()
  HUDToggler.LoadData()

  updateHUD()

  GameUI.Listen(GameUI.Event.VehicleEnter, function()
    HUDToggler.UpdateVehicleHUD()
	end)

  GameUI.Listen(GameUI.Event.VehicleExit, function()
    HUDToggler.UpdateOnFootHUD()
	end)
end)

registerForEvent("onOverlayOpen", function()
  HUDToggler.isCETOpen = true
end)

registerForEvent("onOverlayClose", function()
  HUDToggler.isCETOpen = false
  HUDToggler.SyncManagedSettings()

  updateHUD()

  HUDToggler.SaveData()
end)

registerForEvent("onDraw", function()
  HUDToggler.DrawMenu()
end)

return HUDToggler
