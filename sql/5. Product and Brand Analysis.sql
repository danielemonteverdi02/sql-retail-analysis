/* 1) Prodotti più venduti */

SELECT p.product_id, p.product_name, SUM(oi.quantity) AS quantita_venduta
FROM products p 
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY quantita_venduta DESC;

/* 2) Prodotti più redditizi */

SELECT p.product_id, p.product_name, ROUND(SUM(oi.quantity * oi.list_price * (1-oi.discount)), 2) AS fatturato
FROM products p 
INNER JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY p.product_id, p.product_name
ORDER BY fatturato DESC;

/* 3) Prodotti con alto volume di vendite ma basso fatturato */

WITH product_stats AS (
    SELECT p.product_id, p.product_name, SUM(oi.quantity) AS volume_vendite, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS fatturato
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
)

SELECT *
FROM product_stats
WHERE volume_vendite > (SELECT AVG(volume_vendite) 
						FROM product_stats)
	AND fatturato < (SELECT AVG(fatturato) 
					 FROM product_stats)
ORDER BY volume_vendite DESC;

/* 4) Sconto medio per prodotto */

SELECT oi.product_id,p.product_name, ROUND(AVG(oi.discount), 2) AS sconto_medio
FROM order_items oi 
INNER JOIN products p ON oi.product_id = p.product_id 
GROUP BY oi.product_id, p.product_name
ORDER BY sconto_medio DESC;

/* 5) Performance brand */

SELECT b.brand_id, b.brand_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS fatturato, 
	   COUNT(DISTINCT(oi.order_id)) AS numero_ordini, SUM(oi.quantity) AS quantita_venduta
FROM brands b 
INNER JOIN products p ON b.brand_id = p.brand_id 
INNER JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY b.brand_id, b.brand_name
ORDER BY fatturato DESC;

/* 6) Prodotti presenti nel maggior numero di ordini */

SELECT oi.product_id, p.product_name, COUNT(DISTINCT(oi.order_id)) AS numero_ordini, SUM(oi.quantity) AS quantita_totale
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY numero_ordini DESC;

/* 7) Categoria con più quantità venduta */

SELECT c.category_id, c.category_name, SUM(oi.quantity) AS quantita_venduta
FROM categories c 
INNER JOIN products p ON c.category_id = p.category_id 
INNER JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY c.category_id, c.category_name 
ORDER BY quantita_venduta DESC;