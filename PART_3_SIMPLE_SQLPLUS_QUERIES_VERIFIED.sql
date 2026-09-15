-- =====================================================================
-- SMART WAREHOUSE AND SPACE OPTIMIZATION
-- PART 3: SIMPLE SQL*PLUS QUERIES FOR STUDY, DEMONSTRATION, AND VIVA
-- =====================================================================
-- Run each numbered query separately while taking screenshots.
-- The comments explain WHAT the query does and WHY it is useful.

SET LINESIZE 120
SET PAGESIZE 50
SET WRAP OFF
SET FEEDBACK ON
CLEAR COLUMNS
COLUMN SKU FORMAT A8
COLUMN Item_Name FORMAT A18
COLUMN Category FORMAT A12
COLUMN Product_ID HEADING 'PROD_ID' FORMAT 999
COLUMN Demand_Level HEADING 'DEMAND' FORMAT A8
COLUMN Location_Code HEADING 'LOC_CODE' FORMAT A12
COLUMN Zone_Name FORMAT A20
COLUMN Warehouse_ID HEADING 'WH_ID' FORMAT 999
COLUMN Warehouse_Name HEADING 'WAREHOUSE_NAME' FORMAT A20
COLUMN Location FORMAT A16
COLUMN Total_Area HEADING 'TOTAL_AREA' FORMAT 999999.99
COLUMN Status FORMAT A10
COLUMN Utilization_Status HEADING 'UTIL_STATUS' FORMAT A11
COLUMN Employee_ID HEADING 'EMP_ID' FORMAT 999
COLUMN Employee_Name HEADING 'EMPLOYEE_NAME' FORMAT A20
COLUMN Role FORMAT A20

-- ---------------------------------------------------------------------
-- QUERY 1: SELECT ALL WAREHOUSE ROWS
-- WHAT: Displays every warehouse record and all four attributes.
-- WHY: Explicit column names keep SQL*Plus output readable in screenshots.
-- ---------------------------------------------------------------------
SELECT Warehouse_ID,
       Warehouse_Name,
       Location,
       Total_Area
FROM Warehouse
ORDER BY Warehouse_ID;

-- ---------------------------------------------------------------------
-- QUERY 2: SELECT SPECIFIC COLUMNS
-- WHAT: Displays only the product columns needed in this report.
-- WHY: Selecting required columns produces clearer output than SELECT *.
-- ---------------------------------------------------------------------
SELECT SKU, Item_Name, Category
FROM Warehouse_Product
ORDER BY Product_ID;

-- ---------------------------------------------------------------------
-- QUERY 3: WHERE
-- WHAT: Displays products with HIGH demand.
-- WHY: WHERE filters individual rows before they are displayed.
-- ---------------------------------------------------------------------
SELECT SKU, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Demand_Level = 'HIGH'
ORDER BY SKU;

-- ---------------------------------------------------------------------
-- QUERY 4: ORDER BY
-- WHAT: Displays storage locations from highest to lowest capacity.
-- WHY: ORDER BY sorts the query result.
-- ---------------------------------------------------------------------
SELECT Location_Code, Capacity
FROM Storage_Location
ORDER BY Capacity DESC;

-- ---------------------------------------------------------------------
-- QUERY 5: DISTINCT
-- WHAT: Displays every product category once.
-- WHY: DISTINCT removes duplicate values from the result.
-- ---------------------------------------------------------------------
SELECT DISTINCT Category
FROM Warehouse_Product
ORDER BY Category;

-- ---------------------------------------------------------------------
-- QUERY 6: AND
-- WHAT: Finds high-demand products in the Electronics category.
-- WHY: AND requires both conditions to be true.
-- ---------------------------------------------------------------------
SELECT SKU, Item_Name, Category, Demand_Level
FROM Warehouse_Product
WHERE Category = 'Electronics'
  AND Demand_Level = 'HIGH'
ORDER BY SKU;

