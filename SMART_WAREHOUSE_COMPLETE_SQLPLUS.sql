-- ============================================================================
-- SMART WAREHOUSE AND SPACE OPTIMIZATION
-- COMPLETE ORACLE SQL*PLUS PROJECT: PARTS 1 TO 8
-- ============================================================================
-- Purpose: One reference file for the group project and GitHub.
-- Run this file only in a NEW or EMPTY project schema.
-- Do not run it as SYS or SYSDBA.
--
-- SQL*Plus command:
--   SQL> @C:\Users\oschi\Downloads\smart_warehouse\SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql
-- ============================================================================

SET ECHO ON
SET FEEDBACK ON
SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 50
SET LINESIZE 120
SET WRAP OFF
CLEAR COLUMNS

COLUMN Warehouse_Name FORMAT A20
COLUMN Location FORMAT A16
COLUMN Zone_Name FORMAT A20
COLUMN Zone_Type FORMAT A16
COLUMN Location_Code FORMAT A14
COLUMN SKU FORMAT A8
COLUMN Item_Name FORMAT A18
COLUMN Category FORMAT A12
COLUMN Demand_Level HEADING 'DEMAND' FORMAT A8
COLUMN Employee_Name FORMAT A20
COLUMN Role FORMAT A20
COLUMN Status FORMAT A10
COLUMN Utilization_Status HEADING 'UTIL_STATUS' FORMAT A11
COLUMN Object_Name FORMAT A30
COLUMN Object_Type FORMAT A15

PROMPT ========================================================================
PROMPT PART 1 - CREATE THE SEVEN MAIN TABLES
PROMPT ========================================================================

CREATE TABLE Warehouse (
    Warehouse_ID   NUMBER PRIMARY KEY,
    Warehouse_Name VARCHAR2(100) NOT NULL,
    Location       VARCHAR2(100),
    Total_Area     NUMBER(10,2)
);

CREATE TABLE Zone (
    Zone_ID      NUMBER PRIMARY KEY,
    Zone_Name    VARCHAR2(50) NOT NULL,
    Zone_Type    VARCHAR2(30),
    Warehouse_ID NUMBER,
    CONSTRAINT fk_zone_warehouse FOREIGN KEY (Warehouse_ID)
        REFERENCES Warehouse(Warehouse_ID)
);

CREATE TABLE Storage_Location (
    Location_ID    NUMBER PRIMARY KEY,
    Location_Code  VARCHAR2(20) UNIQUE NOT NULL,
    Zone_ID        NUMBER,
    Capacity       NUMBER NOT NULL,
    Occupied_Space NUMBER DEFAULT 0,
    Status         VARCHAR2(20),
    CONSTRAINT fk_location_zone FOREIGN KEY (Zone_ID)
        REFERENCES Zone(Zone_ID),
    CONSTRAINT chk_location_capacity CHECK (Capacity > 0),
    CONSTRAINT chk_occupied_space CHECK (Occupied_Space >= 0)
);

CREATE TABLE Warehouse_Product (
    Product_ID    NUMBER PRIMARY KEY,
    SKU           VARCHAR2(30) UNIQUE NOT NULL,
    Item_Name     VARCHAR2(150) NOT NULL,
    Category      VARCHAR2(50),
    Unit_Size     NUMBER(10,2),
    Unit_Weight   NUMBER(10,2),
    Demand_Level  VARCHAR2(20),
    Reorder_Level NUMBER,
    CONSTRAINT chk_reorder CHECK (Reorder_Level >= 0)
);

CREATE TABLE Inventory (
    Inventory_ID NUMBER PRIMARY KEY,
    Product_ID   NUMBER,
    Location_ID  NUMBER,
    Quantity     NUMBER DEFAULT 0,
    Last_Updated DATE DEFAULT SYSDATE,
    CONSTRAINT fk_inventory_product FOREIGN KEY (Product_ID)
        REFERENCES Warehouse_Product(Product_ID),
    CONSTRAINT fk_inventory_location FOREIGN KEY (Location_ID)
        REFERENCES Storage_Location(Location_ID),
    CONSTRAINT chk_inventory_quantity CHECK (Quantity >= 0)
);

