-- ============================================================================
-- GOLD LAYER: STAR SCHEMA - DDL (PADRONIZADO COM MNEMÔNICOS)
-- Business Objective: Player Performance & Market Value Analysis (FIFA 21)
-- ============================================================================

DROP SCHEMA IF EXISTS dw CASCADE;
CREATE SCHEMA dw;

COMMENT ON SCHEMA dw IS 'Camada dw - Dados agregados e otimizados para análise FIFA 21';

-- ============================================================================
-- DIMENSÃO: JOGADOR
-- ============================================================================
CREATE TABLE dw.dim_ply (
    srk_ply SERIAL PRIMARY KEY,
    cod_ply INTEGER UNIQUE NOT NULL,
    txt_nam_lng TEXT,
    nom_nam_sht VARCHAR(100),
    num_age INTEGER,
    num_hgt INTEGER,
    num_wgt INTEGER,
    nom_fot VARCHAR(10),
    num_wkf INTEGER,
    num_skm INTEGER,
    num_rep INTEGER,
    nom_nat VARCHAR(50)
);

CREATE INDEX idx_dim_ply_cod ON dw.dim_ply(cod_ply);
CREATE INDEX idx_dim_ply_nam ON dw.dim_ply(nom_nam_sht);
CREATE INDEX idx_dim_ply_nat ON dw.dim_ply(nom_nat);
CREATE INDEX idx_dim_ply_age ON dw.dim_ply(num_age);

COMMENT ON TABLE dw.dim_ply IS 'Dimensão Jogador - Informações demográficas e técnicas';

-- ============================================================================
-- DIMENSÃO: TIME
-- ============================================================================
CREATE TABLE dw.dim_tim (
    srk_tim SERIAL PRIMARY KEY,
    nom_tim VARCHAR(100) NOT NULL
);

COMMENT ON TABLE dw.dim_tim IS 'Dimensão Time';

-- ============================================================================
-- DIMENSÃO: POSIÇÃO
-- ============================================================================
CREATE TABLE dw.dim_pos (
    srk_pos SERIAL PRIMARY KEY,
    nom_pos VARCHAR(50),
    nom_pos_bst VARCHAR(10)
);

CREATE INDEX idx_dim_pos_bst ON dw.dim_pos(nom_pos_bst);

COMMENT ON TABLE dw.dim_pos IS 'Dimensão Posição';

-- ============================================================================
-- FATO: STATUS / PERFORMANCE DO JOGADOR
-- ============================================================================
CREATE TABLE dw.fat_ply_sts (
    srk_ply_sts SERIAL PRIMARY KEY,

    -- Foreign Keys
    srk_ply INTEGER NOT NULL REFERENCES dw.dim_ply(srk_ply),
    srk_tim INTEGER NOT NULL REFERENCES dw.dim_tim(srk_tim),
    srk_pos INTEGER NOT NULL REFERENCES dw.dim_pos(srk_pos),

    -- Métricas Gerais
    num_ovr INTEGER,
    num_pot INTEGER,
    num_bst_ovr INTEGER,
    num_gro INTEGER,
    num_tot INTEGER,
    num_bas INTEGER,
    num_hit INTEGER,

    -- Financeiro
    vlr_mkt NUMERIC(12,2),
    vlr_wag NUMERIC(10,2),
    vlr_rel NUMERIC(12,2),

    -- Contrato
    num_str_yr INTEGER,
    num_end_yr INTEGER,
    dat_joi DATE,

    -- Atributos Principais
    num_pac INTEGER,
    num_sho INTEGER,
    num_pas INTEGER,
    num_dri INTEGER,
    num_def INTEGER,
    num_phy INTEGER,

    -- Attacking
    num_att_tot INTEGER,
    num_att_crs INTEGER,
    num_att_fin INTEGER,
    num_att_hed INTEGER,
    num_att_pas INTEGER,
    num_att_vol INTEGER,

    -- Skill
    num_skl_tot INTEGER,
    num_skl_dri INTEGER,
    num_skl_cur INTEGER,
    num_skl_fka INTEGER,
    num_skl_lps INTEGER,
    num_skl_ctl INTEGER,

    -- Movement
    num_mov_tot INTEGER,
    num_mov_acc INTEGER,
    num_mov_spr INTEGER,
    num_mov_agi INTEGER,
    num_mov_rea INTEGER,
    num_mov_bal INTEGER,

    -- Power
    num_pow_tot INTEGER,
    num_pow_sht INTEGER,
    num_pow_jmp INTEGER,
    num_pow_sta INTEGER,
    num_pow_str INTEGER,
    num_pow_lsh INTEGER,

    -- Mentality
    num_men_tot INTEGER,
    num_men_agg INTEGER,
    num_men_int INTEGER,
    num_men_pos INTEGER,
    num_men_vis INTEGER,
    num_men_pen INTEGER,
    num_men_cmp INTEGER,

    -- Defending
    num_def_tot INTEGER,
    num_def_mrk INTEGER,
    num_def_sta INTEGER,
    num_def_slt INTEGER,

    -- Goalkeeping
    num_gkp_tot INTEGER,
    num_gkp_div INTEGER,
    num_gkp_han INTEGER,
    num_gkp_kic INTEGER,
    num_gkp_pos INTEGER,
    num_gkp_ref INTEGER
);

-- ============================================================================
-- ÍNDICES ANALÍTICOS
-- ============================================================================
CREATE INDEX idx_fat_ply_sts_ply ON dw.fat_ply_sts(srk_ply);
CREATE INDEX idx_fat_ply_sts_tim ON dw.fat_ply_sts(srk_tim);
CREATE INDEX idx_fat_ply_sts_pos ON dw.fat_ply_sts(srk_pos);
CREATE INDEX idx_fat_ply_sts_ovr ON dw.fat_ply_sts(num_ovr);
CREATE INDEX idx_fat_ply_sts_mkt ON dw.fat_ply_sts(vlr_mkt);

COMMENT ON TABLE dw.fat_ply_sts IS 'Fato Status do Jogador - Performance, contrato e valor';

-- ============================================================================
-- FIM DO DDL
-- ============================================================================
