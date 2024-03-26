select
   *
  from `sqlproject-379113.walmart.analysis`;

  -- Walmart Store Analysis

  -- check null values
  select
    *
   from `sqlproject-379113.walmart.analysis`
   where Weekly_Sales is null;

-- 1. Which weeks had the maximum sales?
select
   Date,
   max(Weekly_Sales) as max_sales
from `sqlproject-379113.walmart.analysis`
group by Date
order by max_sales desc
limit 1;

-- 2. Which year recorded the highest total sales?
select
   extract(year from Date) as year,
   sum(Weekly_Sales) as sales
from `sqlproject-379113.walmart.analysis`
group by year
order by sales desc
limit 1;

-- 3. Which month had the highest sales in 2011?
select
   extract(month from Date) as mnth,
   sum(Weekly_Sales) as sales
from `sqlproject-379113.walmart.analysis`
where extract(year from Date)=2011
group by mnth
order by sales desc
limit 1;

-- 4. Which store had the most sales?

select
   store,
   sum(Weekly_Sales) as sales
from `sqlproject-379113.walmart.analysis`
group by store
order by sales desc
limit 1;

-- 5. What were the total sales during the holiday and non-holiday weeks?
select
   case
      when Holiday_Flag=0 then 'Holiday Week'
      else 'Non Holiday Week'
      end as week_type,
   sum(Weekly_Sales) as sales
from `sqlproject-379113.walmart.analysis`
group by week_type
order by sales desc;

-- 6. Which holidays have the most sales?
select
  Date,
  Holiday_Flag,
  max(weekly_sales) as sales
from `sqlproject-379113.walmart.analysis`
where Holiday_Flag=0
group by Date,Holiday_Flag
order by sales desc;


-- Which stores had the highest growth rate from 2010 to 2012?
WITH sales_2012 AS (
  SELECT
    store,
    weekly_sales
  FROM 
    `sqlproject-379113.walmart.analysis`
  WHERE 
    EXTRACT(YEAR FROM Date) = 2012
),
sales_2010 AS (
  SELECT
    store,
    weekly_sales
  FROM 
    `sqlproject-379113.walmart.analysis`
  WHERE 
    EXTRACT(YEAR FROM Date) = 2010
)
SELECT
  s2012.store AS store_id,
  ((s2012.weekly_sales - s2010.weekly_sales) / s2010.weekly_sales) * 100 AS growth_rate
FROM
  sales_2012 AS s2012
JOIN
  sales_2010 AS s2010
ON
  s2012.store = s2010.store
ORDER BY
  growth_rate DESC;

-- Which stores had the lowest growth rate from 2010 to 2012?

WITH sales_2012 AS (
  SELECT
    store,
    weekly_sales
  FROM 
    `sqlproject-379113.walmart.analysis`
  WHERE 
    EXTRACT(YEAR FROM Date) = 2012
),
sales_2010 AS (
  SELECT
    store,
    weekly_sales
  FROM 
    `sqlproject-379113.walmart.analysis`
  WHERE 
    EXTRACT(YEAR FROM Date) = 2010
)
SELECT
  s2012.store AS store_id,
  ((s2012.weekly_sales - s2010.weekly_sales) / s2010.weekly_sales) * 100 AS growth_rate
FROM
  sales_2012 AS s2012
JOIN
  sales_2010 AS s2010
ON
  s2012.store = s2010.store
ORDER BY
  growth_rate ASC
LIMIT
  5;
