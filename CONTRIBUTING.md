# Guia de Contribuição

## 🛠️ Desenvolvimento

### Estrutura de Componentes
```
src/
├── components/     # Componentes reutilizáveis
├── hooks/         # Custom hooks
├── lib/           # Configurações e utilitários
└── types/         # Tipos TypeScript (se necessário)
```

### Padrões de Código
- Use TypeScript para type safety
- Componentes funcionais com hooks
- Tailwind CSS para estilização
- ESLint para qualidade do código

### Commits
Use conventional commits:
```
feat: adicionar nova funcionalidade
fix: corrigir bug
docs: atualizar documentação
style: ajustes de estilo
refactor: refatoração de código
```

## 🗄️ Banco de Dados

### Adicionando Nova Tabela
1. Crie migração em `supabase/migrations/`
2. Adicione tipos em `src/lib/supabase.ts`
3. Crie hook personalizado se necessário
4. Implemente componente

### Exemplo de Migração
```sql
-- Nova tabela
CREATE TABLE IF NOT EXISTS nova_tabela (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- RLS
ALTER TABLE nova_tabela ENABLE ROW LEVEL SECURITY;

-- Política
CREATE POLICY "Public can read" ON nova_tabela
  FOR SELECT TO public USING (true);
```

## 🎨 Design

### Cores Principais
- Amarelo: `#EAB308` (yellow-500)
- Preto: `#000000`
- Cinza: `#111827` (gray-900)
- Branco: `#FFFFFF`

### Breakpoints
- Mobile: até 767px
- Tablet: 768px - 1023px
- Desktop: 1024px+

## 📱 Testes

### Checklist de Testes
- [ ] Responsividade em todos os dispositivos
- [ ] Navegação funcional
- [ ] Links externos funcionando
- [ ] Imagens carregando com fallback
- [ ] Dados do Supabase carregando
- [ ] Estados de loading e erro
- [ ] Botão WhatsApp funcionando