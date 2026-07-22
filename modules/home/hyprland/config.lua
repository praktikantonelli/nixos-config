-- main modifier key
local mod = "ALT"

-- settings.bind
hl.bind(mod .. " + D", hl.dsp.exec_cmd("fuzzel"), { description = "Open fuzzel as application launcher" })
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"), { description = "Open kitty terminal" })
hl.bind(mod .. " + Q", hl.dsp.window.close({}), { description = "Close active window" })
hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }), { description = "Focus workspace 1" })
hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }), { description = "Focus workspace 2" })
hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }), { description = "Focus workspace 3" })
hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }), { description = "Focus workspace 4" })
hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }), { description = "Focus workspace 5" })
hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }), { description = "Focus workspace 6" })
hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }), { description = "Focus workspace 7" })
hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }), { description = "Focus workspace 8" })
hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }), { description = "Focus workspace 9" })
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }), { description = "Focus workspace 10" })

hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }), { description = "Move window to workspace 1" })
hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }), { description = "Move window to workspace 2" })
hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }), { description = "Move window to workspace 3" })
hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }), { description = "Move window to workspace 4" })
hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }), { description = "Move window to workspace 5" })
hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }), { description = "Move window to workspace 6" })
hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }), { description = "Move window to workspace 7" })
hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }), { description = "Move window to workspace 8" })
hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }), { description = "Move window to workspace 9" })
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }), { description = "Move window to workspace 10" })

hl.bind(mod .. " + F", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen for current window" })
hl.bind(mod .. " + SPACE", hl.dsp.window.float(), { description = "Toggle float for current window" })

hl.bind(
	mod .. " + SHIFT + Escape",
	hl.dsp.exec_cmd("shutdown-script"),
	{ description = "Launch fuzzel shutdown script" }
)
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("swaylock"), { description = "Lock screen with swaylock" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nemo"), { description = "Launch nemo file explorer" })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { description = "Mute audio" })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pamixer -i 2"),
	{ repeating = true, description = "Increase volume by 2%" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pamixer -d 2"),
	{ repeating = true, description = "Decrease volume by 2%" }
)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggle play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { repeating = true, description = "Skip to next audio" })
hl.bind(
	"XF86AudioPrev",
	hl.dsp.exec_cmd("playerctl previous"),
	{ repeating = true, description = "Skip to previous audio" }
)
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { description = "Stop audio playback" })

hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl set 5%+"),
	{ repeating = true, description = "Increase brightness by 5%" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl set 5%-"),
	{ repeating = true, description = "Decrease brightness by 5%" }
)

hl.bind(
	mod .. " + V",
	hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"),
	{ description = "Launch fuzzel clipboard history" }
)

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, drag = true, description = "Drag window" })

-- make Bitwarden browser extension float
hl.on("window.title", function(w)
	if w ~= nil and w.title == "Extension: (Bitwarden Password Manager) - Bitwarden — Zen Browser" then
		-- make the window float
		hl.dispatch(hl.dsp.window.float({ action = "set" }))
		-- center it
		hl.dispatch(hl.dsp.window.center())
		-- make it smaller
		hl.dispatch(hl.dsp.window.resize({ x = 500, y = 600 }))
	end
end)

-- settings.config
hl.config({
	["decoration"] = {
		["blur"] = {
			["contrast"] = 1.4,
			["noise"] = 0,
			["size"] = 1,
			["xray"] = true,
		},
	},
	["dwindle"] = {
		["preserve_split"] = true,
	},
	["general"] = {
		["border_size"] = 2,
		["col.active_border"] = {
			colors = {
				"rgb(fe8019)",
				"rgb(458588)",
			},
			angle = 45,
		},
		["col.inactive_border"] = "0x00000000",
		["gaps_in"] = 0,
		["gaps_out"] = 0,
	},
	["input"] = {
		["follow_mouse"] = 1,
		["kb_layout"] = "ch",
		["kb_options"] = "grp:alt_caps_toggle",
		["numlock_by_default"] = true,
		["touchpad"] = {
			["natural_scroll"] = true,
		},
	},
	["misc"] = {
		["disable_hyprland_logo"] = true,
		["enable_swallow"] = true,
	},
	["binds"] = {
		["drag_threshold"] = 10,
	},
})

-- settings.on
hl.on("hyprland.start", function()
	hl.exec_cmd("swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f)")
	hl.exec_cmd("hyprctl setcursor Nordzy-hyprcursors 22")
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)
