local GameSettings = require("GameSettings")
local GameUI = require("GameUI")
local HUDToggler = require("HUDToggler")

registerForEvent("onOverlayOpen", function()
  HUDToggler.isCETOpen = true
end)

registerForEvent("onOverlayClose", function()
  HUDToggler.isCETOpen = false
  HUDToggler.SyncManagedSettings()
end)

registerForEvent("onDraw", function()
  HUDToggler.DrawMenu()
end)

registerForEvent("onInit", function()
  local HUDSettingsGroup = GameSettings.GetSettingsGroup(HUDToggler.HUDSettingGroupPath)

  GameUI.Listen(GameUI.Event.VehicleEnter, function()
    for _, setting in ipairs(HUDToggler.ManagedSettings) do
      GameSettings.UpdateSetting(HUDSettingsGroup, setting.varName, setting.vehicle)
    end
	end)

  GameUI.Listen(GameUI.Event.VehicleExit, function()
    for _, setting in ipairs(HUDToggler.ManagedSettings) do
      GameSettings.UpdateSetting(HUDSettingsGroup, setting.varName, setting.onFoot)
    end
	end)
end)

return HUDToggler
