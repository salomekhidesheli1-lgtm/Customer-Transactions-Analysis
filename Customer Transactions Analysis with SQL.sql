/*
=========================================================
CUSTOMER TRANSACTIONS ANALYSIS
Data Cleaning + Exploratory Data Analysis
Author: Salome Khidesheli
Tools: MySQL
=========================================================
*/


-- =====================================================
-- 1. INITIAL DATA EXPLORATION
-- =====================================================

SELECT *
FROM raw_data;

SELECT COUNT(*) AS total_records
FROM raw_data;

DESCRIBE raw_data;


-- =====================================================
-- 2. DUPLICATE DETECTION
-- =====================================================

WITH duplicated_records AS
(
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY
                   `Customer ID`,
                   Name,
                   Surname,
                   Gender,
                   Birthdate,
                   `Transaction Amount`,
                   `Date`,
                   `Merchant Name`,
                   Category
           ) AS row_num
    FROM raw_data
)

SELECT *
FROM duplicated_records
WHERE row_num > 1;


-- Check duplicated customer IDs

SELECT
    `Customer ID`,
    COUNT(*) AS duplicate_count
FROM raw_data
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;


-- =====================================================
-- 3. CREATE CLEAN TABLE
-- =====================================================

DROP TABLE IF EXISTS transactions_analysis;

CREATE TABLE transactions_analysis (
    `Customer ID` INT,
    `Name` TEXT,
    `Surname` TEXT,
    `Gender` TEXT,
    `Birthdate` DATE,
    `Transaction Amount` DOUBLE,
    `Date` DATE,
    `Merchant Name` TEXT,
    `Category` TEXT,
    row_num INT
);


INSERT INTO transactions_analysis
SELECT *,
       ROW_NUMBER() OVER(
           PARTITION BY
               `Customer ID`,
               Name,
               Surname,
               Gender,
               Birthdate,
               `Transaction Amount`,
               `Date`,
               `Merchant Name`,
               Category
       ) AS row_num
FROM raw_data;


-- Remove duplicate rows

DELETE
FROM transactions_analysis
WHERE row_num > 1;


-- Verify clean dataset

SELECT *
FROM transactions_analysis;


-- =====================================================
-- 4. DATA QUALITY CHECKS
-- =====================================================

SELECT
    SUM(CASE WHEN `Customer ID` IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN Name IS NULL OR Name = '' THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN Surname IS NULL OR Surname = '' THEN 1 ELSE 0 END) AS surname_nulls,
    SUM(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN Birthdate IS NULL THEN 1 ELSE 0 END) AS birthdate_nulls,
    SUM(CASE WHEN `Transaction Amount` IS NULL THEN 1 ELSE 0 END) AS amount_nulls,
    SUM(CASE WHEN `Date` IS NULL THEN 1 ELSE 0 END) AS date_nulls,
    SUM(CASE WHEN `Merchant Name` IS NULL OR `Merchant Name` = '' THEN 1 ELSE 0 END) AS merchant_nulls,
    SUM(CASE WHEN Category IS NULL OR Category = '' THEN 1 ELSE 0 END) AS category_nulls
FROM transactions_analysis;


-- =====================================================
-- 5. DATA CLEANING
-- =====================================================

UPDATE transactions_analysis
SET Gender = NULL
WHERE TRIM(Gender) = '';


-- Verify missing gender values

SELECT *
FROM transactions_analysis
WHERE Gender IS NULL;


-- =====================================================
-- 6. GENERAL DATA OVERVIEW
-- =====================================================

SELECT COUNT(*) AS total_transactions
FROM transactions_analysis;


SELECT
    COUNT(`Merchant Name`) AS merchant_records,
    COUNT(DISTINCT `Merchant Name`) AS unique_merchants
FROM transactions_analysis;


SELECT
    MIN(`Transaction Amount`) AS minimum_transaction,
    MAX(`Transaction Amount`) AS maximum_transaction,
    ROUND(AVG(`Transaction Amount`),2) AS average_transaction
FROM transactions_analysis;


-- =====================================================
-- 7. CATEGORY ANALYSIS
-- =====================================================

SELECT
    Category,
    COUNT(*) AS transaction_count
FROM transactions_analysis
GROUP BY Category
ORDER BY transaction_count DESC;


SELECT
    Category,
    ROUND(SUM(`Transaction Amount`),2) AS total_amount,
    ROUND(AVG(`Transaction Amount`),2) AS average_amount
FROM transactions_analysis
GROUP BY Category
ORDER BY total_amount DESC;


-- =====================================================
-- 8. YEARLY PERFORMANCE ANALYSIS
-- =====================================================

SELECT
    YEAR(`Date`) AS purchase_year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(`Transaction Amount`),2) AS total_revenue,
    ROUND(AVG(`Transaction Amount`),2) AS average_transaction_value
FROM transactions_analysis
GROUP BY YEAR(`Date`)
ORDER BY purchase_year;


-- =====================================================
-- 9. MONTHLY SALES TREND
-- =====================================================

SELECT
    DATE_FORMAT(`Date`, '%Y-%m') AS purchase_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(`Transaction Amount`),2) AS total_revenue,
    ROUND(AVG(`Transaction Amount`),2) AS average_transaction_value
FROM transactions_analysis
GROUP BY purchase_month
ORDER BY purchase_month;


-- Top 3 Months by Revenue

SELECT
    MONTHNAME(`Date`) AS purchase_month,
    ROUND(SUM(`Transaction Amount`),2) AS total_revenue
FROM transactions_analysis
GROUP BY MONTHNAME(`Date`)
ORDER BY total_revenue DESC
LIMIT 3;


-- =====================================================
-- 10. CUSTOMER ANALYSIS
-- =====================================================

SELECT
    CONCAT(Name,' ',Surname) AS customer_name,
    ROUND(SUM(`Transaction Amount`),2) AS total_purchase_amount
FROM transactions_analysis
GROUP BY customer_name
ORDER BY total_purchase_amount DESC;


-- Top 10 Customers

SELECT
    CONCAT(Name,' ',Surname) AS customer_name,
    ROUND(SUM(`Transaction Amount`),2) AS total_purchase_amount
FROM transactions_analysis
GROUP BY customer_name
ORDER BY total_purchase_amount DESC
LIMIT 10;


-- =====================================================
-- 11. GENDER ANALYSIS
-- =====================================================

SELECT
    Gender,
    COUNT(*) AS transaction_count,
    ROUND(SUM(`Transaction Amount`),2) AS total_revenue,
    ROUND(AVG(`Transaction Amount`),2) AS average_transaction_value
FROM transactions_analysis
GROUP BY Gender
ORDER BY total_revenue DESC;


-- =====================================================
-- 12. BUSINESS INSIGHTS QUERIES
-- =====================================================

-- Highest Revenue Category

SELECT
    Category,
    ROUND(SUM(`Transaction Amount`),2) AS total_revenue
FROM transactions_analysis
GROUP BY Category
ORDER BY total_revenue DESC
LIMIT 1;


-- Revenue Contribution By Category

SELECT
    Category,
    ROUND(SUM(`Transaction Amount`),2) AS total_revenue,
    ROUND(
        SUM(`Transaction Amount`) * 100 /
        (SELECT SUM(`Transaction Amount`)
         FROM transactions_analysis),
        2
    ) AS revenue_percentage
FROM transactions_analysis
GROUP BY Category
ORDER BY total_revenue DESC;


-- Average Spend Per Customer

SELECT
    ROUND(
        SUM(`Transaction Amount`) /
        COUNT(DISTINCT `Customer ID`),
        2
    ) AS average_spend_per_customer
FROM transactions_analysis;