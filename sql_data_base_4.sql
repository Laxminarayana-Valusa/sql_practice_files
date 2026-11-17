/* • MySQL: A fast, beginner-friendly, open-source database (owned by Oracle) 
      best suited for high-speed data reading in standard websites and e-commerce apps.
      
• PostgreSQL: A 100% free, community-driven, advanced open-source 
    database built for complex queries, strict data accuracy, and modern data like JSON and AI vectors.
    
• Microsoft SQL Server: A commercial, enterprise-grade database by Microsoft that offers 
   top-tier visual management tools (SSMS) and seamless integration with Windows, Azure, and .NET ecosystems.
*/

 -- here MySQL we are using


CREATE DATABASE school_db;
USE school_db;

CREATE TABLE exam_scores (
    id INT PRIMARY KEY,
    subject VARCHAR(20),
    student VARCHAR(50),
    score INT
);

INSERT INTO exam_scores (id, subject, student, score) VALUES
-- Math (matching your screenshot)
(1, 'Math', 'Aarav', 95),
(2, 'Math', 'Diya', 88),
(3, 'Math', 'Kabir', 88),
(4, 'Math', 'Meera', 80),
(5, 'Math', 'Rohan', 72),

-- Science
(6, 'Science', 'Aarav', 91),
(7, 'Science', 'Diya', 94),
(8, 'Science', 'Kabir', 79),
(9, 'Science', 'Meera', 85),
(10, 'Science', 'Rohan', 94),

-- English
(11, 'English', 'Aarav', 84),
(12, 'English', 'Diya', 89),
(13, 'English', 'Kabir', 92),
(14, 'English', 'Meera', 89),
(15, 'English', 'Rohan', 76);



 select*
from
exam_scores;


