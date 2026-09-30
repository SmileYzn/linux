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

# Verificar pacote sudo
if ! command -v sudo >/dev/null 2>&1; then
    echo "O pacote sudo não está instalado. Instale manualmente."
    exit 1
fi

# Abrir pasta do usuário
cd "$HOME" || exit 1

# Adicionar contrib non-free-firmware
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    sudo sed -i \
        's/^Components:.*/Components: main contrib non-free non-free-firmware/' \
        /etc/apt/sources.list.d/debian.sources
else
    sudo sed -Ei \
        's#^(deb(-src)? .+ trixie(-security|-updates)? main).*$#\1 contrib non-free non-free-firmware#' \
        /etc/apt/sources.list
fi

# Atualizar Respositórios
sudo apt update

# Atualizar Sistema
sudo apt full-upgrade -y

# Pacotes Base
sudo apt install -y --no-upgrade \
7zip \
alsa-firmware \
bash-completion \
bluez \
cifs-utils \
curl \
exfatprogs \
exfat-fuse \
fastfetch \
firefox-esr \
firefox-esr-l10n-pt-br \
firmware-linux \
fwupd \
ffmpeg \
ffmpegthumbnailer \
git \
gvfs \
gvfs-backends \
gvfs-fuse \
intel-microcode \
intel-media-va-driver-non-free \
libavcodec-extra \
libavformat-extra \
man-db \
ntfs-3g \
power-profiles-daemon \
powertop \
unace \
unzip \
unrar \
wget \
xdg-desktop-portal-gtk \
xdg-user-dirs-gtk \
xdg-utils \
xz-utils \
zip

# Fontes adicionais
sudo apt install -y --no-upgrade \
fonts-adobe-sourcesans3 \
fonts-adwaita \
fonts-dejavu \
fonts-firacode \
fonts-noto \
fonts-open-sans \
fonts-roboto \
fonts-ubuntu

# XFCE4 Plugins
sudo apt install -y --no-upgrade \
xfce4 \
xfce4-goodies \
xfce4-docklike-plugin \
xfce4-panel-profiles \
xfce4-power-manager \
xfce4-windowck-plugin

# Thunar
sudo apt install -y --no-upgrade \
thunar \
thunar-archive-plugin \
thunar-data \
thunar-font-manager \
thunar-media-tags-plugin \
thunar-volman

# GStreamer
sudo apt install -y --no-upgrade \
gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-ugly \
gstreamer1.0-libav \
gstreamer1.0-vaapi

# Programas Extras
sudo apt install -y --no-upgrade \
catfish \
galculator \
gcolor3 \
lightdm-gtk-greeter-settings \
mugshot \
orage \
parole \
ristretto \
seahorse

# Bluetooth
sudo systemctl enable bluetooth

# Adicionar grupo autologin
if ! getent group autologin >/dev/null; then
    sudo groupadd -r autologin
fi

# Adicionar ao grupo autologin
if ! id -nG "$USER" | grep -qw autologin; then
    sudo gpasswd -a "$USER" autologin
fi

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
