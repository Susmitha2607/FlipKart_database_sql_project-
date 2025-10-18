

-- 1.Retrieve all products along with their total sales revenue from completed orders.--

    SELECT 
    p.product_id,
    p.product_name,
    COALESCE(SUM(s.quantity * s.price_per_unit), 0) AS total_revenue
FROM products p
LEFT JOIN sales s 
    ON p.product_id = s.product_id
   AND s.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;


--2.List all customers and the products they have purchased, showing only those who have ordered more than two products.--

SELECT c.customer_id, c.customer_name, p.product_name
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN products p ON s.product_id = p.product_id
JOIN (
    SELECT s.customer_id
    FROM sales s
    GROUP BY s.customer_id
    HAVING COUNT(s.product_id) > 2
) AS filtered ON c.customer_id = filtered.customer_id;

             --THE ABOVE QUERY DOES NOT COUNT DISTINCT PRODUCTS --
			        -- UNIQUE PRODUCT FOR THE CUSTOMER --

 SELECT c.customer_id, c.customer_name, p.product_name
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE c.customer_id IN (
    SELECT s.customer_id
    FROM sales s
    GROUP BY s.customer_id
    HAVING COUNT(DISTINCT s.product_id) > 2
);

-- 3.Find the total amount spent by customers in 'Gujarat' who have ordered products priced greater than 10,000.--

SELECT SUM(s.quantity*s.price_per_unit) AS total_Revenue 
FROM customers c JOIN sales s
ON c.customer_id=s.customer_id 
JOIN products p
ON s.product_id=p.product_id
WHERE c.state='Gujarat' AND  p.price>10000;

--4.Retrieve the list of all orders that have not yet been shipped.--

SELECT s.order_id, s.order_date, s.customer_id, s.product_id, s.quantity, s.price_per_unit,sh.delivery_status
FROM sales s
LEFT JOIN shippings sh 
       ON s.order_id = sh.order_id
WHERE sh.order_id IS NULL;



--5.Find the average order value per customer for orders with a quantity of more than 5.--

SELECT t.customer_id,c.customer_name,t.avg_order_value
FROM 
(SELECT 
    s.customer_id,
    AVG(s.quantity * s.price_per_unit) AS avg_order_value
FROM sales s
WHERE s.quantity > 5
GROUP BY s.customer_id) AS t
JOIN customers c 
ON t.customer_id=c.customer_id ;

--6.Get the top 5 customers by total spending on 'Accessories'--

SELECT c.customer_id,
       c.customer_name,
       SUM(s.quantity * s.price_per_unit) AS total_spending
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Accessories'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;

--7.Retrieve a list of customers who have not made any payment for their orders.--

SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
LEFT JOIN payment p ON s.order_id = p.order_id
WHERE p.payment_id IS NULL OR p.payment_status IN ('Payment Failed');

--8.Find the most popular product based on total quantity sold in 2023.--

SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_sold
FROM products p
JOIN sales s ON p.product_id = s.product_id
WHERE EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 1;

--9.List all orders that were cancelled and the reason for cancellation (if available).--

SELECT s.order_id, c.customer_name, s.order_status
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
WHERE s.order_status LIKE'Cancelled';

--10.Get the count of returned orders by shipping provider in 2023.--

SELECT sh.shipping_providers, COUNT(*) AS returned_orders
FROM shippings sh
LEFT JOIN sales s ON sh.order_id = s.order_id
WHERE ( sh.delivery_status IN ('Returned') OR sh.return_date IS NOT NULL)
  AND EXTRACT(YEAR FROM sh.shipping_date) = 2023
GROUP BY sh.shipping_providers
ORDER BY returned_orders DESC;

--11.Show the total revenue generated per month for the year 2023.--

SELECT TO_CHAR(s.order_date, 'YYYY-MM') AS month,
       SUM(s.quantity * s.price_per_unit) AS total_revenue
FROM sales s
WHERE EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY TO_CHAR(s.order_date, 'YYYY-MM')
ORDER BY month;

--12.Find the customer who have made the most purchases in a single month.--

SELECT c.customer_id, c.customer_name, 
       TO_CHAR(s.order_date, 'YYYY-MM') AS month,
       COUNT(s.order_id) AS total_orders
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY c.customer_id, c.customer_name, TO_CHAR(s.order_date, 'YYYY-MM')
ORDER BY total_orders DESC
LIMIT 1;

--13.Retrieve the number of orders made per product category in 2023 and order by total quantity sold.--

SELECT p.category, COUNT(DISTINCT s.order_id) AS total_orders, 
       SUM(s.quantity) AS total_quantity_sold
FROM products p
JOIN sales s ON p.product_id = s.product_id
WHERE EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY p.category
ORDER BY total_quantity_sold DESC;

--14.List the products that have never been ordered (use LEFT JOIN between products and sales).--

SELECT p.product_id, p.product_name, p.category, p.brand
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;
