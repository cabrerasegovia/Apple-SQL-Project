Create table appleStore_description_combined AS 

SELECT * from appleStore_description1
union ALL
select * from appleStore_description2
union all 
select * from appleStore_description3
union all 
select * from appleStore_description4;

**EDA: EXPLORATORY DATA ANALYSIS**

SELECT COUNT(DISTINCT (ID)) AS UniqueAppleStoreId
from AppleStore;
SELECT COUNT(DISTINCT (ID)) AS UniqueAppleStoreId
from appleStore_description_combined

-- check for any missing values in key fields from tables --

select COUNT (*) as MissingValues
from applestore
where track_name is null or user_rating is null or prime_genre is null;

select count (*) as MissingValues
from applestore_description_combined 
where app_desc is null;

-- Find out the number of apps per genre-- 
select prime_genre, count(*) as NumberofApps
from applestore
group by 1
order by NumberofApps desc;

-- Get overview of the app 'raings'--
select max(user_rating) as max,
	   min (user_rating) as min,
	   avg(user_rating) as avg
from applestore;

-- Determine whether paid apps have higher ratings than free apps--
select case 
	when price > 0 then 'paid'
	else 'free'
end as App_type_Price,
 	avg(user_rating) as Avg_userrating
from AppleStore
group by App_Type_Price;

--Check if apps with more supported language have higher rating--
select case 
	when lang_num < 10 then '<10languages'
	when lang_num between 10 and 30 then '10-30 languages'
	else '>30 languages' end as numberlanguages,
	avg(user_rating) as userrating
from applestore
group by numberlanguages
order by userrating desc; 

--Check genre with low ratings
select avg(user_rating) as avergaeuserrating, prime_genre
from AppleStore
group by 2
order by avergaeuserrating

-- Check if there is correlation between the lenght of the app description and the user rating 

select CASE 
			when length(t2.app_desc) < 500 then 'Short Description' 
            when length(t2.app_desc) BETWEEN 500 and 1000 then 'Medium Description' 
            ELSE 'Long Descrption' end as LengthofDescription, 
            avg(user_rating) as averageuserrating
       			
from AppleStore as t1 
join appleStore_description_combined as t2 on t1.id = t2.id
group by LengthofDescription
order by averageuserrating desc;

-- Check the top-rated apps for each genre
SELECT
	   prime_genre,
       track_name,
       user_rating
FROM ( 
  	   SELECT
	   prime_genre,
       track_name,
       user_rating,
       RANK () OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot DESC) AS rank
       from 
       AppleStore)  as a 
where 
a.rank = 1; 




	  


















