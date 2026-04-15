-- Pharmaceutical Sales & Market Analysis (2020–2025)
-- Tools: MySQL, Power BI, Excel
-- Objective: Identify revenue drivers, product performance, and market trends

--------------------------------------------------
-- 1. Database Setup
--------------------------------------------------

-- Create and select database

CREATE DATABASE pharma_analysis;
USE pharma_analysis;

--------------------------------------------------
-- 2. Table Creation
--------------------------------------------------

-- Create main table structure for pharmaceutical sales data

CREATE TABLE pharma_sales (
    date DATE,
    year INT,
    month INT,
    day INT,
    region VARCHAR(50),
    country VARCHAR(50),
    category VARCHAR(50),
    medicine VARCHAR(100),
    age_group VARCHAR(20),
    units_sold INT,
    unit_price DECIMAL(10,2),
    stock_level INT,
    expiry_days_remaining INT,
    covid_flag INT,
    revenue DECIMAL(12,2),
    month_name VARCHAR(10),
    year_month_key VARCHAR(10)
);

--------------------------------------------------
-- 3. Data Exploration
--------------------------------------------------

-- Check total number of records

SELECT COUNT(*) AS total_records
FROM pharma_sales;

-- Preview sample data

SELECT *
FROM pharma_sales
LIMIT 5;

--------------------------------------------------
-- 4. Total Revenue Analysis
--------------------------------------------------

-- Calculate total revenue across dataset

SELECT 
    SUM(revenue) AS total_revenue
FROM pharma_sales;

--------------------------------------------------
-- 5. Top Performing Medicines
--------------------------------------------------

-- Identify top 10 medicines by revenue

SELECT 
    medicine, 
    SUM(revenue) AS total_revenue
FROM pharma_sales
GROUP BY medicine
ORDER BY total_revenue DESC
LIMIT 10;

--------------------------------------------------
-- 6. Revenue by Region
--------------------------------------------------

-- Analyze revenue distribution across regions

SELECT 
    region, 
    SUM(revenue) AS total_revenue
FROM pharma_sales
GROUP BY region
ORDER BY total_revenue DESC;

--------------------------------------------------
-- 7. Monthly Revenue Trends
--------------------------------------------------

-- Analyze revenue trends over time

SELECT 
    year_month_key, 
    SUM(revenue) AS monthly_revenue
FROM pharma_sales
GROUP BY year_month_key
ORDER BY year_month_key;

--------------------------------------------------
-- 8. Category Performance
--------------------------------------------------

-- Analyze revenue contribution by product category

SELECT 
    category, 
    SUM(revenue) AS total_revenue
FROM pharma_sales
GROUP BY category
ORDER BY total_revenue DESC;

--------------------------------------------------
-- 9. COVID Impact Analysis
--------------------------------------------------

-- covid_flag: 1 = COVID period, 0 = non-COVID period
-- Compare revenue during and outside COVID periods

SELECT 
    covid_flag, 
    SUM(revenue) AS total_revenue
FROM pharma_sales
GROUP BY covid_flag;
