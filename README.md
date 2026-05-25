# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `p1_retail_db`

This project analyzes retail sales data using SQL to uncover customer behavior, sales trends, and business insights. The analysis includes data cleaning, exploration, and solving key business problems using SQL queries.

The project demonstrates practical SQL skills used in data analytics, including filtering, aggregation, grouping, Common Table Expressions (CTEs), window functions, and data analysis.

## Objectives

1. **Set up a retail sales database**
2. **Data Cleaning**
3. **Exploratory Data Analysis (EDA)**
4. **Business Analysis**

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantiy INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

alter table retail_sales
rename column quantiy to Quantity;
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select count(distinct customer_id) as Unique_customers
from retail_sales;

select count(distinct category) as Category
from retail_sales;

select count(distinct customer_id) as Unique_customers
from retail_sales;

select *
from retail_sales
where transactions_id is null
	or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or price_per_unit is null
    or quantiy is null
    or cogs is null
    or total_sale is null
    ;
```

### 3. Data Analysis and Business Key Problems

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all columns for sales made on '2022-11-05'**:
```sql
select * 
from retail_sales
where sale_date = '2022-11-05'
order by sale_time asc;
```

2. **Retrieve columns where the category is clothing and quantity is more than 3 in the month of Nov-2022**:
```sql
select *
from retail_sales
where category = 'clothing'
	and date_format(sale_date, '%Y-%m') = '2022-11'
    and quantity >= 3;
```

3. **Calculate total sales for each category**:
```sql
select category, 
	sum(total_sale) Total_Sales_Per_Category,
    count(*) Total_Orders
from retail_sales
group by category;
```

4. **Average age of customers who purchased items from the Beauty category.**:
```sql
select category, round(Avg(age),2)
from retail_sales
where category = 'beauty';
```

5. **Find all transactions where the total_sale is greater than 1000.**:
```sql
select *
from retail_sales
where total_sale > 1000;
```

6. **Total number of transactions made by each gender in each category.**:
```sql
select 
	category, 
    gender, 
    count(transactions_id)
from retail_sales
group by category,
		gender
order by 1;
```

7. **Calculate average sales for each month. Find best selling month in each year.**:
```sql
select year(sale_date) Year,
	month(sale_date) Month,
    Round(avg(total_sale), 2) Avg_Monthly_Sales,
    Rank () over(partition by year(sale_date) order by Round(avg(total_sale), 2) desc) as Monthly_Performance_Rank
from retail_sales
group by Year, Month;

with Monthly_Averages as
(select year(sale_date) Year,
	month(sale_date) Month,
    Round(avg(total_sale), 2) Avg_Monthly_Sales,
    Rank () over(partition by year(sale_date) order by Round(avg(total_sale), 2) desc) as Monthly_Performance_Rank
from retail_sales
group by Year, Month)
select Year, Month, avg_monthly_sales
from monthly_averages
where Monthly_Performance_Rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select distinct customer_id, sum(total_sale) Total_Per_Customer
from retail_sales
group by customer_id
order by Total_Per_Customer desc
limit 5;

```

9. **Find top 5 customers based on total sales.**:
```sql
select category, count( distinct customer_id) Number_of_Customers
from retail_sales
group by category;
```

10. **Create shifts i.e morning <12, afternoon >12 and <=17, Evening >17. determine number of orders in each shift**:
```sql
with Daily_Shifts as 
(select *,
case
	when hour(sale_time) <12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'afternoon'
    else 'evening'
end Shifts
from retail_sales)
select shifts, count(transactions_id) Total_Transactions
from Daily_Shifts
group by shifts;
```

## Findings

The dataset contained multiple product categories, enabling analysis of customer purchasing behavior across different retail segments.
Some product categories generated significantly higher sales revenue and order volumes, showing differences in customer demand across categories.
Monthly sales performance fluctuated throughout the year, with certain months recording stronger average sales than others.
A small group of customers contributed heavily to overall revenue, highlighting the importance of high-value customers to the business.
Transaction activity varied across different times of the day, with afternoon and evening shifts recording a large share of total orders.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project demonstrates how SQL can be used for data cleaning, exploratory data analysis, and solving business-focused problems using retail sales data. Through analyzing sales trends, customer behavior, and product performance, the project highlights how raw transactional data can be transformed into meaningful business insights that support better decision-making. 
