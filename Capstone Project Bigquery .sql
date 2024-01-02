-- select all data from Q1 columns

select
 *
 from 
    `uber-data-393909.analysis.Q1`;

-- Check total rows

select
 count(*) as total_rows
 from 
    `uber-data-393909.analysis.Q1`;


-- check duplicate rows
select
   count(distinct ride_id )
from
   `uber-data-393909.analysis.Q1`;


--check the number of nulls per row
select
   count(*)-count(ride_id) as ride_id,
   count(*)-count(rideable_type) as rideable_type,
   count(*)-count(started_at) as started_at,
   count(*)-count(start_station_name) as start_station_name,
   count(*)-count(end_station_name) as end_station_name,
   count(*)-count(end_station_id) as end_station_id,
   count(*)-count(start_lat) as start_lat,
   count(*)-count(start_lng) as start_lng,
   count(*)-count(end_lat) as end_lat,
   count(*)-count(end_lng) as end_lng,
   count(*)-count(member_casual) as member_casual
from
  `uber-data-393909.analysis.Q1`;


-- checks how many stations there are (50 stations)
select
  count(distinct end_station_name) as count_station_name
from
  `uber-data-393909.analysis.Q1`;

  -- confirms the station count (50 stations still)
SELECT 
   DISTINCT start_station_name AS start_station
from
   `uber-data-393909.analysis.Q1`;


-- confirms that member type is only 2 values which are member and casual riders

select
   distinct member_casual as member_type
from
   `uber-data-393909.analysis.Q1`;



-- remove null values and create new table
create table `uber-data-393909.analysis.Q1_trips` as
select * from
(select
  *
from
  `uber-data-393909.analysis.Q1`
where
    start_station_name is not null and
    end_station_name is not null and
    end_station_id is not null and
    end_lat is not null and
    end_lng is not null);
    
-- create new table for clean data
-- Extract month,day,week
create table `uber-data-393909.analysis.Q1_trips_clean` as
select * from(
SELECT 
    ride_id,rideable_type,start_station_name, end_station_name, start_lat, start_lng,end_lat, end_lng, member_casual AS 
     member_type,started_at,
     case 
        when extract (dayofweek from started_at)=1 then 'Sun'
        when extract (dayofweek from started_at)=2 then 'Mon'
        when extract (dayofweek from started_at)=3 then 'Tue'
        when extract (dayofweek from started_at)=4 then 'Wed'
        when extract (dayofweek from started_at)=5 then 'Thu'
        when extract (dayofweek from started_at)=6 then 'Fri'
        when extract (dayofweek from started_at)=7 then 'Sat'
        end as day_of_week,
     case
        when extract(month from started_at)=2 then 'Feb'
        when extract(month from started_at)=3 then 'Mar'
        else 'Unknown' 
        end as month,
      extract(year from started_at) as year,
      extract(day from started_at) as day,
      TIMESTAMP_DIFF (ended_at, started_at, minute) AS ride_length_m,
      FORMAT_TIMESTAMP("%I:%M %p", started_at) AS time
 FROM
    `uber-data-393909.analysis.Q1_trips`);
    
-- Data Exploration

SELECT
 *
 FROM
    `uber-data-393909.analysis.Q1_trips_clean` 
 LIMIT 1000;

 -- average trip time this is for total users
 select
    round(avg(ride_length_m),2) as avg_trip_Time
 from  
   `uber-data-393909.analysis.Q1_trips_clean`;


 -- average trip time for each group.

 select
    member_type,
    round(avg(ride_length_m),2) as avg_trip_Time
 from  
   `uber-data-393909.analysis.Q1_trips_clean`
   group by
      member_type;


--max trip time for both members
 select
    member_type,
    max(ride_length_m) as max_trip_Time
 from  
   `uber-data-393909.analysis.Q1_trips_clean`
   group by
      member_type;


