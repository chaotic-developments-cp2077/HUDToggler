local GameSettings = require("GameSettings")

local HUDToggler = {
  isCETOpen = false,
  HUDSettingsGroup = GameSettings.GetSettingsGroup("/interface/hud"),
  -- Visibility preferences for each setting in "HUD Visibility" section of interface settings.
  -- The `varName` corresponds to the setting in game code (DO NOT CHANGE)
  Settings = {
    Minimap = { varName = "minimap", onFoot = true, vehicle = true },
    HealthBar = { varName = "healthbar", onFoot = true, vehicle = true },
    StaminaAndOxygen = { varName = "stamina_oxygen", onFoot = true, vehicle = true },
    BossHealthBars = { varName = "npc_healthbar", onFoot = true, vehicle = true },
    AmmoCounter = { varName = "ammo_counter", onFoot = true, vehicle = true },
    Hints = { varName = "input_hints", onFoot = true, vehicle = true },
    ActionButtons = { varName = "action_buttons", onFoot = true, vehicle = true },
    ActivityLog = { varName = "activity_log", onFoot = true, vehicle = true },
    CrossHair = { varName = "crosshairs", onFoot = true, vehicle = true },
    JobTracker = { varName = "quest_tracker", onFoot = true, vehicle = true },
    TargetMarker = { varName = "object_markers", onFoot = true, vehicle = true },
    NPCNames = { varName = "npc_names", onFoot = true, vehicle = true },
    NCPDWantedLevel = { varName = "wanted_level", onFoot = true, vehicle = true },
    NPCNameplates = { varName = "npc_nameplates", onFoot = true, vehicle = true },
    CrouchIndicator = { varName = "crouch_indicator", onFoot = true, vehicle = true },
    VehicleHUD = { varName = "vehicle_hud", onFoot = true, vehicle = true },
    HUDMarkers = { varName = "hud_markers", onFoot = true, vehicle = true },
  },
  ManagedSettings = {} -- HUD elements that must be toggled when entering/exiting vehicles (populated dynamically when overlay is closed)
}

-- Draws CET overlay window
HUDToggler.DrawMenu = function()
  if not HUDToggler.isCETOpen then return end

  local settingsCache = HUDToggler.Settings
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

  ImGui.End()
end

HUDToggler.SyncManagedSettings = function()
  local newManagedSettings = {}
  local settingsCache = HUDToggler.Settings

  for _, value in pairs(settingsCache) do
    if value.onFoot ~= value.vehicle then
      newManagedSettings[#newManagedSettings+1] = value
    end
  end

  HUDToggler.ManagedSettings = newManagedSettings
end

HUDToggler.UpdateOnFootHUD = function()
  for _, setting in ipairs(HUDToggler.ManagedSettings) do
    GameSettings.UpdateSetting(HUDToggler.HUDSettingsGroup, setting.varName, setting.onFoot)
  end
end

HUDToggler.UpdateVehicleHUD = function()
  for _, setting in ipairs(HUDToggler.ManagedSettings) do
    GameSettings.UpdateSetting(HUDToggler.HUDSettingsGroup, setting.varName, setting.vehicle)
  end
end

HUDToggler.SaveData = function()
  local file = io.open("HUDTogglerData.json", "w")

  if not file then
    print("[HUDToggler]: SaveData: failed to open or create data file")
    return
  end

  file:write(json.encode(HUDToggler.Settings))
  file:close()
end

HUDToggler.LoadData = function()
  local file = io.open("HUDTogglerData.json", "r")

  if not file then
    print("[HUDToggler]: LoadData: data file not found")
    return
  end

  local content = file:read("a")

  if not content then
    print("[HUDToggler]: LoadData: failed to read file content")
    return
  end

  file:close()

  HUDToggler.Settings = json.decode(content)
end

return HUDToggler
