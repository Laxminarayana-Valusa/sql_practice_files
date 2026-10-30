DROP DATABASE IF EXISTS `classroom_file`;
CREATE DATABASE `classroom_file`;
USE `classroom_file`;






CREATE TABLE student_demographics (
  roll_num INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (roll_num)
);




INSERT INTO student_demographics (roll_num, first_name, last_name, age, gender, birth_date)
VALUES ('1', 'Leslie', 'Knope', '44', 'Female', '1979-09-25'),
('2', 'Tom', 'Haverford', '36', 'Male', '1987-03-04'),
('3', 'jerry', 'josh', '16', 'Male', '1986-04-16'),
('4', 'hidy', 'peter', '15', 'Female', '1990-06-20');

