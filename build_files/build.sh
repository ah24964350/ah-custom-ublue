#!/bin/bash

set -ouex pipefail

### Install packages
dnf5 install -y adw-gtk3-theme cmatrix fastfetch geany gtkhash-thunar qt5-qtwayland qt5ct qt6-qtwayland qt6-qtwayland-adwaita-decoration qt6ct sway-config-fedora Thunar-docs thunar-media-tags-plugin thunar-vcs-plugin thunar-volman vlc

dnf5 install -y --setopt=install_weak_deps=0 @swaywm-extended @virtualization

# Wezterm nightly
dnf5 -y copr enable wezfurlong/wezterm-nightly
dnf5 install -y wezterm

### === LY DISPLAY MANAGER (built from source) ===
# Build dependencies (official + missing ones for Zig translate-c on Fedora 44)
dnf5 install -y --setopt=install_weak_deps=0 zig pam-devel libxcb-devel kernel-devel glibc-devel

# Runtime dependencies needed by ly (fixed for Fedora 44)
dnf5 install -y --setopt=install_weak_deps=0 xorg-x11-xauth xorg-x11-server-Xorg brightnessctl

# Clone → build → install ly
git clone --depth 1 https://codeberg.org/fairyglade/ly.git /tmp/ly
cd /tmp/ly

# Zig cache fix (uses the already-cached /var/cache from your Containerfile)
mkdir -p /var/cache/zig
export ZIG_GLOBAL_CACHE_DIR=/var/cache/zig

# Build and install
zig build installexe -Dinit_system=systemd

cd /
rm -rf /tmp/ly

# Make ly the default on tty2
systemctl disable gdm.service sddm.service lightdm.service || true
systemctl disable getty@tty2.service || true
systemctl enable ly@tty2.service

# Disable COPR so it doesn't stay enabled in the final image
dnf5 -y copr disable wezfurlong/wezterm-nightly

### Final cleanup
dnf5 clean all
rm -rf /var/cache/* /tmp/* /var/tmp/*
