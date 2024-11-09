local wezterm = require 'wezterm';

local config = wezterm.config_builder();

config.color_scheme = "catppuccin-macchiato";

config.font = wezterm.font "Iosevka Nerd Font";
config.font_size = 16;

config.enable_tab_bar = false;
config.window_decorations = "RESIZE";

config.initial_rows = 100;
config.initial_cols = 600;

return config;
