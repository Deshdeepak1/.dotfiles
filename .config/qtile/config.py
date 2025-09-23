# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import random
from datetime import datetime

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import colors

random.seed(datetime.now().timestamp())

mod = "mod4"
alt = "mod1"
calc_key = "XF86Calculator"
onem_key = "XF86Launch2"

volume_mute_key = "XF86AudioMute"
volume_raise_key = "XF86AudioRaiseVolume"
volume_lower_key = "XF86AudioLowerVolume"

brightness_inc_key = "XF86MonBrightnessUp"
brightness_dec_key = "XF86MonBrightnessDown"

# Colors

colors_dict = colors.catppuccin
# a = [1, 2, 3, 4, 5, 6, 7, 8, 9] + [1, 2, 3, 4, 5, 6, 7, 8, 9] + [1, 2, 3, 4, 5, 6, 7, 8, 9] + [1, 2, 3, 4, 5, 6, 7, 8, 9] + [1, 2, 3, 4, 5, 6, 7, 8, 9]


terminal = os.environ.get("TERMINAL") or guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    # Key(
    #     [mod, "shift"],
    #     "Return",
    #     lazy.layout.toggle_split(),
    #     desc="Toggle between split and unsplit sides of stack",
    # ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "space", lazy.next_layout(), desc="Next layout"),
    Key([mod, "shift"], "space", lazy.prev_layout(), desc="Prev layout"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maximize"),
    Key([mod, "shift"], "m", lazy.window.toggle_minimize(), desc="Toggle minimize"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Switch focus of monitors
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    # My programs
    Key([mod, "shift"], "Return", lazy.spawn(f"{terminal} -e tmux"), desc="Open tmux"),
    ## Launchers
    KeyChord(
        [mod],
        "r",
        [
            Key([], "r", lazy.spawn("rofi -theme dmenu -show run -show-icons -display-run 'Run: '"), desc="Command Menu"),
            Key([], "p", lazy.spawn("rofi -show drun -show-icons -display-drun 'Launch' "), desc="Application Menu"),
            Key([], "w", lazy.spawn("rofi show-icons -show window"), desc="Window Menu"),
            Key([], "s", lazy.spawn("rofi -show ssh"), desc="SSH Menu"),
            Key([], "e", lazy.spawn("rofi -show filebrowser -show-icons"), desc="File Menu"),
            Key([], "l", lazy.spawn("rofi -modi power_menu:rofi-power-menu -show power_menu"), desc="Power Menu"),
            Key([], "c", lazy.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"), desc="Clip Menu"),
            Key([], "b", lazy.spawn("rofi-bluetooth"), desc="Bluetooth Menu"),
        ],
        name="rofi",
        desc="Rofi Menus",
    ),
    KeyChord(
        [mod],
        "p",
        [
            Key([], "m", lazy.spawn("fish -c 'cp -r /home/deshdeepak/temp/1/main.py (xclip -selection clipboard -o)'"), desc=""),
            Key([], "g", lazy.spawn("fish -c 'cp -r /home/deshdeepak/temp/1/getntp.py (xclip -selection clipboard -o)'"), desc=""),
            Key([], "a", lazy.spawn("fish -c 'cp -r /home/deshdeepak/temp/1/* (xclip -selection clipboard -o)'"), desc=""),
        ],
    ),
    KeyChord(
        [mod],
        "s",
        [
            Key([], "l", lazy.spawn("flameshot gui"), desc=""),
        ],
    ),
    Key([], calc_key, lazy.spawn("rofi -show calc -modi calc -no-show-match -no-sort"), desc="Calculator"),
    Key([], volume_mute_key, lazy.spawn("volume mute"), desc="Volume Mute"),
    Key([], volume_raise_key, lazy.spawn("volume up"), desc="Volume Raise"),
    Key([], volume_lower_key, lazy.spawn("volume down"), desc="Volume Lower"),
    Key([], brightness_inc_key, lazy.spawn("brightness up"), desc="Brightness Increase"),
    Key([], brightness_dec_key, lazy.spawn("brightness down"), desc="Brightness Decrease"),
    Key([mod, alt], "e", lazy.spawn("rofimoji"), desc="Emoji Menu"),
    Key([mod, "shift"], "w", lazy.spawn("networkmanager_dmenu"), desc="Wifi Menu"),
    Key([mod, "control"], "b", lazy.spawn("battery-notify"), desc="Battery"),
    Key([mod, "control"], "p", lazy.spawn("pnr"), desc="PNR"),
    ## Applications
    Key([mod], "b", lazy.spawn("brave"), desc="Brave"),
    Key([mod, "shift"], "b", lazy.spawn("brave --incognito"), desc="Launch brave(incognito)"),
    # KeyChord(
    #     [mod],
    #     "p",
    #     [
    #         Key([], "b", lazy.group["btop"].dropdown_toggle("btop")),
    #     ],
    #     name="scratchpad",
    #     desc="Programs ScratchPads",
    # ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

labels = ["", "🌐", "", "📁", "", "⚙️", "💬", "📃", "🔏"]
# labels = list("123456789")
groups_matches = {
    # 2: [Match(wm_class="brave-browser")],
    5: [Match(wm_class="TelegramDesktop")],
    6: [Match(wm_class="mongodb compass")],
}


groups = [Group(name=str(i), label=label, matches=groups_matches.get(i)) for i, label in enumerate(labels, start=1)]

# groups.extend([ScratchPad("btop", [DropDown("btop", "alacritty -e lf")])])
for g in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key([mod], g.name, lazy.group[g.name].toscreen(), desc=f"Switch to group {g.name}"),
            # mod + shift + group number = switch to & move focused window to group
            Key([mod, alt], g.name, lazy.window.togroup(g.name, switch_group=True), desc=f"Switch to & move focused window to group {g.name}"),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            Key([mod, "shift"], g.name, lazy.window.togroup(g.name), desc=f"move focused window to group {g.name}"),
        ]
    )


# Extra
def show_keys(keys: list[Key | KeyChord], key_line_prefix: str = ""):
    """
    print current keybindings in a pretty way for a rofi/dmenu window.
    """
    key_help = ""
    keys_ignored = (
        "XF86AudioMute",  #
        "XF86AudioLowerVolume",  #
        "XF86AudioRaiseVolume",  #
        "XF86AudioPlay",  #
        "XF86AudioNext",  #
        "XF86AudioPrev",  #
        "XF86AudioStop",
    )
    text_replaced = {
        "mod4": "[S]",  #
        "control": "[Ctl]",  #
        "mod1": "[Alt]",  #
        "shift": "[Shf]",  #
        "twosuperior": "²",  #
        "less": "<",  #
        "ampersand": "&",  #
        "Escape": "Esc",  #
        "Return": "Enter",  #
    }
    for k in keys:
        if k.key in keys_ignored:
            continue

        mods = ""
        key = ""
        desc = k.desc.title()
        for m in k.modifiers:
            if m in text_replaced.keys():
                mods += text_replaced[m] + " + "
            else:
                mods += m.capitalize() + " + "

        if len(k.key) > 1:
            if k.key in text_replaced.keys():
                key = text_replaced[k.key]
            else:
                key = k.key.title()
        else:
            key = k.key

        key_combo = mods + key

        key_line = "{:<30} {}".format(key_combo, desc + "\n")
        if isinstance(k, KeyChord):
            sub_key_help = show_keys(k.submappings, key_combo)
            key_help += sub_key_help
        key_help += key_line_prefix + key_line

        # debug_print(key_line)  # debug only

    return key_help


keys.extend(
    [
        Key(
            [mod],
            "F1",
            lazy.spawn("sh -c 'echo \"" + show_keys(keys) + '" | rofi -dmenu -i -mesg "Keyboard shortcuts"\''),
            desc="Print keyboard bindings",
        ),
    ]
)


def check_battery():
    qtile.cmd_spawn("battery-notify -o")
    qtile.call_later(120, check_battery)


def study_reminder():
    qtile.cmd_spawn("dunstify 'Go Study' 'Stop waisting time.'")
    qtile.call_later(1500, study_reminder)


@hook.subscribe.startup_once
def autostart():
    # home = os.path.expanduser("~/.config/qtile/autostart.sh")
    # subprocess.Popen([home])
    # notify_send("hi")
    check_battery()


layout_defaults = {
    "border_width": 2,
    "margin": 8,
    # "border_focus": "#F07178",
    "border_focus": colors_dict["red"],
    # "border_normal": "#3ca4d8",
    "border_normal": colors_dict["blue"],
}


layouts = [
    layout.MonadTall(
        **layout_defaults,
    ),
    layout.Max(**layout_defaults),
    layout.Columns(
        **layout_defaults,
    ),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


widget_defaults = dict(
    font="Mononoki Nerd Font Mono",
    fontsize=12,
    padding=2,
    # foreground=colors["black"],
    # background="#000000",
)
extension_defaults = widget_defaults.copy()

wallpapers = tuple(set(os.listdir(os.path.expanduser("~/wallpapers/"))) - {".git", "README.md"})


def choose_wallpaper():
    wallpaper = f"~/wallpapers/{random.choice(wallpapers)}"
    return wallpaper


arch_logo = widget.Image(
    filename="~/.config/qtile/arch.png",
    mouse_callbacks={"Button1": lazy.spawn("rofi -modi drun -show drun -show-icons -display-drun 'Launch' ")},
)
qtile_logo = widget.Image(filename="~/.config/qtile/logo.png")
chord = widget.Chord(
    chords_colors={
        "launch": ("#ff0000", "#ffffff"),
    },
    name_transform=lambda name: name.upper(),
)
memory_usage = widget.Memory()
clock = widget.Clock(format="%a %d %b, %H:%M")


screens = [
    Screen(
        wallpaper=choose_wallpaper(),
        wallpaper_mode="stretch",
        top=bar.Bar(
            [
                arch_logo,
                widget.GroupBox(disable_drag=True),
                widget.WindowName(),
                chord,
                widget.Systray(),
                memory_usage,
                clock,
                widget.CurrentLayout(mode="icon"),
                qtile_logo,
            ],
            24,
            background="#00000090",
            margin=[2, 20, 2, 20],
        ),
    ),
    Screen(
        wallpaper=choose_wallpaper(),
        wallpaper_mode="stretch",
        top=bar.Bar(
            [
                arch_logo,
                widget.GroupBox(disable_drag=True),
                widget.WindowName(),
                chord,
                memory_usage,
                clock,
                widget.CurrentLayout(),
                qtile_logo,
            ],
            24,
            background="#00000090",
            margin=[2, 20, 2, 20],
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="opengl"),  # opengl
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
# subprocess.getstatusoutput("feh --bg-fill ~/wallpapers --randomize")
