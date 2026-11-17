--  can compare each student's score directly against their subject's average while still keeping every individual student row visible
use school_db;
USE school_db;

select 
	   subject,
       student,
       score,
       round(avg(score) over(partition by subject), 1) as sub_avg,
       score - round(avg(score) over(partition by subject), 1) as diff_from_avg
from exam_scores;
		