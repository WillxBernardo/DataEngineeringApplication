# Arquitetura de Engenharia de Dados com Arquitetura Medalhão

---

## 👥 Integrantes do Projeto

| Nome do Aluno | Matrícula |
|--------------|-----------|
| William Bernardo da Silva | 222021933 |
|  Mateus Henrique Queiroz Magalhães Sousa | 222025950 |

---

## 📌 Introdução

Este projeto foi desenvolvido como parte da disciplina **Bancos de Dados II** e tem como objetivo a construção de uma **arquitetura de engenharia de dados voltada para análise**, utilizando o padrão conhecido como **Arquitetura Medalhão** (Bronze, Silver e Gold).

A arquitetura proposta organiza os dados em diferentes camadas de maturidade, permitindo maior controle de qualidade, rastreabilidade e confiabilidade das informações ao longo do pipeline de dados.

O projeto utiliza **Jupyter Notebooks** como principal ferramenta para:

- Análise exploratória e verificação da qualidade dos dados na camada **Raw/Bronze**
- Tratamento, limpeza e padronização dos dados
- Transformação e ingestão dos dados na camada **Silver**
- Visualização de dados e apoio à análise

Além disso, o armazenamento dos dados é realizado em um banco **PostgreSQL**, executado em ambiente **Docker**, garantindo portabilidade e facilidade de configuração do ambiente de desenvolvimento.

---

## 🏗️ Arquitetura do Projeto

A arquitetura segue o padrão **Medalhão**, composta pelas seguintes camadas:

### 🥉 Camada Bronze (Raw)
- Dados brutos, sem tratamento
- Fonte original do dataset
- Utilizada para análise inicial de qualidade dos dados
- Armazenamento conforme ingerido

### 🥈 Camada Silver
- Dados tratados e padronizados
- Remoção de valores nulos e inconsistentes
- Padronização de tipos e formatos
- Dados persistidos no banco PostgreSQL
- Ingestão realizada via **Jupyter Notebook**

### 🥇 Camada Gold (conceitual)
- Camada destinada a análises finais e agregações
- Base para consumo analítico (dashboards e relatórios)
- Não é o foco principal deste trabalho, mas faz parte da arquitetura proposta

---

## 🧪 Tecnologias Utilizadas

- **Python 3**
- **Jupyter Notebook**
- **Pandas / NumPy**
- **Matplotlib / Seaborn**
- **PostgreSQL**
- **Docker e Docker Compose**
- **Git**

---

## ⚙️ Preparação do Ambiente de Desenvolvimento

### 🔹 1. Clonar o Repositório

```bash
git clone <url-do-repositorio>
cd <nome-do-repositorio>
```

### 🔹 2. Criar um Ambiente Virtual Python

Recomenda-se o uso de um ambiente virtual para isolamento das dependências do projeto.

```bash
python3 -m venv .venv
```

Ativar o ambiente virtual:

- Linux / macOS

```bash
source venv/bin/activate
```

- Windows

```bash
venv\Scripts\activate
```

### 🔹 3. Instalar as Dependências

Com o ambiente virtual ativado, instale as bibliotecas necessárias:

```bash
pip install -r requirements.txt
```

### 🔹 4. Subir o Banco de Dados PostgreSQL com Docker Compose

O projeto utiliza um banco PostgreSQL configurado via Docker Compose.

Certifique-se de ter o **Docker** e o **Docker Compose** instalados.

Para subir os serviços, execute:

```bash
docker compose up -d
```

Após a execução, o banco PostgreSQL estará disponível conforme as configurações definidas no arquivo `docker-compose.yml`.