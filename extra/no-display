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

# Ocultar Atalhos (Arch System Apps)
OCULTAR=(
    "/usr/share/applications/bvnc.desktop" \
    "/usr/share/applications/qv4l2.desktop" \
    "/usr/share/applications/bssh.desktop" \
    "/usr/share/applications/avahi-discover.desktop" \
    "/usr/share/applications/qvidcap.desktop" \
    "/usr/share/applications/cups.desktop" \
    "/usr/share/applications/java-java-openjdk.desktop" \
    "/usr/share/applications/jconsole-java-openjdk.desktop" \
    "/usr/share/applications/jshell-java-openjdk.desktop")

# Loop
for CAMINHO in "${OCULTAR[@]}"; do
    if [ -f "$CAMINHO" ]; then
        echo "NoDisplay=true" | sudo tee -a "$CAMINHO"
    fi
done

# Fim
exit
