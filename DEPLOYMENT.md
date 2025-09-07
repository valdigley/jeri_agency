# Guia de Deploy - Valdigley Jericoacoara

## 🚀 Opções de Deploy

### 1. Vercel (Recomendado)
```bash
# Instalar Vercel CLI
npm i -g vercel

# Deploy
vercel

# Configurar variáveis de ambiente no dashboard da Vercel:
# VITE_SUPABASE_URL
# VITE_SUPABASE_ANON_KEY
```

### 2. Netlify
```bash
# Build do projeto
npm run build

# Upload da pasta dist/ no Netlify
# Configurar variáveis de ambiente no dashboard
```

### 3. GitHub Pages
```bash
# Instalar gh-pages
npm install --save-dev gh-pages

# Adicionar no package.json:
"homepage": "https://seuusuario.github.io/seu-repositorio",
"scripts": {
  "predeploy": "npm run build",
  "deploy": "gh-pages -d dist"
}

# Deploy
npm run deploy
```

## ⚙️ Configurações Necessárias

### Variáveis de Ambiente
Todas as plataformas precisam das seguintes variáveis:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

### Supabase
1. Acesse o [Supabase Dashboard](https://supabase.com/dashboard)
2. Vá em Settings > API
3. Copie a URL e a chave anônima
4. Configure nas variáveis de ambiente da plataforma escolhida

## 🔧 Build Local
```bash
# Gerar build de produção
npm run build

# Testar build localmente
npm run preview
```

## 📋 Checklist Pré-Deploy
- [ ] Todas as imagens estão na pasta `public/imagens/`
- [ ] Variáveis do Supabase configuradas
- [ ] Migrações do banco executadas
- [ ] Build local testado
- [ ] Links externos funcionando
- [ ] Responsividade testada

## 🌐 Domínio Personalizado
Após o deploy, você pode configurar um domínio personalizado:
- Vercel: Settings > Domains
- Netlify: Site settings > Domain management
- GitHub Pages: Settings > Pages > Custom domain