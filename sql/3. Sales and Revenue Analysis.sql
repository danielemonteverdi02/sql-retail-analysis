/* 1) Fatturato per ordine */

SELECT oi.order_id, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato
FROM order_items oi  
GROUP BY oi.order_id;

/* 2) Fatturato per store */

SELECT s.store_id, s.store_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato
FROM order_items oi 
INNER JOIN orders o ON oi.order_id = o.order_id 
INNER JOIN stores s ON o.store_id = s.store_id 
GROUP BY s.store_id, s.store_name;

/* 3) Fatturato per categoria di prodotto */

SELECT c.category_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato
FROM products p 
INNER JOIN order_items oi ON p.product_id  = oi.product_id 
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY fatturato DESC;

/* 4) Miglior venditore (staff con più vendite) */

SELECT s.staff_id, s.first_name, s.last_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS vendite
FROM staffs s 
INNER JOIN orders o ON s.staff_id = o.staff_id 
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY vendite DESC
LIMIT 1;

/* 5) Top 5 prodotti per quantità venduta */

SELECT p.product_id, p.product_name, SUM(oi.quantity) AS quantità_venduta
FROM products p 
INNER JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY p.product_id, p.product_name  
ORDER BY quantità_venduta DESC
LIMIT 5;

/* 6) Top 10 clienti per spesa */

SELECT c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS spesa
FROM customers  c 
INNER JOIN orders o ON c.customer_id = o.customer_id 
INNER JOIN order_items oi ON o.order_id = oi.order_id 
GROUP BY c.first_name, c.last_name
ORDER BY spesa DESC
LIMIT 10;

/* 7) Store con più vendite */

SELECT s.store_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS vendite_totali
FROM stores s 
INNER JOIN orders o ON o.store_id = s.store_id 
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name 
ORDER BY vendite_totali DESC
LIMIT 1;

/* 8) Valore medio per ordine (AOV)?   */

WITH valore_ordini AS (
	SELECT oi.order_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS val_ordini
	FROM order_items oi 
	INNER JOIN orders o ON oi.order_id = o.order_id
	GROUP BY oi.order_id)

SELECT ROUND(AVG(val_ordini), 2) AS AOV
FROM valore_ordini;

/* 9) Ordini per store */

SELECT s.store_id, s.store_name, COUNT(o.order_id) AS numero_ordini
FROM orders o
INNER JOIN stores s ON o.store_id = s.store_id
GROUP BY s.store_id, s.store_name
ORDER BY numero_ordini DESC;

/* 10) AOV per store */

WITH store_stats AS (
    SELECT o.store_id, o.order_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS valore_ordine
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.store_id, o.order_id
)

SELECT s.store_id, s.store_name, ROUND(AVG(valore_ordine), 2) AS ticket_medio
FROM store_stats ss
JOIN stores s ON ss.store_id = s.store_id
GROUP BY s.store_id, s.store_name;
