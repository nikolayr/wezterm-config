-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

-- setup wezterm for WSL
config.default_domain = 'WSL:Ubuntu-20.04'


-- setup leader key
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- copy to clipboard selected text by Enter
local copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(copy_mode, {
  key = 'Enter',
  mods = 'NONE',
  action = act.Multiple {
    { CopyTo = 'ClipboardAndPrimarySelection' },
    act.ClearSelection,
    act.CopyMode 'Close',
  },
})
config.key_tables = { copy_mode = copy_mode }

-- This is where you actually apply your config choices.
config.keys = {
-- disable enter when text is selected
{
    key = 'Enter',
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      -- 1. Grab any currently selected text from the pane
      local selection = window:get_selection_text_for_pane(pane)
      -- 2. Check if the selection exists and isn't empty
      if selection and selection ~= "" then
        -- Text IS selected! 
        -- We do nothing here, which effectively blocks the 'Enter' key.
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
        window:perform_action(act.ClearSelection, pane)        
        return 
      else
        -- 3. No text is selected, so we pass the 'Enter' key through to the terminal normally.
        window:perform_action(wezterm.action.SendKey { key = 'Enter' }, pane)
      end
    end),
  },


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
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'SHIFT',
    action = act.PasteFrom 'Clipboard',
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
