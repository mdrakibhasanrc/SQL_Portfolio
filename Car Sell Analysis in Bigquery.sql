-- Car Inventory Data Analysis
-- KPI

-- Count Total car 
SELECT
  count(*) as total_car,
FROM
   `dbt-project-396315.pizza_sales.car_data`;

-- Max,Min and Avg Price
SELECT
  MAX(Price) as Max_Price,
  MIN(Price) as Min_Price,
  AVG(Price) as Avg_Price
FROM
   `dbt-project-396315.pizza_sales.car_data`;


-- Max,Min and Avg Price for certified Car
SELECT
  Brand_Name,
  MAX(Price) as Max_Price,
  MIN(Price) as Min_Price,
  AVG(Price) as Avg_Price,
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
    Brand_Name;



-- Find the average mileage of all cars in the dataset.
SELECT
    round(AVG(Mileage)) as avg_milege
FROM
   `dbt-project-396315.pizza_sales.car_data`;


-- List the distinct brand names present in the dataset.
SELECT
    distinct Brand_Name
FROM
   `dbt-project-396315.pizza_sales.car_data`;




-- Calculate the average rating and Price for certified cars and non-certified cars separately.

SELECT
    Certified_Group,
    ROUND(AVG(Rating)) as avg_Rating,
    ROUND(AVG(Price)) as avg_Price
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
      Certified_Group;

-- Identify the top 5 dealers with the highest number of cars in their inventory.

SELECT
    Delaer_Name,
    COUNT(Delaer_Name) as count_car
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
      Delaer_Name
ORDER BY
    count_car desc
LIMIT 5;

--  Determine the model year of the car with the highest rating.
SELECT
   Model_Year,
   AVG(Rating) as avg_rating
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
    Model_Year
ORDER BY
     avg_rating DESC;


--  Determine the Brand_Name of the car with the Avg Price.
SELECT
   Brand_Name,
   ROUND(AVG(Price),2) as avg_Price
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Brand_Name
ORDER BY
      avg_Price DESC;

--  Determine the top 5 model year of the car with the Avg_Price.
SELECT
   Model_Year,
   AVG(Price) as avg_Price
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
    Model_Year
ORDER BY
     avg_Price DESC
LIMIT 5;


-- Calculate the total number of cars for each rating group.
SELECT
    Rating_Group,
    COUNT(Rating_Group) as total_number_car
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
  Rating_Group
ORDER BY
    total_number_car DESC;


-- Calculate the average mileage for cars in each rating group.
SELECT
    Rating_Group,
   ROUND(AVG(Mileage)) as avg_milege
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
  Rating_Group
ORDER BY
    avg_milege DESC;


-- Identify the top 3 brands with the highest average ratings.
SELECT
   Brand_Name,
   ROUND(AVG(Rating),2) AS avg_rating
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
    Brand_Name
ORDER BY
     avg_rating DESC
LIMIT 3;


-- Calculate the total number of Car certified Group.
SELECT
    Certified_Group,
    COUNT(Certified_Group) as total_number_car
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
  Certified_Group
ORDER BY
    total_number_car DESC;



-- Retrieve the top 5 models with the highest average rating, and display their model names and average ratings.
SELECT
    Model_Name,
    ROUND(AVG(Rating),2) AS avg_rating
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Model_Name
ORDER BY 
    avg_rating DESC
LIMIT 5;

-- Find the brand that has the highest total mileage for its cars in the dataset.
SELECT
    Brand_Name,
    MAX(Rating) AS max_mileage
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Brand_Name
ORDER BY 
    max_mileage DESC
LIMIT 1;


--  Identify the Top 5 dealer(s) with the highest average rating for their cars.

SELECT
    Delaer_Name,
    ROUND(AVG(Rating),2) AS avg_rating
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Delaer_Name
ORDER BY 
    avg_rating DESC
LIMIT 5;

-- Calculate the percentage of certified cars in the dataset.

SELECT
    Delaer_Name,
    ROUND(AVG(Rating),2) AS avg_rating
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Delaer_Name
ORDER BY 
    avg_rating DESC
LIMIT 5;


-- List the dealer names and the number of cars they have in each price group.


SELECT
    Price_Group,
    Delaer_Name,
    COUNT(Price_Group) as cnt
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Price_Group,
    Delaer_Name
ORDER BY 
    cnt DESC;


-- Avg Price by Rating Group

SELECT
    Rating_Group,
    AVG(Price) as avg_price
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Rating_Group
ORDER BY 
    avg_price DESC;






-- Review By Brand name

SELECT
    Brand_Name,
    AVG(Review) as avg_review,
    MAX(Review) as max_review,
    MIN(Review) as min_review
FROM
   `dbt-project-396315.pizza_sales.car_data`
GROUP BY
   Brand_Name
ORDER BY 
    avg_review DESC
LIMIT 5;
