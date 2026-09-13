from sqlalchemy import create_engine, text

# 1. Conecta ao banco de dados 
url_padrao = 'postgresql://postgres:SUASENHA@localhost:5432/postgres'
engine = create_engine(url_padrao, isolation_level="AUTOCOMMIT")

# 2. Executa o comando SQL para criar o novo banco
with engine.connect() as conexao:
    conexao.execute(text("CREATE DATABASE ecommerce_olist"))

print("Banco de dados 'ecommerce_olist' criado com sucesso!")