CREATE TABLE Movement (
    Movement_ID   NUMBER PRIMARY KEY,
    Product_ID    NUMBER,
    From_Location NUMBER,
    To_Location   NUMBER,
    Quantity      NUMBER NOT NULL,
    Movement_Type VARCHAR2(20),
    Movement_Date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_movement_product FOREIGN KEY (Product_ID)
        REFERENCES Warehouse_Product(Product_ID),
    CONSTRAINT fk_movement_from FOREIGN KEY (From_Location)
        REFERENCES Storage_Location(Location_ID),
    CONSTRAINT fk_movement_to FOREIGN KEY (To_Location)
        REFERENCES Storage_Location(Location_ID),
    CONSTRAINT chk_movement_quantity CHECK (Quantity > 0)
);

CREATE TABLE Employee (
    Employee_ID   NUMBER PRIMARY KEY,
    Employee_Name VARCHAR2(100) NOT NULL,
    Role          VARCHAR2(50),
    Contact_No    VARCHAR2(15)
);

PROMPT Confirm the seven tables:
SELECT table_name
FROM user_tables
ORDER BY table_name;

PROMPT ========================================================================
PROMPT PART 2 - INSERT SAMPLE VALUES
PROMPT ========================================================================

-- Warehouse rows
INSERT INTO Warehouse VALUES (1, 'Central Warehouse', 'Kochi', 50000);
INSERT INTO Warehouse VALUES (2, 'North Warehouse', 'Delhi', 42000);
INSERT INTO Warehouse VALUES (3, 'South Warehouse', 'Chennai', 38000);
INSERT INTO Warehouse VALUES (4, 'East Warehouse', 'Kolkata', 35000);
INSERT INTO Warehouse VALUES (5, 'West Warehouse', 'Mumbai', 45000);
INSERT INTO Warehouse VALUES (6, 'Hill Warehouse', 'Bengaluru', 32000);
INSERT INTO Warehouse VALUES (7, 'Port Warehouse', 'Goa', 28000);
INSERT INTO Warehouse VALUES (8, 'Metro Warehouse', 'Hyderabad', 40000);
INSERT INTO Warehouse VALUES (9, 'City Warehouse', 'Pune', 30000);
INSERT INTO Warehouse VALUES (10, 'Coastal Warehouse', 'Visakhapatnam', 33000);

-- Zone rows
INSERT INTO Zone VALUES (101, 'Receiving Zone', 'Receiving', 1);
INSERT INTO Zone VALUES (102, 'Fast Moving Zone', 'Fast Moving', 1);
INSERT INTO Zone VALUES (103, 'Bulk Storage Zone', 'Bulk Storage', 2);
INSERT INTO Zone VALUES (104, 'Cold Storage Zone', 'Cold Storage', 3);
INSERT INTO Zone VALUES (105, 'Electronics Zone', 'Secure Storage', 4);
INSERT INTO Zone VALUES (106, 'Furniture Zone', 'Bulk Storage', 5);
INSERT INTO Zone VALUES (107, 'Packing Zone', 'Packing', 6);
INSERT INTO Zone VALUES (108, 'Dispatch Zone', 'Dispatch', 7);
INSERT INTO Zone VALUES (109, 'Returns Zone', 'Returns', 8);
INSERT INTO Zone VALUES (110, 'Reserve Zone', 'Reserve Storage', 9);

-- Storage-location rows; location 1011 is intentionally empty.
INSERT INTO Storage_Location VALUES (1001, 'R-01-01', 101, 100, 90, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1002, 'F-01-01', 102, 120, 36, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1003, 'B-01-01', 103, 150, 25, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1004, 'C-01-01', 104, 100, 36, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1005, 'E-01-01', 105, 100, 27, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1006, 'FU-01-01', 106, 200, 40, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1007, 'P-01-01', 107, 100, 48, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1008, 'D-01-01', 108, 150, 44, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1009, 'RT-01-01', 109, 100, 35, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1010, 'RS-01-01', 110, 120, 27.5, 'OCCUPIED');
INSERT INTO Storage_Location VALUES (1011, 'R-01-02', 101, 120, 0, 'EMPTY');

