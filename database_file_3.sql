-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS PracticeJoinsDB;
USE PracticeJoinsDB;

-- 2. Drop existing tables if they exist to allow a fresh start
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Departments;

-- 3. Create Departments Table (Independent dimension table)
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL,
    manager_name VARCHAR(50)
);

-- 4. Create Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    country VARCHAR(50),
    referred_by_id INT, -- For Self-Join practice
    FOREIGN KEY (referred_by_id) REFERENCES Customers(customer_id)
);

-- 5. Create Orders Table (Contains foreign keys linking to both tables)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT, -- Intentional NULLs allowed for Outer Join practice
    department_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);


-- ========================================================
-- INSERTING 20 DEPARTMENTS
-- ========================================================
INSERT INTO Departments (dept_name, manager_name) VALUES
('Electronics', 'Alice Smith'), ('Clothing', 'Bob Jones'), ('Home & Kitchen', 'Charlie Brown'),
('Books', 'Diana Prince'), ('Sports', 'Evan Wright'), ('Beauty', 'Fiona Gallagher'),
('Automotive', 'George Clark'), ('Toys & Games', 'Hannah Abbott'), ('Grocery', 'Ian Malcolm'),
('Health', 'Julia Roberts'), ('Tools', 'Kevin Bacon'), ('Garden', 'Laura Croft'),
('Office Supplies', 'Michael Scott'), ('Pet Supplies', 'Nancy Drew'), ('Music', 'Oliver Twist'),
('Jewelry', 'Penelope Cruz'), ('Shoes', 'Quentin Tarantino'), ('Baby Care', 'Rachel Green'),
('Software', 'Steve Jobs'), ('Industrial', 'Tony Stark');

-- ========================================================
-- INSERTING 30 CUSTOMERS (Including Self-Join Relationships)
-- ========================================================
-- Base Customers (No Referrals)
INSERT INTO Customers (customer_id, first_name, last_name, email, country, referred_by_id) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'USA', NULL),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'Canada', NULL),
(3, 'Alex', 'Jones', 'alex.j@example.com', 'UK', NULL),
(4, 'Emily', 'Brown', 'emily.b@example.com', 'Australia', NULL),
(5, 'Michael', 'Davis', 'mike.d@example.com', 'USA', NULL);

-- Customers referred by earlier ones
INSERT INTO Customers (customer_id, first_name, last_name, email, country, referred_by_id) VALUES
(6, 'Sarah', 'Wilson', 'sarah.w@example.com', 'UK', 1),
(7, 'David', 'Miller', 'david.m@example.com', 'Canada', 1),
(8, 'James', 'Taylor', 'james.t@example.com', 'USA', 2),
(9, 'Linda', 'Anderson', 'linda.a@example.com', 'Germany', 3),
(10, 'Robert', 'Thomas', 'robert.t@example.com', 'France', 4),
(11, 'William', 'Jackson', 'will.j@example.com', 'USA', 5),
(12, 'Elizabeth', 'White', 'liz.w@example.com', 'Australia', 5),
(13, 'Megan', 'Harris', 'megan.h@example.com', 'UK', 6),
(14, 'Kevin', 'Martin', 'kevin.m@example.com', 'Canada', 7),
(15, 'Brian', 'Thompson', 'brian.t@example.com', 'USA', 8),
(16, 'Edward', 'Garcia', 'ed.g@example.com', 'Spain', NULL),
(17, 'Susan', 'Martinez', 'susan.m@example.com', 'Mexico', NULL),
(18, 'Chris', 'Robinson', 'chris.r@example.com', 'USA', NULL),
(19, 'Jessica', 'Clark', 'jess.c@example.com', 'UK', NULL),
(20, 'Matthew', 'Rodriguez', 'matt.r@example.com', 'Brazil', NULL),
(21, 'Ashley', 'Lewis', 'ash@example.com', 'USA', 11),
(22, 'Joshua', 'Lee', 'josh.l@example.com', 'South Korea', 11),
(23, 'Amanda', 'Walker', 'amanda.w@example.com', 'UK', 12),
(24, 'Andrew', 'Hall', 'andrew.h@example.com', 'Canada', 13),
(25, 'Daniel', 'Allen', 'dan.a@example.com', 'USA', 15),
(26, 'Thomas', 'Young', 'tom.y@example.com', 'New Zealand', NULL),
(27, 'Donna', 'King', 'donna.k@example.com', 'USA', NULL),
(28, 'Nancy', 'Wright', 'nancy.w@example.com', 'UK', NULL),
(29, 'Steven', 'Lopez', 'steve.l@example.com', 'Mexico', NULL),
(30, 'Sandra', 'Hill', 'sandra.h@example.com', 'USA', NULL);

