use walmart_db;

-- walmart project queries - MYSQL
select*from walmart;
-- drop table walmart;

-- count total records
select count(*) from walmart;

-- count payment method and number of transaction by payment method
select payment_method,
count(*) as no_payments
from walmart
group by payment_method;

-- count distinct branches
select count(distinct branch) from walmart;

-- Business Problem Q1: Find different payment methods, number of transactions, and quantity sold by payment method
select payment_method,
count(*) as no_payment,
sum(quantity) as no_qty_sold
from walmart
group by payment_method;


-- Project Question #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
 select branch,category,avg_rating
 from
 (
 select branch,
 category,
 avg(rating) as avg_rating,
 rank () over( partition by branch order by avg(rating) desc) as rnk
 from walmart
 group by branch, category ) as ranked
 where rnk=1;
 
 -- Q3: Identify the busiest day for each branch based on the number of transactions
 select branch,day_name,no_transaction
 from
 (
 select branch,
 dayname(str_to_date(date,'%d/%m/%Y')) as day_name,
 count(*) as no_transaction,
 rank() over(partition by branch order by count(*) desc) as rnk
 from walmart
 group by branch,day_name
 )as ranked
 where rnk=1;
 
 -- Q4: Calculate the total quantity of items sold per payment method
 select 
 payment_method,
 sum(quantity) as no_qty_sold
 from walmart
 group by payment_method;
 
-- Q5: Determine the average, minimum, and maximum rating of categories for each city
select city,
category,
min(rating) as min_rating,
max(rating) as max_rating,
round(avg(rating),2) as avg_rating
from walmart
group by city,category;

-- Q6: Calculate the total profit for each category
select category,
sum(unit_price * quantity * profit_margin) as total_profit
from walmart
group by category
order by total_profit desc;

-- Q7: Determine the most common payment method for each branch
with CTE as
(
select payment_method,
branch,
count(*) as total_transactions,
rank() over(partition by payment_method order by branch desc)as rnk
from walmart
group by  branch,
payment_method
)
select branch, payment_method as preferred_payment_method
from CTE
where rnk=1;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts
select
 branch,
case
when hour(time(time)) <12 then 'morning'
when hour(time(time)) between 12 and 17 then 'afternoon'
else 'evening'
end as shift,
count(*) as num_invoices
from walmart
group by branch,shift
order by branch,num_invoices desc;




 
 
