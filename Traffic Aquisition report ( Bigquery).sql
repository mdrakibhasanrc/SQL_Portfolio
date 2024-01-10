-- User dimensions & metrics (GA4)
-- Tools: Google Bigquery
-- Event name

SELECT 
   distinct event_name
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

 -- Total Users

 SELECT 
   count(distinct user_pseudo_id ) as total_user
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` ;

-- New user and Returning User

 SELECT 
     case
        when (select value.int_value from unnest(event_params) where key='ga_session_number')=1 then "New Visior"
        when (select value.int_value from unnest(event_params) where key='ga_session_number')>1 then "Return Visitor"
        else null end as user_type,
   count(distinct user_pseudo_id ) as total_user
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
 group by user_type;


-- (%) of New user and Returning User

 SELECT 
        (count(case when (select value.int_value from unnest(event_params) where key='ga_session_number')=1 then user_pseudo_id else null end)/count(user_pseudo_id))*100 as _of_New_user_percent,
         (count(case when (select value.int_value from unnest(event_params) where key='ga_session_number')>1 then user_pseudo_id else null end)/count(user_pseudo_id))*100 as _of_return_user_percent
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

-- Total Session

 select
    count(distinct concat(user_pseudo_id,(select value.int_value from unnest (event_params) where key='ga_session_id')) ) as session
from
 `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

-- New Session Count
 SELECT
     count(case when (select value.int_value from unnest(event_params) where key='ga_session_number')=1 then concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key='ga_session_id'))else null end) as new_session
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

 -- % new sessions
 SELECT
     count(case when (select value.int_value from unnest(event_params) where key='ga_session_number')=1 then concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key='ga_session_id'))else null end)/count(distinct concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key='ga_session_id'))) as new_session
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


 -- Engagment
 select
    count(distinct concat(user_pseudo_id,(select value.int_value from unnest (event_params) where key='session_engaged')) ) as session_engaged
from
 `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

 -- Number of sessions per user

 select
    round(count(distinct (select value.int_value from unnest (event_params) where key ='ga_session_id'))/count(distinct user_pseudo_id),2) as per_user_session
  from
     `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

 -- Combined query

 SELECT 
   distinct event_name,
   count(distinct user_pseudo_id ) as total_user,
   count(distinct concat(user_pseudo_id,(select value.int_value from unnest (event_params) where key='ga_session_id')) ) as session,
   count(case when (select value.int_value from unnest(event_params) where key='ga_session_number')=1 then concat(user_pseudo_id,(select value. 
      int_value from unnest(event_params) where key='ga_session_id'))else null end) as new_session,
   count(distinct concat(user_pseudo_id,(select value.int_value from unnest (event_params) where key='session_engaged')) ) as session_engaged,
     case
        when (select value.int_value from unnest(event_params) where key='ga_session_number')=1 then "New Visior"
        when (select value.int_value from unnest(event_params) where key='ga_session_number')>1 then "Return Visitor"
        else null end as user_type
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
group by
     event_name,user_type;