-- Product rows
INSERT INTO Warehouse_Product
    (Product_ID, SKU, Item_Name, Category, Unit_Size, Unit_Weight,
     Demand_Level, Reorder_Level)
VALUES (1, 'SKU001', 'Laptop', 'Electronics', 2.5, 1.8, 'HIGH', 10);
INSERT INTO Warehouse_Product VALUES
    (2, 'SKU002', 'Keyboard', 'Electronics', 1.2, 0.8, 'HIGH', 20);
INSERT INTO Warehouse_Product VALUES
    (3, 'SKU003', 'Mouse', 'Electronics', 0.5, 0.2, 'HIGH', 30);
INSERT INTO Warehouse_Product VALUES
    (4, 'SKU004', 'Office Chair', 'Furniture', 3.0, 12, 'MEDIUM', 8);
INSERT INTO Warehouse_Product VALUES
    (5, 'SKU005', 'Table Lamp', 'Furniture', 1.5, 2, 'MEDIUM', 10);
INSERT INTO Warehouse_Product VALUES
    (6, 'SKU006', 'Refrigerator', 'Appliances', 4.0, 45, 'LOW', 5);
INSERT INTO Warehouse_Product VALUES
    (7, 'SKU007', 'Water Bottle', 'Home Goods', 0.8, 0.5, 'HIGH', 25);
INSERT INTO Warehouse_Product VALUES
    (8, 'SKU008', 'Printer', 'Electronics', 2.0, 6, 'MEDIUM', 8);
INSERT INTO Warehouse_Product VALUES
    (9, 'SKU009', 'Notebook', 'Stationery', 1.0, 0.3, 'HIGH', 20);
INSERT INTO Warehouse_Product VALUES
    (10, 'SKU010', 'Desk Organizer', 'Stationery', 1.1, 1, 'LOW', 10);

-- Inventory rows
INSERT INTO Inventory VALUES (1, 1, 1001, 36, SYSDATE);
INSERT INTO Inventory VALUES (2, 2, 1002, 30, SYSDATE);
INSERT INTO Inventory VALUES (3, 3, 1003, 50, SYSDATE);
INSERT INTO Inventory VALUES (4, 4, 1004, 12, SYSDATE);
INSERT INTO Inventory VALUES (5, 5, 1005, 18, SYSDATE);
INSERT INTO Inventory VALUES (6, 6, 1006, 10, SYSDATE);
INSERT INTO Inventory VALUES (7, 7, 1007, 60, SYSDATE);
INSERT INTO Inventory VALUES (8, 8, 1008, 22, SYSDATE);
INSERT INTO Inventory VALUES (9, 9, 1009, 35, SYSDATE);
INSERT INTO Inventory VALUES (10, 10, 1010, 25, SYSDATE);

-- Movement rows
INSERT INTO Movement VALUES (1, 1, 1001, 1011, 2, 'TRANSFER', SYSDATE - 10);
INSERT INTO Movement VALUES (2, 2, 1002, 1003, 5, 'TRANSFER', SYSDATE - 9);
INSERT INTO Movement VALUES (3, 3, 1003, 1002, 10, 'TRANSFER', SYSDATE - 8);
INSERT INTO Movement VALUES (4, 1, 1011, 1001, 1, 'TRANSFER', SYSDATE - 7);
INSERT INTO Movement VALUES (5, 4, 1004, 1006, 2, 'TRANSFER', SYSDATE - 6);
INSERT INTO Movement VALUES (6, 7, 1007, 1008, 15, 'TRANSFER', SYSDATE - 5);
INSERT INTO Movement VALUES (7, 8, 1008, 1005, 3, 'TRANSFER', SYSDATE - 4);
INSERT INTO Movement VALUES (8, 9, 1009, 1010, 8, 'TRANSFER', SYSDATE - 3);
INSERT INTO Movement VALUES (9, 2, 1003, 1002, 4, 'TRANSFER', SYSDATE - 2);
INSERT INTO Movement VALUES (10, 1, 1001, 1011, 3, 'TRANSFER', SYSDATE - 1);

