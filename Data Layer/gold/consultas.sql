-- ============================================================================
-- FIFA 21 | GOLD LAYER
-- OBJETIVO: Consultas analíticas para geração de insights de negócio
-- MODELO: Star Schema (dim_ply, dim_tm, dim_pos, fat_ply_stats)
-- ============================================================================


-- ============================================================================
-- 1. PERFIL GERAL DOS JOGADORES
-- ============================================================================

-- --------------------------------------------------------------------------
-- 1.1 Distribuição de idade vs performance
-- Pergunta de negócio:
-- Jogadores mais velhos ainda performam melhor? Existe um pico de idade?
-- --------------------------------------------------------------------------
SELECT
    p.age,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.overall_rating), 2)   AS avg_overall,
    ROUND(AVG(f.potential_rating), 2) AS avg_potential
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
GROUP BY p.age
ORDER BY p.age;


-- --------------------------------------------------------------------------
-- 1.2 Nacionalidades com maior volume e qualidade
-- Pergunta de negócio:
-- Quais países produzem mais jogadores e com melhor qualidade média?
-- --------------------------------------------------------------------------
SELECT
    p.nationality,
    COUNT(*) AS total_players,
    ROUND(AVG(f.overall_rating), 2)   AS avg_overall,
    ROUND(AVG(f.potential_rating), 2) AS avg_potential
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
GROUP BY p.nationality
HAVING COUNT(*) > 50
ORDER BY avg_overall DESC;


-- ============================================================================
-- 2. ANÁLISES DE MERCADO / VALOR FINANCEIRO
-- ============================================================================

-- --------------------------------------------------------------------------
-- 2.1 Valor médio de mercado por posição
-- Pergunta de negócio:
-- Quais posições são mais valorizadas no mercado?
-- --------------------------------------------------------------------------
SELECT
    pos.best_position,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.value_eur), 2) AS avg_value_eur,
    ROUND(AVG(f.wage_eur), 2)  AS avg_wage_eur
FROM dw.fat_ply_stats f
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
GROUP BY pos.best_position
ORDER BY avg_value_eur DESC;


-- --------------------------------------------------------------------------
-- 2.2 Jogadores subvalorizados (alto overall, baixo valor)
-- Pergunta de negócio:
-- Quais jogadores entregam alta performance por um custo abaixo do mercado?
-- --------------------------------------------------------------------------
SELECT
    p.name,
    pos.best_position,
    f.overall_rating,
    f.value_eur,
    f.wage_eur
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p   ON p.ply_key = f.ply_srk
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
WHERE
    f.overall_rating >= 80
    AND f.value_eur < (
        SELECT AVG(value_eur)
        FROM dw.fat_ply_stats
        WHERE overall_rating >= 80
    )
ORDER BY f.overall_rating DESC, f.value_eur ASC;


-- ============================================================================
-- 3. CRESCIMENTO E POTENCIAL
-- ============================================================================

-- --------------------------------------------------------------------------
-- 3.1 Jogadores com maior potencial de crescimento
-- Pergunta de negócio:
-- Quais jogadores têm maior diferença entre potencial e overall atual?
-- --------------------------------------------------------------------------
SELECT
    p.name,
    p.age,
    f.overall_rating,
    f.potential_rating,
    (f.potential_rating - f.overall_rating) AS growth
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
ORDER BY growth DESC
LIMIT 20;


-- --------------------------------------------------------------------------
-- 3.2 Crescimento médio por faixa etária
-- Pergunta de negócio:
-- Em qual idade os jogadores tendem a evoluir mais?
-- --------------------------------------------------------------------------
SELECT
    p.age,
    ROUND(AVG(f.potential_rating - f.overall_rating), 2) AS avg_growth
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
GROUP BY p.age
ORDER BY p.age;


-- ============================================================================
-- 4. PERFIL TÉCNICO POR POSIÇÃO
-- ============================================================================

-- --------------------------------------------------------------------------
-- 4.1 Atributos médios por posição
-- Pergunta de negócio:
-- Quais atributos definem tecnicamente cada posição?
-- --------------------------------------------------------------------------
SELECT
    pos.best_position,
    ROUND(AVG(f.pace), 1)            AS avg_pace,
    ROUND(AVG(f.shooting), 1)        AS avg_shooting,
    ROUND(AVG(f.passing), 1)         AS avg_passing,
    ROUND(AVG(f.dribbling_stat), 1)  AS avg_dribbling,
    ROUND(AVG(f.defending_stat), 1)  AS avg_defending,
    ROUND(AVG(f.physical), 1)        AS avg_physical
FROM dw.fat_ply_stats f
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
GROUP BY pos.best_position
ORDER BY pos.best_position;


-- ============================================================================
-- 5. ANÁLISES ESPECÍFICAS POR PAPEL (GOLEIROS)
-- ============================================================================

-- --------------------------------------------------------------------------
-- 5.1 Ranking de goleiros por performance
-- Pergunta de negócio:
-- Quem são os melhores goleiros considerando atributos específicos?
-- --------------------------------------------------------------------------
SELECT
    p.name,
    f.overall_rating,
    f.goalkeeping_total,
    f.gk_reflexes,
    f.gk_positioning
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p   ON p.ply_key = f.ply_srk
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
WHERE pos.best_position = 'GK'
ORDER BY f.overall_rating DESC
LIMIT 15;


-- ============================================================================
-- 6. ANÁLISES POR TIME / ELENCO
-- ============================================================================

-- --------------------------------------------------------------------------
-- 6.1 Qualidade média do elenco por time
-- Pergunta de negócio:
-- Quais times possuem os elencos mais fortes e valiosos?
-- --------------------------------------------------------------------------
SELECT
    t.team,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.overall_rating), 2) AS avg_overall,
    ROUND(SUM(f.value_eur), 2)      AS total_value_eur
FROM dw.fat_ply_stats f
JOIN dw.dim_tm t ON t.tm_key = f.tm_srk
GROUP BY t.team
ORDER BY avg_overall DESC;
