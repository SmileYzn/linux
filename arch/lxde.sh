#!/bin/bash

######################################################
# FAÇA A INSTALAÇÃO MÍNIMA DO XORG VIA ARCH INSTALLER
######################################################

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
zip

# Pacotes XDG Desktop e User Dirs
sudo pacman -S --needed --noconfirm \
xdg-user-dirs \
xdg-user-dirs-gtk \
xdg-desktop-portal \
xdg-desktop-portal-gtk \
xdg-utils

# CIFS, EXFAT, GVFS
sudo pacman -S --needed --noconfirm \
cifs-utils \
exfatprogs \
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

# LXDE
sudo pacman -S --needed --noconfirm \
galculator \
gcolor3 \
iso-codes\
l3afpad \
libnotify \
lightdm \
lightdm-gtk-greeter \
lxde \
mpv \
mugshot \
notification-daemon \
network-manager-applet \
pavucontrol \
seahorse \
picom \
simple-scan \
system-config-printer \
xarchiver \
xpdf \
xscreensaver

# LightDM GTK + Service
sudo systemctl enable lightdm

# Habilitar notification Daemon
sudo cp /usr/share/applications/notification-daemon.desktop /etc/xdg/autostart/

# Adwaita
sudo pacman -S --needed --noconfirm \
adwaita-cursors \
adwaita-fonts \
adwaita-icon-theme \
adwaita-icon-theme-legacy

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

# Configuração do LXDE Panel
LXPANEL="/Td6WFoAAATm1rRGBMD8BYgQIQEWAAAAAAAAAFlrPSfgCAcC9F0AEYgKCCHMlGgedS3yj4gZAZo+EbH9bnvQzmht+lr00B61+5a14Byz7h8C5yN/5v5WjM1dPql+4E8p2WQTIXQjzztYOVwKj5wlnJQK/Z+bF+zHX4WlEnpThXhODmwwf2j0OdiIVEDJgamlNZQS41KbWPVwIaRLCz6F+krYbTlKi4EwG9v9CGXoNtNlXY4JSL3K9mVVe8iCewTR2QwKcotDwSvX3QAlX9oL1TPfe81kuTpnkR7fgfWyb/sygOIy/92X3GrEXDPOls630ndpS/col/omVTENeTbt60MvuJcLrODxjHQ3gaOwkXsTm5n8RmtFncNrIc20xDLY9VRXUW4UoUVvt5QagbzAvY8dL1WuICGIFrY5gDAU+SRjf2d7MV8l4YxUkAp6bulR7+DGNhXeCl6+mYmtoVDolIigvSCiA8dlYLv+hhd31RWiQ/9XnA2UDW1RGunYnNP/VzR0xzZUgbYRL/M5VHQ+OQ0qm7rcLNZWAE3v7y+9oK0SblAfi1Hiu2ooEsK6vj96sxp82rPJqweUzWVhY6Mbh2ArW9Mee2le0uEULE/VfFPzUPAD0482a3qPhXcVfMIh4bpAEeZ1iXJGtUeu/McLHE+C7Y31DzOSDuUOCbVRupscY9jUG4che6Se5gxLC4UAWzj4m6VreOEBvJAWz9qMiOp2xxEmyGL6/A3s0iw4yAaj+s1aL0GirgiKRxtGw2OS8ub/YKdNiSWkOnCZ1J7FQ4JmYzi8A4LKw/owMwoQCC5b2n/0Rn/SD1fENxzaA5FIWKOUlfLfu3lOgKFLP2YcL+oiC7UZ+VQ00YDJiXVOjZa9b+U8BBs5iVdSnilT/UNj5smpHVxajXOZqVowskVBueeEKMJrciKINBKxN7KRNFYswLDmFwsBXfjps/mg/b89slXd4pn6J2Hz3NwFa4YwCF1m5/gq94hIXHTUbsmxSb7hrcwAqb/FUbvP57HadD5SbJE3ZYt2L/nylHC3UQaiZy89zv4i7BgWJQgAAGN8UMTUZwtjAAGYBogQAAD3iOuJscRn+wIAAAAABFla"
mkdir -p /home/$USER/.config/lxpanel/LXDE/panels
echo "$LXPANEL" | base64 -d | unxz -c > /home/$USER/.config/lxpanel/LXDE/panels/panel

# Configurar picom Compositor
mkdir -p /home/$USER/.config/picom/
cp /etc/xdg/picom.conf /home/$USER/.config/picom/picom.conf
sed -i 's/shadow = true;/shadow = false;/g' /home/$USER/.config/picom/picom.conf
sed -i 's/fading = true;/fading = false;/g' /home/$USER/.config/picom/picom.conf
sed -i 's/frame-opacity = 0.9;/frame-opacity = 1.0;/g' /home/$USER/.config/picom/picom.conf
picom --daemon

# Limpar histórico
history -c && > ~/.bash_history

# Fim
exit 0
