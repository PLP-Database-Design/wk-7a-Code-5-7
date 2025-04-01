-- Question 1: Achieving 1NF

-- Create a temporary table with the original data (if needed)
CREATE TEMPORARY TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

-- Insert the given data into the temporary table
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Transform the table into 1NF
CREATE TEMPORARY TABLE ProductDetail_1NF AS
SELECT 
    OrderID, 
    CustomerName, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM 
    ProductDetail
CROSS JOIN 
    (SELECT a.N + b.N * 10 + 1 AS n
     FROM 
         (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
         (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
     ORDER BY n
    ) n
WHERE 
    n.n <= 1 + (LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')));

-- Select from the 1NF table to display the result
SELECT * FROM ProductDetail_1NF;

-- Question 2: Achieving 2NF

-- Create a temporary table with the original data (if needed)
CREATE TEMPORARY TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT
);

-- Insert the given data into the temporary table
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create a table for Orders (OrderID, CustomerName)
CREATE TEMPORARY TABLE Orders_2NF AS
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a table for OrderItems (OrderID, Product, Quantity)
CREATE TEMPORARY TABLE OrderItems_2NF AS
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Select from the 2NF tables to display the result
SELECT * FROM Orders_2NF;
SELECT * FROM OrderItems_2NF;
