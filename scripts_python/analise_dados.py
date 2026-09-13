import pandas as pd
from sqlalchemy import create_engine

url_banco = 'postgresql://postgres:SUASENHA@localhost:5432/ecommerce_olist'
engine = create_engine(url_banco)

#exemplo de query para consulta
query_sql = query_sql = """
WITH Vendas_Por_Pedido AS (
    SELECT 
        o.order_id,
        o.customer_id,
        SUM(oi.price) AS valor_produtos
    FROM 
        orders o
    INNER JOIN 
        order_items oi ON o.order_id = oi.order_id
    WHERE 
        o.order_status = 'delivered'
    GROUP BY 
        o.order_id, o.customer_id
)
SELECT 
    c.customer_state AS estado,
    COUNT(v.order_id) AS total_pedidos,
    ROUND(AVG(v.valor_produtos)::numeric, 2) AS ticket_medio
FROM 
    Vendas_Por_Pedido v
INNER JOIN 
    customers c ON v.customer_id = c.customer_id
GROUP BY 
    c.customer_state
ORDER BY 
    ticket_medio DESC;

"""

print(" Consultando o banco de dados...")

#resultado em uma tabela (DataFrame)
df_resultado = pd.read_sql(query_sql, engine)

print("\n Resultado da consulta:")
print(df_resultado.to_string(index=False))