-- returns only matching rows in both table customer_id
SELECT o.order_id, c.first_name, c.last_name, o.amount, o.status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id;

