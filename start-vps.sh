#!/bin/bash

# Script de inicialização rápida para VPS
# Uso: ./start-vps.sh

set -e

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Iniciando Valdigley Jericoacoara na VPS${NC}"
echo "=============================================="

# Verificar se está no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Execute este script no diretório do projeto"
    exit 1
fi

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Verificar se .env existe
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚙️ Criando arquivo .env...${NC}"
    cp .env.example .env
    echo "❗ Configure suas variáveis do Supabase em .env"
    echo "   VITE_SUPABASE_URL=sua_url"
    echo "   VITE_SUPABASE_ANON_KEY=sua_chave"
    read -p "Pressione Enter após configurar o .env..."
fi

# Instalar dependências
echo -e "${BLUE}📦 Instalando dependências...${NC}"
npm install

# Build do projeto
echo -e "${BLUE}🔨 Fazendo build...${NC}"
npm run build

# Verificar se build foi criado
if [ ! -d "dist" ]; then
    echo "❌ Falha no build"
    exit 1
fi

echo -e "${GREEN}✅ Projeto pronto para deploy!${NC}"
echo ""
echo "Próximos passos:"
echo "1. Configure o .env com suas credenciais do Supabase"
echo "2. Execute: ./deploy.sh docker (ou pm2 ou static)"
echo "3. Configure SSL: ./deploy.sh ssl"
echo "4. Monitore: ./monitor.sh all"