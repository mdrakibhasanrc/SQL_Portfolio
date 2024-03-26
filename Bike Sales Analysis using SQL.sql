--- Bike Sales Analysis in Europe



select
   *
from `sqlproject-379113.bike_sales.analytics_query`
limit 10;

-- No of Counts

select
   count(*) as count_order
from `sqlproject-379113.bike_sales.analytics_query`
;

-- Total Revenue and Profit
select
   sum(Revenue) as Total_Sales,
   sum(Profit) as Total_Profit
from `sqlproject-379113.bike_sales.analytics_query`;


-- What are the top-selling product categories in terms of revenue?
select
    Product_Category,
    sum(Revenue) as Total_Sales
from `sqlproject-379113.bike_sales.analytics_query`
group by Product_Category
order by Total_Sales desc
limit 1;

-- How does the customer age group impact the average unit price of products purchased?

select
   Customer_Age_Group,
   avg(Unit_Price) as unit_price
from `sqlproject-379113.bike_sales.analytics_query`
group by Customer_Age_Group
order by Unit_Price desc;

-- Which countries have the highest and lowest average profit margins?
select
   Country,
   (sum(Profit)/sum(Revenue))*100 as profit_margin
from `sqlproject-379113.bike_sales.analytics_query`
group by Country
order by profit_margin desc , Country asc;

-- What is the distribution of product categories across different states?
select
   State,
   Product_Category,
   sum(Order_Quantity) as total_order
from `sqlproject-379113.bike_sales.analytics_query`
group by State,Product_Category
order by total_order desc;

-- How does the order quantity vary between weekdays and weekends?

select
   Weekend_Flag,
   sum(Order_Quantity) as total_order
from `sqlproject-379113.bike_sales.analytics_query`
group by Weekend_Flag
order by total_order desc;

-- What is the average profit per order for each sub-category of products?
select
   Sub_Category,
   avg(Profit) as avg_profit
from `sqlproject-379113.bike_sales.analytics_query`
group by 
   Sub_Category
order by 
    avg_profit desc;


-- How does the customer age group impact the revenue generated?

select
   Customer_Age_Group,
   sum(Revenue) as total_revenue
from `sqlproject-379113.bike_sales.analytics_query`
group by Customer_Age_Group
order by total_revenue desc;


-- Which months see the highest and lowest sales revenue?

select
   Month_Name,
   sum(Revenue) as total_Revenue
from `sqlproject-379113.bike_sales.analytics_query`
group by Month_Name
order by total_Revenue desc , Month_Name asc;


-- Which sub-categories of products have the highest profit margins?

select
   Sub_Category,
   (sum(Profit)/sum(Revenue))*100 as profit_margin
from `sqlproject-379113.bike_sales.analytics_query`
group by Sub_Category
order by profit_margin desc;



-- What is the relationship between unit cost and unit price for different product categories?

SELECT
   Product_Category,
   AVG(Unit_Cost) AS Average_Unit_Cost,
   AVG(Unit_Price) AS Average_Unit_Price
FROM `sqlproject-379113.bike_sales.analytics_query`
GROUP BY Product_Category;