-- Employee rows
INSERT INTO Employee VALUES (1, 'Anu Joseph', 'Warehouse Manager', '9876543210');
INSERT INTO Employee VALUES (2, 'Rahul Das', 'Inventory Officer', '9876543211');
INSERT INTO Employee VALUES (3, 'Meera Nair', 'Store Keeper', '9876543212');
INSERT INTO Employee VALUES (4, 'Arjun Kumar', 'Dispatch Officer', '9876543213');
INSERT INTO Employee VALUES (5, 'Neha Thomas', 'Receiving Officer', '9876543214');
INSERT INTO Employee VALUES (6, 'Vivek Raj', 'Packing Officer', '9876543215');
INSERT INTO Employee VALUES (7, 'Asha Paul', 'Store Keeper', '9876543216');
INSERT INTO Employee VALUES (8, 'Nikhil Bose', 'Quality Officer', '9876543217');
INSERT INTO Employee VALUES (9, 'Diya George', 'Inventory Officer', '9876543218');
INSERT INTO Employee VALUES (10, 'Rohan Ali', 'Security Officer', '9876543219');

COMMIT;

PROMPT Confirm the inserted data:
SELECT 'WAREHOUSE' AS Table_Name, COUNT(*) AS Row_Count FROM Warehouse
UNION ALL SELECT 'ZONE', COUNT(*) FROM Zone
UNION ALL SELECT 'STORAGE_LOCATION', COUNT(*) FROM Storage_Location
UNION ALL SELECT 'WAREHOUSE_PRODUCT', COUNT(*) FROM Warehouse_Product
UNION ALL SELECT 'INVENTORY', COUNT(*) FROM Inventory
UNION ALL SELECT 'MOVEMENT', COUNT(*) FROM Movement
UNION ALL SELECT 'EMPLOYEE', COUNT(*) FROM Employee;

PROMPT ========================================================================
PROMPT PART 3 - TWENTY IMPORTANT SQL QUERIES
PROMPT ========================================================================

PROMPT QUERY 1 - SELECT ALL WAREHOUSES
SELECT Warehouse_ID, Warehouse_Name, Location, Total_Area
FROM Warehouse
ORDER BY Warehouse_ID;

PROMPT QUERY 2 - SELECT SPECIFIC PRODUCT COLUMNS
SELECT SKU, Item_Name, Category
FROM Warehouse_Product
ORDER BY Product_ID;

PROMPT QUERY 3 - WHERE
SELECT SKU, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Demand_Level = 'HIGH'
ORDER BY SKU;

PROMPT QUERY 4 - ORDER BY
SELECT Location_Code, Capacity
FROM Storage_Location
ORDER BY Capacity DESC;

PROMPT QUERY 5 - DISTINCT
SELECT DISTINCT Category
FROM Warehouse_Product
ORDER BY Category;

PROMPT QUERY 6 - AND
SELECT SKU, Item_Name, Category, Demand_Level
FROM Warehouse_Product
WHERE Category = 'Electronics'
  AND Demand_Level = 'HIGH'
ORDER BY SKU;

PROMPT QUERY 7 - OR
SELECT SKU, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Demand_Level = 'HIGH'
   OR Demand_Level = 'MEDIUM'
ORDER BY SKU;

PROMPT QUERY 8 - IN
SELECT SKU, Item_Name, Category
FROM Warehouse_Product
WHERE Category IN ('Electronics', 'Furniture')
ORDER BY Category, Item_Name;

PROMPT QUERY 9 - BETWEEN
SELECT Location_Code, Capacity
FROM Storage_Location
WHERE Capacity BETWEEN 100 AND 150
ORDER BY Capacity, Location_Code;

PROMPT QUERY 10 - LIKE
SELECT SKU, Item_Name
FROM Warehouse_Product
WHERE Item_Name LIKE 'L%';

PROMPT QUERY 11 - ARITHMETIC CALCULATION
SELECT Location_Code,
       Capacity,
       Occupied_Space,
       Capacity - Occupied_Space AS Available_Space
