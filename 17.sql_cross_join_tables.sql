-- 1. Create the Database (Optional)
USE classroom_file;

-- 2. Create the 'Meals' Table
CREATE TABLE Meals (
    MealID INT PRIMARY KEY AUTO_INCREMENT,
    MealName VARCHAR(50) NOT NULL
);

-- 3. Create the 'Drinks' Table
CREATE TABLE Drinks (
    DrinkID INT PRIMARY KEY AUTO_INCREMENT,
    DrinkName VARCHAR(50) NOT NULL
);

-- 4. Insert Data into 'Meals'
INSERT INTO Meals (MealName) VALUES 
('Pancakes'),
('Omelet');

-- 5. Insert Data into 'Drinks'
INSERT INTO Drinks (DrinkName) VALUES 
('Coffee'),
('Tea'),
('Orange Juice');

-- 6. Execute the CROSS JOIN
SELECT 
    m.MealName, 
    d.DrinkName
FROM 
    Meals m
CROSS JOIN 
    Drinks d;
