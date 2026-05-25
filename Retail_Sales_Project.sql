-- Create Table


create table Retail_Sales
	(transactions_id int ,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar (15),
	age int,
	category varchar (15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float)
    ;

select *
from retail_sales
limit 10;

-- check null values

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

alter table retail_sales
rename column quantiy to Quantity;

-- Data Exploration
-- Number of Sales

select count(*) as Total_Sales
from retail_sales;

-- number of customers

select count(distinct customer_id) as Unique_customers
from retail_sales;

select count(distinct category) as Category
from retail_sales;

-- Data Analysis and Business Key Problems

-- 1. Retrieve all columns for sales made on '2022-11-05'

select * 
from retail_sales
where sale_date = '2022-11-05'
order by sale_time asc;

-- 2. Retrieve columns where the category is clothing and quantity is more than 3 in the month of Nov-2022

select *
from retail_sales
where category = 'clothing'
	and date_format(sale_date, '%Y-%m') = '2022-11'
    and quantity >= 3;


-- 3. Calculate total sales for each category

select category, 
	sum(total_sale) Total_Sales_Per_Category,
    count(*) Total_Orders
from retail_sales
group by category;

-- 4. Average age of customers who purchased items from the Beauty category

select category, round(Avg(age),2)
from retail_sales
where category = 'beauty';

-- 5. Find all transactions where the total_sale is greater than 1000

select *
from retail_sales
where total_sale > 1000;


-- 6. Total number of transactions made by each gender in each category

select 
	category, 
    gender, 
    count(transactions_id)
from retail_sales
group by category,
		gender
order by 1;

-- 7. Calculate average sales for each month. Find best selling month in each year.

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


-- 8. Find top 5 customers based on total sales

select distinct customer_id, sum(total_sale) Total_Per_Customer
from retail_sales
group by customer_id
order by Total_Per_Customer desc
limit 5;

-- 9. Find number of unique customers that purchased from each category

select category, count( distinct customer_id) Number_of_Customers
from retail_sales
group by category;



-- 10. Create shifts i.e morning <12, afternoon >12 and <=17, Evening >17. determine number of orders in each shift

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


































































































