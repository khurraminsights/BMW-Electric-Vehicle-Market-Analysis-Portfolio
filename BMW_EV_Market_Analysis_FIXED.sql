/*
BMW EV Market Analysis — corrected reproducible SQL Server educational case study
Source: BMW_EV_Market_Analysis.sql supplied by the user.
Changes: removed duplicate inserts; repaired syntax; protected comparison grain;
replaced unsupported preference and market-share calculations with descriptive measures.
All data below are demonstration records, not actual BMW sales or industry data.
RUN IN A TEST SQL SERVER INSTANCE. Creates/rebuilds FOUR tables in this database.
*/
IF DB_ID(N'BMW_EV_Market_Analysis') IS NULL
    CREATE DATABASE BMW_EV_Market_Analysis;
GO
USE BMW_EV_Market_Analysis;
GO
DROP TABLE IF EXISTS dbo.Potential_Customers;
DROP TABLE IF EXISTS dbo.Competitor_EVs;
DROP TABLE IF EXISTS dbo.BMW_EVs;
DROP TABLE IF EXISTS dbo.BMW_Sales;
GO
CREATE TABLE dbo.BMW_Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    [Year] INT NOT NULL CHECK ([Year] BETWEEN 2000 AND 2100),
    Region NVARCHAR(50) NOT NULL,
    Vehicle_Type NVARCHAR(20) NOT NULL CHECK (Vehicle_Type IN (N'Electric',N'Non-Electric')),
    Model NVARCHAR(50) NOT NULL,
    Sales INT NOT NULL CHECK (Sales >= 0)
);
CREATE TABLE dbo.BMW_EVs (
    EV_ID INT IDENTITY(1,1) PRIMARY KEY,
    Model NVARCHAR(50) NOT NULL,
    Customer_Satisfaction DECIMAL(3,2) NOT NULL CHECK (Customer_Satisfaction BETWEEN 0 AND 5),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Range_KM INT NOT NULL CHECK (Range_KM >= 0),
    Battery_Capacity_KWh DECIMAL(5,2) NOT NULL CHECK (Battery_Capacity_KWh >= 0),
    Sales INT NOT NULL CHECK (Sales >= 0)
);
CREATE TABLE dbo.Competitor_EVs (
    Competitor_ID INT IDENTITY(1,1) PRIMARY KEY,
    Competitor NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    [Year] INT NOT NULL,
    Region NVARCHAR(50) NOT NULL,
    Sales INT NOT NULL CHECK (Sales >= 0)
);
CREATE TABLE dbo.Potential_Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Region NVARCHAR(50) NOT NULL,
    Age INT NOT NULL CHECK (Age BETWEEN 0 AND 120),
    Interest NVARCHAR(50) NOT NULL
);
GO
-- Source's second batches contain all intended unique sample records.
INSERT INTO dbo.BMW_Sales ([Year],Region,Vehicle_Type,Model,Sales) VALUES
(2022,N'North America',N'Electric',N'i4',1500),
(2022,N'Europe',N'Electric',N'iX3',2200),
(2023,N'Asia',N'Electric',N'iX',1800),
(2023,N'North America',N'Electric',N'iX3',2500),
(2023,N'Europe',N'Electric',N'i7',1700),
(2023,N'Asia',N'Electric',N'i4',2300),
(2022,N'North America',N'Non-Electric',N'3 Series',4000),
(2023,N'North America',N'Non-Electric',N'X5',5200),
(2022,N'Europe',N'Non-Electric',N'5 Series',3100),
(2023,N'Asia',N'Non-Electric',N'7 Series',4500),
(2022,N'Europe',N'Non-Electric',N'X3',2900);
INSERT INTO dbo.BMW_EVs (Model,Customer_Satisfaction,Price,Range_KM,Battery_Capacity_KWh,Sales) VALUES
(N'i4',4.5,55000.00,590,80.0,1500),
(N'iX3',4.3,65000.00,460,74.0,2200),
(N'iX',4.6,85000.00,630,100.0,1800),
(N'i7',4.8,100000.00,500,120.0,1700),
(N'i4',4.7,55000.00,590,80.0,2300),
(N'i3',4.2,45000.00,350,60.0,1900),
(N'iX1',4.4,65000.00,480,70.0,2200);
INSERT INTO dbo.Competitor_EVs (Competitor,Model,[Year],Region,Sales) VALUES
(N'Tesla',N'Model 3',2022,N'North America',7000),
(N'Tesla',N'Model S',2023,N'Europe',5000),
(N'Tesla',N'Model Y',2023,N'Asia',5500),
(N'Audi',N'e-tron',2023,N'Asia',3000),
(N'Audi',N'Q4 e-tron',2023,N'North America',2700),
(N'Mercedes',N'EQC',2022,N'Europe',3500),
(N'Mercedes',N'EQS',2023,N'North America',4000),
(N'Nissan',N'Leaf',2022,N'Asia',4800),
(N'Hyundai',N'Ioniq 5',2023,N'North America',4300);
INSERT INTO dbo.Potential_Customers (Region,Age,Interest) VALUES
(N'North America',30,N'Electric Vehicles'),
(N'Europe',45,N'Electric Vehicles'),
(N'Asia',35,N'Electric Vehicles'),
(N'North America',28,N'Electric Vehicles'),
(N'Europe',38,N'Electric Vehicles'),
(N'Asia',42,N'Electric Vehicles'),
(N'North America',33,N'Electric Vehicles'),
(N'Europe',50,N'Electric Vehicles'),
(N'Asia',29,N'Electric Vehicles');
GO
-- QUALITY CHECK: expected table rows 11 / 7 / 9 / 9.
SELECT N'BMW_Sales' AS TableName,COUNT(*) AS RowsFound FROM dbo.BMW_Sales
UNION ALL SELECT N'BMW_EVs',COUNT(*) FROM dbo.BMW_EVs
UNION ALL SELECT N'Competitor_EVs',COUNT(*) FROM dbo.Competitor_EVs
UNION ALL SELECT N'Potential_Customers',COUNT(*) FROM dbo.Potential_Customers;
-- EV-only example units are 3,700 in 2022 and 8,300 in 2023 (12,000 total).