FROM Storage_Location
ORDER BY Available_Space DESC;

PROMPT QUERY 12 - CASE
SELECT Location_Code,
       ROUND(Occupied_Space / Capacity * 100, 2) AS Utilization,
       CASE
           WHEN Occupied_Space / Capacity * 100 >= 80 THEN 'HIGH'
           WHEN Occupied_Space / Capacity * 100 >= 50 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS Utilization_Status
FROM Storage_Location
ORDER BY Utilization DESC;

PROMPT QUERY 13 - COUNT
SELECT COUNT(*) AS Total_Products
FROM Warehouse_Product;

PROMPT QUERY 14 - SUM, AVG, MIN AND MAX
SELECT SUM(Quantity) AS Total_Quantity,
       ROUND(AVG(Quantity), 2) AS Average_Quantity,
       MIN(Quantity) AS Minimum_Quantity,
       MAX(Quantity) AS Maximum_Quantity
FROM Inventory;

PROMPT QUERY 15 - GROUP BY
SELECT Product_ID, SUM(Quantity) AS Total_Quantity
FROM Inventory
GROUP BY Product_ID
ORDER BY Product_ID;

PROMPT QUERY 16 - HAVING
SELECT wp.Category, SUM(i.Quantity) AS Total_Units
FROM Warehouse_Product wp
JOIN Inventory i ON i.Product_ID = wp.Product_ID
GROUP BY wp.Category
HAVING SUM(i.Quantity) >= 30
ORDER BY Total_Units DESC;

PROMPT QUERY 17 - TWO-TABLE INNER JOIN
SELECT wp.Item_Name, i.Quantity
FROM Warehouse_Product wp
JOIN Inventory i ON i.Product_ID = wp.Product_ID
ORDER BY wp.Item_Name;

PROMPT QUERY 18 - THREE-TABLE INNER JOIN
SELECT wp.Item_Name, i.Quantity, sl.Location_Code
FROM Warehouse_Product wp
JOIN Inventory i ON i.Product_ID = wp.Product_ID
JOIN Storage_Location sl ON sl.Location_ID = i.Location_ID
ORDER BY wp.Item_Name;

PROMPT QUERY 19 - SUBQUERY
SELECT wp.Item_Name, i.Quantity
FROM Warehouse_Product wp
JOIN Inventory i ON i.Product_ID = wp.Product_ID
WHERE i.Quantity > (SELECT AVG(Quantity) FROM Inventory)
ORDER BY i.Quantity DESC;

PROMPT QUERY 20 - LEFT JOIN
SELECT sl.Location_Code, sl.Capacity, sl.Status
FROM Storage_Location sl
LEFT JOIN Inventory i ON i.Location_ID = sl.Location_ID
WHERE i.Inventory_ID IS NULL
ORDER BY sl.Location_Code;

PROMPT ========================================================================
PROMPT PART 3B - DML AND TRANSACTION CONTROL COMMANDS
PROMPT ========================================================================

SAVEPOINT before_dml_demo;

-- INSERT: add a temporary employee.
INSERT INTO Employee (Employee_ID, Employee_Name, Role, Contact_No)
VALUES (99, 'Test Employee', 'Trainee', '9999999999');

-- UPDATE: temporarily change one product.
UPDATE Warehouse_Product
SET Demand_Level = 'HIGH'
WHERE Product_ID = 10;

-- DELETE: temporarily remove one employee.
DELETE FROM Employee
WHERE Employee_ID = 10;

-- Display temporary changes.
SELECT Employee_ID, Employee_Name
FROM Employee
WHERE Employee_ID IN (10, 99)
ORDER BY Employee_ID;

SELECT Product_ID, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Product_ID = 10;

-- ROLLBACK cancels the INSERT, UPDATE and DELETE.
ROLLBACK TO before_dml_demo;

-- Confirm that the original data returned.
SELECT Employee_ID, Employee_Name
FROM Employee
WHERE Employee_ID IN (10, 99)
ORDER BY Employee_ID;

SELECT Product_ID, Item_Name, Demand_Level
FROM Warehouse_Product
WHERE Product_ID = 10;