-- ========================================================
-- INSERTING 50 ORDERS (Mixed Customer IDs & Department IDs)
-- ========================================================
-- Standard orders matching valid customer and department rows
INSERT INTO Orders (customer_id, department_id, order_date, amount, status) VALUES
(1, 1, '2026-01-01', 599.99, 'Shipped'), (2, 1, '2026-01-02', 1200.50, 'Shipped'),
(3, 2, '2026-01-03', 45.00, 'Processing'), (4, 3, '2026-01-04', 89.95, 'Shipped'),
(5, 4, '2026-01-05', 15.20, 'Cancelled'), (6, 5, '2026-01-06', 250.00, 'Shipped'),
(7, 2, '2026-01-07', 110.00, 'Shipped'), (8, 3, '2026-01-08', 45.50, 'Processing'),
(9, 1, '2026-01-09', 850.00, 'Shipped'), (10, 4, '2026-01-10', 32.00, 'Shipped'),
(11, 6, '2026-01-11', 75.00, 'Shipped'), (12, 7, '2026-01-12', 420.00, 'Processing'),
(13, 8, '2026-01-13', 25.99, 'Shipped'), (14, 9, '2026-01-14', 105.30, 'Shipped'),
(15, 10, '2026-01-15', 60.00, 'Cancelled'), (1, 2, '2026-01-16', 85.00, 'Shipped'),
(2, 3, '2026-01-17', 140.00, 'Shipped'), (3, 6, '2026-01-18', 95.00, 'Shipped'),
(4, 1, '2026-01-19', 1500.00, 'Shipped'), (5, 8, '2026-01-20', 18.50, 'Processing'),
(16, 11, '2026-01-21', 65.00, 'Shipped'), (17, 12, '2026-01-22', 115.00, 'Shipped'),
(18, 13, '2026-01-23', 45.25, 'Shipped'), (19, 14, '2026-01-24', 35.00, 'Cancelled'),
(20, 15, '2026-01-25', 150.00, 'Shipped'), (21, 11, '2026-01-26', 88.00, 'Shipped'),
(22, 12, '2026-01-27', 210.00, 'Processing'), (23, 13, '2026-01-28', 12.50, 'Shipped'),
(24, 1, '2026-01-29', 340.00, 'Shipped'), (25, 2, '2026-01-30', 65.99, 'Shipped'),
(6, 14, '2026-02-01', 42.00, 'Shipped'), (7, 15, '2026-02-02', 180.00, 'Shipped'),
(8, 1, '2026-02-03', 999.99, 'Shipped'), (9, 4, '2026-02-04', 14.95, 'Processing'),
(10, 6, '2026-02-05', 120.00, 'Shipped'), (11, 7, '2026-02-06', 55.00, 'Shipped'),
(12, 8, '2026-02-07', 31.50, 'Shipped'), (13, 9, '2026-02-08', 88.40, 'Cancelled'),
(14, 10, '2026-02-09', 210.00, 'Shipped'), (15, 2, '2026-02-10', 74.00, 'Shipped');

-- Orphaned Orders: Explicitly left with NULL customer_id or department_id to practice OUTER JOINS
INSERT INTO Orders (customer_id, department_id, order_date, amount, status) VALUES
(NULL, 1, '2026-02-11', 250.00, 'Shipped'),
(NULL, 3, '2026-02-12', 85.00, 'Shipped'),
(NULL, 5, '2026-02-13', 19.99, 'Processing'),
(1, NULL, '2026-02-14', 150.00, 'Shipped'),
(2, NULL, '2026-02-15', 300.00, 'Shipped'),
(3, NULL, '2026-02-16', 45.00, 'Shipped'),
(NULL, NULL, '2026-02-17', 100.00, 'Shipped'),
(NULL, NULL, '2026-02-18', 20.00, 'Shipped'),
(NULL, NULL, '2026-02-19', 350.00, 'Processing'),
(NULL, NULL, '2026-02-20', 75.25, 'Shipped');

select* from customers;
select* from departments;
select* from orders;