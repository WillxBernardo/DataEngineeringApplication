# Dicionário de Mnemônicos – Gold Layer (FIFA 21 Players)

Este documento define todas as abreviações, convenções de nomenclatura e estrutura do **Star Schema da camada Gold** para o dataset **FIFA 21 Players**.

---

## 1. Abreviações de Tabelas

| Abreviação | Significado | Tabela Completa |
|-----------|-------------|-----------------|
| `ply` | **Ply**ayer (Jogador) | `dim_ply` |
| `tm` | **T**ea**m** (Time) | `dim_tm` |
| `pos` | **Pos**ição | `dim_pos` |
| `fts` | **F**a**t**o **S**tats | `fat_ply_stats` |

---

## 2. Prefixos de Tabelas

| Prefixo | Significado | Exemplo |
|--------|-------------|---------|
| `dim_` | **Dim**ensão | `dim_ply`, `dim_tm`, `dim_pos` |
| `fat_` | **F**ac**t** (tabela fato) | `fat_ply_stats` |
| `vw_` | **V**ie**w** analítica | `vw_player_performance` |
| `idx_` | Índice | `idx_ply_nationality` |

---

## 3. Sufixos de Chaves

| Sufixo | Significado | Uso |
|------|-------------|-----|
| `_key` | **Key** – Chave primária surrogate | Dimensões |
| `_srk` | **S**urrogate **R**eference **K**ey | FKs na tabela fato |

**Exemplos:**
- `ply_key` – PK da dimensão jogador  
- `ply_srk` – FK na fato referenciando `dim_ply(ply_key)`

---

## 4. Abreviações de Colunas

| Abreviação | Significado |
|-----------|-------------|
| `nr` | Número |
| `cm` | Centímetros |
| `kg` | Quilogramas |
| `eur` | Euro |
| `gk` | Goalkeeper |
| `att` | Attacking |
| `def` | Defending |

---

## 5. Estrutura das Tabelas

---

### 5.1 Dimensão Jogador (`dim_ply`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `ply_key` | SERIAL | Chave primária surrogate |
| `player_id` | INTEGER | ID original do jogador |
| `long_name` | TEXT | Nome completo |
| `name` | VARCHAR(100) | Nome curto |
| `age` | INTEGER | Idade |
| `height_cm` | INTEGER | Altura em cm |
| `weight_kg` | INTEGER | Peso em kg |
| `preferred_foot` | VARCHAR(10) | Pé dominante |
| `weak_foot` | INTEGER | Qualidade do pé fraco |
| `skill_moves` | INTEGER | Nível de habilidade |
| `international_reputation` | INTEGER | Reputação internacional |
| `nationality` | VARCHAR(50) | Nacionalidade |

---

### 5.2 Dimensão Time (`dim_tm`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `tm_key` | SERIAL | Chave primária surrogate |
| `team` | VARCHAR(100) | Nome do time |
| `contract_start_year` | INTEGER | Ano de início do contrato |
| `contract_end_year` | INTEGER | Ano de término do contrato |
| `joined_date` | DATE | Data de entrada no time |

---

### 5.3 Dimensão Posição (`dim_pos`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `pos_key` | SERIAL | Chave primária surrogate |
| `position_id` | INTEGER | ID da posição |
| `positions` | VARCHAR(50) | Posições possíveis |
| `best_position` | VARCHAR(10) | Melhor posição |

---

### 5.4 Fato Status Player (`fat_ply_stats`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `fts_key` | SERIAL | Chave primária surrogate |
| `ply_srk` | INTEGER | FK para `dim_ply` |
| `tm_srk` | INTEGER | FK para `dim_tm` |
| `pos_srk` | INTEGER | FK para `dim_pos` |

---

