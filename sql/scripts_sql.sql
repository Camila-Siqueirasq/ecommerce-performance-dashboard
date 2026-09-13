
--5 CATEGORIAS DE PRODUTOS MAIS VENDIDAS
-- Objetivo: Descobrir quais categorias de produtos geram a maior receita 
--           (faturamento bruto) para a empresa.
SELECT 
    p.product_category_name AS categoria,
    COUNT(oi.order_id) AS total_vendas,
    SUM(oi.price) AS faturamento_total
FROM 
    order_items oi
INNER JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    p.product_category_name IS NOT NULL
GROUP BY 
    p.product_category_name
ORDER BY 
    faturamento_total DESC
LIMIT 5;


-- EVOLUÇÃO DO FATURAMENTO MENSAL (SAZONALIDADE)
-- Objetivo: Acompanhar o crescimento das vendas ao longo do tempo, somando o 
--           valor do produto e do frete dos pedidos entregues.
SELECT 
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS mes_ano,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    SUM(oi.price + oi.freight_value) AS faturamento_bruto
FROM 
    orders o
INNER JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    o.order_status = 'delivered'
GROUP BY 
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
ORDER BY 
    mes_ano;


-- 3. TICKET MÉDIO E VOLUME DE PEDIDOS POR ESTADO
-- Objetivo: Identificar quanto cada cliente gasta, em média, por pedido em 
--           cada estado do Brasil, destacando os estados mais rentáveis.
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
    ROUND(AVG(v.valor_produtos), 2) AS ticket_medio
FROM 
    Vendas_Por_Pedido v
INNER JOIN 
    customers c ON v.customer_id = c.customer_id
GROUP BY 
    c.customer_state
ORDER BY 
    ticket_medio DESC;

-- 4. TAXA DE PEDIDOS ATRASADOS POR ESTADO
-- Objetivo: Avaliar a eficiência das entregas, calculando o percentual de 
--           pedidos que chegaram aos clientes após a data estimada.
WITH metricas_entrega AS (
    SELECT 
        c.customer_state AS estado,
        CASE 
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 
            ELSE 0 
        END AS atrasado
    FROM 
        orders o
    INNER JOIN 
        customers c ON o.customer_id = c.customer_id
    WHERE 
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
)
SELECT 
    estado,
    COUNT(*) AS total_pedidos,
    SUM(atrasado) AS qtd_atrasados,
    ROUND((SUM(atrasado)::numeric / COUNT(*)) * 100, 2) AS percentual_atraso
FROM 
    metricas_entrega
GROUP BY 
    estado
ORDER BY 
    percentual_atraso DESC;


-- 5. ANÁLISE DE LOGÍSTICA (FRETE E TEMPO MÉDIO DE ENTREGA)
-- Objetivo: Descobrir o custo médio do frete e quantos dias os pedidos demoram 
--           para chegar, em média, em cada estado brasileiro.
SELECT 
    c.customer_state AS estado,
    ROUND(AVG(oi.freight_value), 2) AS frete_medio,
    ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)))::numeric, 1) AS dias_medio_entrega
FROM 
    orders o
INNER JOIN 
    customers c ON o.customer_id = c.customer_id
INNER JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    c.customer_state
ORDER BY 
    dias_medio_entrega DESC;