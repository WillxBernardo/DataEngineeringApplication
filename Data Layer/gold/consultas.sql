-- ============================================================================
-- FIFA 21 | GOLD LAYER
-- OBJETIVO: Consultas analíticas para geração de insights de negócio
-- MODELO: Star Schema (dim_ply, dim_tm, dim_pos, fat_ply_stats)
-- CAMADA: Gold (dw)
-- ============================================================================


-- --------------------------------------------------------------------------
-- 1. Distribuição de idade vs performance
-- Pergunta de negócio:
-- Jogadores mais velhos ainda performam bem? Existe um pico de performance?
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
-- 2. Nacionalidades com maior volume e qualidade média
-- Pergunta de negócio:
-- Quais países produzem mais jogadores e com melhor nível técnico?
-- --------------------------------------------------------------------------
SELECT
    p.nationality,
    COUNT(*) AS total_players,
    ROUND(AVG(f.overall_rating), 2) AS avg_overall
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
GROUP BY p.nationality
HAVING COUNT(*) > 50
ORDER BY avg_overall DESC;


-- --------------------------------------------------------------------------
-- 3. Valor médio de mercado por posição
-- Pergunta de negócio:
-- Quais posições são mais valorizadas financeiramente?
-- --------------------------------------------------------------------------
SELECT
    pos.best_position,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.value_eur), 2) AS avg_value_eur
FROM dw.fat_ply_stats f
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
GROUP BY pos.best_position
ORDER BY avg_value_eur DESC;


-- --------------------------------------------------------------------------
-- 4. Jogadores subvalorizados (alto overall, baixo valor)
-- Pergunta de negócio:
-- Quais jogadores entregam alta performance por um custo abaixo do mercado?
-- --------------------------------------------------------------------------
SELECT
    p.name,
    pos.best_position,
    f.overall_rating,
    f.value_eur
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


-- --------------------------------------------------------------------------
-- 5. Jogadores com maior potencial de crescimento
-- Pergunta de negócio:
-- Quem são os jogadores que mais podem evoluir no futuro?
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
-- 6. Crescimento médio por idade
-- Pergunta de negócio:
-- Em qual faixa etária os jogadores evoluem mais?
-- --------------------------------------------------------------------------
SELECT
    p.age,
    ROUND(AVG(f.potential_rating - f.overall_rating), 2) AS avg_growth
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
GROUP BY p.age
ORDER BY p.age;


-- --------------------------------------------------------------------------
-- 7. Perfil técnico médio por posição
-- Pergunta de negócio:
-- Quais atributos técnicos caracterizam cada posição?
-- --------------------------------------------------------------------------
SELECT
    pos.best_position,
    ROUND(AVG(f.pace), 1)       AS avg_pace,
    ROUND(AVG(f.shooting), 1)   AS avg_shooting,
    ROUND(AVG(f.passing), 1)    AS avg_passing,
    ROUND(AVG(f.defending_stat), 1) AS avg_defending
FROM dw.fat_ply_stats f
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
GROUP BY pos.best_position
ORDER BY pos.best_position;


-- --------------------------------------------------------------------------
-- 8. Ranking de goleiros por overall
-- Pergunta de negócio:
-- Quem são os melhores goleiros considerando performance geral?
-- --------------------------------------------------------------------------
SELECT
    p.name,
    f.overall_rating,
    f.goalkeeping_total
FROM dw.fat_ply_stats f
JOIN dw.dim_ply p   ON p.ply_key = f.ply_srk
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
WHERE pos.best_position = 'GK '
ORDER BY f.overall_rating DESC
LIMIT 15;


-- --------------------------------------------------------------------------
-- 9. Qualidade média do elenco por time
-- Pergunta de negócio:
-- Quais times possuem os elencos mais fortes?
-- --------------------------------------------------------------------------
SELECT
    t.team,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.overall_rating), 2) AS avg_overall
FROM dw.fat_ply_stats f
JOIN dw.dim_tm t ON t.tm_key = f.tm_srk
GROUP BY t.team
ORDER BY avg_overall DESC;


-- --------------------------------------------------------------------------
-- 10. Times mais valiosos financeiramente
-- Pergunta de negócio:
-- Quais times concentram maior valor de mercado em seus elencos?
-- --------------------------------------------------------------------------
SELECT
    t.team,
    ROUND(SUM(f.value_eur), 2) AS total_value_eur
FROM dw.fat_ply_stats f
JOIN dw.dim_tm t ON t.tm_key = f.tm_srk
GROUP BY t.team
ORDER BY total_value_eur DESC;



-- ============================================================================
-- CONSULTAS ANALÍTICAS UTILIZANDO CTE (WITH)
-- TOTAL: 2
-- ============================================================================


-- --------------------------------------------------------------------------
-- 11. (CTE) Ranking de jogadores acima da média da posição
-- Pergunta de negócio:
-- Quais jogadores performam acima da média da sua posição?
-- --------------------------------------------------------------------------
WITH avg_position_overall AS (
    SELECT
        pos_srk,
        AVG(overall_rating) AS avg_overall_position
    FROM dw.fat_ply_stats
    GROUP BY pos_srk
)
SELECT
    p.name,
    pos.best_position,
    f.overall_rating,
    a.avg_overall_position
FROM dw.fat_ply_stats f
JOIN avg_position_overall a ON a.pos_srk = f.pos_srk
JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
JOIN dw.dim_pos pos ON pos.pos_key = f.pos_srk
WHERE f.overall_rating > a.avg_overall_position
ORDER BY f.overall_rating DESC;


-- --------------------------------------------------------------------------
-- 12. (CTE) Times com jogadores jovens e alto potencial
-- Pergunta de negócio:
-- Quais times investem melhor em jovens talentos?
-- --------------------------------------------------------------------------
WITH young_high_potential AS (
    SELECT
        tm_srk,
        COUNT(*) AS qtd_jogadores,
        AVG(potential_rating) AS avg_potential
    FROM dw.fat_ply_stats f
    JOIN dw.dim_ply p ON p.ply_key = f.ply_srk
    WHERE p.age <= 23
    GROUP BY tm_srk
)
SELECT
    t.team,
    y.qtd_jogadores,
    ROUND(y.avg_potential, 2) AS avg_potential
FROM young_high_potential y
JOIN dw.dim_tm t ON t.tm_key = y.tm_srk
ORDER BY avg_potential DESC;