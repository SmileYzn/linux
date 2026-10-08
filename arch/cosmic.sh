#!/bin/bash

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

# Atualizar sistema
sudo pacman -Syu --needed --noconfirm

# Pacotes Base
sudo pacman -S --needed --noconfirm \
7zip \
alsa-firmware \
base-devel \
bash-completion \
bluez \
fastfetch \
fwupd \
ffmpeg \
ffmpegthumbnailer \
git \
power-profiles-daemon \
powertop \
reflector \
udisks2 \
unace \
unzip \
unrar \
xz \
zip

# Pacotes XDG Desktop e User Dirs
sudo pacman -S --needed --noconfirm \
xdg-user-dirs \
xdg-user-dirs-gtk \
xdg-desktop-portal \
xdg-desktop-portal-cosmic \
xdg-utils

# CIFS, EXFAT, GVFS
sudo pacman -S --needed --noconfirm \
cifs-utils \
exfat-utils \
gvfs \
gvfs-dnssd \
gvfs-goa \
gvfs-mtp \
gvfs-nfs \
gvfs-smb \
gvfs-wsdd

# Fontes adicionais
sudo pacman -S --needed --noconfirm \
adobe-source-code-pro-fonts \
adobe-source-sans-fonts \
adobe-source-serif-fonts \
noto-fonts \
noto-fonts-cjk \
noto-fonts-emoji \
noto-fonts-extra \
ttf-bitstream-vera \
ttf-dejavu \
ttf-droid \
ttf-fira-code \
ttf-fira-mono \
ttf-fira-sans \
ttf-liberation \
ttf-opensans \
ttf-roboto \
ttf-roboto-mono \
ttf-ubuntu-font-family

# Firefox
sudo pacman -S --needed --noconfirm \
firefox \
firefox-i18n-pt-br

# GStreamer
sudo pacman -S --needed --noconfirm \
gstreamer \
gst-libav \
gst-plugins-base \
gst-plugins-good \
gst-plugins-bad \
gst-plugins-ugly

# COSMIC

# Atualizar o chace de fontes
sudo fc-cache -f -v

# Serviços
sudo systemctl enable bluetooth

# YAY (Arch User Repository)
git clone https://aur.archlinux.org/yay-bin.git "$HOME/yay-bin"
makepkg -si --needed --noconfirm -D "$HOME/yay-bin"
rm -rf "$HOME/yay-bin"

# Limpar pacotes
sudo pacman -R --noconfirm htop vim vim-runtime 2>/dev/null || true

# Limpar dependências órfãs
orphans=$(pacman -Qdtq 2>/dev/null || true)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rcs --noconfirm $orphans
fi

# Adicionar grupo autologin
if ! getent group autologin >/dev/null; then
    sudo groupadd -r autologin
fi

# Adicionar ao grupo autologin
sudo gpasswd autologin -a "$USER"

# Criar Pastas em pt-BR
mkdir -p Desktop Documentos Downloads Imagens Modelos Músicas Projetos Rede Vídeos

# Atualizar XDG
xdg-user-dirs-update --force --set DESKTOP "$HOME/Desktop"
xdg-user-dirs-update --force --set DOCUMENTS "$HOME/Documentos"
xdg-user-dirs-update --force --set DOWNLOAD "$HOME/Downloads"
xdg-user-dirs-update --force --set PICTURES "$HOME/Imagens"
xdg-user-dirs-update --force --set TEMPLATES "$HOME/Modelos"
xdg-user-dirs-update --force --set MUSIC "$HOME/Músicas"
xdg-user-dirs-update --force --set PROJECTS "$HOME/Projetos"
xdg-user-dirs-update --force --set PUBLICSHARE "$HOME/Rede"
xdg-user-dirs-update --force --set VIDEOS "$HOME/Vídeos"

# Limpar histórico
history -c && > ~/.bash_history

# Fim
exit 0
