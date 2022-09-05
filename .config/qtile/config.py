import os
import re
import subprocess

from libqtile import bar, extension, hook, layout, widget
from libqtile.config import Click, Drag, DropDown, EzKey, Group, Key, KeyChord, Match, Rule, Screen, ScratchPad
from libqtile.lazy import lazy
from Xlib.ext.randr import ScreenChangeNotify

from pprint import pprint

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/autostart.sh")
    subprocess.Popen([home])

@hook.subscribe.screen_change
def screen_change(event: ScreenChangeNotify):
    pprint(event)

mod = "mod4"
terminal = "kitty"

meh = ["mod1", "control", "shift"]
hyper = ["mod1", "mod4", "control", "shift"]

keys = [
    EzKey("M-h", lazy.layout.left(), desc="Move focus to left"),
    EzKey("M-l", lazy.layout.right(), desc="Move focus to right"),
    EzKey("M-j", lazy.layout.down(), desc="Move focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Move focus up"),
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),

    EzKey("M-e", lazy.next_layout(), desc="Toggle layout"),
    EzKey("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),
    EzKey("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    EzKey("M-w", lazy.window.kill(), desc="Kill focused window"),
    EzKey("M-<Tab>", lazy.group.next_window(), desc="Focus next window"),
    EzKey("M-S-<Tab>", lazy.group.prev_window(), desc="Focus previous window"),
    EzKey("M-S-<space>", lazy.window.toggle_floating(), desc="Toggle floating"),

    EzKey("M-<Return>", lazy.spawn(f"{terminal} -e fish"), desc="Launch terminal"),
    EzKey("M-<space>", lazy.spawn("rofi -show combi"), desc="Spawn rofi"),

    EzKey("<XF86AudioRaiseVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    EzKey("<XF86AudioLowerVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    EzKey("<XF86AudioMute>", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    EzKey("<XF86AudioMicMute>", lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle")),

    EzKey("<XF86AudioPrev>", lazy.spawn("playerctl -p $(playerctl -l | rofi -dmenu -auto-select) previous")),
    EzKey("<XF86AudioNext>", lazy.spawn("playerctl -p $(playerctl -l | rofi -dmenu -auto-select) next")),
    EzKey("<XF86AudioPlay>", lazy.spawn("playerctl -p $(playerctl -l | rofi -dmenu -auto-select) play-pause")),
    EzKey("<XF86AudioStop>", lazy.spawn("playerctl -a stop")),

    EzKey("S-<XF86AudioPrev>", lazy.spawn("playerctl -a previous")),
    EzKey("S-<XF86AudioNext>", lazy.spawn("playerctl -a next")),
    EzKey("S-<XF86AudioPlay>", lazy.spawn("playerctl -a play-pause")),

    EzKey("M-C-<Left>", lazy.spawn("playerctl -a previous")),
    EzKey("M-C-<Right>", lazy.spawn("playerctl -a next")),
    EzKey("M-C-<Down>", lazy.spawn("playerctl -a play-pause")),
    EzKey("M-C-<Up>", lazy.spawn("playerctl -a stop")),

    EzKey("<Print>", lazy.spawn("flameshot gui")),

    EzKey("A-C-S-0", lazy.spawn("zsh ~/Projects/kill-projects.sh")),
    EzKey("A-C-S-s", lazy.spawn("xfce4-settings-manager")),
    EzKey("A-C-S-a", lazy.spawn("arandr")),
    EzKey("A-C-S-v", lazy.spawn("pavucontrol")),
    EzKey("A-C-S-c", lazy.spawn("qalculate-gtk")),
    EzKey("A-C-S-m", lazy.spawn("cat ~/music-commands | rofi -dmenu | nohup bash > /dev/null & disown")),
    EzKey("A-C-S-t", lazy.spawn("cat ~/tenor-commands | rofi -i -dmenu | cut -d'|' -f2 | sed 's/^ //' | xargs -r | xclip -sel clip")),
    EzKey("A-C-S-g", lazy.spawn(f"{terminal} -e nvim ~/.config/i3/config")),
    EzKey("A-C-S-<period>", lazy.spawn("rofimoji -s neutral")),
    EzKey("A-C-S-q", lazy.spawn("xkill")),
    EzKey("A-C-S-<Tab>", lazy.spawn("chorder")),

    EzKey("M-A-C-S-l", lazy.spawn("fish -c 'i3lock -c 000000 -t -i ~/Obrazy/fancy_pants.jpg'")),
    EzKey("M-A-C-S-c", lazy.reload_config(), desc="Reload the config"),
    EzKey("M-A-C-S-r", lazy.restart(), desc="Restart Qtile"),
    EzKey("M-A-C-S-q", lazy.shutdown(), desc="Shutdown Qtile"),

    EzKey("A-<F2>", lazy.spawncmd()),
    EzKey(
        "M-m",
        lazy.run_extension(
            extension.CommandSet(
                dmenu_command='rofi -dmenu',
                commands={
                    'test': 'firefox-developer-edition',
                    'hello': 'echo hello world',
                },
            ),
        ),
    ),

    EzKey(
        "<F10>",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Toggle scratchpad terminal",
    ),

    KeyChord(
        [mod], "r",
        [
            EzKey("h", lazy.layout.grow_left(), desc="Grow window to the left"),
            EzKey("l", lazy.layout.grow_right(), desc="Grow window to the right"),
            EzKey("j", lazy.layout.grow_down(), desc="Grow window down"),
            EzKey("k", lazy.layout.grow_up(), desc="Grow window up"),
        ],
        mode="Resize",
    ),
]

groups = [
    Group("1", screen_affinity=2),
    Group("2", screen_affinity=2),
    Group("3", screen_affinity=1),
    Group("4", screen_affinity=1),
    Group("5", screen_affinity=1),
    Group("6", screen_affinity=1),
    Group("7", screen_affinity=1),
    Group("8", screen_affinity=1),
    Group("9", screen_affinity=1),
    Group("F1", screen_affinity=0),
    Group("F2", screen_affinity=0),
    Group("F3", screen_affinity=0),
    Group("F4", screen_affinity=0),
    Group("F5", screen_affinity=0),
    Group("F6", screen_affinity=0),
    Group("F7", screen_affinity=0),
    Group("F8", screen_affinity=0),
    Group("F9", screen_affinity=0),
    Group("F10", screen_affinity=0),
    Group("F11", screen_affinity=0),
    Group("F12", screen_affinity=0),
]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.to_screen(i.screen_affinity),
                lazy.group[i.name].toscreen(toggle=False),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

groups.extend(
    [
        ScratchPad(
            "scratchpad",
            [
                DropDown(
                    "term",
                    "kitty -e fish",
                    x=0.05,
                    y=0.3,
                    width=0.9,
                    height=0.4,
                    opacity=0.9,
                ),
            ],
        ),
    ],
)

layouts = [
    layout.MonadTall(
        border_focus="#80ff00",
        border_width=3,
        ratio=0.6,
    ),
    layout.MonadWide(
        border_focus="#80ff00",
        border_width=3,
        ratio=0.6,
    ),
]

widget_defaults = dict(
    font="monospace",
    fontsize=14,
    padding=4,
)

extension_defaults = widget_defaults.copy()

main_bar_widgets = [
    widget.GroupBox(
        inactive="#000000",
        hide_unused=True,
        highlight_method="block",
        visible_groups=[f"F{i + 1}" for i in range(12)],
    ),
    widget.Spacer(),
    widget.Prompt(),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Spacer(),
    widget.Memory(
        format="mem {MemPercent:5.1f}%",
    ),
    widget.CPU(
        format="cpu {load_percent:5.1f}%",
    ),
    widget.Systray(),
    widget.PulseVolume(
        fmt="vol {}",
        emoji=False,
        step=2,
    ),
    widget.ThermalSensor(
        fmt="tmp {}",
    ),
    widget.Clock(format="%c"),
]

sub_bar_1_widgets = [
    widget.GroupBox(
        inactive="#000000",
        hide_unused=True,
        highlight_method="block",
        visible_groups=[f"{i + 3}" for i in range(7)],
    ),
    widget.Spacer(),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Spacer(),
    widget.Memory(
        format="mem {MemPercent:5.1f}%",
    ),
    widget.CPU(
        format="cpu {load_percent:5.1f}%",
    ),
    widget.PulseVolume(
        fmt="vol {}",
        emoji=False,
        step=2,
    ),
    widget.ThermalSensor(
        fmt="tmp {}",
    ),
    widget.Clock(format="%c"),
]

sub_bar_2_widgets = [
    widget.GroupBox(
        inactive="#000000",
        hide_unused=True,
        highlight_method="block",
        visible_groups=[f"{i + 1}" for i in range(2)],
    ),
    widget.Spacer(),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Spacer(),
    widget.Memory(
        format="mem {MemPercent:5.1f}%",
    ),
    widget.CPU(
        format="cpu {load_percent:5.1f}%",
    ),
    widget.PulseVolume(
        fmt="vol {}",
        emoji=False,
        step=2,
    ),
    widget.ThermalSensor(
        fmt="tmp {}",
    ),
    widget.Clock(format="%c"),
]

screens = [
    Screen(top=bar.Bar(main_bar_widgets, 24, border_width=[0, 0, 3, 0])),
    Screen(top=bar.Bar(sub_bar_1_widgets, 24, border_width=[0, 0, 3, 0])),
    Screen(top=bar.Bar(sub_bar_2_widgets, 24, border_width=[0, 0, 3, 0])),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None

dgroups_app_rules = [
    Rule(
        Match(wm_instance_class="EditorAlacritty"),
        group="1"
    ),
    Rule(
        Match(wm_instance_class="ProjectAlacritty"),
        group="2"
    ),

    Rule(
        Match(wm_class=re.compile("^firefoxdeveloperedition$")),
        group="3"
    ),
    Rule(
        Match(wm_class="Brave-browser"),
        group="4"
    ),
    Rule(
        Match(wm_class=re.compile("^firefox$")),
        group="5"
    ),
    Rule(
        Match(wm_class="Joplin"),
        group="6"
    ),
    Rule(
        Match(wm_class="smplayer"),
        group="9"
    ),

    Rule(
        Match(wm_class="Slack"),
        group="F1"
    ),
    Rule(
        Match(wm_class=re.compile(r"evolution", flags=re.IGNORECASE)),
        group="F2"
    ),
    Rule(
        Match(wm_class=re.compile(r"ferdium", flags=re.IGNORECASE)),
        group="F3"
    ),
    Rule(
        Match(wm_class=re.compile(r"ferdi", flags=re.IGNORECASE)),
        group="F3"
    ),
]

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#0080ff",
    border_width=3,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="pinentry-qt"),
        Match(wm_class="re.sonny.Junction"),
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
