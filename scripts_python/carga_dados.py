import pandas as pd
from sqlalchemy import create_engine
import os

url_banco = 'postgresql://postgres:suasenha@localhost:5432/ecommerce_olist'
engine = create_engine(url_banco)

arquivos_tabelas = {
    'olist_customers_dataset.csv': 'customers',
    'olist_orders_dataset.csv': 'orders',
    'olist_products_dataset.csv': 'products',
    'olist_order_items_dataset.csv': 'order_items'
}


pasta_dados = 'data'


for arquivo, nome_tabela in arquivos_tabelas.items():
    caminho_completo = os.path.join(pasta_dados, arquivo)
    
    print(f"Lendo arquivo: {arquivo}...")
    df = pd.read_csv(caminho_completo)
    
    print(f" Enviando para o PostgreSQL na tabela: {nome_tabela}...")
   
    df.to_sql(name=nome_tabela, con=engine, if_exists='replace', index=False)
    
    print(f"Tabela {nome_tabela} carregada com sucesso!\n")

print(" Carga de todos os dados finalizada!")