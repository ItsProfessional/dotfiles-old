local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- basics
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.hide_mouse_cursor_when_typing = false

-- color
config.color_scheme = 'Catppuccin Mocha'

-- font
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = "Regular" })
config.font_size = 11

local act = wezterm.action

config.keys = {
  { key = 'UpArrow', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', action = act.ScrollByLine(1) },
}


-- and finally, return the configuration to wezterm
return config

