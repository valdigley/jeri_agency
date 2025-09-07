#!/bin/bash

# Script de restauração para VPS
# Uso: ./restore.sh [arquivo_backup.tar.gz]

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="/var/backups/valdigley"
PROJECT_DIR="/var/www/valdigley-jericoacoara"

if [ -z "$1" ]; then
    echo -e "${YELLOW}📋 Backups disponíveis:${NC}"
    sudo ls -la $BACKUP_DIR/*.tar.gz 2>/dev/null || echo "Nenhum backup encontrado"
    echo ""
    echo "Uso: $0 [arquivo_backup.tar.gz]"
    echo "Exemplo: $0 valdigley_backup_20250101_120000.tar.gz"
    exit 1
fi

BACKUP_FILE="$1"

# Verificar se o arquivo existe
if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    echo -e "${RED}❌ Arquivo de backup não encontrado: $BACKUP_DIR/$BACKUP_FILE${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Iniciando restauração do backup${NC}"
echo "Arquivo: $BACKUP_FILE"
echo ""

# Confirmação
read -p "⚠️  Isso irá sobrescrever os arquivos atuais. Continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restauração cancelada."
    exit 1
fi

# Parar serviços
echo -e "${BLUE}⏹️  Parando serviços...${NC}"
sudo systemctl stop nginx 2>/dev/null || true
docker-compose down 2>/dev/null || true
pm2 stop all 2>/dev/null || true

# Backup do estado atual
echo -e "${BLUE}💾 Fazendo backup do estado atual...${NC}"
CURRENT_BACKUP="current_state_$(date +%Y%m%d_%H%M%S).tar.gz"
sudo tar -czf "$BACKUP_DIR/$CURRENT_BACKUP" \
    -C $(dirname $PROJECT_DIR) \
    $(basename $PROJECT_DIR) \
    --exclude=node_modules \
    --exclude=dist \
    --exclude=.git 2>/dev/null || true

# Restaurar arquivos
echo -e "${BLUE}📁 Restaurando arquivos...${NC}"
sudo rm -rf $PROJECT_DIR
sudo mkdir -p $(dirname $PROJECT_DIR)
sudo tar -xzf "$BACKUP_DIR/$BACKUP_FILE" -C $(dirname $PROJECT_DIR)

# Ajustar permissões
sudo chown -R $USER:$USER $PROJECT_DIR
cd $PROJECT_DIR

# Instalar dependências
echo -e "${BLUE}📦 Instalando dependências...${NC}"
npm install

# Build do projeto
echo -e "${BLUE}🔨 Fazendo build...${NC}"
npm run build

# Reiniciar serviços
echo -e "${BLUE}🔄 Reiniciando serviços...${NC}"

# Nginx
if systemctl is-enabled nginx &>/dev/null; then
    sudo systemctl start nginx
fi

# Docker
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
fi

# PM2
if command -v pm2 &> /dev/null; then
    pm2 resurrect 2>/dev/null || true
fi

echo -e "${GREEN}✅ Restauração concluída!${NC}"
echo "Backup do estado anterior salvo em: $CURRENT_BACKUP"
echo ""
echo "Verificar status:"
echo "- Site: curl -I http://localhost"
echo "- Serviços: ./monitor.sh status"