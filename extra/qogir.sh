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

# Clonar Qogir GTK
git clone https://github.com/vinceliuice/Qogir-theme.git

# Clonar Qogir Icon
git clone https://github.com/vinceliuice/Qogir-icon-theme.git

# Clonar Qogir Openbox
git clone https://github.com/tr1nh/qogir-theme-openbox.git

# Instalar Qogir Theme
sudo sh "$HOME/Qogir-theme/install.sh" -i arch
sh "$HOME/Qogir-theme/install.sh" -i arch
sh "$HOME/Qogir-theme/install.sh" -i arch -c dark -l

# Instalar Qogir Icon
sudo sh "$HOME/Qogir-icon-theme/install.sh" -t default

# Instalar Qogir Openbox
sudo cp -r "$HOME/qogir-theme-openbox/Qogir-Dark" /usr/share/themes/
sudo cp -r "$HOME/qogir-theme-openbox/Qogir-Light" /usr/share/themes/

# Remover pastas
rm -rf "$HOME/Qogir-theme"
rm -rf "$HOME/Qogir-icon-theme"
rm -rf "$HOME/qogir-theme-openbox"

# Sucesso
echo "Qogir instalado com sucesso!"

# Fim
exit 0
