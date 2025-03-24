-- ln -s /Users/peter/Documents/Local/git/.dotfiles/wezterm/wezterm.lua /Users/peter/.wezterm.lua

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.keys = {
	{
		key = "f",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "N", mods = "CTRL" }),
	},
}

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("CaskaydiaCove NF")
config.max_fps = 120
config.font_size = 16

config.show_tab_index_in_tab_bar = true
config.tab_and_split_indices_are_zero_based = false
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_padding = {
	left = 35,
	right = 35,
	top = 20,
	bottom = 8,
}
config.window_frame = {
	active_titlebar_bg = "#24283c",
	inactive_titlebar_bg = "#24283c",
}

config.colors = {
	tab_bar = {
		background = "#24283c",
		inactive_tab_edge = "#24283c",
		active_tab = {
			bg_color = "#24283c",
			fg_color = "#fff",
		},

		inactive_tab = {
			bg_color = "#24283c",
			fg_color = "#fff",
		},
	},
}

config.default_prog = { "/opt/homebrew/bin/tmux" }

-- and finally, return the configuration to wezterm
return config
