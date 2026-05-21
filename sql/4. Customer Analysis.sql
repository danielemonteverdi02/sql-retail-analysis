/* 1) Media articoli per ordine */

WITH articoli_per_ordine AS(
	SELECT SUM(oi.quantity) AS articoli_ordine
	FROM order_items oi
	GROUP BY oi.order_id)

SELECT ROUND(AVG(articoli_ordine), 2) AS avg_articoli_per_ordine
FROM articoli_per_ordine;

/* 2) Ordini mai spediti */

SELECT o.order_id, p.product_name
FROM order_items oi 
INNER JOIN orders o ON oi.order_id = o.order_id 
INNER JOIN products p ON oi.product_id = p.product_id 
WHERE o.shipped_date IS NULL;

/* 3) Clienti inattivi */

SELECT p.product_name, p.list_price 
FROM products p 
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

/* 4) Numero ordini per cliente */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT o.order_id) AS numero_ordini
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/* 5) Clienti con almeno 2 ordini */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS numero_ordini
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING numero_ordini  >= 2;

/* 6) Spesa totale e numero ordini per cliente */

WITH ordini_cliente AS (
    SELECT o.customer_id, o.order_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS valore_ordine
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id, o.order_id)

SELECT c.customer_id, c.first_name, c.last_name, SUM(oc.valore_ordine) AS spesa_totale, COUNT(oc.order_id) AS numero_ordini
FROM customers c
LEFT JOIN ordini_cliente oc ON c.customer_id = oc.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/* 7) Numero di clienti unici per store */

SELECT s.store_id, s.store_name, COUNT(c.customer_id) AS numero_clienti
FROM customers c 
INNER JOIN orders o ON c.customer_id = o.customer_id 
INNER JOIN stores s ON o.store_id = s.store_id 
GROUP BY s.store_id, s.store_name 
ORDER BY numero_clienti DESC;