#### Ratings Gerais

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `overall_rating` | INTEGER | Overall atual |
| `potential_rating` | INTEGER | Potencial |
| `best_overall_rating` | INTEGER | Melhor overall |
| `growth` | INTEGER | Crescimento |
| `total_stats` | INTEGER | Total de atributos |
| `base_stats` | INTEGER | Base de atributos |
| `hits` | INTEGER | Popularidade |

---

#### Valores Financeiros

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `value_eur` | NUMERIC(12,2) | Valor de mercado |
| `wage_eur` | NUMERIC(10,2) | Salário |
| `release_clause_eur` | NUMERIC(12,2) | Cláusula de rescisão |

---

#### Atributos Principais

| Coluna |
|------|
| `pace` |
| `shooting` |
| `passing` |
| `dribbling_stat` |
| `defending_stat` |
| `physical` |

---

#### Grupos de Atributos

Os grupos seguem o padrão:
- `<grupo>_total`
- atributos individuais do grupo

**Attacking**
- `attacking_total`
- `crossing`
- `finishing`
- `heading_accuracy`
- `short_passing`
- `volleys`

**Skill**
- `skill_total`
- `dribbling`
- `curve`
- `fk_accuracy`
- `long_passing`
- `ball_control`

**Movement**
- `movement_total`
- `acceleration`
- `sprint_speed`
- `agility`
- `reactions`
- `balance`

**Power**
- `power_total`
- `shot_power`
- `jumping`
- `stamina`
- `strength`
- `long_shots`

**Mentality**
- `mentality_total`
- `aggression`
- `interceptions`
- `positioning`
- `vision`
- `penalties`
- `composure`

**Defending**
- `defending_total`
- `marking`
- `standing_tackle`
- `sliding_tackle`

**Goalkeeping**
- `goalkeeping_total`
- `gk_diving`
- `gk_handling`
- `gk_kicking`
- `gk_positioning`
- `gk_reflexes`

---

## 6. Views Analíticas

| View | Descrição |
|----|-----------|
| `vw_player_overall` | Estatísticas gerais por jogador |
| `vw_top_players` | Top jogadores por overall |
| `vw_player_value` | Análise de valor vs performance |
| `vw_team_strength` | Força agregada por time |
| `vw_position_analysis` | Performance média por posição |

---

## 7. Convenções Gerais

1. **Snake_case** em todos os identificadores  
2. **Português sem acentos** para colunas de negócio  
3. **Inglês** para termos técnicos (`rating`, `overall`, `key`)  
4. **Chaves surrogate** obrigatórias na Gold   
6. **Dimensões com atributos descritivos**  
7. **Valores monetários sempre em EUR**

---

## 8. Diagrama do Star Schema

        +-----------------------+          +-----------------------+
        |       dim_ply         |          |        dim_tm         |
        +-----------------------+          +-----------------------+
        | plyr_key (PK)         |          | tm_key (PK)           |
        | player_id             |          | team_id               |
        | long_name             |          | team_name             |
        | name                  |          | contract_period       |
        | age                   |          | joined_date           |
        | height_cm             |          +-----------+-----------+
        | weight_kg             |                      |
        | preferred_foot        |                      |
        | nationality           |                      | tm_srk (FK)
        +-----------+-----------+                      |
                    |                                  v
                    | ply _srk (FK)        +-----------------------+
                    |                      |     ft_ply_stats      |
                    +--------------------->+-----------------------+
                                           | fts_key (PK)          |
        +-----------------------+          | plyr_srk (FK)         |
        |       dim_pos         |          | tm_srk (FK)           |
        +-----------------------+          | pos_srk (FK)          |
        | pos_key (PK)          |          |-----------------------|
        | position_id           |          | overall_rating        |
        | positions             |          | potential_rating      |
        | best_position         |          | value_eur             |
        +-----------+-----------+          | wage_eur              |
                    |                      | release_clause_eur    |
                    | pos_srk (FK)         |-----------------------|
                    +--------------------->| pace, shooting        |
                                           | passing, dribbling    |
                                           | defending, physical   |
                                           +-----------------------+