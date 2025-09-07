# Deploy na VPS - Valdigley Jericoacoara

## 🚀 Guia Completo para Deploy na VPS

### Pré-requisitos
- VPS com Ubuntu 20.04+ ou CentOS 7+
- Acesso SSH à VPS
- Domínio configurado (opcional)

## 📋 Opção 1: Deploy com Docker (Recomendado)

### 1. Criar Dockerfile
```dockerfile
# Build stage
FROM node:18-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Copiar arquivos buildados
COPY --from=builder /app/dist /usr/share/nginx/html

# Configuração do Nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 2. Configuração do Nginx
```nginx
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;

        # Gzip compression
        gzip on;
        gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        # Handle client routing
        location / {
            try_files $uri $uri/ /index.html;
        }

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
```

### 3. Docker Compose
```yaml
version: '3.8'

services:
  valdigley-site:
    build: .
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./ssl:/etc/nginx/ssl
    environment:
      - NODE_ENV=production
    restart: unless-stopped

  # Opcional: Certbot para SSL
  certbot:
    image: certbot/certbot
    volumes:
      - ./ssl:/etc/letsencrypt
      - ./www:/var/www/certbot
    command: certonly --webroot --webroot-path=/var/www/certbot --email seu@email.com --agree-tos --no-eff-email -d seudominio.com
```

## 📋 Opção 2: Deploy Manual com PM2

### 1. Instalar Node.js na VPS
```bash
# Conectar na VPS
ssh usuario@seu-ip-vps

# Instalar Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PM2 globalmente
sudo npm install -g pm2

# Instalar Nginx
sudo apt update
sudo apt install nginx
```

### 2. Configurar Nginx como Proxy Reverso
```nginx
# /etc/nginx/sites-available/valdigley
server {
    listen 80;
    server_name seudominio.com www.seudominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3. Script de Deploy
```bash
#!/bin/bash
# deploy.sh

echo "🚀 Iniciando deploy do Valdigley Jericoacoara..."

# Variáveis
PROJECT_DIR="/var/www/valdigley"
REPO_URL="https://github.com/seuusuario/valdigley-jericoacoara.git"

# Criar diretório se não existir
sudo mkdir -p $PROJECT_DIR
sudo chown $USER:$USER $PROJECT_DIR

# Clonar ou atualizar repositório
if [ -d "$PROJECT_DIR/.git" ]; then
    echo "📥 Atualizando repositório..."
    cd $PROJECT_DIR
    git pull origin main
else
    echo "📥 Clonando repositório..."
    git clone $REPO_URL $PROJECT_DIR
    cd $PROJECT_DIR
fi

# Instalar dependências
echo "📦 Instalando dependências..."
npm ci

# Build do projeto
echo "🔨 Fazendo build..."
npm run build

# Configurar variáveis de ambiente
echo "⚙️ Configurando variáveis de ambiente..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "❗ Configure as variáveis em .env antes de continuar"
    exit 1
fi

# Servir arquivos estáticos com serve
npm install -g serve
pm2 delete valdigley-site 2>/dev/null || true
pm2 start "serve -s dist -l 3000" --name "valdigley-site"
pm2 save

echo "✅ Deploy concluído!"
echo "🌐 Site disponível em: http://seu-ip-vps"
```

## 📋 Opção 3: Deploy Estático com Nginx

### 1. Script de Build e Deploy
```bash
#!/bin/bash
# static-deploy.sh

echo "🚀 Deploy estático do Valdigley Jericoacoara..."

# Build local
npm run build

# Upload para VPS
rsync -avz --delete dist/ usuario@seu-ip-vps:/var/www/valdigley/

# Configurar Nginx na VPS
ssh usuario@seu-ip-vps << 'EOF'
sudo tee /etc/nginx/sites-available/valdigley > /dev/null << 'NGINX_CONF'
server {
    listen 80;
    server_name seudominio.com www.seudominio.com;
    root /var/www/valdigley;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # Handle client routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
NGINX_CONF

sudo ln -sf /etc/nginx/sites-available/valdigley /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
EOF

echo "✅ Deploy estático concluído!"
```

## 🔒 Configurar SSL (Let's Encrypt)

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Obter certificado SSL
sudo certbot --nginx -d seudominio.com -d www.seudominio.com

# Renovação automática
sudo crontab -e
# Adicionar linha:
# 0 12 * * * /usr/bin/certbot renew --quiet
```

## 📊 Monitoramento

### 1. Script de Monitoramento
```bash
#!/bin/bash
# monitor.sh

echo "📊 Status do Valdigley Jericoacoara"
echo "=================================="

# Status do Nginx
echo "🌐 Nginx:"
sudo systemctl status nginx --no-pager -l

# Status do PM2 (se usando)
echo -e "\n🔄 PM2:"
pm2 status

# Uso de recursos
echo -e "\n💾 Recursos:"
free -h
df -h /var/www

# Logs recentes
echo -e "\n📝 Logs recentes:"
sudo tail -n 10 /var/log/nginx/access.log
```

## 🚀 Comandos Rápidos

```bash
# Deploy com Docker
docker-compose up -d --build

# Deploy manual
chmod +x deploy.sh && ./deploy.sh

# Deploy estático
chmod +x static-deploy.sh && ./static-deploy.sh

# Monitorar
chmod +x monitor.sh && ./monitor.sh

# Ver logs
sudo tail -f /var/log/nginx/access.log
pm2 logs valdigley-site
```

## 🔧 Troubleshooting

### Problemas Comuns:
1. **Porta 80/443 ocupada**: `sudo netstat -tlnp | grep :80`
2. **Permissões**: `sudo chown -R www-data:www-data /var/www/valdigley`
3. **Firewall**: `sudo ufw allow 'Nginx Full'`
4. **DNS**: Verificar se domínio aponta para IP da VPS

### Logs Importantes:
- Nginx: `/var/log/nginx/error.log`
- PM2: `pm2 logs`
- Sistema: `journalctl -u nginx`

## 📋 Checklist Final

- [ ] VPS configurada e acessível
- [ ] Node.js e dependências instaladas
- [ ] Repositório clonado/atualizado
- [ ] Variáveis de ambiente configuradas
- [ ] Build realizado com sucesso
- [ ] Nginx configurado
- [ ] SSL configurado (se aplicável)
- [ ] Domínio apontando para VPS
- [ ] Site acessível e funcionando
- [ ] Monitoramento configurado

---

**Dica**: Comece com a **Opção 3 (Deploy Estático)** por ser mais simples, depois migre para Docker se precisar de mais recursos.