-- ---------------------------------------------------------------------
-- QUERY 7: OR
-- WHAT: Finds products with HIGH or MEDIUM demand.
-- WHY: OR requires at least one condition to be true.
-- ---------------------------------------------------------------------
SELECT SKU, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Demand_Level = 'HIGH'
   OR Demand_Level = 'MEDIUM'
ORDER BY SKU;

-- ---------------------------------------------------------------------
-- QUERY 8: IN
-- WHAT: Finds products belonging to selected categories.
-- WHY: IN is a shorter alternative to several OR conditions.
-- ---------------------------------------------------------------------
SELECT SKU, Item_Name, Category
FROM Warehouse_Product
WHERE Category IN ('Electronics', 'Furniture')
ORDER BY Category, Item_Name;

-- ---------------------------------------------------------------------
-- QUERY 9: BETWEEN
-- WHAT: Finds locations with capacity from 100 through 150.
-- WHY: BETWEEN checks whether a value is inside an inclusive range.
-- ---------------------------------------------------------------------
SELECT Location_Code, Capacity
FROM Storage_Location
WHERE Capacity BETWEEN 100 AND 150
ORDER BY Capacity, Location_Code;

-- ---------------------------------------------------------------------
-- QUERY 10: LIKE
-- WHAT: Finds product names beginning with the letter L.
-- WHY: LIKE performs simple text-pattern matching; % means any characters.
-- ---------------------------------------------------------------------
SELECT SKU, Item_Name
FROM Warehouse_Product
WHERE Item_Name LIKE 'L%';

-- ---------------------------------------------------------------------
-- QUERY 11: ARITHMETIC CALCULATION
-- WHAT: Calculates the free space in each storage location.
-- WHY: Available space equals total capacity minus occupied space.
-- ---------------------------------------------------------------------
SELECT Location_Code,
       Capacity,
       Occupied_Space,
       Capacity - Occupied_Space AS Available_Space
FROM Storage_Location
ORDER BY Available_Space DESC;

-- ---------------------------------------------------------------------
-- QUERY 12: CASE
-- WHAT: Labels each location as HIGH, MEDIUM, or LOW utilization.
-- WHY: CASE converts a calculated value into an understandable category.
-- ---------------------------------------------------------------------
SELECT Location_Code,
       ROUND(Occupied_Space / Capacity * 100, 2) AS Utilization,
       CASE
           WHEN Occupied_Space / Capacity * 100 >= 80 THEN 'HIGH'
           WHEN Occupied_Space / Capacity * 100 >= 50 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS Utilization_Status
FROM Storage_Location
ORDER BY Utilization DESC;

-- ---------------------------------------------------------------------
-- QUERY 13: COUNT
-- WHAT: Counts the number of products.
-- WHY: COUNT returns how many rows satisfy the query.
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS Total_Products
FROM Warehouse_Product;

-- ---------------------------------------------------------------------
-- QUERY 14: SUM, AVG, MIN, AND MAX
-- WHAT: Summarizes the quantities stored in Inventory.
-- WHY: Aggregate functions calculate one result from several rows.
-- ---------------------------------------------------------------------
SELECT SUM(Quantity) AS Total_Quantity,
       ROUND(AVG(Quantity), 2) AS Average_Quantity,
       MIN(Quantity) AS Minimum_Quantity,
       MAX(Quantity) AS Maximum_Quantity
FROM Inventory;

-- ---------------------------------------------------------------------
-- QUERY 15: GROUP BY
-- WHAT: Calculates total inventory quantity for every product.
-- WHY: GROUP BY creates one result group for each product.
-- ---------------------------------------------------------------------
SELECT Product_ID,
       SUM(Quantity) AS Total_Quantity
FROM Inventory
GROUP BY Product_ID
ORDER BY Product_ID;

-- ---------------------------------------------------------------------
-- QUERY 16: HAVING
-- WHAT: Displays categories containing at least 30 inventory units.
-- WHY: HAVING filters grouped results after SUM has been calculated.
-- ---------------------------------------------------------------------
SELECT wp.Category,
       SUM(i.Quantity) AS Total_Units
