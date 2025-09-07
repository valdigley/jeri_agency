#!/bin/bash

# Script de atualização para VPS
# Uso: ./update.sh

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔄 Atualizando Valdigley Jericoacoara${NC}"
echo "====================================="

# Verificar se está no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Execute este script no diretório do projeto"
    exit 1
fi

# Fazer backup antes da atualização
echo -e "${BLUE}💾 Fazendo backup antes da atualização...${NC}"
./backup.sh

# Atualizar código do repositório
if [ -d ".git" ]; then
    echo -e "${BLUE}📥 Atualizando código do Git...${NC}"
    git stash push -m "Auto stash before update $(date)"
    git pull origin main
    git stash pop 2>/dev/null || echo "Nenhum stash para aplicar"
else
    echo -e "${YELLOW}⚠️  Não é um repositório Git. Pule esta etapa se fez upload manual.${NC}"
fi

# Verificar mudanças no package.json
if git diff HEAD~1 package.json &>/dev/null; then
    echo -e "${BLUE}📦 Atualizando dependências...${NC}"
    npm install
fi

# Build do projeto
echo -e "${BLUE}🔨 Fazendo novo build...${NC}"
npm run build

# Verificar se build foi bem-sucedido
if [ ! -d "dist" ]; then
    echo "❌ Falha no build. Restaurando backup..."
    LATEST_BACKUP=$(sudo ls -t /var/backups/valdigley/valdigley_backup_*.tar.gz | head -1)
    ./restore.sh $(basename $LATEST_BACKUP)
    exit 1
fi

# Reiniciar serviços
echo -e "${BLUE}🔄 Reiniciando serviços...${NC}"

# Docker
if [ -f "docker-compose.yml" ] && docker-compose ps &>/dev/null; then
    docker-compose down
    docker-compose up -d --build
fi

# PM2
if command -v pm2 &> /dev/null && pm2 list | grep -q "online"; then
    pm2 restart all
fi

# Nginx
if systemctl is-active --quiet nginx; then
    sudo systemctl reload nginx
fi

# Verificar se tudo está funcionando
echo -e "${BLUE}🔍 Verificando funcionamento...${NC}"
sleep 5

if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200"; then
    echo -e "${GREEN}✅ Atualização concluída com sucesso!${NC}"
    echo ""
    echo "Status dos serviços:"
    ./monitor.sh status
else
    echo -e "${YELLOW}⚠️  Site pode não estar respondendo. Verifique os logs:${NC}"
    echo "- Nginx: sudo tail -f /var/log/nginx/error.log"
    echo "- PM2: pm2 logs"
    echo "- Docker: docker-compose logs"
fi

echo ""
echo -e "${GREEN}🎉 Atualização finalizada!${NC}"