-- 1. YEARLY EV UNIT TREND
SELECT [Year],SUM(Sales) AS EV_Units
FROM dbo.BMW_Sales WHERE Vehicle_Type=N'Electric'
GROUP BY [Year] ORDER BY [Year];

-- 2. REGION EV UNITS
SELECT Region,SUM(Sales) AS EV_Units
FROM dbo.BMW_Sales WHERE Vehicle_Type=N'Electric'
GROUP BY Region ORDER BY EV_Units DESC;

-- 3. BEST-SELLING EV MODEL IN EACH REGION (ties preserved)
WITH ModelUnits AS (
    SELECT Region,Model,SUM(Sales) AS EV_Units
    FROM dbo.BMW_Sales WHERE Vehicle_Type=N'Electric'
    GROUP BY Region,Model
), Ranked AS (
    SELECT *,DENSE_RANK() OVER(PARTITION BY Region ORDER BY EV_Units DESC) AS SalesRank
    FROM ModelUnits
)
SELECT Region,Model,EV_Units,SalesRank FROM Ranked ORDER BY Region,SalesRank,Model;

-- 4. RECORDED SATISFACTION AND FEATURES BY MODEL; not consumer feature preferences
SELECT Model,CAST(AVG(Customer_Satisfaction) AS DECIMAL(5,2)) AS AvgSatisfaction,
       CAST(AVG(Price) AS DECIMAL(12,2)) AS AvgPriceUSD,
       CAST(AVG(CAST(Range_KM AS DECIMAL(12,2))) AS DECIMAL(10,2)) AS AvgRangeKM,
       CAST(AVG(Battery_Capacity_KWh) AS DECIMAL(10,2)) AS AvgBatteryKWh,
       COUNT(*) AS SourceRecords
FROM dbo.BMW_EVs GROUP BY Model ORDER BY AvgSatisfaction DESC,Model;

-- 5. DESCRIPTIVE MODEL PRICE, SATISFACTION AND SAMPLE SALES (no causal impact claim)
SELECT Model,AVG(Price) AS AvgPriceUSD,AVG(Customer_Satisfaction) AS AvgSatisfaction,
       SUM(Sales) AS RecordedModelSales
FROM dbo.BMW_EVs GROUP BY Model ORDER BY AvgPriceUSD DESC;

-- 6. MATCHED REGION-YEAR BMW AND SELECTED COMPETITOR SALES; no invented year alignment
WITH BMW AS (
 SELECT [Year],Region,SUM(Sales) AS BMWUnits FROM dbo.BMW_Sales
 WHERE Vehicle_Type=N'Electric' GROUP BY [Year],Region
), Rival AS (
 SELECT [Year],Region,Competitor,SUM(Sales) AS RivalUnits FROM dbo.Competitor_EVs
 WHERE Competitor IN (N'Tesla',N'Audi',N'Mercedes')
 GROUP BY [Year],Region,Competitor
)
SELECT r.[Year],r.Region,r.Competitor,b.BMWUnits,r.RivalUnits,
       b.BMWUnits-r.RivalUnits AS BMWMinusRivalUnits
