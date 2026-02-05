-- ============================================================================
-- FIFA 21 | GOLD LAYER
-- OBJETIVO: Consultas analíticas para geração de insights de negócio
-- MODELO: Star Schema (dim_ply, dim_tm, dim_pos, fat_ply_stats)
-- CAMADA: Gold (dw)
-- ============================================================================


-- --------------------------------------------------------------------------
-- 1. Custo-benefício dos jogadores (Overall x Valor de Mercado)
-- Pergunta de negócio:
-- Quais jogadores entregam maior overall pagando menos no mercado?
-- Ideal para encontrar barganhas competitivas.
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht,
    t.nom_tim,
    p.num_age,
    f.num_ovr,
    f.vlr_mkt,
    ROUND(f.vlr_mkt / NULLIF(f.num_ovr, 0), 2) AS vlr_por_ovr
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON f.srk_ply = p.srk_ply
JOIN dw.dim_tim t ON f.srk_tim = t.srk_tim
WHERE f.vlr_mkt IS NOT NULL;


-- --------------------------------------------------------------------------
-- 2. Top 10 times com maior overall médio
-- Pergunta de negócio:
-- Quais clubes possuem elencos mais fortes em média?
-- --------------------------------------------------------------------------
SELECT
    t.nom_tim,
    ROUND(AVG(f.num_ovr), 2) AS avg_ovr
FROM dw.fat_ply_sts f
JOIN dw.dim_tim t ON f.srk_tim = t.srk_tim
GROUP BY t.nom_tim
ORDER BY avg_ovr DESC
LIMIT 10;


-- --------------------------------------------------------------------------
-- 3. Top 10 elencos mais caros
-- Pergunta de negócio:
-- Quais times concentram maior valor financeiro em seus jogadores?
-- --------------------------------------------------------------------------
SELECT
    t.nom_tim,
    SUM(f.vlr_mkt) AS vlr_total_elenco
FROM dw.fat_ply_sts f
JOIN dw.dim_tim t ON f.srk_tim = t.srk_tim
GROUP BY t.nom_tim
ORDER BY vlr_total_elenco DESC
LIMIT 10;


-- --------------------------------------------------------------------------
-- 4. Top 10 batedores de pênalti
-- Pergunta de negócio:
-- Quais jogadores possuem os melhores atributos de cobrança de pênalti
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht AS nom_jogador,
    f.num_men_pen AS num_penalties
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON f.srk_ply = p.srk_ply
JOIN dw.dim_tim t ON f.srk_tim = t.srk_tim
WHERE f.num_men_pen IS NOT NULL
ORDER BY f.num_men_pen DESC
LIMIT 10;

-- --------------------------------------------------------------------------
-- 5. Relação entre idade e performance média
-- Pergunta de negócio:
-- Existe uma idade em que os jogadores performam melhor em média?
-- --------------------------------------------------------------------------
SELECT
    p.num_age,
    COUNT(*) AS qtd_jogadores,
    ROUND(AVG(f.num_ovr), 2) AS avg_ovr
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON f.srk_ply = p.srk_ply
GROUP BY p.num_age
ORDER BY p.num_age;

-- --------------------------------------------------------------------------
-- 6. Top 10 nacionalidades com melhores dribladores
-- Pergunta de negócio:
-- Quais nacionalidades concentram jogadores com maior habilidade de driblar
-- --------------------------------------------------------------------------
SELECT
    p.nom_nat                    AS nom_nacionalidade,
    ROUND(AVG(f.num_skl_dri), 2) AS avg_drible,
    COUNT(*)                     AS qtd_jogadores
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON f.srk_ply = p.srk_ply
WHERE f.num_skl_dri IS NOT NULL
GROUP BY p.nom_nat
HAVING COUNT(*) >= 5
ORDER BY avg_drible DESC
LIMIT 10;


-- --------------------------------------------------------------------------
-- 7. Alta aceleração e baixa stamina
-- Pergunta de negócio:
-- Quais jogadores são explosivos, mas se cansam rapidamente?
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht,
    f.num_mov_acc,
    f.num_pow_sta
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON f.srk_ply = p.srk_ply
WHERE f.num_mov_acc >= 85
  AND f.num_pow_sta <= 60;


