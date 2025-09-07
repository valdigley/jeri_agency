#!/bin/bash

# Script de backup para VPS
# Uso: ./backup.sh

set -e

# Variáveis
BACKUP_DIR="/var/backups/valdigley"
PROJECT_DIR="/var/www/valdigley-jericoacoara"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="valdigley_backup_$DATE"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}💾 Iniciando backup do Valdigley Jericoacoara${NC}"

# Criar diretório de backup
sudo mkdir -p $BACKUP_DIR

# Backup do projeto
echo -e "${BLUE}📁 Fazendo backup dos arquivos...${NC}"
sudo tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" \
    -C $(dirname $PROJECT_DIR) \
    $(basename $PROJECT_DIR) \
    --exclude=node_modules \
    --exclude=dist \
    --exclude=.git

# Backup da configuração do Nginx
if [ -f "/etc/nginx/sites-available/valdigley-jericoacoara" ]; then
    echo -e "${BLUE}🌐 Backup da configuração Nginx...${NC}"
    sudo cp /etc/nginx/sites-available/valdigley-jericoacoara "$BACKUP_DIR/nginx_$DATE.conf"
fi

# Backup dos certificados SSL
if [ -d "/etc/letsencrypt/live" ]; then
    echo -e "${BLUE}🔒 Backup dos certificados SSL...${NC}"
    sudo tar -czf "$BACKUP_DIR/ssl_$DATE.tar.gz" -C /etc/letsencrypt .
fi

# Backup do Docker (se existir)
if [ -f "docker-compose.yml" ]; then
    echo -e "${BLUE}🐳 Backup das configurações Docker...${NC}"
    sudo cp docker-compose.yml "$BACKUP_DIR/docker-compose_$DATE.yml"
fi

# Listar backups
echo -e "${GREEN}✅ Backup concluído!${NC}"
echo "Arquivos de backup:"
sudo ls -la $BACKUP_DIR/

# Limpeza de backups antigos (manter apenas os 5 mais recentes)
echo -e "${BLUE}🧹 Limpando backups antigos...${NC}"
sudo find $BACKUP_DIR -name "valdigley_backup_*.tar.gz" -type f | sort -r | tail -n +6 | sudo xargs rm -f

echo -e "${GREEN}💾 Backup finalizado em: $BACKUP_DIR/$BACKUP_NAME.tar.gz${NC}"