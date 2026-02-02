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
    p.num_age,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.num_ovr), 2) AS avg_overall,
    ROUND(AVG(f.num_pot), 2) AS avg_potential
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON p.srk_ply = f.srk_ply
GROUP BY p.num_age
ORDER BY p.num_age;


-- --------------------------------------------------------------------------
-- 2. Nacionalidades com maior volume e qualidade média
-- Pergunta de negócio:
-- Quais países produzem mais jogadores e com melhor nível técnico?
-- --------------------------------------------------------------------------
SELECT
    p.nom_nat,
    COUNT(*) AS total_players,
    ROUND(AVG(f.num_ovr), 2) AS avg_overall
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON p.srk_ply = f.srk_ply
GROUP BY p.nom_nat
HAVING COUNT(*) > 50
ORDER BY avg_overall DESC;


-- --------------------------------------------------------------------------
-- 3. Valor médio de mercado por posição
-- Pergunta de negócio:
-- Quais posições são mais valorizadas financeiramente?
-- --------------------------------------------------------------------------
SELECT
    pos.nom_pos_bst,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.vlr_mkt), 2) AS avg_valor_mercado
FROM dw.fat_ply_sts f
JOIN dw.dim_pos pos ON pos.srk_pos = f.srk_pos
GROUP BY pos.nom_pos_bst
ORDER BY avg_valor_mercado DESC;



-- --------------------------------------------------------------------------
-- 4. Jogadores subvalorizados (alto overall, baixo valor)
-- Pergunta de negócio:
-- Quais jogadores entregam alta performance por um custo abaixo do mercado?
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht,
    pos.nom_pos_bst,
    f.num_ovr,
    f.vlr_mkt
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p   ON p.srk_ply = f.srk_ply
JOIN dw.dim_pos pos ON pos.srk_pos = f.srk_pos
WHERE
    f.num_ovr >= 80
    AND f.vlr_mkt < (
        SELECT AVG(vlr_mkt)
        FROM dw.fat_ply_sts
        WHERE num_ovr >= 80
    )
ORDER BY f.num_ovr DESC, f.vlr_mkt ASC;


-- --------------------------------------------------------------------------
-- 5. Jogadores com maior potencial de crescimento
-- Pergunta de negócio:
-- Quem são os jogadores que mais podem evoluir no futuro?
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht,
    p.num_age,
    f.num_ovr,
    f.num_pot,
    f.num_gro AS crescimento
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON p.srk_ply = f.srk_ply
ORDER BY crescimento DESC
LIMIT 20;


-- --------------------------------------------------------------------------
-- 6. Crescimento médio por idade
-- Pergunta de negócio:
-- Em qual faixa etária os jogadores evoluem mais?
-- --------------------------------------------------------------------------
SELECT
    p.num_age,
    ROUND(AVG(f.num_gro), 2) AS avg_crescimento
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON p.srk_ply = f.srk_ply
GROUP BY p.num_age
ORDER BY p.num_age;


-- --------------------------------------------------------------------------
-- 7. Perfil técnico médio por posição
-- Pergunta de negócio:
-- Quais atributos técnicos caracterizam cada posição?
-- --------------------------------------------------------------------------
SELECT
    pos.nom_pos_bst,
    ROUND(AVG(f.num_pac), 1) AS avg_pace,
    ROUND(AVG(f.num_sho), 1) AS avg_shooting,
    ROUND(AVG(f.num_pas), 1) AS avg_passing,
    ROUND(AVG(f.num_def), 1) AS avg_defending
FROM dw.fat_ply_sts f
JOIN dw.dim_pos pos ON pos.srk_pos = f.srk_pos
GROUP BY pos.nom_pos_bst
ORDER BY pos.nom_pos_bst;


-- --------------------------------------------------------------------------
-- 8. Ranking de goleiros por overall
-- Pergunta de negócio:
-- Quem são os melhores goleiros considerando performance geral?
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht,
    f.num_ovr,
    f.num_gkp_tot
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p   ON p.srk_ply = f.srk_ply
JOIN dw.dim_pos pos ON pos.srk_pos = f.srk_pos
WHERE pos.nom_pos_bst = 'GK '
ORDER BY f.num_ovr DESC
LIMIT 15;


-- --------------------------------------------------------------------------
-- 9. Qualidade média do elenco por time
-- Pergunta de negócio:
-- Quais times possuem os elencos mais fortes?
-- --------------------------------------------------------------------------
SELECT
    t.nom_tim,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.num_ovr), 2) AS avg_overall
FROM dw.fat_ply_sts f
JOIN dw.dim_tim t ON t.srk_tim = f.srk_tim
GROUP BY t.nom_tim
ORDER BY avg_overall DESC;


-- --------------------------------------------------------------------------
-- 10. Times mais valiosos financeiramente
-- Pergunta de negócio:
-- Quais times concentram maior valor de mercado em seus elencos?
-- --------------------------------------------------------------------------
SELECT
    t.nom_tim,
    ROUND(SUM(f.vlr_mkt), 2) AS total_valor_mercado
FROM dw.fat_ply_sts f
JOIN dw.dim_tim t ON t.srk_tim = f.srk_tim
GROUP BY t.nom_tim
ORDER BY total_valor_mercado DESC;



-- ============================================================================
-- CONSULTAS ANALÍTICAS UTILIZANDO CTE (WITH)
-- TOTAL: 2
-- ============================================================================


-- --------------------------------------------------------------------------
-- 11. (CTE) Ranking de jogadores acima da média da posição
-- Pergunta de negócio:
-- Quais jogadores performam acima da média da sua posição?
-- --------------------------------------------------------------------------
WITH avg_pos_ovr AS (
    SELECT
        srk_pos,
        AVG(num_ovr) AS avg_ovr_pos
    FROM dw.fat_ply_sts
    GROUP BY srk_pos
)
SELECT
    p.nom_nam_sht,
    pos.nom_pos_bst,
    f.num_ovr,
    a.avg_ovr_pos
FROM dw.fat_ply_sts f
JOIN avg_pos_ovr a ON a.srk_pos = f.srk_pos
JOIN dw.dim_ply p  ON p.srk_ply = f.srk_ply
JOIN dw.dim_pos pos ON pos.srk_pos = f.srk_pos
WHERE f.num_ovr > a.avg_ovr_pos
ORDER BY f.num_ovr DESC;


-- --------------------------------------------------------------------------
-- 12. (CTE) Times com jogadores jovens e alto potencial
-- Pergunta de negócio:
-- Quais times investem melhor em jovens talentos?
-- --------------------------------------------------------------------------
WITH young_potential AS (
    SELECT
        f.srk_tim,
        COUNT(*) AS qtd_jogadores,
        AVG(f.num_pot) AS avg_potencial
    FROM dw.fat_ply_sts f
    JOIN dw.dim_ply p ON p.srk_ply = f.srk_ply
    WHERE p.num_age <= 23
    GROUP BY f.srk_tim
)
SELECT
    t.nom_tim,
    y.qtd_jogadores,
    ROUND(y.avg_potencial, 2) AS avg_potencial
FROM young_potential y
JOIN dw.dim_tim t ON t.srk_tim = y.srk_tim
ORDER BY avg_potencial DESC;
