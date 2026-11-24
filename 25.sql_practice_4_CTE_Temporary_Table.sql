CREATE DATABASE IF NOT EXISTS interview_prep;
USE interview_prep;

CREATE TABLE raw_events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(20),
    event_time DATETIME
);

INSERT INTO raw_events VALUES
(1, 101, 'view',     '2026-03-01 10:00:00'),
(2, 101, 'view',     '2026-03-01 10:01:00'), -- duplicate view
(3, 101, 'cart',     '2026-03-01 10:05:00'),
(4, 101, 'purchase', '2026-03-01 10:12:00'),
(5, 102, 'view',     '2026-03-01 11:00:00'),
(6, 102, 'cart',     '2026-03-01 11:04:00'), -- dropped off at cart
(7, 103, 'view',     '2026-03-01 12:00:00'); -- dropped off at view

-- call raw_events
select* from raw_events;

-- call raw_events table using use interview_prep db
select event_id, u
ser_id, event_type, event_time
	from raw_events;
 
-- to know total count of rows
select count(*) as total_number_of_rows
	from raw_events; 
    
-- group by to user_id to know total count of rows
select user_id,
	count(*) as total_rows_by_user_id
	from raw_events
    group by user_id;

-- group by event_type to know total count of rows
select event_type,
	count(*) as total_rows_by_event_type
	from raw_events
    group by event_type;
    
-- group by event_type to know distinct event counts 
select event_type,
	count(*) as total_rows_by_event_type
    from raw_events
    group by event_type;
 
-- assign row_no, rank, dense_rank,  after order by event_type
select user_id, event_type,
	   row_number() over(partition by event_type order by user_id) row_no,
       rank() over(partition by event_type order by user_id) rnk,
       dense_rank() over(partition by event_type order by user_id) dense_rnk
from raw_events;

select* from raw_events;
select distinct user_id, event_type from raw_events;


-- 1. Optimized Temp Table Solution
-- Step 1: Materialize the expensive deduplication ONCE
CREATE TEMPORARY TABLE temp_first_events AS
SELECT user_id, event_type, event_time
FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY user_id, event_type ORDER BY event_time ASC) AS rn
    FROM raw_events
) sub
WHERE rn = 1;

-- Step 2: Add index for fast self-joins
CREATE INDEX idx_user_event ON temp_first_events (user_id, event_type);

select* from temp_first_events;

-- Step 3: Fast funnel calculation using index seeks
-- SELECT 
--     COUNT(DISTINCT v.user_id) AS total_viewers,
--     COUNT(DISTINCT c.user_id) AS added_to_cart,
--     COUNT(DISTINCT p.user_id) AS purchasers
-- FROM temp_first_events v
-- LEFT JOIN temp_first_events c 
--     ON v.user_id = c.user_id AND c.event_type = 'cart'
-- LEFT JOIN temp_first_events p 
--     ON c.user_id = p.user_id AND p.event_type = 'purchase'
-- WHERE v.event_type = 'view';


CREATE TEMPORARY TABLE temp_cart AS 
SELECT user_id, event_time FROM temp_first_events WHERE event_type = 'cart';

CREATE TEMPORARY TABLE temp_purchase AS 
SELECT user_id, event_time FROM temp_first_events WHERE event_type = 'purchase';

SELECT 
    COUNT(v.user_id) AS total_viewers,
    COUNT(c.user_id) AS added_to_cart,
    COUNT(p.user_id) AS purchasers
FROM temp_first_events v
LEFT JOIN temp_cart c 
    ON v.user_id = c.user_id AND c.event_time >= v.event_time
LEFT JOIN temp_purchase p 
    ON c.user_id = p.user_id AND p.event_time >= c.event_time
WHERE v.event_type = 'view';