FROM Rival r INNER JOIN BMW b ON b.[Year]=r.[Year] AND b.Region=r.Region
ORDER BY r.[Year],r.Region,r.Competitor;

-- 7. REGIONS/YEAR WHERE AGGREGATED INCLUDED RIVALS OUTSELL BMW.
-- This is NOT market share; competitor coverage is incomplete.
WITH BMW AS (
 SELECT [Year],Region,SUM(Sales) AS BMWUnits FROM dbo.BMW_Sales
 WHERE Vehicle_Type=N'Electric' GROUP BY [Year],Region
), Rival AS (
 SELECT [Year],Region,SUM(Sales) AS IncludedRivalUnits FROM dbo.Competitor_EVs
 WHERE Competitor IN (N'Tesla',N'Audi',N'Mercedes') GROUP BY [Year],Region
)
SELECT b.[Year],b.Region,b.BMWUnits,r.IncludedRivalUnits,
       r.IncludedRivalUnits-b.BMWUnits AS UnitGap
FROM BMW b INNER JOIN Rival r ON r.[Year]=b.[Year] AND r.Region=b.Region
WHERE b.BMWUnits<r.IncludedRivalUnits ORDER BY UnitGap DESC;

-- 8. POTENTIAL CUSTOMER SAMPLE COUNTS; the Interest field has NO intensity categories.
SELECT Region,COUNT(*) AS SampleCustomerCount,
       COUNT(DISTINCT Interest) AS DistinctInterestLabels
FROM dbo.Potential_Customers GROUP BY Region ORDER BY SampleCustomerCount DESC,Region;

-- 9. REGIONAL SAMPLE COUNTS VS EV UNITS, aggregated before JOIN to prevent multiplication.
WITH CustomersByRegion AS (
 SELECT Region,COUNT(*) AS SampleCustomers FROM dbo.Potential_Customers GROUP BY Region
), SalesByRegion AS (
 SELECT Region,SUM(Sales) AS EVUnits FROM dbo.BMW_Sales
 WHERE Vehicle_Type=N'Electric' GROUP BY Region
)
SELECT c.Region,c.SampleCustomers,s.EVUnits
FROM CustomersByRegion c LEFT JOIN SalesByRegion s ON s.Region=c.Region ORDER BY c.Region;

-- 10. AVAILABLE MODEL FEATURES IN REGIONS WHERE BMW EV MODELS ARE RECORDED.
-- Feature scores are author-defined proxies, NOT actual customer preferences.
WITH RegionModel AS (
 SELECT DISTINCT Region,Model FROM dbo.BMW_Sales WHERE Vehicle_Type=N'Electric'
), ModelFeatures AS (
 SELECT Model,AVG(CAST(Range_KM AS DECIMAL(10,2))) AS RangeKM,
        AVG(Battery_Capacity_KWh) AS BatteryKWh FROM dbo.BMW_EVs GROUP BY Model
)
SELECT rm.Region,rm.Model,m.RangeKM,m.BatteryKWh,
 CASE WHEN m.RangeKM >= 400 THEN N'400+ km' ELSE N'Below 400 km' END AS RangeGroup
FROM RegionModel rm LEFT JOIN ModelFeatures m ON m.Model=rm.Model
ORDER BY rm.Region,rm.Model;

-- 11. CUSTOMER INTEREST LABEL DISTRIBUTION; meaningful levels are not in source.
SELECT Interest,Region,COUNT(*) AS SampleCustomers
FROM dbo.Potential_Customers GROUP BY Interest,Region ORDER BY Region,Interest;

-- 12. REGIONAL FEATURES OF BMW MODELS ACTUALLY SHOWN IN THE SAMPLE SALES TABLE.
-- This measures model specifications, NOT customer feature preferences.
WITH RegionModel AS (
 SELECT DISTINCT Region,Model FROM dbo.BMW_Sales WHERE Vehicle_Type=N'Electric'
), Features AS (
 SELECT Model,AVG(CAST(Range_KM AS DECIMAL(10,2))) AS RangeKM,
        AVG(Battery_Capacity_KWh) AS BatteryKWh FROM dbo.BMW_EVs GROUP BY Model
)
SELECT r.Region,COUNT(*) AS UniqueModels,
       CAST(AVG(f.RangeKM) AS DECIMAL(10,2)) AS AvgModelRangeKM,
       CAST(AVG(f.BatteryKWh) AS DECIMAL(10,2)) AS AvgModelBatteryKWh
FROM RegionModel r JOIN Features f ON r.Model=f.Model
GROUP BY r.Region ORDER BY r.Region;
GO
