-- E-commerce Sales Analysis Using Bigquery

-- Question:

-- To create a KPI banner showing year-to-date sales(YTD), year-to-date profit (YTDProfit), year-to-date Quantity sold(YTD Quantity) and year-to-date profit margin(YTD profit Margin).
-- Find Year-on -year growth on each KPI
-- Find YTD sales on each state
-- Top 5 and bottom 5 customer city sold
-- Find YTD sales by region
-- YTD sales by Shipping type


SELECT 
    *
 FROM `practice-410312.practice.dataset` ;

-- YTD Sales

SELECT 
    round(sum(sales_per_order),2) as total_sales
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date();


-- YTD Profit

SELECT 
    round(sum(profit_per_order),2) as total_profit
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date();

  -- YTD Quantity Sold

SELECT 
    round(sum(order_quantity),2) as quantity_sold
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date();

  -- Year-on -year growth for Sales

with sales_2022 as (
    SELECT 
    round(sum(sales_per_order),2) as total_sales_2022
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
),

sales_2021 as (
    SELECT 
    round(sum(sales_per_order),2) as total_sales_2021
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2021 and order_date<=current_date()
)

select
   round(((total_sales_2022-total_sales_2021)/(total_sales_2022))*100,2)as YoY_sales_growth
    
from  sales_2022, sales_2021;



-- Year-on -year growth for profit

with profit_2022 as (
    SELECT 
    round(sum(profit_per_order),2) as total_profit_2022
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
),

profit_2021 as (
    SELECT 
    round(sum(profit_per_order),2) as total_profit_2021
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2021 and order_date<=current_date()
)

select
   ((total_profit_2022-total_profit_2021)/(total_profit_2022))*100 as YoY_Profit_growth
    
from  profit_2022, profit_2021;


-- Year-on -year growth for quantity sold

with orders_quantity_2022 as (
    SELECT 
    round(sum(order_quantity),2) as order_quantity_2022
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
),

orders_quantity_2021 as (
    SELECT 
    round(sum(order_quantity),2) as order_quantity_2021
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2021 and order_date<=current_date()
)

select
   round(((order_quantity_2022-order_quantity_2021)/(order_quantity_2022))*100,2) as YoY_Quantity_sold
    
from  orders_quantity_2022, orders_quantity_2021;


-- -- Profit margin

SELECT 
    round(sum(profit_per_order)/sum(sales_per_order)*100,2) as profit_margin
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date();



-- YTD Sales, PYTD Sales, and Year over Yearr growth  By Category

with YTD_sale as (
    SELECT 
    category_name,
    round(sum(sales_per_order),2) as YTD_Sales,
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
  group by
     category_name
),
PYTD_sale as (
    SELECT 
    category_name,
    round(sum(sales_per_order),2) as PYTD_sales,
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2021 and order_date<=current_date()
  group by
     category_name
)
select
   yt.category_name,
   yt.YTD_Sales,
   py.PYTD_sales,
   round((yt.YTD_Sales-py.PYTD_sales)/(yt.YTD_Sales)*100,2) as YoY_Growth
from YTD_sale yt
join PYTD_sale py
on yt.category_name=py.category_name;



-- Top 5 Customer_city by YTD sales

SELECT 
    customer_city,
    round(sum(sales_per_order),2) as total_sales
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
  group by 
    customer_city
order by
    total_sales desc
limit 5;


-- Bottom 5 Customer_city by YTD sales

SELECT 
    customer_city,
    round(sum(sales_per_order),2) as total_sales
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
  group by 
    customer_city
order by
    total_sales asc
limit 5;




-- 
-- Sales by YTD Sales

SELECT 
    customer_region,
    round(sum(sales_per_order),2) as total_sales
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
  group by 
    customer_region
 order by
     total_sales desc;


-- Shipping Type  by YTD Sales

SELECT 
    shipping_type,
    round(sum(sales_per_order),2) as total_sales
 FROM `practice-410312.practice.dataset` 
 where
  extract(year from order_date)=2022 and order_date<=current_date()
  group by 
    shipping_type
 order by
     total_sales desc;





