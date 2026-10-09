#!/bin/bash


#################################################
# Alpine Linux (Pós Instalação) para XFCE
#################################################

# Erros
set -e

# Trap
trap 'echo; echo "ERRO: falha na linha $LINENO"; echo "Comando: $BASH_COMMAND"; exit 1' ERR

# Limpar
clear

# Verificar acesso root
if [[ $EUID -eq 0 ]]; then
    echo "Esse script NÃO deve ser executado como root"
    exit 1
fi

# Abrir pasta do usuário
cd "$HOME" || exit 1

# Instalar SUDO, habilitar grupo wheel e adicionar usuário ao grupo wheel
su root -c "apk update && apk add --no-cache sudo && echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel && addgroup $(whoami) wheel"

# Atualizar sistema
sudo apk update

# Base
sudo apk add --no-cache \
7zip \
bash-completion \
bluez \
bluez-openrc \
blueman \
blueman-lang \
coreutils \
fastfetch \
fwupd \
ffmpeg \
ffmpegthumbnailer \
git \
gtk-update-icon-cache \
musl-locales \
musl-locales-lang \
nano \
networkmanager \
networkmanager-lang \
networkmanager-wifi \
network-manager-applet \
network-manager-applet-lang \
pipewire \
pipewire-pulse \
power-profiles-daemon \
powertop \
shadow \
udisks2 \
unzip \
util-linux \
wireplumber \
xz \
zip

# Network Manager
sudo rc-update add networkmanager default

# Bluetooth
sudo rc-update add bluetooth default

# Language for MUSL
echo 'export LANG=pt_BR.UTF-8' | sudo tee /etc/profile.d/locale.sh
echo 'export LC_ALL=pt_BR.UTF-8' | sudo tee -a /etc/profile.d/locale.sh

# XDG Portal
sudo apk add --no-cache xdg-user-dirs xdg-user-dirs-gtk xdg-desktop-portal xdg-desktop-portal-gtk xdg-utils

# CIFS, EXFAT, GVFS, NTFS
sudo apk add --no-cache cifs-utils exfat-utils gvfs gvfs-afc gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb ntfs-3g

# Fontes
sudo apk add --no-cache \
adwaita-fonts \
adwaita-fonts-mono \
adwaita-fonts-sans \
font-adobe-source-code-pro \
font-dejavu \
font-droid \
font-fira \
font-inconsolata \
font-noto \
font-noto-cjk \
font-noto-emoji \
font-noto-extra \
font-opensans \
font-roboto \
font-terminus

# Atualizar o chace de fontes
sudo fc-cache -f -v

# XFCE4
sudo apk add --no-cache \
xfce4-appfinder \
xfce4-appfinder-lang \
xfce4-notifyd \
xfce4-notifyd-lang \
xfce-polkit \
xfce4-screensaver \
xfce4-screensaver-lang \
xfce4-screenshooter \
xfce4-screenshooter-lang \
xfce4-taskmanager \
xfce4-taskmanager-lang \
xfce4-terminal \
xfce4-terminal-lang

# XFCE4 Plugins
sudo apk add --no-cache $(apk search -q "xfce4-*-plugin")
sudo apk add --no-cache $(apk search -q "xfce4-*-plugin-lang")

# Thunar
sudo apk add --no-cache \
thunar \
thunar-lang \
thunar-archive-plugin \
thunar-archive-plugin-lang \
thunar-media-tags-plugin \
thunar-media-tags-plugin-lang

# Adwaita
sudo apk add --no-cache adwaita-icon-theme adwaita-xfce-icon-theme papirus-icon-theme

# Apps
sudo apk add --no-cache \
galculator \
galculator-lang \
gcolor3 \
gcolor3-lang \
gthumb \
gthumb-lang \
mousepad \
mousepad-lang \
mugshot \
mugshot-lang \
parole \
parole-lang \
pavucontrol \
pavucontrol-lang \
peek \
peek-lang \
seahorse \
seahorse-lang \
xarchiver \
xarchiver-lang \
xfburn \
xfburn-lang

# Firefox
sudo apk add --no-cache firefox firefox-intl

# GStreamer
sudo apk add --no-cache gstreamer gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly

# Criar pastas padrão
xdg-user-dirs-update

# Criar Pastas em pt-BR
mkdir -p Desktop Documentos Downloads Imagens Modelos Músicas Projetos Rede Vídeos

# Alterar pastas
xdg-user-dirs-update --force --set DESKTOP "$HOME/Desktop"
xdg-user-dirs-update --force --set DOCUMENTS "$HOME/Documentos"
xdg-user-dirs-update --force --set DOWNLOAD "$HOME/Downloads"
xdg-user-dirs-update --force --set PICTURES "$HOME/Imagens"
xdg-user-dirs-update --force --set TEMPLATES "$HOME/Modelos"
xdg-user-dirs-update --force --set MUSIC "$HOME/Músicas"
xdg-user-dirs-update --force --set PROJECTS "$HOME/Projetos"
xdg-user-dirs-update --force --set PUBLICSHARE "$HOME/Rede"
xdg-user-dirs-update --force --set VIDEOS "$HOME/Vídeos"

# Remover pastas antigas
sudo rm -rf Documents Music Pictures Projects Public Templates Videos

# Grupos do usuário
sudo addgroup autologin

# Adicionar aos grupos
sudo adduser $(whoami) autologin
sudo adduser $(whoami) plugdev
