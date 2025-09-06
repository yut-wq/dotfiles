-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- global
config.font = wezterm.font("UDEV Gothic NF")
config.font_size = 14
config.color_scheme = "Material (base16)"
config.use_ime = true
config.window_close_confirmation = "AlwaysPrompt"
config.enable_scroll_bar = true
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"

config.window_background_image = wezterm.home_dir .. "desktop.jpg"

-- 起動時に最大化
wezterm.on('gui-startup', function()
    local _, _, window = wezterm.mux.spawn_window({})
    window:gui_window():maximize()
end)

-- key
config.keys = {
	{
		key = "N",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = ",",
		mods = "CTRL",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- windows用の設定
-- wslの設定
-- プロファイルの有無によって切り替えることはできなさそう。
-- config.default_domain = "WSL:Ubuntu"
config.default_domain = "WSL:Ubuntu-24.04"

-- Finally, return the configuration to wezterm:
return config