FROM Warehouse_Product wp
JOIN Inventory i
  ON i.Product_ID = wp.Product_ID
GROUP BY wp.Category
HAVING SUM(i.Quantity) >= 30
ORDER BY Total_Units DESC;

-- ---------------------------------------------------------------------
-- QUERY 17: TWO-TABLE INNER JOIN
-- WHAT: Displays each inventory quantity with its product name.
-- WHY: The matching Product_ID connects Product and Inventory.
-- ---------------------------------------------------------------------
SELECT wp.Item_Name,
       i.Quantity
FROM Warehouse_Product wp
JOIN Inventory i
  ON i.Product_ID = wp.Product_ID
ORDER BY wp.Item_Name;

-- ---------------------------------------------------------------------
-- QUERY 18: THREE-TABLE INNER JOIN
-- WHAT: Displays each product, its quantity, and its storage location.
-- WHY: Inventory connects products to storage locations.
-- ---------------------------------------------------------------------
SELECT wp.Item_Name,
       i.Quantity,
       sl.Location_Code
FROM Warehouse_Product wp
JOIN Inventory i
  ON i.Product_ID = wp.Product_ID
JOIN Storage_Location sl
  ON sl.Location_ID = i.Location_ID
ORDER BY wp.Item_Name;

-- ---------------------------------------------------------------------
-- QUERY 19: SUBQUERY
-- WHAT: Displays inventory rows whose quantity is above average.
-- WHY: The inner query calculates the average used by the outer query.
-- ---------------------------------------------------------------------
SELECT wp.Item_Name,
       i.Quantity
FROM Warehouse_Product wp
JOIN Inventory i
  ON i.Product_ID = wp.Product_ID
WHERE i.Quantity > (
    SELECT AVG(Quantity)
    FROM Inventory
)
ORDER BY i.Quantity DESC;

-- ---------------------------------------------------------------------
-- QUERY 20: LEFT JOIN
-- WHAT: Finds storage locations that do not contain an inventory row.
-- WHY: LEFT JOIN retains locations even when no matching inventory exists.
-- ---------------------------------------------------------------------
SELECT sl.Location_Code,
       sl.Capacity,
       sl.Status
FROM Storage_Location sl
LEFT JOIN Inventory i
  ON i.Location_ID = sl.Location_ID
WHERE i.Inventory_ID IS NULL
ORDER BY sl.Location_Code;

-- =====================================================================
-- COMMANDS 21-25: SAFE DML AND TRANSACTION CONTROL
-- These changes are temporary. ROLLBACK restores the original data.
-- =====================================================================

-- COMMAND 21: SAVEPOINT
-- Marks the state to which the demonstration will return.
SAVEPOINT before_dml_demo;

-- COMMAND 22: INSERT
-- Temporarily inserts a test employee.
INSERT INTO Employee
    (Employee_ID, Employee_Name, Role, Contact_No)
VALUES
    (99, 'Test Employee', 'Trainee', '9999999999');

SELECT Employee_ID, Employee_Name, Role
FROM Employee
WHERE Employee_ID = 99;

-- COMMAND 23: UPDATE
-- Temporarily changes the demand level of Desk Organizer.
UPDATE Warehouse_Product
SET Demand_Level = 'HIGH'
WHERE Product_ID = 10;

SELECT Product_ID, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Product_ID = 10;

-- COMMAND 24: DELETE
-- Temporarily removes employee 10.
DELETE FROM Employee
WHERE Employee_ID = 10;

SELECT Employee_ID, Employee_Name
FROM Employee
WHERE Employee_ID = 10;

-- COMMAND 25: ROLLBACK
-- Cancels the INSERT, UPDATE, and DELETE performed after the savepoint.
ROLLBACK TO before_dml_demo;

-- Confirm that employee 10 returned and employee 99 was removed.
SELECT Employee_ID, Employee_Name
FROM Employee
WHERE Employee_ID IN (10, 99)
ORDER BY Employee_ID;

-- Confirm that Desk Organizer returned to LOW demand.
SELECT Product_ID, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Product_ID = 10;

COMMIT;
