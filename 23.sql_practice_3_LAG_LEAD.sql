USE school_db;

-- LAG & LEAD
CREATE TABLE monthly_sales (
    id INT PRIMARY KEY,
    region VARCHAR(20),
    sales_month DATE,
    revenue INT
);

INSERT INTO monthly_sales VALUES
(1, 'North', '2026-01-01', 10000),
(2, 'North', '2026-02-01', 12000),
(3, 'North', '2026-03-01', 11400),
(4, 'North', '2026-04-01', 15000),
(5, 'South', '2026-01-01', 8000),
(6, 'South', '2026-02-01', 9600),
(7, 'South', '2026-03-01', 11000),
(8, 'South', '2026-04-01', 10500);


CREATE TABLE user_activity (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(20),
    amount INT,
    event_date DATE
);

INSERT INTO user_activity VALUES
-- User 101: Has a 3-day consecutive login streak (Jan 1, 2, 3), a gap, then Jan 6
(1, 101, 'login', 0, '2026-01-01'),
(2, 101, 'purchase', 500, '2026-01-01'),
(3, 101, 'login', 0, '2026-01-02'),
(4, 101, 'login', 0, '2026-01-03'),
(5, 101, 'purchase', 1200, '2026-01-03'),
(6, 101, 'login', 0, '2026-01-06'),

-- User 102: Has multiple purchases on the same day and a 2-day streak
(7, 102, 'login', 0, '2026-01-02'),
(8, 102, 'purchase', 300, '2026-01-02'),
(9, 102, 'purchase', 300, '2026-01-02'),
(10, 102, 'login', 0, '2026-01-03'),
(11, 102, 'purchase', 900, '2026-01-05'),

-- User 103: Single login, big purchase
(12, 103, 'login', 0, '2026-01-04'),
(13, 103, 'purchase', 1500, '2026-01-04');


-- call monthly_sales table
select* from monthly_sales;

-- call user_activity table
select* from user_Activity;

-- 1. Month-over-Month (MoM) Growth %
select
	region,
    sales_month,
    revenue,
    LAG(revenue) over(partition by region order by sales_month) as prev_month_rev,
	ROUND(
		((revenue - LAG(revenue) over(partition by region order by sales_month))
        / LAG(revenue) over(partition by region order by sales_month)) * 100,
	2) as mom_growth_pct
from monthly_sales;
	
-- 2. Days Between Consecutive Purchases
WITH PurchaseHistory AS (
    SELECT 
        user_id,
        event_date AS current_purchase,
        LAG(event_date) OVER(PARTITION BY user_id ORDER BY event_date ASC, event_id ASC) AS previous_purchase
    FROM user_activity
    WHERE event_type = 'purchase'
)
SELECT 
    user_id,
    previous_purchase,
    current_purchase,
    DATEDIFF(current_purchase, previous_purchase) AS days_between_purchases
FROM PurchaseHistory
WHERE previous_purchase IS NOT NULL;

-- 3. Funnel Conversion (login Immediately Followed by purchase)
WITH NextAction AS (
    SELECT 
        user_id,
        event_type AS current_event,
        event_date AS `current_date`,
        LEAD(event_type) OVER(PARTITION BY user_id ORDER BY event_date ASC, event_id ASC) AS next_event,
        LEAD(event_date) OVER(PARTITION BY user_id ORDER BY event_date ASC, event_id ASC) AS next_date
    FROM user_activity
)
SELECT user_id, `current_date` AS conversion_date
FROM NextAction
WHERE current_event = 'login' 
  AND next_event = 'purchase'
  AND `current_date` = next_date;
  
-- 4. Two Consecutive Months of Revenue Growth
WITH TrendCheck AS (
    SELECT 
        region,
        sales_month,
        revenue,
        LAG(revenue, 1) OVER(PARTITION BY region ORDER BY sales_month) AS prev_1_month,
        LAG(revenue, 2) OVER(PARTITION BY region ORDER BY sales_month) AS prev_2_months
    FROM monthly_sales
)
SELECT region, sales_month, prev_2_months, prev_1_month, revenue
FROM TrendCheck
WHERE revenue > prev_1_month 
  AND prev_1_month > prev_2_months;

-- 5. Using Default Values in LAG() and LEAD()
SELECT 
    region,
    sales_month,
    LAG(revenue, 1, 0)  OVER(PARTITION BY region ORDER BY sales_month) AS prev_rev,
    revenue AS current_rev,
    LEAD(revenue, 1, 0) OVER(PARTITION BY region ORDER BY sales_month) AS next_rev
FROM monthly_sales;