COMMIT;

PROMPT ========================================================================
PROMPT PART 4 - VIEW
PROMPT ========================================================================

CREATE OR REPLACE VIEW High_Utilization_Locations AS
SELECT Location_ID,
       Location_Code,
       Capacity,
       Occupied_Space,
       Capacity - Occupied_Space AS Available_Space,
       ROUND(Occupied_Space / Capacity * 100, 2) AS Utilization_Percentage
FROM Storage_Location
WHERE Occupied_Space / Capacity * 100 >= 80;

SELECT *
FROM High_Utilization_Locations
ORDER BY Utilization_Percentage DESC;

PROMPT ========================================================================
PROMPT PART 5 - STORED PROCEDURE
PROMPT ========================================================================

CREATE OR REPLACE PROCEDURE Add_Inventory_Stock (
    p_inventory_id IN NUMBER,
    p_product_id   IN NUMBER,
    p_location_id  IN NUMBER,
    p_quantity     IN NUMBER
)
IS
    v_unit_size       Warehouse_Product.Unit_Size%TYPE;
    v_available_space NUMBER;
    v_required_space  NUMBER;
BEGIN
    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Quantity must be greater than zero.');
    END IF;

    SELECT Unit_Size
    INTO v_unit_size
    FROM Warehouse_Product
    WHERE Product_ID = p_product_id;

    SELECT Capacity - Occupied_Space
    INTO v_available_space
    FROM Storage_Location
    WHERE Location_ID = p_location_id;

    v_required_space := p_quantity * v_unit_size;

    IF v_required_space > v_available_space THEN
        RAISE_APPLICATION_ERROR(-20003, 'Insufficient storage space.');
    END IF;

    INSERT INTO Inventory
        (Inventory_ID, Product_ID, Location_ID, Quantity, Last_Updated)
    VALUES
        (p_inventory_id, p_product_id, p_location_id, p_quantity, SYSDATE);

    UPDATE Storage_Location
    SET Occupied_Space = Occupied_Space + v_required_space,
        Status = 'OCCUPIED'
    WHERE Location_ID = p_location_id;

    DBMS_OUTPUT.PUT_LINE('Inventory added. Space used = ' || v_required_space);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid product ID or location ID.');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Inventory ID already exists.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Safe procedure demonstration; rollback keeps the original data.
SAVEPOINT before_procedure_demo;
EXEC Add_Inventory_Stock(1011, 1, 1011, 2);
SELECT Inventory_ID, Product_ID, Location_ID, Quantity
FROM Inventory
WHERE Inventory_ID = 1011;
ROLLBACK TO before_procedure_demo;

PROMPT ========================================================================
PROMPT PART 6 - FUNCTION
PROMPT ========================================================================

CREATE OR REPLACE FUNCTION Get_Utilization (
    p_location_id IN NUMBER
)
RETURN NUMBER
IS
    v_capacity Storage_Location.Capacity%TYPE;
    v_occupied Storage_Location.Occupied_Space%TYPE;
BEGIN
    SELECT Capacity, Occupied_Space
    INTO v_capacity, v_occupied
    FROM Storage_Location
    WHERE Location_ID = p_location_id;

    RETURN ROUND(v_occupied / v_capacity * 100, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Location does not exist.');
END;
/

SELECT Get_Utilization(1001) AS Utilization_Percentage
FROM dual;

PROMPT ========================================================================
PROMPT PART 7 - EXPLICIT CURSOR
PROMPT ========================================================================

DECLARE
    CURSOR location_cursor IS
        SELECT Location_Code, Capacity, Occupied_Space
        FROM Storage_Location
        WHERE Occupied_Space / Capacity * 100 >= 40
        ORDER BY Occupied_Space / Capacity DESC;

    v_location_code  Storage_Location.Location_Code%TYPE;
    v_capacity       Storage_Location.Capacity%TYPE;
    v_occupied_space Storage_Location.Occupied_Space%TYPE;
BEGIN
    OPEN location_cursor;
    LOOP
        FETCH location_cursor
        INTO v_location_code, v_capacity, v_occupied_space;

        EXIT WHEN location_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_location_code || ' - Utilization: ' ||
            ROUND(v_occupied_space / v_capacity * 100, 2) || '%'
        );
    END LOOP;
    CLOSE location_cursor;
