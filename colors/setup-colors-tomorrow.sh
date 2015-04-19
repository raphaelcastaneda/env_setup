#!/usr/bin/env sh

PALETTE=""

# Blacks
PALETTE="$PALETTE:#000000000000"
PALETTE="$PALETTE:#919122222626"

# Red
PALETTE="$PALETTE:#777789890000"
PALETTE="$PALETTE:#AEAE7B7B0000"

# Green
PALETTE="$PALETTE:#1D1D25259494"
PALETTE="$PALETTE:#68682a2a9b9b"

# Yellow
PALETTE="$PALETTE:#2B2B66665151"
PALETTE="$PALETTE:#929295959393"

# Blue
PALETTE="$PALETTE:#666666666666"
PALETTE="$PALETTE:#CCCC66666666"

# Magenta
PALETTE="$PALETTE:#B5B5BDBD6868"
PALETTE="$PALETTE:#F0F0C6C67474"

# Cyan
PALETTE="$PALETTE:#8181A2A2BEBE"
PALETTE="$PALETTE:#B2B29494BBBB"

# White
PALETTE="$PALETTE:#8A8ABEBEB7B7"
PALETTE="$PALETTE:#ECECEBEBECEC"

gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/palette $PALETTE
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/background_color "#1d1d1f1f2121"
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/foreground_color "#c5c5c8c8c6c6"
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/bold_color "#8A8ABEBEB7B7"
gconftool-2 -s -t bool /apps/gnome-terminal/profiles/Default/bold_color_same_as_fg "false"
gconftool-2 -s -t bool /apps/gnome-terminal/profiles/Default/use_theme_colors "false"
gconftool-2 -s -t bool /apps/gnome-terminal/profiles/Default/use_theme_background "false"

unset PALETTE