-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- see https://github.com/danielcopper/wezterm-session-manager
local session_manager = require("wezterm-session-manager/session-manager")
wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

-- setup leader key
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }


-- This is where you actually apply your config choices.
config.keys = {
  -- paste from the clipboard
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },

  -- paste from the primary selection
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },

   {key = "S", mods = "LEADER", action = wezterm.action{EmitEvent = "save_session"}},
   {key = "L", mods = "LEADER", action = wezterm.action{EmitEvent = "load_session"}},
   {key = "R", mods = "LEADER", action = wezterm.action{EmitEvent = "restore_session"}},

  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- split vertical by Ctrl+a and _ within 1000ms
  { mods = 'LEADER|SHIFT', key = '_', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
-- full screen
  {
    key = 'Enter',
    mods = 'SUPER', -- This uses the Windows key
    action = wezterm.action.ToggleFullScreen,
  },
}

config.mouse_bindings = {
  -- Paste from primary selection on middle click
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
