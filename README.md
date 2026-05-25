**Retail Sales SQL Analysis Project**
**Overview**
This project analyzes retail sales data using SQL to uncover customer behavior, sales trends, and business insights. The project includes data cleaning, data exploration, and solving real business problems using SQL queries.

**Tools Used**
MySQL
**Dataset Information
**
The dataset contains retail transaction data including:
    Transaction ID
    Sale Date & Time
    Customer ID
    Gender
    Age
    Category
    Quantity
    Price Per Unit
    COGS
    Total Sale
**Data Cleaning**
    **Create Table**
    CREATE TABLE Retail_Sales
    (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
    );
**Check Null Values**

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR price_per_unit IS NULL
    OR quantiy IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
**Rename Incorrect Column Name**
    ALTER TABLE retail_sales
    RENAME COLUMN quantiy TO Quantity;
**Data Exploration**
**Total Number of Sales**
SELECT COUNT(*) AS Total_Sales
FROM retail_sales;

**Total Number of Customers**
SELECT COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_sales;
**Number of Categories**
SELECT COUNT(DISTINCT category) AS Category
FROM retail_sales;
******Business Problems & Solutions******
**1. Retrieve all columns for sales made on '2022-11-05'**
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'
ORDER BY sale_time ASC;
Insight

This query helps identify all transactions made on a specific date.

**2. Retrieve all transactions where category is Clothing and quantity sold is more than or equal to 3 in November 2022**
SELECT *
FROM retail_sales
WHERE category = 'clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantity >= 3;
Insight

This analysis helps identify high-volume clothing purchases during a specific month.

**3. Calculate total sales for each category**
SELECT
    category,
    SUM(total_sale) AS Total_Sales_Per_Category,
    COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category;
Insight

This query shows which product categories generate the highest revenue and order volume.

**4. Find the average age of customers who purchased Beauty products**
SELECT
    category,
    ROUND(AVG(age), 2) AS Average_Age
FROM retail_sales
WHERE category = 'beauty';
Insight

This helps understand the customer demographic for Beauty products.

**5. Find all transactions where total sale is greater than 1000**
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
Insight

This query identifies high-value transactions.

**6. Find total number of transactions made by each gender in each category**
SELECT
    category,
    gender,
    COUNT(transactions_id) AS Total_Transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
Insight

This helps analyze purchasing patterns by gender across categories.

**7. Calculate average sales for each month and find the best-selling month in each year**
SELECT
    YEAR(sale_date) AS Year,
    MONTH(sale_date) AS Month,
    ROUND(AVG(total_sale), 2) AS Avg_Monthly_Sales,
    RANK() OVER(
        PARTITION BY YEAR(sale_date)
        ORDER BY ROUND(AVG(total_sale), 2) DESC
    ) AS Monthly_Performance_Rank
FROM retail_sales
GROUP BY Year, Month;
Best Selling Month Per Year
WITH Monthly_Averages AS
(
    SELECT
        YEAR(sale_date) AS Year,
        MONTH(sale_date) AS Month,
        ROUND(AVG(total_sale), 2) AS Avg_Monthly_Sales,
        RANK() OVER(
            PARTITION BY YEAR(sale_date)
            ORDER BY ROUND(AVG(total_sale), 2) DESC
        ) AS Monthly_Performance_Rank
    FROM retail_sales
    GROUP BY Year, Month
)

SELECT
    Year,
    Month,
    Avg_Monthly_Sales
FROM Monthly_Averages
WHERE Monthly_Performance_Rank = 1;
Insight

This analysis identifies the strongest sales-performing months.

**8. Find the top 5 customers based on total sales**
SELECT
    customer_id,
    SUM(total_sale) AS Total_Per_Customer
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Per_Customer DESC
LIMIT 5;
Insight

This query identifies the highest-value customers.

**9. Find the number of unique customers who purchased from each category**
SELECT
    category,
    COUNT(DISTINCT customer_id) AS Number_of_Customers
FROM retail_sales
GROUP BY category;
Insight

This helps measure customer distribution across categories.

**10. Create sales shifts and determine number of orders in each shift
Shift Categories
Morning: Before 12 PM
Afternoon: Between 12 PM and 5 PM
Evening: After 5 PM**
WITH Daily_Shifts AS
(
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Shifts
    FROM retail_sales
)

SELECT
    shifts,
    COUNT(transactions_id) AS Total_Transactions
FROM Daily_Shifts
GROUP BY shifts;
Insight

This analysis helps identify peak transaction periods during the day.

******Conclusion******

This project demonstrates practical SQL skills used in real-world data analysis, including:

Data Cleaning
Aggregations
Window Functions
CTEs
Customer Analysis
Sales Trend Analysis
Business Insight Generation
