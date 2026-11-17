/* Window functions calculate values across a set of rows 
related to the current row without collapsing them into a 
single summary row like GROUP BY does. */

-- 1. Ranking Functions (ROW_NUMBER, RANK, DENSE_RANK)

USE school_db;
select
	subject,
    student,
    score,
    row_number() over(partition by subject order by score desc) as row_num,
    rank() over(partition by subject order by score desc) as rnk,
    dense_rank() over(partition by subject order by score desc) as dense_rnk
from exam_scores;


-- 1. Comparing to the Top & Bottom Scorers (FIRST_VALUE & LAST_VALUE)
SELECT 
    subject,
    student,
    score,
    FIRST_VALUE(student) OVER(PARTITION BY subject ORDER BY score DESC) AS subject_topper,  -- sql sees from 1st to last here
    FIRST_VALUE(score)   OVER(PARTITION BY subject ORDER BY score DESC) - score AS points_behind_topper, -- sql sees current to below, not top
    LAST_VALUE(score)    OVER(PARTITION BY subject ORDER BY score DESC   -- so statement added to look from toptobottom
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_score
FROM exam_scores;

-- 2. Dividing Students into Tiers (NTILE)
/* NTILE(n) splits each subject's students into n roughly
equal buckets (for example, top tier, middle tier, and bottom tier). */
SELECT 
    subject,
    student,
    score,
    NTILE(3) OVER(PARTITION BY subject ORDER BY score DESC) AS performance_tier
FROM exam_scores;

-- 3. Calculating Percentiles (PERCENT_RANK & CUME_DIST)
/* These functions are widely used in grading systems 
to show where a student stands relative to everyone else in the same subject.
*/
SELECT 
    subject,
    student,
    score,
    ROUND(PERCENT_RANK() OVER(PARTITION BY subject ORDER BY score ASC), 2) AS pct_rank,
    ROUND(CUME_DIST()    OVER(PARTITION BY subject ORDER BY score ASC), 2) AS cumulative_dist
FROM exam_scores;

-- 4. Running Totals & Moving Averages (Frame Clauses)
/* Adding an ORDER BY inside OVER() turns standard 
aggregates like SUM() and AVG() into cumulative calculations. */
SELECT 
    subject,
    student,
    score,
    SUM(score) OVER(PARTITION BY subject ORDER BY score DESC) AS running_total_score,
    ROUND(AVG(score) OVER(
        PARTITION BY subject 
        ORDER BY score DESC 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ), 1) AS moving_3_student_avg
FROM exam_scores;


-- Practice
-- 1. Overall Leaderboard
select
	student,
    subject,
    score,
    row_number() over(order by score desc) as row_num,
    rank() over(order by score desc) as rank_no,
    dense_rank() over(order by score desc) as dense_rnk
from exam_scores;

-- 2. Lowest Scores First
select
	student,
    subject,
    score,
    dense_rank() over(partition by subject order by score asc) as lowest_rank
	from exam_scores;
    
-- 3. Top 2 Students Per Subject (Keeping Ties)
with RankedScores as (
	select 
		student,
        subject,
        score,
        dense_rank() over(partition by subject order by score desc) as rnk
	from exam_scores
)
    
select*
	from RankedScores
    where rnk<=2;
   
-- 4. Strict Top 2 Rows Per Subject (Breaking Ties)   
with strictTop_2 as (
	select*,
		row_number() over(partition by subject order by score asc) as row_num
        from exam_scores
)

select*
	from strictTop_2
    where row_num <= 2;
    
-- 5. Each Student's #1 Strongest Subject
with student_subject as (
	select*,
		rank() over(partition by student order by score desc) as subject_rank
        from exam_scores
)
select
	student,
	subject as best_subject,
    score
	from student_subject
    where subject_rank =1;
    

    