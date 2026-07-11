USE sales_analytics;

SELECT
    p.id_pedido,
    p.valor_total,
    ROUND(SUM(ip.quantidade * ip.preco_unitario) - p.desconto + p.frete, 2) AS valor_calculado
FROM pedidos p
JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.valor_total, p.desconto, p.frete
HAVING ABS(p.valor_total - valor_calculado) > 0.01;