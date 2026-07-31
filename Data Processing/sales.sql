select * from `workspace`.`default`.`saless`;

------------------------------------------------------------
---EXPLORATORY DATA ANALYSIS
------------------------------------------------------------
--1.CHECKING FOR NULLS
SELECT *
FROM workspace.default.saless
WHERE Date IS NULL
   OR Sales IS NULL
   OR `Cost Of Sales` IS NULL
   OR `Quantity Sold` IS NULL;
   ---NO NULLS
 -------------------------------------------------------------
 --2.CHECKING FOR DUPLICATES
 SELECT Date,
       Sales,
       `Cost Of Sales`,
       `Quantity Sold`,
       COUNT(*) AS duplicate_count
FROM workspace.default.saless
GROUP BY Date, Sales, `Cost Of Sales`, `Quantity Sold`
HAVING COUNT(*) > 1;
--NO DUPLICATES
----------------------------------------------------------------
--3.ADDING NEW COLUMNS
CREATE OR REPLACE TEMP VIEW salesss AS
SELECT *,
       YEAR(Date) AS Year,
       MONTH(Date) AS Month,
       DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
       DAY(Date) AS Day,
       DATE_FORMAT(Date, 'EEEE') AS `Day Name`,
       CASE
           WHEN DAYOFWEEK(Date) IN (1, 7) THEN 'Weekend'
           ELSE 'Weekday'
       END AS `Day Type`
FROM workspace.default.saless;
---------------------------------------------------------------------
SELECT *
FROM salesss ---CHANGED TABLE NAME FROM SALESS TO SALESSS
LIMIT 10;
-------------------------------------------------------------------
--5. FINDING TOTAL SALES
SELECT SUM(Sales) AS `Total Sales`
FROM salesss;
-------------------------------------------------------------------
--6.FINDING TOTAL COS
SELECT SUM(`Cost Of Sales`) AS `Total Cost Of Sales`
FROM salesss;
---------------------------------------------------------------------
--7.FINDING TOTAL QUANTITY SOLD
SELECT SUM(`Quantity Sold`) AS `Total Quantity Sold`
FROM salesss;
---------------------------------------------------------------------
---GROUPING BY AND AGGREATE FUNCTIONS
--8.TOTAL SALES BY YEAR
SELECT
    YEAR(Date) AS Year,
    SUM(Sales) AS `Total Sales`
FROM salesss
GROUP BY YEAR(Date)
ORDER BY Year;

--9.TOTAL SALES BY MONTH
SELECT
    MONTH(Date) AS Month,
    DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
    SUM(Sales) AS `Total Sales`
FROM salesss
GROUP BY MONTH(Date), DATE_FORMAT(Date, 'MMMM')
ORDER BY Month;

--10.COST OF SALE BY MONTH
SELECT
    MONTH(Date) AS Month,
    DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
    SUM(`Cost Of Sales`) AS `Total Cost Of Sales`
FROM salesss
GROUP BY MONTH(Date), DATE_FORMAT(Date, 'MMMM')
ORDER BY Month;

--11.QUANTITY BY MONTH
SELECT
    MONTH(Date) AS Month,
    DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
    SUM(`Quantity Sold`) AS `Total Quantity Sold`
FROM salesss
GROUP BY MONTH(Date), DATE_FORMAT(Date, 'MMMM')
ORDER BY Month;

--12.QUANTITY SOLD PER DAY NAME
SELECT
    DATE_FORMAT(Date, 'EEEE') AS `Day Name`,
    SUM(`Quantity Sold`) AS `Total Quantity Sold`
FROM salesss
GROUP BY DATE_FORMAT(Date, 'EEEE'), DAYOFWEEK(Date)
ORDER BY DAYOFWEEK(Date);

--13.AVG SALES BY MONTH
SELECT
    MONTH(Date) AS Month,
    DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
    AVG(Sales) AS `Average Sales`
FROM salesss
GROUP BY MONTH(Date), DATE_FORMAT(Date, 'MMMM')
ORDER BY Month;

--14 MAXIMUM AND MINIMUM SALES BY MONTH
SELECT
    MONTH(Date) AS Month,
    DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
    MAX(Sales) AS `Maximum Sale`,
    MIN(Sales) AS `Minimum Sale`
FROM salesss
GROUP BY MONTH(Date), DATE_FORMAT(Date, 'MMMM')
ORDER BY Month;

---------------------------------------------------------
--FINAL FEATURE BUILDING
SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    DATE_FORMAT(Date, 'MMMM') AS `Month Name`,
    SUM(Sales) AS `Total Sales`,
    SUM(`Cost Of Sales`) AS `Total Cost Of Sales`,
    SUM(`Quantity Sold`) AS `Total Quantity Sold`,
    SUM(Sales - `Cost Of Sales`) AS Profit,
    AVG(Sales) AS `Average Sales`,
    AVG(`Cost Of Sales`) AS `Average Cost Of Sales`,
    AVG(`Quantity Sold`) AS `Average Quantity Sold`,
    COUNT(Date) AS `Number Of Sales Days`
FROM salesss
GROUP BY
    YEAR(Date),
    MONTH(Date),
    DATE_FORMAT(Date, 'MMMM')
ORDER BY
    Year,
    Month;
