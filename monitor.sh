#!/bin/bash

# Script de monitoramento para Valdigley Jericoacoara
# Uso: ./monitor.sh [opcao]
# Opções: status, logs, resources, all

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_NAME="valdigley-jericoacoara"
PROJECT_DIR="/var/www/$PROJECT_NAME"

print_header() {
    echo -e "${BLUE}=================================="
    echo -e "📊 $1"
    echo -e "==================================${NC}"
}

print_section() {
    echo -e "\n${YELLOW}$1${NC}"
    echo "-------------------"
}

# Status dos serviços
check_services() {
    print_header "STATUS DOS SERVIÇOS"
    
    # Nginx
    print_section "🌐 Nginx"
    if systemctl is-active --quiet nginx; then
        echo -e "${GREEN}✅ Nginx está rodando${NC}"
        echo "Configuração: $(nginx -t 2>&1 | grep -o 'successful' || echo 'com problemas')"
    else
        echo -e "${RED}❌ Nginx não está rodando${NC}"
    fi
    
    # PM2
    print_section "🔄 PM2"
    if command -v pm2 &> /dev/null; then
        pm2 status 2>/dev/null || echo "PM2 não tem processos rodando"
    else
        echo "PM2 não está instalado"
    fi
    
    # Docker
    print_section "🐳 Docker"
    if command -v docker &> /dev/null; then
        if docker-compose ps 2>/dev/null | grep -q "Up"; then
            echo -e "${GREEN}✅ Containers Docker rodando${NC}"
            docker-compose ps
        else
            echo "Nenhum container Docker rodando"
        fi
    else
        echo "Docker não está instalado"
    fi
    
    # Portas
    print_section "🔌 Portas em Uso"
    echo "Porta 80 (HTTP):"
    sudo netstat -tlnp | grep :80 || echo "Porta 80 livre"
    echo "Porta 443 (HTTPS):"
    sudo netstat -tlnp | grep :443 || echo "Porta 443 livre"
    echo "Porta 3000 (Node):"
    sudo netstat -tlnp | grep :3000 || echo "Porta 3000 livre"
}

# Logs do sistema
check_logs() {
    print_header "LOGS DO SISTEMA"
    
    # Nginx Access Logs
    print_section "📝 Nginx - Últimos Acessos"
    if [ -f /var/log/nginx/access.log ]; then
        tail -n 10 /var/log/nginx/access.log
    else
        echo "Log de acesso não encontrado"
    fi
    
    # Nginx Error Logs
    print_section "❌ Nginx - Últimos Erros"
    if [ -f /var/log/nginx/error.log ]; then
        tail -n 10 /var/log/nginx/error.log
    else
        echo "Log de erro não encontrado"
    fi
    
    # PM2 Logs
    print_section "🔄 PM2 - Logs"
    if command -v pm2 &> /dev/null; then
        pm2 logs --lines 10 2>/dev/null || echo "Nenhum log PM2 disponível"
    fi
    
    # Docker Logs
    print_section "🐳 Docker - Logs"
    if command -v docker-compose &> /dev/null; then
        docker-compose logs --tail=10 2>/dev/null || echo "Nenhum log Docker disponível"
    fi
    
    # System Logs
    print_section "🖥️ Sistema - Últimos Erros"
    journalctl -u nginx --lines=5 --no-pager 2>/dev/null || echo "Logs do sistema não disponíveis"
}

# Recursos do sistema
check_resources() {
    print_header "RECURSOS DO SISTEMA"
    
    # CPU e Memória
    print_section "💾 Memória"
    free -h
    
    print_section "💽 Disco"
    df -h /var/www 2>/dev/null || df -h /
    
    print_section "⚡ CPU"
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//' | awk '{print "Uso da CPU: " $1 "%"}'
    
    # Processos relacionados
    print_section "🔍 Processos Relacionados"
    echo "Nginx:"
    ps aux | grep nginx | grep -v grep || echo "Nenhum processo nginx"
    echo -e "\nNode.js:"
    ps aux | grep node | grep -v grep || echo "Nenhum processo node"
    echo -e "\nDocker:"
    ps aux | grep docker | grep -v grep | head -3 || echo "Nenhum processo docker"
    
    # Conexões de rede
    print_section "🌐 Conexões Ativas"
    echo "Conexões HTTP/HTTPS:"
    ss -tuln | grep -E ':80|:443|:3000' || echo "Nenhuma conexão nas portas web"
}