-- --------------------------------------------------------------------------
-- 8. Top 10 goleiros por overall
-- Pergunta de negócio:
-- Quais são os melhores goleiros disponíveis no jogo?
-- --------------------------------------------------------------------------
SELECT
    p.nom_nam_sht,
    f.num_ovr
FROM dw.fat_ply_sts f
JOIN dw.dim_ply p ON f.srk_ply = p.srk_ply
JOIN dw.dim_pos pos ON f.srk_pos = pos.srk_pos
WHERE pos.nom_pos_bst = 'GK '
ORDER BY f.num_ovr DESC
LIMIT 10;


-- --------------------------------------------------------------------------
-- 9. Média salarial por posição
-- Pergunta de negócio:
-- Quais posições recebem os maiores salários em média?
-- --------------------------------------------------------------------------
SELECT
    pos.nom_pos_bst,
    ROUND(AVG(f.vlr_wag), 2) AS avg_salario
FROM dw.fat_ply_sts f
JOIN dw.dim_pos pos ON f.srk_pos = pos.srk_pos
GROUP BY pos.nom_pos_bst;


-- --------------------------------------------------------------------------
-- 10. Distribuição de jogadores por posição
-- Pergunta de negócio:
-- Como os jogadores estão distribuídos entre as posições do jogo?
-- --------------------------------------------------------------------------
SELECT
    pos.nom_pos_bst,
    COUNT(*) AS qtd_jogadores
FROM dw.fat_ply_sts f
JOIN dw.dim_pos pos ON f.srk_pos = pos.srk_pos
GROUP BY pos.nom_pos_bst;


-- --------------------------------------------------------------------------
-- 11 (CTE). Times com melhor desempenho defensivo coletivo
-- Pergunta de negócio:
-- Quais times possuem o melhor desempenho defensivo médio, considerando
-- atributos defensivos e físicos de seus jogadores?
-- --------------------------------------------------------------------------
WITH defesa_jogador AS (
    SELECT
        f.srk_tim,
        (
            f.num_def_tot +
            f.num_def_mrk +
            f.num_def_sta +
            f.num_def_slt +
            f.num_phy
        ) / 5.0 AS scr_def_jogador
    FROM dw.fat_ply_sts f
),
defesa_time AS (
    SELECT
        t.nom_tim,
        AVG(d.scr_def_jogador) AS avg_defesa_time
    FROM defesa_jogador d
    JOIN dw.dim_tim t ON d.srk_tim = t.srk_tim
    GROUP BY t.nom_tim
)
SELECT
    nom_tim,
    ROUND(avg_defesa_time, 2) AS avg_defesa_time
FROM defesa_time
ORDER BY avg_defesa_time DESC;

-- --------------------------------------------------------------------------
-- 12. (CTE) . Dependência salarial em relação ao desempenho
-- Pergunta de negócio:
-- Quais times apresentam maior dependência salarial em relação ao desempenho
-- técnico de seus jogadores, considerando salário total e overall médio?
-- --------------------------------------------------------------------------

WITH cte_salario_desempenho AS (
    SELECT
        t.nom_tim,
        SUM(f.vlr_wag) AS vlr_salario_total,
        AVG(f.num_ovr) AS avg_overall
    FROM dw.fat_ply_sts f
    JOIN dw.dim_tim t ON f.srk_tim = t.srk_tim
    GROUP BY t.nom_tim
),
cte_dependencia AS (
    SELECT
        nom_tim,
        vlr_salario_total,
        avg_overall,
        vlr_salario_total / NULLIF(avg_overall, 0) AS idx_dependencia_salarial
    FROM cte_salario_desempenho
)
SELECT
    nom_tim,
    ROUND(vlr_salario_total, 2) AS vlr_salario_total,
    ROUND(avg_overall, 2)       AS avg_overall,
    ROUND(idx_dependencia_salarial, 2) AS idx_dependencia_salarial
FROM cte_dependencia
ORDER BY idx_dependencia_salarial DESC;
