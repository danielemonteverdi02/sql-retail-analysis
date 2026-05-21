/* 1) Elenco negozi*/

SELECT s.store_name 
FROM stores s; 

/* 2) Info staff  */

SELECT s.first_name, s.last_name, s.email, s.phone 
FROM staffs s;

/* 3) Clienti per città */

SELECT c.customer_id, c.first_name, c.phone, c.city 
FROM customers c 
WHERE c.city = 'New York';

/* 4) Prodotti con prezzo > 1000 */

SELECT p.product_id, p.product_name, p.list_price 
FROM products p 
WHERE p.list_price > 1000;

/* 5) Numero clienti per città */

SELECT c.city, COUNT(c.customer_id) AS numero_clienti
FROM customers c
GROUP BY c.city;

/* 6) Prezzo medio prodotti */

SELECT ROUND(AVG(p.list_price), 2) AS prezzo_medio
FROM products p;

/* 7) Prodotto più costoso */

SELECT p.product_id, p.product_name, p.list_price 
FROM products p
ORDER BY p.list_price DESC
LIMIT 1;
					  
/* 8) Numero totale ordini */

SELECT COUNT(o.order_id) AS numero_ordini
FROM orders o;

/* 9) Ordini per stato */

SELECT o.order_status, COUNT(o.order_id) AS numero_ordini
FROM orders o
GROUP BY o.order_status;