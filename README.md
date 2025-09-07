# Site do Fotógrafo Valdigley - Jericoacoara

Site profissional desenvolvido em React + TypeScript + Supabase para o fotógrafo Valdigley, especializado em sessões fotográficas em Jericoacoara, Ceará.

## 🚀 Tecnologias Utilizadas

- **React 18** - Biblioteca JavaScript para interfaces
- **TypeScript** - Tipagem estática para JavaScript
- **Tailwind CSS** - Framework CSS utilitário
- **Vite** - Build tool e dev server
- **Lucide React** - Ícones modernos
- **Supabase** - Backend as a Service (banco de dados)

## 📁 Estrutura do Projeto

```
├── public/
│   └── imagens/           # Imagens do site
│       ├── duna_por_do_sol.jpg
│       ├── pedra_furada.jpg
│       ├── lagoa_paraiso.jpg
│       ├── vila_jericoacoara.jpg
│       └── perfil/        # Imagens do fotógrafo
│           ├── logo.png
│           └── foto_valdiglei.jpg
├── src/
│   ├── components/        # Componentes React
│   │   └── PricingTables.tsx
│   ├── hooks/            # Custom hooks
│   │   └── useTours.ts
│   ├── lib/              # Configurações
│   │   └── supabase.ts
│   ├── App.tsx           # Componente principal
│   ├── main.tsx          # Entry point
│   └── index.css         # Estilos globais
├── supabase/
│   └── migrations/       # Migrações do banco
└── package.json
```

## 🗄️ Banco de Dados (Supabase)

### Tabelas Criadas:
- `jeri_agency_tours` - Passeios (Leste/Oeste)
- `jeri_agency_helicopter_tours` - Voos de helicóptero

### Recursos:
- ✅ Row Level Security (RLS)
- ✅ Políticas de acesso público para leitura
- ✅ Dados iniciais pré-carregados
- ✅ Triggers para timestamps automáticos

## 🎨 Funcionalidades

### Design e UX
- **Design moderno e responsivo** com Tailwind CSS
- **Animações suaves** e micro-interações
- **Navegação intuitiva** com scroll suave
- **Hover effects** em todos os elementos interativos
- **Gradientes e sombras** para profundidade visual
- **Tipografia otimizada** com Google Fonts (Inter)

### Funcionalidades Dinâmicas
- **Preços dinâmicos** carregados do Supabase
- **Menu mobile responsivo**
- **Navbar com efeito scroll**
- **Botão WhatsApp flutuante**
- **Fallback de imagens** automático
- **Loading states** e tratamento de erros

### Seções do Site
1. **Hero Section** - Apresentação principal com call-to-actions
2. **Sobre Jericoacoara** - Por que é um destino especial
3. **Locais Icônicos** - Cards dos principais pontos fotográficos
4. **Passeios** - Detalhes dos tours Leste e Oeste
5. **Preços** - Tabelas dinâmicas de investimentos (Supabase)
6. **Contato** - Informações e botões de ação

## 🚀 Como Executar

### Pré-requisitos
- Node.js 18+
- Conta no Supabase

### Instalação
```bash
# Clone o repositório
git clone [seu-repositorio]
cd valdigley-jericoacoara

# Instale as dependências
npm install

# Configure as variáveis de ambiente
cp .env.example .env
# Adicione suas credenciais do Supabase no .env

# Execute o projeto
npm run dev
```

### Configuração do Supabase
1. Crie um projeto no [Supabase](https://supabase.com)
2. Execute as migrações em `supabase/migrations/`
3. Configure as variáveis no arquivo `.env`:
```env
VITE_SUPABASE_URL=sua_url_do_supabase
VITE_SUPABASE_ANON_KEY=sua_chave_anonima
```

## 📱 Responsividade

O site é totalmente responsivo e otimizado para:
- **Desktop** (1024px+)
- **Tablet** (768px - 1023px)
- **Mobile** (até 767px)

## 🎯 SEO e Acessibilidade

- Meta tags otimizadas
- Estrutura semântica HTML5
- Alt texts em todas as imagens
- Contraste adequado de cores
- Navegação por teclado

## 📞 Contato

- **WhatsApp**: (85) 99801-8443
- **Instagram**: @valdigley
- **Localização**: Jericoacoara, Ceará

## 🔧 Scripts Disponíveis

```bash
npm run dev      # Servidor de desenvolvimento
npm run build    # Build para produção
npm run preview  # Preview do build
npm run lint     # Verificar código
```

## 📝 Changelog

### v2.0.0 - Integração com Supabase
- ✅ Integração completa com Supabase
- ✅ Tabelas dinâmicas de preços
- ✅ Sistema de fallback para imagens
- ✅ Melhorias no botão WhatsApp
- ✅ Correções de layout e responsividade

### v1.0.0 - Versão Inicial
- ✅ Site completo em React + TypeScript
- ✅ Design responsivo com Tailwind CSS
- ✅ Todas as seções funcionais

---

Desenvolvido com ❤️ para capturar os melhores momentos em Jericoacoara!