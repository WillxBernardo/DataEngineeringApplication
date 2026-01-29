# Padronização de Nomenclatura (Mnemônicos) – FIFA 21

Este documento define as regras estritas de abreviação (3 letras) aplicadas ao **Data Warehouse FIFA 21**, no schema `dw`, seguindo boas práticas de modelagem dimensional (Star Schema).

---

## 1. Tipos de Dados (Prefixos)

Define o início do nome da coluna, indicando o tipo de dado armazenado.

| Mnemônico | Significado | Exemplo |
| :--- | :--- | :--- |
| **srk** | Surrogate Key (PK/FK) | `srk_ply` |
| **cod** | Código Original | `cod_ply` |
| **nom** | Nome / Descrição Curta | `nom_tim` |
| **txt** | Texto Longo | `txt_nam_lng` |
| **dat** | Data | `dat_joi` |
| **num** | Número Inteiro / Métrica | `num_ovr` |
| **vlr** | Valor Monetário | `vlr_mkt` |

---

## 2. Entidades (Contexto Principal)

Define o assunto macro da tabela. Compõe o nome da tabela (`dim_XXX`, `fat_XXX`).

| Mnemônico | Significado | Contexto |
| :--- | :--- | :--- |
| **dw** | Data Warehouse | Schema |
| **dim** | Dimensão | Tabela dimensão |
| **fat** | Fato | Tabela Fato |
| **ply** | Player | Jogador |
| **tim** | Team | Time |
| **pos** | Position | Posição |
| **sts** | Status | Estado do jogador (contrato/time) |

---

## 3. Qualificadores (Sufixos)

Define o detalhe específico da coluna. Usado para completar o nome (`nom_XXX`, `num_XXX`).

| Mnemônico | Significado | Exemplo |
| :--- | :--- | :--- |
| **lng** | Longo | `txt_nam_lng` |
| **sht** | Curto | `nom_nam_sht` |
| **age** | Idade | `num_age` |
| **hgt** | Altura | `num_hgt` |
| **wgt** | Peso | `num_wgt` |
| **nat** | Nacionalidade | `nom_nat` |
| **fot** | Pé Preferido | `nom_fot` |
| **ovr** | Overall | `num_ovr` |
| **pot** | Potencial | `num_pot` |
| **bst** | Melhor | `num_bst_ovr` |
| **gro** | Crescimento | `num_gro` |
| **tot** | Total | `num_tot` |
| **bas** | Base | `num_bas` |
| **hit** | Popularidade | `num_hit` |
| **mkt** | Mercado | `vlr_mkt` |
| **wag** | Salário | `vlr_wag` |
| **rel** | Rescisão | `vlr_rel` |
| **joi** | Entrada (Join) | `dat_joi` |
| **str** | Início | `num_str_yr` |
| **end** | Fim | `num_end_yr` |

### 3.1 Qualificadores de Grupos Técnicos (Atributos FIFA)

 Mnemônico | Significado | Exemplo |
| :--- | :--- | :--- |
| **att** | Attacking | `num_att_fin` |
| **skl** | Skill | `num_skl_dri` |
| **mov** | Movement | `num_mov_acc` |
| **pow** | Power | `num_pow_sht` |
| **men** | Mentality | `num_men_vis` |
| **def** | Defending | `num_def_sta` |
| **gkp** | Goalkeeping | `num_gkp_ref` |

## 4. Estrutura das Tabelas

### 4.1 Dimensão Jogador (`dw.dim_ply`)

| Coluna | Tipo | Descrição |
| :--- | :--- | :--- |
| `srk_ply` | INTEGER | Chave surrogate do jogador |
| `cod_ply` | INTEGER | ID original do jogador |
| `txt_nam_lng` | TEXT | Nome completo |
| `nom_nam_sht` | VARCHAR(100) | Nome curto |
| `num_age` | INTEGER | Idade |
| `num_hgt` | INTEGER | Altura (cm) |
| `num_wgt` | INTEGER | Peso (kg) |
| `nom_fot` | VARCHAR(10) | Pé preferido |
| `num_wkf` | INTEGER | Pé fraco |
| `num_skm` | INTEGER | Skill moves |
| `num_rep` | INTEGER | Reputação Internacional |
| `nom_nat` | VARCHAR(50) | Nacionalidade |

---

### 4.2 Dimensão Time (`dw.dim_tim`)

