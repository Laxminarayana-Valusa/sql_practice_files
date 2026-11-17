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


