/* 1) Stock totale per prodotto */

SELECT s.product_id, SUM(s.quantity) AS stock_totale
FROM stocks s 
GROUP BY s.product_id;

/* 2) Stock basso */

SELECT s.product_id, SUM(s.quantity) AS stock_totale
FROM stocks s 
GROUP BY s.product_id
HAVING stock_totale < 20;

/* 3) Stock sotto la media */

WITH stock AS(
	SELECT s.product_id, SUM(s.quantity) AS stock_tot
	FROM stocks s
	GROUP BY s.product_id)

SELECT *
FROM stock  
WHERE stock_tot < (SELECT AVG(stock_tot) 
					FROM stock);

/* 4) Stock vs vendite (analisi rischio esaurimento stock) */
					
WITH stock_disponibile AS (
	SELECT s.product_id, SUM(s.quantity) AS stock
	FROM stocks s 
	GROUP BY s.product_id),
	quantita_venduta AS (
	SELECT oi.product_id, SUM(OI.quantity) AS quant_venduta
	FROM order_items oi 
	GROUP BY oi.product_id)

SELECT sd.product_id, stock, quant_venduta
FROM stock_disponibile sd
INNER JOIN quantita_venduta qv ON sd.product_id = qv.product_id;
