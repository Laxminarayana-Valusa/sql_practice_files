use practicejoinsdb;
-- to select matching rows from both tables among two tables with customer_id
-- inner join
SELECT o.order_id, c.first_name, c.last_name, o.amount, o.status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
order by order_id;

select* from customers;


-- LEFT JOIN (Keeps all items from the left table)

-- List every single customer, alongside their order details if they have any. 
-- (Customers like Thomas Young (ID 26) will show NULL for order details because they haven't placed an order yet):

SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN (Keeps all items from the right table)
-- See all orders, including orphaned orders that do not map to a registered customer (customer_id is NULL):
SELECT o.order_id, o.amount, c.first_name, c.last_name, c.customer_id
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;


-- SELF JOIN (Table joining itself)
-- Find who referred whom. This maps the referred_by_id column back to the customer_id column of the same table:
SELECT 
    sub.first_name AS Customer, 
    ref.first_name AS Referred_By
FROM Customers sub
INNER JOIN Customers ref ON sub.referred_by_id = ref.customer_id;

select* from customers;
