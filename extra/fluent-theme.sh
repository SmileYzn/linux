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

# Clonar Fluent GTK Theme && Fluent Icon Theme
git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
git clone https://github.com/vinceliuice/Fluent-icon-theme.git

# Instalar Tema
sudo sh "$HOME/Fluent-gtk-theme/install.sh" --icon arch --size standard --tweaks solid
sh "$HOME/Fluent-gtk-theme/install.sh" --icon arch --size standard --tweaks solid
sh "$HOME/Fluent-gtk-theme/install.sh" --icon arch --size standard --tweaks solid

# Instalar Icones
sudo sh "$HOME/Fluent-icon-theme/install.sh"

# Instalar Cursores
sudo sh "$HOME/Fluent-icon-theme/cursors/install.sh"

# Remover pastas
sudo rm -rf Fluent-gtk-theme
sudo rm -rf Fluent-icon-theme

# Sucesso
echo "Fluent GTK instalado com sucesso!"

# Fim
exit 0
