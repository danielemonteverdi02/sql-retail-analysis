/* 1) Fatturato giornaliero */

SELECT o.order_date, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato
FROM orders o 
INNER JOIN order_items oi ON o.order_id = oi.order_id 
GROUP BY o.order_date;

/* 2) Giorno con il fatturato più alto */

SELECT o.order_date, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato
FROM orders o 
INNER JOIN order_items oi ON o.order_id = oi.order_id 
GROUP BY o.order_date
ORDER BY fatturato DESC
LIMIT 1;

/* 3) Fatturato mensile */

SELECT strftime('%Y', order_date) || '-' || strftime('%m', order_date) AS periodo, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY periodo;

/* 43) Ordini per mese */

SELECT strftime('%Y-%m', order_date) AS mese, COUNT(order_id) AS numero_ordini
FROM orders
GROUP BY mese;

/* 49) Tempo medio di spedizione per store */

SELECT o.store_id, s.store_name, s.city, ROUND(AVG(julianday(o.shipped_date) - julianday(o.order_date)), 2) AS tempo_medio_spedizione
FROM orders o 
INNER JOIN stores s ON o.store_id = s.store_id 
WHERE o.shipped_date IS NOT NULL
GROUP BY o.store_id, s.store_name, s.city;
