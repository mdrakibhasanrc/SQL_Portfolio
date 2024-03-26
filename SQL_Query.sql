use campaign;
-- KPI

-- Total Spend
select
    sum(Total_Spend) as Total
from fact_table;

-- Total Purchase
select
    sum(Total_Purchase) as Total_Purchase
from fact_table;

-- Total web_visit_month
select
    sum(web_visit_month) as web_visit
from fact_table;

-- Total Campaign
select
  count(distinct Campaign) as Campaign_count
from campaign_dim;

-- What does the average customer look like?
-- Customer Average Age
select
    avg(Age) as avg_age
from customers_dim;


-- Customer Average Income
select
    avg(Income) as avg_income
from customers_dim;

-- Customer Education
select
    Education,
    count(Education) as Eduation
from customers_dim
group by
    Education
order by
    Eduation desc
limit 1;

-- Customer Maritial Status
select
    Marital_Status,
    count(Marital_Status) as Marital_Status
from customers_dim
group by
    Marital_Status
order by
    Marital_Status desc
limit 1;

-- Age Groups By Spends
select
    c.Age_Group,
    sum(f.Total_Spend) as Total
from customers_dim c
join fact_table f
on f.customer_id=c.customer_id
group by
    c.Age_Group;

-- Campaign by Customer Accepted Offer
select
     Campaign,
    sum(No) as accepted_offer
from campaign_dim
group by
    Campaign;

-- Education By Total Spends
select
    c.Education,
    count(c.Education) as count_edu,
    sum(f.Total_Spend) as Total
from customers_dim c
join fact_table f
on f.customer_id=c.customer_id
group by
    c.Education;


-- Maritial status By Total Spends
select
    c.Marital_Status,
    count(c.Marital_Status) as count_edu,
    sum(f.Total_Spend) as Total
from customers_dim c
join fact_table f
on f.customer_id=c.customer_id
group by
    c.Marital_Status;
    
 -- Country By Total Purchase
select
    c.Country,
    count(c.Country) as count_purchase,
    sum(f.Total_Purchase) as Total_spends
from customers_dim c
join fact_table f
on f.customer_id=c.customer_id
group by
    c.Country;   
    