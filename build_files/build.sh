#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y adw-gtk3-theme cmatrix fastfetch geany gtkhash-thunar qt5-qtwayland qt5ct qt6-qtwayland qt6-qtwayland-adwaita-decoration qt6ct sway-config-fedora Thunar-docs thunar-media-tags-plugin thunar-vcs-plugin thunar-volman vlc 

#install groups
dnf5 install -y --setopt=install_weak_deps=0 @swaywm-extended @virtualization

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
dnf5 -y copr enable wezfurlong/wezterm-nightly
dnf5 install -y wezterm

#### Example for enabling a System Unit File

systemctl enable podman.socket
