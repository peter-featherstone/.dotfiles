-- ln -s /Users/peter/Documents/Local/git/.dotfiles/wezterm/wezterm.lua /Users/peter/.wezterm.lua

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Ef-Deuteranopia-Dark'
config.font = wezterm.font 'CaskaydiaCove NF'
config.max_fps = 120
config.font_size = 16

config.show_tab_index_in_tab_bar = true
config.tab_and_split_indices_are_zero_based = false
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
    active_titlebar_bg = '#000a1f',
    inactive_titlebar_bg = '#000a1f',
}

config.colors = {
    tab_bar = {
      background = '#000a1f',
      inactive_tab_edge = '#000a1f',
      active_tab = {
        bg_color = '#000a1f',
        fg_color = '#fff',
      },
  
      inactive_tab = {
        bg_color = '#000a1f',
        fg_color = '#fff',
      },
    },
  }

-- and finally, return the configuration to wezterm
return config
