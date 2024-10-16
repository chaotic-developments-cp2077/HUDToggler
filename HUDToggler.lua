local GameSettings = require("GameSettings")

local HUDToggler = {
  isCETOpen = false,
  isHUDShown = true,
  HUDSettingsGroup = GameSettings.GetSettingsGroup("/interface/hud"),
  -- Visibility preferences for each setting in "HUD Visibility" section of interface settings.
  -- The `varName` corresponds to the setting in game code (DO NOT CHANGE)
  Settings = {
    Minimap = { varName = "minimap", onFoot = true, vehicle = true, scanner = true, wheel = true },
    HealthBar = { varName = "healthbar", onFoot = true, vehicle = true, scanner = true, wheel = true },
    StaminaAndOxygen = { varName = "stamina_oxygen", onFoot = true, vehicle = true, scanner = true, wheel = true },
    BossHealthBars = { varName = "npc_healthbar", onFoot = true, vehicle = true, scanner = true, wheel = true },
    AmmoCounter = { varName = "ammo_counter", onFoot = true, vehicle = true, scanner = true, wheel = true },
    Hints = { varName = "input_hints", onFoot = true, vehicle = true, scanner = true, wheel = true },
    ActionButtons = { varName = "action_buttons", onFoot = true, vehicle = true, scanner = true, wheel = true },
    ActivityLog = { varName = "activity_log", onFoot = true, vehicle = true, scanner = true, wheel = true },
    CrossHair = { varName = "crosshairs", onFoot = true, vehicle = true, scanner = true, wheel = true },
    JobTracker = { varName = "quest_tracker", onFoot = true, vehicle = true, scanner = true, wheel = true },
    TargetMarker = { varName = "object_markers", onFoot = true, vehicle = true, scanner = true, wheel = true },
    NPCNames = { varName = "npc_names", onFoot = true, vehicle = true, scanner = true, wheel = true },
    NCPDWantedLevel = { varName = "wanted_level", onFoot = true, vehicle = true, scanner = true, wheel = true },
    NPCNameplates = { varName = "npc_nameplates", onFoot = true, vehicle = true, scanner = true, wheel = true },
    CrouchIndicator = { varName = "crouch_indicator", onFoot = true, vehicle = true, scanner = true, wheel = true },
    VehicleHUD = { varName = "vehicle_hud", onFoot = true, vehicle = true, scanner = true, wheel = true },
    HUDMarkers = { varName = "hud_markers", onFoot = true, vehicle = true, scanner = true, wheel = true },
  },
}

-- Local variable is more performant than table lookup
local settingsCache = HUDToggler.Settings

-- Draws CET overlay window
HUDToggler.DrawMenu = function()
  if not HUDToggler.isCETOpen then return end

  local fullWidth, fullHeight = GetDisplayResolution()

  -- Set window position and size
  ImGui.SetNextWindowPos(fullWidth*0.83, fullHeight*0.1, ImGuiCond.FirstUseEver)
  ImGui.SetNextWindowSize(fullWidth*0.14, fullHeight*0.6, ImGuiCond.FirstUseEver)

  if not ImGui.Begin("HUD Toggler") then return end

  ImGui.TextWrapped("Selected settings will be enabled.")
  ImGui.Dummy(0, 10)
  ImGui.Separator()
  ImGui.Dummy(0, 10)

  if ImGui.CollapsingHeader("On Foot") then
    for setting, value in pairs(settingsCache) do
      ImGui.PushID(setting .. "_onFoot") -- IDs needed since we're using the same table for on-foot and vehicle
      value.onFoot = ImGui.Checkbox(setting, value.onFoot)
      ImGui.PopID()
    end
  end

  ImGui.Separator()

  if ImGui.CollapsingHeader("In Vehicle") then
    for setting, value in pairs(settingsCache) do
      ImGui.PushID(setting .. "_vehicle")
      value.vehicle = ImGui.Checkbox(setting, value.vehicle)
      ImGui.PopID()
    end
  end

  ImGui.Separator()

  if ImGui.CollapsingHeader("In Scanner") then
    for setting, value in pairs(settingsCache) do
      ImGui.PushID(setting .. "_scanner")
      value.scanner = ImGui.Checkbox(setting, value.scanner)
      ImGui.PopID()
    end
  end

  ImGui.Separator()

  if ImGui.CollapsingHeader("In Weapon Wheel") then
    for setting, value in pairs(settingsCache) do
      ImGui.PushID(setting .. "_wheel")
      value.wheel = ImGui.Checkbox(setting, value.wheel)
      ImGui.PopID()
    end
  end

  ImGui.End()
end

-- Toggles in-game HUD settings using `key` to determine whether on-foot or vehicle preferences should be used.
-- If `key` is `nil`, toggle all HUD on/off using `HUDToggler.isAllHUDToggled`.
HUDToggler.ToggleHUD = function(key)
  local settingsGroup = HUDToggler.HUDSettingsGroup

  if key ~= nil and HUDToggler.isHUDShown then
    for _, setting in pairs(settingsCache) do
      GameSettings.UpdateSetting(settingsGroup, setting.varName, setting[key])
    end

    return
  end

  for _, setting in pairs(settingsCache) do
    GameSettings.UpdateSetting(settingsGroup, setting.varName, HUDToggler.isHUDShown)
  end
end

HUDToggler.SaveData = function()
  local file = io.open("data.json", "w")

  if not file then
    print("[HUDToggler]: SaveData: failed to open or create data file")
    return
  end

  file:write(json.encode(HUDToggler.Settings))
  file:close()
end

HUDToggler.LoadData = function()
  local file = io.open("data.json", "r")

  if not file then
    print("[HUDToggler]: LoadData: data file not found. This is expected if the mod has just been installed.")
    return
  end

  local content = file:read("a")

  if not content then
    print("[HUDToggler]: LoadData: failed to read file content")
    return
  end

  file:close()

  HUDToggler.Settings = json.decode(content)
  settingsCache = HUDToggler.Settings
end

return HUDToggler
