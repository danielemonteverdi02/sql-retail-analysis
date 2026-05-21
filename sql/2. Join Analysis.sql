/* 1) Ordini con cliente */

SELECT o.order_id, c.first_name, c.last_name
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.customer_id;

/* 2) Ordini con store */

SELECT o.order_id, s.store_name, s.city 
FROM orders o 
INNER JOIN stores s ON o.store_id = s.store_id;

/* 3) Prodotti con categoria */

SELECT p.product_name, c.category_name, p.list_price 
FROM products p 
INNER JOIN categories c ON p.category_id = c.category_id;

/* 4) Prodotti con brand */

SELECT p.product_name, b.brand_name, p.list_price 
FROM products p 
INNER JOIN brands b ON p.brand_id = b.brand_id;

/* 5) Ordini con staff e cliente */

SELECT o.order_id, o.order_status, s.first_name AS staff_name, 
	   s.last_name AS staff_last_name, c.first_name AS cust_name, c.last_name AS cust_last_name
FROM orders o 
INNER JOIN staffs s ON o.staff_id = s.staff_id 
INNER JOIN customers c ON o.customer_id = c.customer_id; 
