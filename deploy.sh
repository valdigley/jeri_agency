#!/bin/bash

# Deploy script para VPS - Valdigley Jericoacoara
# Uso: ./deploy.sh [opcao]
# Opções: docker, pm2, static

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis
PROJECT_NAME="valdigley-jericoacoara"
PROJECT_DIR="/var/www/$PROJECT_NAME"
REPO_URL="https://github.com/seuusuario/$PROJECT_NAME.git"
DOMAIN="seudominio.com"

# Funções
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se está rodando como root para algumas operações
check_sudo() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Rodando como root. Algumas operações podem precisar de ajustes de permissão."
    fi
}

# Deploy com Docker
deploy_docker() {
    print_status "🐳 Iniciando deploy com Docker..."
    
    # Verificar se Docker está instalado
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado. Instalando..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        sudo usermod -aG docker $USER
        print_warning "Faça logout e login novamente para usar Docker sem sudo"
    fi
    
    # Verificar se Docker Compose está instalado
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose não está instalado. Instalando..."
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    
    # Parar containers existentes
    print_status "Parando containers existentes..."
    docker-compose down 2>/dev/null || true
    
    # Build e start
    print_status "Fazendo build e iniciando containers..."
    docker-compose up -d --build
    
    # Verificar status
    sleep 5
    if docker-compose ps | grep -q "Up"; then
        print_success "✅ Deploy com Docker concluído!"
        print_status "🌐 Site disponível em: http://localhost"
    else
        print_error "❌ Falha no deploy com Docker"
        docker-compose logs
        exit 1
    fi
}

# Deploy com PM2
deploy_pm2() {
    print_status "🔄 Iniciando deploy com PM2..."
    
    # Verificar se Node.js está instalado
    if ! command -v node &> /dev/null; then
        print_error "Node.js não está instalado. Instalando..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    # Verificar se PM2 está instalado
    if ! command -v pm2 &> /dev/null; then
        print_status "Instalando PM2..."
        sudo npm install -g pm2
    fi
    
    # Criar diretório do projeto
    sudo mkdir -p $PROJECT_DIR
    sudo chown $USER:$USER $PROJECT_DIR
    
    # Clonar ou atualizar repositório
    if [ -d "$PROJECT_DIR/.git" ]; then
        print_status "📥 Atualizando repositório..."
        cd $PROJECT_DIR
        git pull origin main
    else
        print_status "📥 Clonando repositório..."
        git clone $REPO_URL $PROJECT_DIR
        cd $PROJECT_DIR
    fi
    
    # Verificar se .env existe
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            print_warning "⚙️ Configure as variáveis em .env antes de continuar"
            print_status "Editando .env..."
            nano .env
        else
            print_error "❌ Arquivo .env.example não encontrado"
            exit 1
        fi
    fi
    
    # Instalar dependências
    print_status "📦 Instalando dependências..."
    npm ci
    
    # Build do projeto
    print_status "🔨 Fazendo build..."
    npm run build
    
    # Instalar serve se não estiver instalado
    if ! command -v serve &> /dev/null; then
        print_status "Instalando serve..."
        sudo npm install -g serve
    fi
    
    # Parar processo existente
    pm2 delete $PROJECT_NAME 2>/dev/null || true
    
    # Iniciar com PM2
    pm2 start "serve -s dist -l 3000" --name $PROJECT_NAME
    pm2 save
    
    print_success "✅ Deploy com PM2 concluído!"
    print_status "🌐 Site disponível em: http://localhost:3000"
}

# Deploy estático
deploy_static() {
    print_status "📄 Iniciando deploy estático..."
    
    # Verificar se Nginx está instalado
    if ! command -v nginx &> /dev/null; then
        print_status "Instalando Nginx..."
        sudo apt update
        sudo apt install -y nginx
    fi
    
    # Build local (assumindo que está rodando na máquina de desenvolvimento)
    if [ -f "package.json" ]; then
        print_status "🔨 Fazendo build local..."
        npm run build
        
        # Criar diretório no servidor
        sudo mkdir -p $PROJECT_DIR
        sudo chown www-data:www-data $PROJECT_DIR
        
        # Copiar arquivos
        print_status "📤 Copiando arquivos..."
        sudo cp -r dist/* $PROJECT_DIR/
        sudo chown -R www-data:www-data $PROJECT_DIR
    else
        print_error "❌ package.json não encontrado. Execute este script no diretório do projeto."
        exit 1
    fi
    
    # Configurar Nginx
    print_status "⚙️ Configurando Nginx..."
    sudo tee /etc/nginx/sites-available/$PROJECT_NAME > /dev/null << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root $PROJECT_DIR;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # Handle client routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    
    # Ativar site
    sudo ln -sf /etc/nginx/sites-available/$PROJECT_NAME /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Testar configuração
    if sudo nginx -t; then
        sudo systemctl reload nginx
        print_success "✅ Deploy estático concluído!"
        print_status "🌐 Site disponível em: http://$DOMAIN"
    else
        print_error "❌ Erro na configuração do Nginx"
        exit 1
    fi
}

# Configurar SSL
setup_ssl() {
    print_status "🔒 Configurando SSL com Let's Encrypt..."
    
    # Instalar Certbot
    if ! command -v certbot &> /dev/null; then
        sudo apt update
        sudo apt install -y certbot python3-certbot-nginx
    fi
    
    # Obter certificado
    sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email contato@$DOMAIN
    
    # Configurar renovação automática
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    
    print_success "✅ SSL configurado com sucesso!"
}

# Monitoramento
monitor() {
    print_status "📊 Status do $PROJECT_NAME"
    echo "=================================="
    
    # Status do Nginx
    echo -e "\n🌐 Nginx:"
    sudo systemctl status nginx --no-pager -l | head -10
    
    # Status do PM2 (se estiver rodando)
    if command -v pm2 &> /dev/null; then
        echo -e "\n🔄 PM2:"
        pm2 status
    fi
    
    # Status do Docker (se estiver rodando)
    if command -v docker &> /dev/null; then
        echo -e "\n🐳 Docker:"
        docker-compose ps 2>/dev/null || echo "Docker Compose não está rodando"
    fi
    
    # Uso de recursos
    echo -e "\n💾 Recursos:"
    free -h
    df -h $PROJECT_DIR 2>/dev/null || df -h /var/www
    
    # Logs recentes do Nginx
    echo -e "\n📝 Logs recentes do Nginx:"
    sudo tail -n 5 /var/log/nginx/access.log 2>/dev/null || echo "Logs não encontrados"
}

# Menu principal
show_help() {
    echo "Deploy script para Valdigley Jericoacoara"
    echo ""
    echo "Uso: $0 [OPÇÃO]"
    echo ""
    echo "Opções:"
    echo "  docker    Deploy usando Docker e Docker Compose"
    echo "  pm2       Deploy usando PM2 e Node.js"
    echo "  static    Deploy estático usando Nginx"
    echo "  ssl       Configurar SSL com Let's Encrypt"
    echo "  monitor   Mostrar status do sistema"
    echo "  help      Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 docker"
    echo "  $0 pm2"
    echo "  $0 static"
    echo "  $0 ssl"
}

# Main
main() {
    check_sudo
    
    case "${1:-help}" in
        docker)
            deploy_docker
            ;;
        pm2)
            deploy_pm2
            ;;
        static)
            deploy_static
            ;;
        ssl)
            setup_ssl
            ;;
        monitor)
            monitor
            ;;
        help|*)
            show_help
            ;;
    esac
}

# Executar função principal
main "$@"