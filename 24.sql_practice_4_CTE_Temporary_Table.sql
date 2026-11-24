USE school_db;
-- CTE && Temporary Table
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

-- Example
USE school_db;

-- Step 1: Materialize heavy deduplication once into a Temp Table
CREATE TEMPORARY TABLE temp_clean_activity AS
WITH RankedEvents AS (
    SELECT 
        user_id,
        event_type,
        amount,
        event_date,
        ROW_NUMBER() OVER(
            PARTITION BY user_id, event_type, amount, event_date 
            ORDER BY event_id ASC
        ) AS rn
    FROM user_activity
)
SELECT user_id, event_type, amount, event_date
FROM RankedEvents
WHERE rn = 1;

-- Step 2: Add an index to speed up downstream joins and filters
	-- single index_works (user_id)
       -- An index creates a hidden, sorted mini-table with row pointers for instant lookups.
       -- It jumps straight to the matching rows in the main table without scanning every row.
 
     -- Composite Index (user_id, event_date)
        -- Sorts the hidden lookup list first by user_id, and then by event_date inside each user.
        -- Points straight to the exact rows in the main table when filtering by user_id (or both).

CREATE INDEX idx_user_date ON temp_clean_activity (user_id, event_date);
SHOW INDEX FROM temp_clean_activity;
select* from temp_clean_activity;

-- Step 3: Reuse the indexed Temp Table across multiple fast queries
SELECT user_id, COUNT(*) AS total_logins
FROM temp_clean_activity
WHERE event_type = 'login'
GROUP BY user_id;

SELECT user_id, SUM(amount) AS total_spent
FROM temp_clean_activity
WHERE event_type = 'purchase'
GROUP BY user_id;

-- 1. WHERE vs. HAVING (Order of Execution)
select* from user_activity;
-- GOOD: Filters 'purchase' events BEFORE grouping (fast)
select
	user_id, 
    sum(amount) as amount_purchased,
    count(*) as user_count
from user_activity
where event_type = 'purchase'
group by user_id
having amount_purchased > 1000;

-- SAFE & FAST: Find users who logged in but never made a purchase
SELECT DISTINCT u1.user_id
FROM user_activity u1
WHERE u1.event_type = 'login'
  AND NOT EXISTS (
      SELECT 1 
      FROM user_activity u2 
      WHERE u2.user_id = u1.user_id 
        AND u2.event_type = 'purchase'
  );




