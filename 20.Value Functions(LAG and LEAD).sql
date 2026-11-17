use school_db;
SELECT 
    subject,
    student,
    score,
    LAG(score) OVER(PARTITION BY subject ORDER BY score DESC) AS higher_score_above,
    LAG(score) OVER(PARTITION BY subject ORDER BY score DESC) - score AS points_behind
FROM exam_scores;

USE school_db;

SELECT 
    subject,
    student,
    score,
    LEAD(student) OVER(PARTITION BY subject ORDER BY score DESC) AS next_student_below,
    LEAD(score)   OVER(PARTITION BY subject ORDER BY score DESC) AS next_score_below,
    score - LEAD(score) OVER(PARTITION BY subject ORDER BY score DESC) AS lead_margin
FROM exam_scores;
