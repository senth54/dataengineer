Weather Analysis

Table with daily weather data.
Write a query to provide month, monthly max, monthly min and monthly avg
Round the avg to nearest Integer

Approach
  1. First derive the month column from record date via substring method
  2. See the output has single number digit for  July, Aug, Sep - 7, 8, 9 - Hence Substring of single digit for these months and Substring of 2 digits for Oct Nov Dec (10, 11, 12)
  3. Get the Max of data value when the data_type is max in Seperate Subquery
  4. Similary get the Min and Avg of data value when the data_type is Min, Avg as Seperate subquery
  5. Join all the Subqueries using WITH and join based on Month, to pivot the data as columns
  

WITH 
max_temp as 
(
Select 
case when
Substr(record_date,6,1)='0'
then
Substr(record_date,7,1)
Else
Substr(record_date,6,2)
End as month,
max(coalesce(data_value,0)) as max
from
temperature_records
where data_type='max'
group by month
),
min_temp as 
(
Select 
case when
Substr(record_date,6,1)='0'
then
Substr(record_date,7,1)
Else
Substr(record_date,6,2) End as month1,
min(coalesce(data_value,0)) as min
from
temperature_records
where data_type='min'
group by month1
),
avg_temp as 
(
Select 
case when
Substr(record_date,6,1)='0'
then
Substr(record_date,7,1)
Else
Substr(record_date,6,2) End as month2,
round(avg(coalesce(data_value,0))) as avg
from
temperature_records
where data_type='avg'
group by month2
)

Select mx.month, mx.max , mn.min, av.avg
FROM
max_temp as mx
INNER JOIN
min_temp as mn
on mx.month=mn.month1
INNER JOIN
avg_temp as av
on mx.month=av.month2
;
