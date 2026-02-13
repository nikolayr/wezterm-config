-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action


-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.keys = {
  -- paste from the clipboard
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },

  -- paste from the primary selection
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
}

config.mouse_bindings = {
  -- Paste from primary selection on middle click
  {
    event = { Down = { streak = 1, button = 'Middle' } },
    mods = 'SHIFT',
    action = act.PasteFrom 'Clipboard',
  },
  {
    event = { Down = { streak = 1, button = 'Middle' } },
    mods = 'NONE',
    action = act.PasteFrom 'PrimarySelection',
  },
}



-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 32

-- or, changing the font size and color scheme.
config.font_size = 16
config.color_scheme = 'AdventureTime'

-- Finally, return the configuration to wezterm:
return config
