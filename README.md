# Brazilian E-Commerce Analytics & Operations Dashboard

Projeto de engenharia e análise de dados utilizando o famoso dataset público da **Olist** (E-commerce brasileiro). O objetivo deste projeto é extrair insights estratégicos sobre faturamento, sazonalidade, comportamento de clientes por estado e eficiência logística (frete e prazos de entrega).

---

## 🛠️ Stack Tecnológica

* **Linguagem:** Python (Pandas, SQLAlchemy)[cite: 1, 2]
* **Banco de Dados:** PostgreSQL
* **Visualização:** Power BI (DAX, Modelagem de Dados, UI/UX)
* **Controle de Versão:** Git & GitHub

---

## Estrutura do Repositório

```text
├── dashboard/               # Contém o arquivo .pbix do Power BI e exports em PDF
├── scripts_python/          # Scripts de automação, criação do banco e consultas
│   ├── cria_banco.py        # Script para inicializar o banco PostgreSQL
│   ├── carga_dados.py       # Script de ETL para injetar os CSVs no banco
│   └── analise_dados.py     # Script de validação com Pandas e SQLAlchemy
└── sql/
    └── scripts_sql.sql      # Consultas avançadas de vendas, sazonalidade e logística

você pode baixar o dataset completo diretamente por este link oficial: (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
Kaggle: Brazilian E-Commerce Public Dataset by Olist

