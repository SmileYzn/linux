#!/bin/bash

# Habilitar saída em caso de erros
set -e

# Limpar
clear

# Verificar acesso root
if [[ $EUID -eq 0 ]]; then
    echo "Esse script NÃO deve ser executado como root"
    exit 1
fi

# Verificar comandos necessários
for comando in wget unzip sha512sum; do
    if ! command -v "$comando" >/dev/null 2>&1; then
        echo "Verifique se o comando $comando está disponível"
        exit 1
    fi
done

# Dados do pacote do netbeans
PACOTE="netbeans"
DESCRICAO="IDE for Java, HTML5, PHP, Groovy, C and C++"
CATEGORIA="Development;Java;IDE"
VERSAO="31"
DOWNLOAD="https://www.apache.org/dyn/closer.lua/netbeans/netbeans/${VERSAO}/netbeans-${VERSAO}-bin.zip?action=download"
SHA512="https://downloads.apache.org/netbeans/netbeans/${VERSAO}/netbeans-${VERSAO}-bin.zip.sha512"
LOGO="https://netbeans.apache.org/_/images/apache-netbeans.svg"

# Limpar
sudo rm -rf "/opt/${PACOTE}-${VERSAO}"
sudo rm -rf "/usr/share/applications/${PACOTE}-${VERSAO}.desktop"
sudo rm -rf "/usr/share/icons/hicolor/scalable/apps/${PACOTE}.svg"

# Pasta temporária
trap 'rm -rf "/tmp/${PACOTE}"' EXIT
rm -rf "/tmp/${PACOTE}"
mkdir -p "/tmp/${PACOTE}"

# Baixar salvando exatamente como
wget -q --show-progress -O "/tmp/${PACOTE}/${PACOTE}-${VERSAO}-bin.zip" "${DOWNLOAD}"
wget -q --show-progress -O "/tmp/${PACOTE}/${PACOTE}-${VERSAO}-bin.sha512" "${SHA512}"
wget -q --show-progress -O "/tmp/${PACOTE}/${PACOTE}.svg" "${LOGO}"

# Validar o hash
if ! (cd "/tmp/${PACOTE}" && sha512sum -c "${PACOTE}-${VERSAO}-bin.sha512") >/dev/null 2>&1; then
    echo "Download de ${PACOTE}-${VERSAO}-bin.zip falhou."
    exit 1
fi

# Criar pasta destino
sudo mkdir -p "/opt/${PACOTE}-${VERSAO}"

# Mover Imagem
sudo install -Dm644 "/tmp/${PACOTE}/${PACOTE}.svg" "/usr/share/icons/hicolor/scalable/apps/${PACOTE}.svg"

# Descompactar netbeans
unzip -q -o "/tmp/${PACOTE}/${PACOTE}-${VERSAO}-bin.zip" -d "/tmp/${PACOTE}/temp"

# Mover arquivos
sudo cp -ar "/tmp/${PACOTE}/temp/netbeans/." "/opt/${PACOTE}-${VERSAO}/"

# Criar Lançador
sudo tee "/tmp/${PACOTE}/${PACOTE}-${VERSAO}.desktop" > /dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Netbeans ${VERSAO}
Comment=${DESCRICAO}
Exec=/opt/${PACOTE}-${VERSAO}/bin/${PACOTE}
Icon=${PACOTE}
Terminal=false
StartupNotify=false
Categories=${CATEGORIA};
StartupWMClass=Apache NetBeans IDE ${VERSAO}
EOF

# Mover Lançador
sudo install -Dm644 "/tmp/${PACOTE}/${PACOTE}-${VERSAO}.desktop" "/usr/share/applications/${PACOTE}-${VERSAO}.desktop"

# Atualizar ícones
sudo update-desktop-database /usr/share/applications
sudo gtk-update-icon-cache -f /usr/share/icons/hicolor

# Fim
echo "Apache NetBeans IDE ${VERSAO} instalado com êxito."