| Coluna | Tipo | Descrição |
| :--- | :--- | :--- |
| `srk_tim` | INTEGER | Chave surrogate do time |
| `nom_tim` | VARCHAR(100) | Nome do time |

---

### 4.3 Dimensão Posição (`dw.dim_pos`)

| Coluna | Tipo | Descrição |
| :--- | :--- | :--- |
| `srk_pos` | INTEGER | Chave surrogate da posição |
| `nom_pos` | VARCHAR(50) | Posições possíveis |
| `nom_pos_bst` | VARCHAR(10) | Melhor posição |

---

### 4.4 Fato Status do Jogador (`dw.fat_ply_sts`)

Tabela que representa **o estado do jogador em um time**, incluindo métricas técnicas, financeiras e contratuais.

| Coluna | Tipo | Descrição |
| :--- | :--- | :--- |
| `srk_ply_sts` | INTEGER | PK da tabela fato |
| `srk_ply` | INTEGER | FK → dim_ply |
| `srk_tim` | INTEGER | FK → dim_tim |
| `srk_pos` | INTEGER | FK → dim_pos |

---

#### Métricas Principais

| Coluna | Descrição |
| :--- | :--- |
| `num_ovr` | Overall |
| `num_pot` | Potencial |
| `num_bst_ovr` | Melhor overall |
| `num_gro` | Crescimento |
| `num_tot` | Total de atributos |
| `num_bas` | Base de atributos |
| `num_hit` | Taxa de eficiência dos chutes a gol |

---

#### Métricas Financeiras

| Coluna | Descrição |
| :--- | :--- |
| `vlr_mkt` | Valor de mercado |
| `vlr_wag` | Salário |
| `vlr_rel` | Cláusula de rescisão |

---

#### Informações Contratuais

| Coluna | Descrição |
| :--- | :--- |
| `num_str_yr` | Ano início contrato |
| `num_end_yr` | Ano fim contrato |
| `dat_joi` | Data de entrada no time |

---

#### Atributos Principais

| Coluna | Significado |
|------|-----------|
| `num_pac` | Pace |
| `num_sho` | Shooting |
| `num_pas` | Passing |
| `num_dri` | Dribbling |
| `num_def` | Defending |
| `num_phy` | Physical |

---

### Attacking

| Coluna | Significado |
|------|-----------|
| `num_att_tot` | Attacking total |
| `num_att_crs` | Crossing |
| `num_att_fin` | Finishing |
| `num_att_hed` | Heading accuracy |
| `num_att_pas` | Short passing |
| `num_att_vol` | Volleys |

---

### Skill

| Coluna | Significado |
|------|-----------|
| `num_skl_tot` | Skill total |
| `num_skl_dri` | Dribbling |
| `num_skl_cur` | Curve |
| `num_skl_fka` | Free kick accuracy |
| `num_skl_lps` | Long passing |
| `num_skl_ctl` | Ball control |

---

### Movement

| Coluna | Significado |
|------|-----------|
| `num_mov_tot` | Movement total |
| `num_mov_acc` | Acceleration |
| `num_mov_spr` | Sprint speed |
| `num_mov_agi` | Agility |
| `num_mov_rea` | Reactions |
| `num_mov_bal` | Balance |

---

### Power

| Coluna | Significado |
|------|-----------|
| `num_pow_tot` | Power total |
| `num_pow_sht` | Shot power |
| `num_pow_jmp` | Jumping |
| `num_pow_sta` | Stamina |
| `num_pow_str` | Strength |
| `num_pow_lsh` | Long shots |

---

### Mentality


| Coluna | Significado |
|------|-----------|
| `num_men_tot` | Mentality total |
| `num_men_agg` | Aggression |
| `num_men_int` | Interceptions |
| `num_men_pos` | Positioning |
| `num_men_vis` | Vision |
| `num_men_pen` | Penalties |
| `num_men_cmp` | Composure |

---

### Defending

| Coluna | Significado |
|------|-----------|
| `num_def_tot` | Defending total |
| `num_def_mrk` | Marking |
| `num_def_sta` | Standing tackle |
| `num_def_slt` | Sliding tackle |

---

### Goalkeeping

| Coluna | Significado |
|------|-----------|
| `num_gkp_tot` | Goalkeeping total |
| `num_gkp_div` | Diving |
| `num_gkp_han` | Handling |
| `num_gkp_kic` | Kicking |
| `num_gkp_pos` | Positioning |
| `num_gkp_ref` | Reflexes |


