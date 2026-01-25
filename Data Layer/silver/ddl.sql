-- ============================================================================
-- SILVER LAYER: FIFA 21 COMPLETO
-- Camada Silver - Todos os atributos técnicos e físicos
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.fifa21_players CASCADE;

CREATE TABLE silver.fifa21_players (
    player_id INTEGER PRIMARY KEY,
    long_name VARCHAR(255),
    name VARCHAR(255),
    nationality VARCHAR(100),
    positions VARCHAR(100),
    age INTEGER,
    overall_rating INTEGER,
    potential_rating INTEGER,
    team VARCHAR(255),
    contract_start_year INTEGER,
    contract_end_year INTEGER,
    height_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    preferred_foot VARCHAR(10),
    best_overall_rating INTEGER,
    best_position CHAR(3),
    growth INTEGER,
    joined_date DATE,
    value_eur DECIMAL(15,2),
    wage_eur DECIMAL(15,2),
    release_clause_eur DECIMAL(15,2),
    attacking_total INTEGER,
    crossing INTEGER,
    finishing INTEGER,
    heading_accuracy INTEGER,
    short_passing INTEGER,
    volleys INTEGER,
    skill_total INTEGER,
    dribbling INTEGER,
    curve INTEGER,
    fk_accuracy INTEGER,
    long_passing INTEGER,
    ball_control INTEGER,
    movement_total INTEGER,
    acceleration INTEGER,
    sprint_speed INTEGER,
    agility INTEGER,
    reactions INTEGER,
    balance INTEGER,
    power_total INTEGER,
    shot_power INTEGER,
    jumping INTEGER,
    stamina INTEGER,
    strength INTEGER,
    long_shots INTEGER,
    mentality_total INTEGER,
    aggression INTEGER,
    interceptions INTEGER,
    positioning INTEGER,
    vision INTEGER,
    penalties INTEGER,
    composure INTEGER,
    defending_total INTEGER,
    marking INTEGER,
    standing_tackle INTEGER,
    sliding_tackle INTEGER,
    goalkeeping_total INTEGER,
    gk_diving INTEGER,
    gk_handling INTEGER,
    gk_kicking INTEGER,
    gk_positioning INTEGER,
    gk_reflexes INTEGER,
    total_stats INTEGER,
    base_stats INTEGER,
    weak_foot INTEGER,
    skill_moves INTEGER,
    attack_work_rate VARCHAR(20),
    defense_work_rate VARCHAR(20),
    international_reputation INTEGER,
    pace INTEGER,
    shooting INTEGER,
    passing INTEGER,
    dribbling_stat INTEGER,
    defending_stat INTEGER,
    physical INTEGER,
    hits INTEGER,
);

-- ============================================================================
-- ÍNDICES PARA CONSULTAS TÉCNICAS
-- ============================================================================
CREATE INDEX idx_fifa_player_name ON silver.fifa21_players(name);
CREATE INDEX idx_fifa_team_name ON silver.fifa21_players(team);
CREATE INDEX idx_fifa_rating ON silver.fifa21_players(overall_rating);
CREATE INDEX idx_fifa_value_eur ON silver.fifa21_players(value_eur);

-- Comentário na tabela
COMMENT ON TABLE silver.fifa21_players IS 'Dados completos de jogadores do FIFA 21 processados da camada Bronze';