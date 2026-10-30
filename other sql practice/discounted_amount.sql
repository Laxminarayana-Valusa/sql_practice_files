with cte as (
SELECT *,
   row_number() over(partition by customer_id order by transaction_id) three
 FROM purchases
),
cte2 as (
  select *
    from cte 
  where three = 3
)
select customer_id, transaction_id, amount,  amount * 0.67 AS discounted_amount
    from cte2
;


-- or
SELECT customer_id, transaction_id, amount, amount * 0.67 AS discounted_amount
FROM (
    SELECT customer_id, transaction_id, amount, 
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_id) AS rn
    FROM purchases
) t
WHERE rn = 3
ORDER BY customer_id ASC;

-- Output the customer id, transaction id, amount,
-- and the amount after the discount as "discounted_amount".