END;
/

PROMPT ========================================================================
PROMPT PART 8 - TRIGGERS AND AUDIT TABLE
PROMPT ========================================================================

-- Trigger 1: prevent occupied space from exceeding capacity.
CREATE OR REPLACE TRIGGER trg_check_capacity
BEFORE UPDATE OF Occupied_Space ON Storage_Location
FOR EACH ROW
BEGIN
    IF :NEW.Occupied_Space > :NEW.Capacity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Storage capacity exceeded.');
    END IF;
END;
/

-- Table and sequence used by the audit trigger.
CREATE TABLE Inventory_Audit (
    Audit_ID      NUMBER PRIMARY KEY,
    Inventory_ID  NUMBER,
    Product_ID    NUMBER,
    Location_ID   NUMBER,
    Quantity      NUMBER,
    Changed_By    VARCHAR2(30),
    Changed_On    DATE
);

CREATE SEQUENCE Inventory_Audit_Seq
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Trigger 2: record every new Inventory row.
CREATE OR REPLACE TRIGGER trg_inventory_audit
AFTER INSERT ON Inventory
FOR EACH ROW
BEGIN
    INSERT INTO Inventory_Audit
        (Audit_ID, Inventory_ID, Product_ID, Location_ID,
         Quantity, Changed_By, Changed_On)
    VALUES
        (Inventory_Audit_Seq.NEXTVAL, :NEW.Inventory_ID, :NEW.Product_ID,
         :NEW.Location_ID, :NEW.Quantity, USER, SYSDATE);
END;
/

-- Safe audit-trigger test.
SAVEPOINT before_audit_test;
INSERT INTO Inventory
    (Inventory_ID, Product_ID, Location_ID, Quantity, Last_Updated)
VALUES
    (2001, 2, 1011, 1, SYSDATE);

SELECT Audit_ID, Inventory_ID, Product_ID, Location_ID, Quantity, Changed_By
FROM Inventory_Audit
WHERE Inventory_ID = 2001;

ROLLBACK TO before_audit_test;

-- Confirm the stored objects.
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN (
    'HIGH_UTILIZATION_LOCATIONS',
    'ADD_INVENTORY_STOCK',
    'GET_UTILIZATION',
    'TRG_CHECK_CAPACITY',
    'TRG_INVENTORY_AUDIT',
    'INVENTORY_AUDIT_SEQ'
)
ORDER BY object_type, object_name;

PROMPT ========================================================================
PROMPT PROJECT SCRIPT COMPLETED
PROMPT ========================================================================

-- ============================================================================
-- OPTIONAL REFERENCE COMMANDS - DO NOT RUN UNLESS REQUIRED
-- ============================================================================
-- Capacity-trigger error demonstration:
--   UPDATE Storage_Location
--   SET Occupied_Space = Capacity + 1
--   WHERE Location_ID = 1001;
-- Expected result: ORA-20001: Storage capacity exceeded.
-- Then run: ROLLBACK;
--
-- DCL examples require the account owner or DBA and another real username:
--   GRANT SELECT ON Warehouse TO other_username;
--   REVOKE SELECT ON Warehouse FROM other_username;
--
-- DROP commands, in safe dependency order, for intentionally resetting a schema:
--   DROP TRIGGER trg_inventory_audit;
--   DROP TRIGGER trg_check_capacity;
--   DROP PROCEDURE Add_Inventory_Stock;
--   DROP FUNCTION Get_Utilization;
--   DROP VIEW High_Utilization_Locations;
--   DROP SEQUENCE Inventory_Audit_Seq;
--   DROP TABLE Inventory_Audit CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Movement CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Inventory CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Employee CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Storage_Location CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Warehouse_Product CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Zone CASCADE CONSTRAINTS PURGE;
--   DROP TABLE Warehouse CASCADE CONSTRAINTS PURGE;
