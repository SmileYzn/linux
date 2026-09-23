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
# Pacotes XDG Desktop e User Dirs
# CIFS, EXFAT, GVFS, NTFS
# Fontes adicionais
# XFCE4 Plugins
# Thunar
# Firefox
# GStreamer
# Programas Extras
sudo pacman -S --needed --noconfirm \
7zip \
alsa-firmware \
base-devel \
bash-completion \
blueman \
bluez \
fastfetch \
fwupd \
ffmpeg \
ffmpegthumbnailer \
git \
numlockx \
power-profiles-daemon \
powertop \
reflector \
udisks2 \
unace \
unzip \
unrar \
xiccd \
xz \
zip \
xdg-user-dirs \
xdg-user-dirs-gtk \
xdg-desktop-portal \
xdg-desktop-portal-gtk \
xdg-utils \
cifs-utils \
exfat-utils \
gvfs \
gvfs-dnssd \
gvfs-goa \
gvfs-mtp \
gvfs-nfs \
gvfs-smb \
gvfs-wsdd \
ntfs-3g \
adobe-source-code-pro-fonts \
adobe-source-sans-fonts \
adobe-source-serif-fonts \
noto-fonts \
noto-fonts-cjk \
noto-fonts-emoji \
noto-fonts-extra \
ttf-dejavu \
ttf-droid \
ttf-fira-code \
ttf-fira-mono \
ttf-fira-sans \
ttf-opensans \
ttf-roboto \
ttf-roboto-mono \
ttf-ubuntu-font-family \
xfce4-goodies \
xfce4-docklike-plugin \
xfce4-mixer \
xfce4-panel-profiles \
xfce4-volumed-pulse \
xfce4-windowck-plugin \
thunar-media-tags-plugin \
thunar-archive-plugin \
thunar-shares-plugin \
thunar-volman \
firefox \
firefox-i18n-pt-br \
gstreamer \
gst-libav \
gst-plugins-base \
gst-plugins-good \
gst-plugins-bad \
gst-plugins-ugly \
catfish \
galculator \
gcolor3 \
gthumb \
lightdm-gtk-greeter-settings \
mugshot \
orage \
parole \
seahorse

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
