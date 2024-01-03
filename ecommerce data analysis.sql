use dataology;

-- Analyzing Data with SQL (Structured Query Language) — A Case from an E-Commerce Company
-- Tools or Database: MySQL

-- Business Case: An E-Commerce company has been collecting data from its customer during the last 2 years of its operation. The collected data is used to help the management and operation for analyzing and answering some questions they face in their daily business operation. There are 3 datasets used in analyzing and answering the above questions, mainly the order_detail, sku_detail, and payment_detail datasets. The questions are as follows with query:

-- Q1: Of all the paid transactions that took place during the 2021, in what month did the maximum total transaction (after_discount) happen?

select
   monthname( order_date) as month,
   round(sum(after_discount),2) as Total_sales
from 
    order_detail
where
    is_valid=1 and year(order_date)=2021
group by
     month
order by
     Total_sales desc;
     
-- Q2: Of all the paid transactions that took place during the 2021, in what month did the total customer (unique), total order (unique), and the total quantity number of product reach their maximum?

select
   monthname( order_date) as month,
   count(distinct customer_id) as Total_customer,
   count(distinct id) as Total_order,
   sum(qty_ordered) as total_quantity
from 
    order_detail
where
    is_valid=1 and year(order_date)=2021
group by
     month
order by
     total_quantity desc,Total_customer desc, Total_order desc;
	
-- Q3. Of all the paid transactions that took place during the 2022, what is the category of product that drove the maximum value of transaction?

select
    sk.category,
    sum(od.after_discount) as after_discount_sales
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2022
group by
    sk.category
order by 
     after_discount_sales desc;

-- Q4: By comparing the paid transaction value of each product category between year 2021 and 2022, what are the product categories that experienced improvement, and what are the product categories that experienced decrement of their corresponding transaction values during the period of 2021 and 2022?

with 2022_sales as (select
    sk.category,
    sum(od.after_discount) as after_discount_sales_2022
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2022
group by
    sk.category
order by 
     after_discount_sales_2022 desc),
     
2021_sales as (select
    sk.category,
    sum(od.after_discount) as after_discount_sales_2021
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2021
group by
    sk.category
order by 
     after_discount_sales_2021 desc)
     
select
    COALESCE(s22.category, s21.category) AS category,
   after_discount_sales_2022,
   after_discount_sales_2021,
    (after_discount_sales_2022-after_discount_sales_2021) as sales_difference
from
    2022_sales s22
left join 
     2021_sales s21
on s22.category=s21.category;

-- Q5: Display the top 10 sku_name (along with its corresponding category) based on the paid transaction value during the 2022. Display also the total number of customer (unique), total_order (unique), and total quantity!

select
    sk.sku_name,
    sk.category,
    sum(od.after_discount) as after_discount_sales_2022,
    count(distinct od.customer_id) as Total_customer,
    count(distinct od.id) as Total_order,
    sum(od.qty_ordered) as total_quantity
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2022
group by
    sk.sku_name,
    sk.category
order by 
     after_discount_sales_2022 desc
limit 10;

-- Q6: Display the top 5 of most popularly used of payment method in 2022 for all paid transactions (based on the total unique order)!

select
   py.payment_method,
   count(distinct od.id) as unique_order
from payment_detail py
left join order_detail od
on py.id=od.payment_id
where  is_valid=1 and year(order_date)=2022
group by
    py.payment_method
order by
    unique_order desc
limit 5;

-- Q7: Sort the following 5 products based on their corresponding paid transaction value: (Samsung, Apple, Sony, Huawei, and Lenovo)!

select
  case
    when sk.sku_name like "%Samsung%" then "Samsung"
    when sk.sku_name like "%Apple%" then "Apple"
    when sk.sku_name like "%Sony%" then "Sony"
    when sk.sku_name like "%Huawei%" then "Huawei"
    when sk.sku_name like "%Lenovo%" then "Lenovo"
    end as product_name,
    sum(od.after_discount) as after_discount_total_sales
from sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where
  is_valid=1 and (
    sk.sku_name like "%Samsung%"
   or sk.sku_name like "%Apple%"
    or sk.sku_name like "%Sony%"
    or sk.sku_name like "%Huawei%"  
     or sk.sku_name like "%Lenovo%"  
    )
group by
   product_name
order by
   after_discount_total_sales desc;
     
     
-- Q8: As per question no 3, make a profit comparison between year 2021 and 2022 for each paid product category prior to displaying the percentage (%) of the profit disparity between 2021 and 2022.

with 2022_sales as (select
    sk.category,
    sum(od.after_discount) as after_discount_sales_2022
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2022
group by
    sk.category
order by 
     after_discount_sales_2022 desc),
     
2021_sales as (select
    sk.category,
    sum(od.after_discount) as after_discount_sales_2021
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2021
group by
    sk.category
order by 
     after_discount_sales_2021 desc)
     
select
    COALESCE(s22.category, s21.category) AS category,
   after_discount_sales_2022,
   after_discount_sales_2021,
    ((after_discount_sales_2022-after_discount_sales_2021)/after_discount_sales_2021) as growth
from
    2022_sales s22
left join 
     2021_sales s21
on s22.category=s21.category
order by
    growth desc;
     
     
     
-- Q9: Display the top 5 of SKU with the highest contribution in year 2022, based on the product category with the highest profit grow between 2021 and 2022
     
 with 2022_sales as (select
	sk.sku_name,
    sk.category,
    sum(od.after_discount) as after_discount_sales_2022
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2022
group by
    sk.category,sk.sku_name
order by 
     after_discount_sales_2022 desc),
     
2021_sales as (select
    sk.sku_name,
    sk.category,
    sum(od.after_discount) as after_discount_sales_2021
from
   sku_detail sk
left join order_detail od
on sk.id=od.sku_id
where  is_valid=1 and year(order_date)=2021
group by
    sk.category,sk.sku_name
order by 
     after_discount_sales_2021 desc)
     
select
    COALESCE(s22.sku_name, s21.sku_name) AS category,
    COALESCE(s22.category, s21.category) AS category,
   after_discount_sales_2022,
   after_discount_sales_2021,
   (after_discount_sales_2022-after_discount_sales_2021) as sale_diff,
       CASE
        WHEN after_discount_sales_2021 = 0 THEN NULL
        ELSE ((after_discount_sales_2022 - after_discount_sales_2021) / after_discount_sales_2021)
    END AS growth
    
from
    2022_sales s22
left join 
     2021_sales s21
on s22.sku_name=s21.sku_name
order by
    growth desc
limit 5;    
     
-- Q10: Display the number of unique order that use the top 5 payment methods (from question no 6) based on the product category in year 2022!

SELECT
 sd.category,
 COUNT(DISTINCT CASE WHEN pd.payment_method = 'cod' 
    THEN od.id END) AS cod,
 COUNT(DISTINCT CASE WHEN pd.payment_method = 'Payaxis' 
    THEN od.id END) AS Payaxis,
 COUNT(DISTINCT CASE WHEN pd.payment_method = 'Easypay' 
    THEN od.id END) AS Easypay,
 COUNT(DISTINCT CASE WHEN pd.payment_method = 'customercredit' 
    THEN od.id END) AS customercredit,
 COUNT(DISTINCT CASE WHEN pd.payment_method = 'jazzwallet' 
    THEN od.id END) AS jazzwallet
FROM order_detail od
LEFT JOIN sku_detail sd
 ON od.sku_id = sd.id
LEFT JOIN payment_detail pd
 ON od.payment_id = pd.id
WHERE
 EXTRACT(YEAR FROM od.order_date) = 2022
 AND od.is_valid = 1
GROUP BY category
ORDER BY category

-- Based on the case explained, we can conclude that SQL is essential in managing, manipulating and analyzing large datasets. From the analysis being conducted, SQL can provide crucial insights and help make a data-driven decision for company that adopts its technologies.