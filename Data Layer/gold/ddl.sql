-- ============================================================================
-- GOLD LAYER: STAR SCHEMA - DDL
-- Business Objective: Player Performance & Market Value Analysis (FIFA 21)
-- ============================================================================

DROP SCHEMA IF EXISTS dw CASCADE;
CREATE SCHEMA dw;

COMMENT ON SCHEMA dw IS 'Camada dw - Dados agregados e otimizados para análise FIFA 21';

-- ============================================================================
-- DIMENSION 1: JOGADOR
-- ============================================================================
CREATE TABLE dw.dim_ply (
    ply_key SERIAL PRIMARY KEY,
    player_id INTEGER UNIQUE NOT NULL,
    long_name TEXT,
    name VARCHAR(100),
    age INTEGER,
    height_cm INTEGER,
    weight_kg INTEGER,
    preferred_foot VARCHAR(10),
    weak_foot INTEGER,
    skill_moves INTEGER,
    international_reputation INTEGER,
    nationality VARCHAR(50)
);

CREATE INDEX idx_ply_player_id ON dw.dim_ply(player_id);
CREATE INDEX idx_ply_name ON dw.dim_ply(name);
CREATE INDEX idx_ply_nationality ON dw.dim_ply(nationality);
CREATE INDEX idx_ply_age ON dw.dim_ply(age);

COMMENT ON TABLE dw.dim_ply IS 'Dimensão Jogador - Informações demográficas e técnicas do jogador';
COMMENT ON COLUMN dw.dim_ply.ply_key IS 'Chave primária surrogate';
COMMENT ON COLUMN dw.dim_ply.player_id IS 'Identificador original do jogador no FIFA';
COMMENT ON COLUMN dw.dim_ply.preferred_foot IS 'Pé dominante do jogador';

-- ============================================================================
-- DIMENSION 2: TIME
-- ============================================================================
CREATE TABLE dw.dim_tm (
    tm_key SERIAL PRIMARY KEY,
    team VARCHAR(100) NOT NULL
);

COMMENT ON TABLE dw.dim_tm IS 'Dimensão Time - Informações contratuais e vínculo do jogador';
COMMENT ON COLUMN dw.dim_tm.tm_key IS 'Chave primária surrogate';

-- ============================================================================
-- DIMENSION 3: POSIÇÃO
-- ============================================================================
CREATE TABLE dw.dim_pos (
    pos_key SERIAL PRIMARY KEY,
    positions VARCHAR(50),
    best_position VARCHAR(10)
);

CREATE INDEX idx_pos_best_position ON dw.dim_pos(best_position);

COMMENT ON TABLE dw.dim_pos IS 'Dimensão Posição - Posições jogáveis do atleta';
COMMENT ON COLUMN dw.dim_pos.pos_key IS 'Chave primária surrogate';

-- ============================================================================
-- FACT TABLE: STATUS / PERFORMANCE DO JOGADOR
-- ============================================================================
CREATE TABLE dw.fat_ply_stats (
    fts_key SERIAL PRIMARY KEY,

    -- Foreign Keys (Surrogate Keys)
    ply_srk INTEGER NOT NULL REFERENCES dw.dim_ply(ply_key),
    tm_srk INTEGER NOT NULL REFERENCES dw.dim_tm(tm_key),
    pos_srk INTEGER NOT NULL REFERENCES dw.dim_pos(pos_key),

    -- Ratings Gerais
    overall_rating INTEGER,
    potential_rating INTEGER,
    best_overall_rating INTEGER,
    growth INTEGER,
    total_stats INTEGER,
    base_stats INTEGER,
    hits INTEGER,

    -- Valores Financeiros
    value_eur NUMERIC(12,2),
    wage_eur NUMERIC(10,2),
    release_clause_eur NUMERIC(12,2),

    -- Contrato
    contract_start_year INTEGER,
    contract_end_year INTEGER,
    joined_date DATE,

    -- Atributos Principais
    pace INTEGER,
    shooting INTEGER,
    passing INTEGER,
    dribbling_stat INTEGER,
    defending_stat INTEGER,
    physical INTEGER,

    -- Attacking
    attacking_total INTEGER,
    crossing INTEGER,
    finishing INTEGER,
    heading_accuracy INTEGER,
    short_passing INTEGER,
    volleys INTEGER,

    -- Skill
    skill_total INTEGER,
    dribbling INTEGER,
    curve INTEGER,
    fk_accuracy INTEGER,
    long_passing INTEGER,
    ball_control INTEGER,

    -- Movement
    movement_total INTEGER,
    acceleration INTEGER,
    sprint_speed INTEGER,
    agility INTEGER,
    reactions INTEGER,
    balance INTEGER,

    -- Power
    power_total INTEGER,
    shot_power INTEGER,
    jumping INTEGER,
    stamina INTEGER,
    strength INTEGER,
    long_shots INTEGER,

    -- Mentality
    mentality_total INTEGER,
    aggression INTEGER,
    interceptions INTEGER,
    positioning INTEGER,
    vision INTEGER,
    penalties INTEGER,
    composure INTEGER,

    -- Defending
    defending_total INTEGER,
    marking INTEGER,
    standing_tackle INTEGER,
    sliding_tackle INTEGER,

    -- Goalkeeping
    goalkeeping_total INTEGER,
    gk_diving INTEGER,
    gk_handling INTEGER,
    gk_kicking INTEGER,
    gk_positioning INTEGER,
    gk_reflexes INTEGER
);

CREATE INDEX idx_ft_ply_stats_ply ON dw.fat_ply_stats(ply_srk);
CREATE INDEX idx_ft_ply_stats_tm ON dw.fat_ply_stats(tm_srk);
CREATE INDEX idx_ft_ply_stats_pos ON dw.fat_ply_stats(pos_srk);
CREATE INDEX idx_ft_ply_stats_overall ON dw.fat_ply_stats(overall_rating);
CREATE INDEX idx_ft_ply_stats_value ON dw.fat_ply_stats(value_eur);

COMMENT ON TABLE dw.fat_ply_stats IS 'Fato Player Stats - Métricas de performance e valor do jogador';
COMMENT ON COLUMN dw.fat_ply_stats.fts_key IS 'Chave primária surrogate da tabela fato';
COMMENT ON COLUMN dw.fat_ply_stats.ply_srk IS 'Chave estrangeira surrogate para dim_ply';
COMMENT ON COLUMN dw.fat_ply_stats.tm_srk IS 'Chave estrangeira surrogate para dim_tm';
COMMENT ON COLUMN dw.fat_ply_stats.pos_srk IS 'Chave estrangeira surrogate para dim_pos';
COMMENT ON COLUMN dw.fat_ply_stats.overall_rating IS 'Overall atual do jogador';
COMMENT ON COLUMN dw.fat_ply_stats.value_eur IS 'Valor de mercado estimado em euros';

-- ============================================================================
-- GRANTS (opcional - para usuários BI)
-- ============================================================================
-- GRANT SELECT ON ALL TABLES IN SCHEMA dw TO bi_user;
-- GRANT SELECT ON ALL SEQUENCES IN SCHEMA dw TO bi_user;
-- GRANT USAGE ON SCHEMA dw TO bi_user;

-- ============================================================================
-- FIM DO DDL dw - FIFA 21
-- ============================================================================
