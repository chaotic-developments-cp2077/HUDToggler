# HUDToggler
This mod allows for HUD elements to automatically be toggled for events like opening/closing the weapon wheel, getting into a car, and toggling the scanner.

The "real" game interface settings do not need to be touched, as they will automatically be toggled depending on whatever is selected in the mod's CET overlay window.

Some HUD elements are automatically hidden in certain game states, but the mod UI does not make this differentiation. Enabling/disabling a HUD element will have no effect if that element is already disabled by the game.

This mod also features a hotkey to completely hide the HUD. This overrides any selected preferences and restores them when the hotkey is toggled off.

Running this mod requires [CET](https://www.nexusmods.com/cyberpunk2077/mods/107) and [Red4Ext](https://www.nexusmods.com/cyberpunk2077/mods/2380).

## Demo
Note that this demo is from v1.0.0 but the functionality remains the same:

https://imgur.com/s8iSm73

## Updates
Please **reinstall this mod** when updating to a newer version, as it may break if the previous version is not removed.

## Features
- Separate toggles for individual HUD elements across multiple game states
- Hotkey toggle to hide all HUD elements (restores HUD preferences when disabled)

## Disclaimer
This mod uses the [GameUI.lua](https://github.com/psiberx/cp2077-cet-kit/blob/main/GameUI.lua) file by psiberx, which is protected by the MIT license. The `GameSettings.lua` file, however, while having the same name as the one by psiberx, is my own and does not use code from that repo.
