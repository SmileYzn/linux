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

# Desativar compositor XFCE
xfconf-query -c xfwm4 -p /general/use_compositing -s false

# Desativar compositor MATE
gsettings set org.mate.marco.general compositing-manager false

# Instalar Picom via pacman
sudo pacman -S --needed --noconfirm picom

# Criar pasta de configuração picom
mkdir -p "$HOME/.config/picom"

# Copiar arquivo padrão do picom
cp /etc/xdg/picom.conf "$HOME/.config/picom/picom.conf"

# Desativar sombras
sed -i 's/shadow = true;/shadow = false;/g' "$HOME/.config/picom/picom.conf"

# Desativar fading
sed -i 's/fading = true;/fading = false;/g' "$HOME/.config/picom/picom.conf"

# Desativar transparência
sed -i 's/frame-opacity = 0.9;/frame-opacity = 1.0;/g' "$HOME/.config/picom/picom.conf"

# Trocar XRender por GLX no backend
sed -i 's/backend = "xrender"/backend = "glx"/g' "$HOME/.config/picom/picom.conf"

# Iniciar o compositor
picom --backend glx --daemon
