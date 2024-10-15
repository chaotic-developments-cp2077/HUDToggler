-- Loading these after init to ensure the game engine is fully initialised
local GameUI, HUDToggler

local function updateHUD()
  if GameUI.IsScanner() then
    HUDToggler.ToggleHUD("scanner")
  elseif GameUI.IsWheel() then
    HUDToggler.ToggleHUD("wheel")
  elseif GameUI.IsVehicle() then
    HUDToggler.ToggleHUD("vehicle")
  else
    HUDToggler.ToggleHUD("onFoot")
  end
end

registerForEvent("onInit", function()
  GameUI = require("GameUI")
  HUDToggler = require("HUDToggler")

  HUDToggler.LoadData()

  GameUI.Listen(GameUI.Event.VehicleEnter, function()
    HUDToggler.ToggleHUD("vehicle")
	end)

  GameUI.Listen(GameUI.Event.VehicleExit, function()
    updateHUD()
	end)

  GameUI.Listen(GameUI.Event.ScannerOpen, function()
    HUDToggler.ToggleHUD("scanner")
	end)

  GameUI.Listen(GameUI.Event.ScannerClose, function()
    updateHUD()
	end)

  GameUI.Listen(GameUI.Event.WheelOpen, function()
    HUDToggler.ToggleHUD("wheel")
	end)

  GameUI.Listen(GameUI.Event.WheelClose, function()
    updateHUD()
	end)

  updateHUD()
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

  HUDToggler.isHUDShown = not HUDToggler.isHUDShown

  if not HUDToggler.isHUDShown then
    HUDToggler.ToggleHUD(nil)
  else
    updateHUD()
  end
end)

return HUDToggler
