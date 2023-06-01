local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- basics
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.hide_mouse_cursor_when_typing = false
config.default_cursor_style = 'SteadyBar'

-- color
config.color_scheme = 'Catppuccin Mocha'

-- font
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = "Regular" })
config.font_size = 11

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- Make Ctrl-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
    mouse_reporting = true --- this fixes it from not working in tmux
  },

  -- Fix shift+selection: https://github.com/wez/wezterm/issues/2910#issuecomment-1441182554
  { event = { Down = { streak = 1, button = 'Left' } }, mods = 'SHIFT', action = act.SelectTextAtMouseCursor('Cell'), },
  { event = { Down = { streak = 1, button = 'Middle' } }, mods = 'SHIFT', action = act.PasteFrom('PrimarySelection'), },
  { event = { Down = { streak = 2, button = 'Left' } }, mods = 'SHIFT', action = act.SelectTextAtMouseCursor('Word'), },
  { event = { Down = { streak = 3, button = 'Left' } }, mods = 'SHIFT', action = act.SelectTextAtMouseCursor('Line'), },
  { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'SHIFT', action = act.ExtendSelectionToMouseCursor('Cell'), },
  { event = { Drag = { streak = 2, button = 'Left' } }, mods = 'SHIFT', action = act.ExtendSelectionToMouseCursor('Word'), },
  { event = { Drag = { streak = 3, button = 'Left' } }, mods = 'SHIFT', action = act.ExtendSelectionToMouseCursor('Line'), },
  { event = { Up = { streak = 2, button = 'Left' } }, mods = 'SHIFT', action = act.CompleteSelection('ClipboardAndPrimarySelection'), },
  { event = { Up = { streak = 3, button = 'Left' } }, mods = 'SHIFT', action = act.CompleteSelection('ClipboardAndPrimarySelection'), },
}


return config

