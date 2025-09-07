/*
  # Criar tabelas da agência Jeri

  1. Novas Tabelas
    - `jeri_agency_tours`
      - `id` (uuid, primary key)
      - `name` (text, nome do passeio)
      - `description` (text, descrição)
      - `vehicle_type` (text, tipo de veículo)
      - `price_min` (numeric, preço mínimo)
      - `price_max` (numeric, preço máximo)
      - `capacity` (integer, capacidade)
      - `duration` (text, duração)
      - `active` (boolean, ativo)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `jeri_agency_helicopter_tours`
      - `id` (uuid, primary key)
      - `name` (text, nome do voo)
      - `duration` (text, duração)
      - `normal_price` (numeric, preço normal)
      - `voucher_price` (numeric, preço com voucher)
      - `discount_percentage` (integer, percentual de desconto)
      - `max_passengers` (integer, máximo de passageiros)
      - `active` (boolean, ativo)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Segurança
    - Habilitar RLS em ambas as tabelas
    - Permitir leitura pública para registros ativos
    - Permitir inserção e atualização para usuários autenticados

  3. Dados Iniciais
    - Inserir passeios de exemplo
    - Inserir voos de helicóptero de exemplo
*/

-- Criar função para atualizar updated_at se não existir
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Criar tabela de passeios
CREATE TABLE IF NOT EXISTS jeri_agency_tours (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    vehicle_type text NOT NULL,
    price_min numeric(10,2) NOT NULL,
    price_max numeric(10,2),
    capacity integer NOT NULL,
    duration text NOT NULL,
    active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Criar tabela de voos de helicóptero
CREATE TABLE IF NOT EXISTS jeri_agency_helicopter_tours (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    duration text NOT NULL,
    normal_price numeric(10,2) NOT NULL,
    voucher_price numeric(10,2) NOT NULL,
    discount_percentage integer DEFAULT 5,
    max_passengers integer DEFAULT 3,
    active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE jeri_agency_tours ENABLE ROW LEVEL SECURITY;
ALTER TABLE jeri_agency_helicopter_tours ENABLE ROW LEVEL SECURITY;

-- Políticas para passeios
DROP POLICY IF EXISTS "Permitir leitura pública de passeios" ON jeri_agency_tours;
CREATE POLICY "Permitir leitura pública de passeios"
    ON jeri_agency_tours
    FOR SELECT
    TO public
    USING (active = true);

DROP POLICY IF EXISTS "Permitir inserção para usuários autenticados - passeios" ON jeri_agency_tours;
CREATE POLICY "Permitir inserção para usuários autenticados - passeios"
    ON jeri_agency_tours
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualização para usuários autenticados - passeios" ON jeri_agency_tours;
CREATE POLICY "Permitir atualização para usuários autenticados - passeios"
    ON jeri_agency_tours
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Políticas para voos de helicóptero
DROP POLICY IF EXISTS "Permitir leitura pública de voos de helicóptero" ON jeri_agency_helicopter_tours;
CREATE POLICY "Permitir leitura pública de voos de helicóptero"
    ON jeri_agency_helicopter_tours
    FOR SELECT
    TO public
    USING (active = true);

DROP POLICY IF EXISTS "Permitir inserção para usuários autenticados - helicóptero" ON jeri_agency_helicopter_tours;
CREATE POLICY "Permitir inserção para usuários autenticados - helicóptero"
    ON jeri_agency_helicopter_tours
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualização para usuários autenticados - helicóptero" ON jeri_agency_helicopter_tours;
CREATE POLICY "Permitir atualização para usuários autenticados - helicóptero"
    ON jeri_agency_helicopter_tours
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Triggers para updated_at
DROP TRIGGER IF EXISTS update_jeri_agency_tours_updated_at ON jeri_agency_tours;
CREATE TRIGGER update_jeri_agency_tours_updated_at
    BEFORE UPDATE ON jeri_agency_tours
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_jeri_agency_helicopter_tours_updated_at ON jeri_agency_helicopter_tours;
CREATE TRIGGER update_jeri_agency_helicopter_tours_updated_at
    BEFORE UPDATE ON jeri_agency_helicopter_tours
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Inserir dados iniciais para passeios (apenas se não existirem)
INSERT INTO jeri_agency_tours (name, description, vehicle_type, price_min, price_max, capacity, duration, active)
SELECT * FROM (VALUES
    ('Passeio Leste', 'Pedra Furada, Árvore da Preguiça, Lagoa Azul, Lagoa do Paraíso', 'Buggy', 80.00, 120.00, 4, '6 horas', true),
    ('Passeio Oeste', 'Mangue Seco, Buraco Azul, Lagoa Grande, Caiçara', 'Buggy', 100.00, 150.00, 4, '8 horas', true),
    ('Passeio Tatajuba', 'Vila de Tatajuba, Lagoa de Tatajuba', 'Buggy', 120.00, 180.00, 4, '8 horas', true),
    ('Transfer Fortaleza', 'Transfer do aeroporto de Fortaleza para Jericoacoara', 'Van', 80.00, 100.00, 8, '4 horas', true)
) AS v(name, description, vehicle_type, price_min, price_max, capacity, duration, active)
WHERE NOT EXISTS (SELECT 1 FROM jeri_agency_tours LIMIT 1);

-- Inserir dados iniciais para voos de helicóptero (apenas se não existirem)
INSERT INTO jeri_agency_helicopter_tours (name, duration, normal_price, voucher_price, discount_percentage, max_passengers, active)
SELECT * FROM (VALUES
    ('Voo Panorâmico Básico', '10 minutos', 300.00, 285.00, 5, 3, true),
    ('Voo Panorâmico Completo', '20 minutos', 500.00, 475.00, 5, 3, true),
    ('Voo Sunset Premium', '30 minutos', 800.00, 760.00, 5, 3, true),
    ('Voo Pedra Furada', '15 minutos', 400.00, 380.00, 5, 3, true)
) AS v(name, duration, normal_price, voucher_price, discount_percentage, max_passengers, active)
WHERE NOT EXISTS (SELECT 1 FROM jeri_agency_helicopter_tours LIMIT 1);