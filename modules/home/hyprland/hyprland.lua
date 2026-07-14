-- main modifier key
local mod = "ALT"

-- settings.bind
hl.bind((mod .. " + D"), (hl.dsp.exec_cmd("fuzzel")))
hl.bind((mod .. " + Return"), (hl.dsp.exec_cmd("kitty")))
hl.bind((mod .. " + Q"), (hl.dsp.window.close({})))
hl.bind((mod .. " + 1"), (hl.dsp.focus({ workspace = 1 })))
hl.bind((mod .. " + 2"), (hl.dsp.focus({ workspace = 2 })))
hl.bind((mod .. " + 3"), (hl.dsp.focus({ workspace = 3 })))
hl.bind((mod .. " + 4"), (hl.dsp.focus({ workspace = 4 })))
hl.bind((mod .. " + 5"), (hl.dsp.focus({ workspace = 5 })))
hl.bind((mod .. " + 6"), (hl.dsp.focus({ workspace = 6 })))
hl.bind((mod .. " + 7"), (hl.dsp.focus({ workspace = 7 })))
hl.bind((mod .. " + 8"), (hl.dsp.focus({ workspace = 8 })))
hl.bind((mod .. " + 9"), (hl.dsp.focus({ workspace = 9 })))
hl.bind((mod .. " + 0"), (hl.dsp.focus({ workspace = 10 })))

hl.bind((mod .. " + SHIFT + 1"), (hl.dsp.window.move({ workspace = 1 })))
hl.bind((mod .. " + SHIFT + 2"), (hl.dsp.window.move({ workspace = 2 })))
hl.bind((mod .. " + SHIFT + 3"), (hl.dsp.window.move({ workspace = 3 })))
hl.bind((mod .. " + SHIFT + 4"), (hl.dsp.window.move({ workspace = 4 })))
hl.bind((mod .. " + SHIFT + 5"), (hl.dsp.window.move({ workspace = 5 })))
hl.bind((mod .. " + SHIFT + 6"), (hl.dsp.window.move({ workspace = 6 })))
hl.bind((mod .. " + SHIFT + 7"), (hl.dsp.window.move({ workspace = 7 })))
hl.bind((mod .. " + SHIFT + 8"), (hl.dsp.window.move({ workspace = 8 })))
hl.bind((mod .. " + SHIFT + 9"), (hl.dsp.window.move({ workspace = 9 })))
hl.bind((mod .. " + SHIFT + 0"), (hl.dsp.window.move({ workspace = 10 })))

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
				45,
			},
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
})

-- settings.misc
hl.misc({
	["disable_autoreload"] = true,
	["disable_hyprland_logo"] = true,
	["enable_swallog"] = true,
	["focus_on_activate"] = true,
})

-- settings.on
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user import-environment")
	hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("wl-clip-persist --clipboard both")
	hl.exec_cmd("swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f)")
	hl.exec_cmd("hyprctl setcursor Nordzy-cursors 22")
	hl.exec_cmd("hyprctl dispatch workspace 1")
	hl.exec_cmd("poweralertd")
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("owncloud")
end)

-- startup
hl.on("hyprland.start", function()
	hl.exec_cmd(
		"/nix/store/165rncxlyi4f9pjf1zk3hmj3mh2v881w-dbus-1.16.2/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
	)
end)