---- minimum amount of time spent on a bike divided per group

 select
    member_type,
    min(ride_length_m) as min_trip_Time
 from  
   `uber-data-393909.analysis.Q1_trips_clean`
   group by
      member_type;


-- this query checks what days are the most popular ones within the week 
select
   day_of_week,
   count(ride_id) as count_ride
from
   `uber-data-393909.analysis.Q1_trips_clean`
group by 
    day_of_week
order by
     count_ride desc;


-- this query checks for the most popular and least popular day for casual riders
select
   day_of_week,
   count(day_of_week) as count_ride
from
   `uber-data-393909.analysis.Q1_trips_clean`
where member_type='casual'
group by 
    day_of_week
order by
     count_ride desc;

-- this query checks for the most popular and least popular day for members riders
select
   day_of_week,
   count(day_of_week) as count_ride
from
   `uber-data-393909.analysis.Q1_trips_clean`
where member_type='member'
group by 
    day_of_week
order by
     count_ride desc;

-- this query checks for the most popular and least popular day for members member type
select
   member_type,
   day_of_week,
   count(day_of_week) as count_ride
from
   `uber-data-393909.analysis.Q1_trips_clean`
group by 
    day_of_week,
    member_type
order by
     count_ride desc;

-- this query selects the number of frequency of rides per month for members
select
   month,
   count(month) as count_ride
from
   `uber-data-393909.analysis.Q1_trips_clean`
where member_type='member'
group by 
    month
order by
     count_ride desc;

-- this query selects the number of frequency of rides per month for casual riders
select
   month,
   count(month) as count_ride
from
   `uber-data-393909.analysis.Q1_trips_clean`
where member_type='casual'
group by 
    month
order by
     count_ride desc;

select
   month,
   count(month) as total_ride,
   countif(member_type='casual') as casual_type,
   countif(member_type='member') as members_type
from
   `uber-data-393909.analysis.Q1_trips_clean`
group by 
    month
order by
     total_ride desc;

  --trip time (hour)

            SELECT 
              EXTRACT (HOUR from started_at) AS time_of_day, count (*) AS occurances, member_type
            FROM
             `uber-data-393909.analysis.Q1_trips_clean`
            GROUP BY
              time_of_day , member_type
            ORDER BY
              time_of_day DESC;


-- shows the least and most frequented start station name for member type
select
   start_station_name,
   count(start_station_name) as total_count_station,
   countif(member_type='casual') as casual_type,
   countif(member_type='member') as members_type
from
   `uber-data-393909.analysis.Q1_trips_clean`
group by
    start_station_name;



 -- shows least and most frequented end station name for member type

select
   end_station_name,
   count(start_station_name) as total_count_station,
   countif(member_type='casual') as casual_type,
   countif(member_type='member') as members_type
from
   `uber-data-393909.analysis.Q1_trips_clean`
group by
    end_station_name
order by
   total_count_station desc;

-- Checks the most popular routes
            SELECT
              COUNT(*) AS frequency,
              end_station_name,
              start_station_name
            FROM
              `uber-data-393909.analysis.Q1_trips_clean`
            GROUP BY
              start_station_name,
              end_station_name
            ORDER BY
              frequency DESC LIMIT 2;

 -- checks the most popular routes for member type
          SELECT
              COUNT(*) AS frequency,
              end_station_name,
              start_station_name,
              countif(member_type='casual') as casual_type,
             countif(member_type='member') as members_type
            FROM
              `uber-data-393909.analysis.Q1_trips_clean`
            GROUP BY
              start_station_name,
              end_station_name
            ORDER BY
              frequency DESC LIMIT 2;


-- checks the least popular routes for member type
          SELECT
              COUNT(*) AS frequency,
              end_station_name,
              start_station_name,
              countif(member_type='casual') as casual_type,
             countif(member_type='member') as members_type
            FROM
              `uber-data-393909.analysis.Q1_trips_clean`
            GROUP BY
              start_station_name,
              end_station_name
            ORDER BY
              frequency asc LIMIT 2;