# Verificação de saúde
health_check() {
    print_header "VERIFICAÇÃO DE SAÚDE"
    
    # Teste de conectividade local
    print_section "🏠 Teste Local"
    if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200"; then
        echo -e "${GREEN}✅ Site respondendo localmente${NC}"
    else
        echo -e "${RED}❌ Site não responde localmente${NC}"
    fi
    
    # Teste de arquivos estáticos
    print_section "📁 Arquivos do Site"
    if [ -d "$PROJECT_DIR" ]; then
        echo "Diretório do projeto: $PROJECT_DIR"
        echo "Arquivos principais:"
        ls -la $PROJECT_DIR/index.html 2>/dev/null && echo "✅ index.html encontrado" || echo "❌ index.html não encontrado"
        ls -la $PROJECT_DIR/assets/ 2>/dev/null && echo "✅ Pasta assets encontrada" || echo "❌ Pasta assets não encontrada"
    else
        echo -e "${RED}❌ Diretório do projeto não encontrado: $PROJECT_DIR${NC}"
    fi
    
    # Certificados SSL
    print_section "🔒 Certificados SSL"
    if [ -d "/etc/letsencrypt/live" ]; then
        echo "Certificados encontrados:"
        ls /etc/letsencrypt/live/ 2>/dev/null || echo "Nenhum certificado"
    else
        echo "Let's Encrypt não configurado"
    fi
    
    # Configuração do Nginx
    print_section "⚙️ Configuração Nginx"
    if nginx -t 2>/dev/null; then
        echo -e "${GREEN}✅ Configuração do Nginx válida${NC}"
    else
        echo -e "${RED}❌ Problemas na configuração do Nginx${NC}"
        nginx -t
    fi
}

# Relatório completo
full_report() {
    echo -e "${BLUE}📊 RELATÓRIO COMPLETO - $(date)${NC}"
    echo "=================================================="
    
    check_services
    echo -e "\n"
    check_resources
    echo -e "\n"
    health_check
    echo -e "\n"
    check_logs
    
    echo -e "\n${GREEN}📋 RESUMO:${NC}"
    echo "- Site: $(curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null || echo "Offline")"
    echo "- Nginx: $(systemctl is-active nginx 2>/dev/null || echo "Inativo")"
    echo "- Espaço em disco: $(df -h /var/www 2>/dev/null | tail -1 | awk '{print $4}' || echo "N/A") disponível"
    echo "- Memória livre: $(free -h | grep Mem | awk '{print $7}')"
}

# Monitoramento em tempo real
live_monitor() {
    print_header "MONITORAMENTO EM TEMPO REAL"
    echo "Pressione Ctrl+C para sair"
    echo ""
    
    while true; do
        clear
        echo -e "${BLUE}🔄 Atualizando a cada 5 segundos...${NC}"
        echo "Última atualização: $(date)"
        echo ""
        
        # Status rápido
        echo -e "${YELLOW}Status dos Serviços:${NC}"
        echo "Nginx: $(systemctl is-active nginx 2>/dev/null || echo "Inativo")"
        if command -v pm2 &> /dev/null; then
            echo "PM2: $(pm2 list 2>/dev/null | grep -c "online" || echo "0") processos online"
        fi
        
        # Recursos
        echo -e "\n${YELLOW}Recursos:${NC}"
        free -h | grep Mem
        df -h /var/www 2>/dev/null | tail -1 || df -h / | tail -1
        
        # Últimos acessos
        echo -e "\n${YELLOW}Últimos Acessos:${NC}"
        tail -n 3 /var/log/nginx/access.log 2>/dev/null || echo "Nenhum log disponível"
        
        sleep 5
    done
}

# Menu de ajuda
show_help() {
    echo "Script de Monitoramento - Valdigley Jericoacoara"
    echo ""
    echo "Uso: $0 [OPÇÃO]"
    echo ""
    echo "Opções:"
    echo "  status     Verificar status dos serviços"
    echo "  logs       Mostrar logs do sistema"
    echo "  resources  Mostrar uso de recursos"
    echo "  health     Verificação de saúde completa"
    echo "  all        Relatório completo"
    echo "  live       Monitoramento em tempo real"
    echo "  help       Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 status"
    echo "  $0 all"
    echo "  $0 live"
}

# Main
main() {
    case "${1:-all}" in
        status)
            check_services
            ;;
        logs)
            check_logs
            ;;
        resources)
            check_resources
            ;;
        health)
            health_check
            ;;
        all)
            full_report
            ;;
        live)
            live_monitor
            ;;
        help|*)
            show_help
            ;;
    esac
}

# Executar função principal
main "$@"