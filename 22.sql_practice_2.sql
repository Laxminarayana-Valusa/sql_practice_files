USE school_db;

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

-- call entire table
select*
from user_activity;

-- 1. Consecutive Login Streaks (3+ Days)
WITH DistinctLogins AS (
    SELECT DISTINCT user_id, event_date
    FROM user_activity
    WHERE event_type = 'login'
),
StreakGroups AS (
    SELECT 
        user_id,
        event_date,
        DATE_SUB(event_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY event_date) DAY) AS grp
		-- DATE_SUB('2026-05-10', INTERVAL 1 DAY) → Subtracts 1 day (gives 2026-05-09)
        -- Day subtract as day=1,2,3.. rather than months, years
   FROM DistinctLogins
)
SELECT 
    user_id,
    MIN(event_date) AS streak_start,
    MAX(event_date) AS streak_end,
    COUNT(*) AS consecutive_days
FROM StreakGroups
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;

-- 2. First Purchase Per User
with RankedPurchases as (
	select*,
		row_number() over(partition by user_id order by event_date asc, event_id asc) rn
	from user_activity
    where event_type = 'purchase' 
)
select 
	user_id,
    event_date as first_purchase_date,
    amount as first_purchase_amount
from RankedPurchases
where rn = 1;

-- 3. Second Highest Purchase Per User
with Ranked_purchases as (
	select*,
		dense_rank() over(partition by user_id order by amount desc) drnk
	from user_activity
    where event_type = 'purchase'
)
select distinct
	user_id,
    amount as Second_purchase_date
from Ranked_purchases
where drnk = 2;

-- 4. Identify & Remove Duplicate Rows
-- Step 1: Preview duplicates
WITH DuplicateCheck AS (
    SELECT 
        event_id,
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
SELECT * FROM DuplicateCheck WHERE rn > 1;

-- Step 2: Delete duplicates in MySQL 8.0+
WITH DuplicateCheck AS (
    SELECT 
        event_id,
        ROW_NUMBER() OVER(
            PARTITION BY user_id, event_type, amount, event_date 
            ORDER BY event_id ASC
        ) AS rn
    FROM user_activity
)
DELETE FROM user_activity
WHERE event_id IN (SELECT event_id FROM DuplicateCheck WHERE rn > 1);

select* from user_activity;

-- 5. Median Purchase Amount
with OrderedPurchases as (
	select
		amount,
		row_number() over(order by amount asc, event_id asc ) rn,
        count(*) over() as total_rows
	from user_activity
    where event_type = 'purchase'
)
select avg(amount) as median_purchase
from OrderedPurchases
where rn in (Floor((total_rows+1)/2), CEIL((total_rows+1)/2));


	
