-- Top 10 produtos mais vendidos (quantidade)
USE sales_analytics;

SELECT
    p.nome AS produto,
    p.categoria,
    SUM(ip.quantidade) AS quantidade_vendida
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN pedidos pe ON pe.id_pedido = ip.id_pedido
WHERE pe.status <> 'Cancelado'
GROUP BY p.id_produto, p.nome, p.categoria
ORDER BY quantidade_vendida DESC
LIMIT 10;


--  Top 10 produtos por faturamento
USE sales_analytics;

SELECT
    p.nome AS produto,
    p.categoria,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN pedidos pe ON pe.id_pedido = ip.id_pedido
WHERE pe.status <> 'Cancelado'
GROUP BY p.id_produto, p.nome, p.categoria
ORDER BY faturamento DESC
LIMIT 10;


-- Ticket médio por cliente
USE sales_analytics;

SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(pe.id_pedido) AS total_pedidos,
    ROUND(AVG(pe.valor_total), 2) AS ticket_medio,
    ROUND(SUM(pe.valor_total), 2) AS valor_total_gasto
FROM pedidos pe
JOIN clientes c ON c.id_cliente = pe.id_cliente
WHERE pe.status <> 'Cancelado'
GROUP BY c.id_cliente, c.nome
ORDER BY ticket_medio DESC;


--  Ticket médio geral da loja
USE sales_analytics;

SELECT
    ROUND(AVG(valor_total), 2) AS ticket_medio_geral,
    COUNT(*) AS total_pedidos_validos
FROM pedidos
WHERE status <> 'Cancelado';


-- Faturamento por funcionário (vendedor)
USE sales_analytics;

SELECT
    f.matricula,
    f.nome AS funcionario,
    f.cargo,
    COUNT(pe.id_pedido) AS total_pedidos,
    ROUND(SUM(pe.valor_total), 2) AS faturamento_total,
    ROUND(AVG(pe.valor_total), 2) AS ticket_medio
FROM pedidos pe
JOIN funcionarios f ON f.id_funcionario = pe.id_funcionario
WHERE pe.status <> 'Cancelado'
GROUP BY f.id_funcionario, f.matricula, f.nome, f.cargo
ORDER BY faturamento_total DESC;


-- Faturamento por categoria de produto
USE sales_analytics;

SELECT
    p.categoria,
    SUM(ip.quantidade) AS unidades_vendidas,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN pedidos pe ON pe.id_pedido = ip.id_pedido
WHERE pe.status <> 'Cancelado'
GROUP BY p.categoria
ORDER BY faturamento DESC;


-- Faturamento mensal (série temporal)
USE sales_analytics;

SELECT
    DATE_FORMAT(data_pedido, '%Y-%m') AS mes,
    COUNT(*) AS total_pedidos,
    ROUND(SUM(valor_total), 2) AS faturamento
FROM pedidos
WHERE status <> 'Cancelado'
GROUP BY DATE_FORMAT(data_pedido, '%Y-%m')
ORDER BY mes;


--  Faturamento por estado do cliente
USE sales_analytics;

SELECT
    c.estado,
    COUNT(pe.id_pedido) AS total_pedidos,
    ROUND(SUM(pe.valor_total), 2) AS faturamento
FROM pedidos pe
JOIN clientes c ON c.id_cliente = pe.id_cliente
WHERE pe.status <> 'Cancelado'
GROUP BY c.estado
ORDER BY faturamento DESC;


-- Forma de pagamento mais utilizada
USE sales_analytics;

SELECT
    forma_pagamento,
    COUNT(*) AS total_pedidos,
    ROUND(SUM(valor_total), 2) AS faturamento,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM pedidos WHERE status <> 'Cancelado'), 2) AS percentual
FROM pedidos
WHERE status <> 'Cancelado'
GROUP BY forma_pagamento
ORDER BY total_pedidos DESC;


-- Taxa de cancelamento de pedidos
USE sales_analytics;

SELECT
    status,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM pedidos), 2) AS percentual
FROM pedidos
GROUP BY status
ORDER BY total DESC;


--  Top 10 clientes por quantidade de pedidos
USE sales_analytics;

SELECT
    c.nome AS cliente,
    c.cidade,
    c.estado,
    COUNT(pe.id_pedido) AS total_pedidos
FROM pedidos pe
JOIN clientes c ON c.id_cliente = pe.id_cliente
GROUP BY c.id_cliente, c.nome, c.cidade, c.estado
ORDER BY total_pedidos DESC
LIMIT 10;


--  Produtos com estoque baixo (abaixo de 15 unidades)
USE sales_analytics;

SELECT
    nome,
    categoria,
    marca,
    estoque
FROM produtos
WHERE ativo = TRUE
  AND estoque < 15
ORDER BY estoque ASC;


-- Tempo médio entre pedido e entrega (em dias)
USE sales_analytics;

SELECT
    ROUND(AVG(DATEDIFF(data_entrega, data_pedido)), 1) AS media_dias_entrega
FROM pedidos
WHERE status = 'Entregue'
  AND data_entrega IS NOT NULL;
  
  
-- Ranking de marcas por faturamento
USE sales_analytics;

SELECT
    p.marca,
    SUM(ip.quantidade) AS unidades_vendidas,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN pedidos pe ON pe.id_pedido = ip.id_pedido
WHERE pe.status <> 'Cancelado'
GROUP BY p.marca
ORDER BY faturamento DESC;


-- Clientes que compraram apenas uma vez (potencial de retenção)
USE sales_analytics;

SELECT
    c.nome AS cliente,
    c.email,
    COUNT(pe.id_pedido) AS total_pedidos
FROM pedidos pe
JOIN clientes c ON c.id_cliente = pe.id_cliente
GROUP BY c.id_cliente, c.nome, c.email
HAVING COUNT(pe.id_pedido) = 1;