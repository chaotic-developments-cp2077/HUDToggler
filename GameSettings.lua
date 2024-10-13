local GameSettings = {}

GameSettings.GetSettingsGroup = function(groupPath)
  return Game.GetSettingsSystem():GetGroup(groupPath)
end

GameSettings.UpdateSetting = function(settingsGroup, settingName, value)
  settingsGroup:GetVar(settingName):SetValue(value)
end

return GameSettings
