USE ecomm;
select* from customer_churn;

-- Handling Missing Values and Outliers:

/* ➢ Impute mean  for the following columns, and round off to the nearest integer if 
required: WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear, 
DaySinceLastOrder. */

select round(avg(warehousetohome)) from customer_churn;
    update  customer_churn
    set warehousetohome=16
    where warehousetohome is null;
    
    SET sql_safe_updates = 0;

    select round(avg(HourSpendOnApp)) from customer_churn; -- 3
    select round(avg(OrderAmountHikeFromlastYear)) from customer_churn; -- 16
    select round(avg(DaySinceLastOrder) )from customer_churn;  -- 5
    
    
    update  customer_churn
    set
    HourSpendOnApp=3,
    OrderAmountHikeFromlastYear=16,
    DaySinceLastOrder=5
    where
    HourSpendOnApp is null or
    OrderAmountHikeFromlastYear is null or
    DaySinceLastOrder is null;
  --  ➢ ➢ Impute mode for the following columns: Tenure, CouponUsed, OrderCount.
select tenure,count(*) from customer_churn
where tenure is not null
group by  Tenure
order by count(tenure) desc limit 1;                                        -- 1 tenure

select couponused,count(*)  as count_couponused from customer_churn
where couponused is not null
group by couponused
order by count_couponused desc limit 1;                                    -- 1 couponused   

select OrderCount,count(*)  as count_OrderCount from customer_churn
where OrderCount is not null
group by OrderCount
order by count_OrderCount desc limit 1  ;                                   -- 2 OrderCount

update  customer_churn
set
Tenure=1, 
CouponUsed=1,
 OrderCount=2
 where 
 Tenure is null or
 couponused is null or
 ordercount is null;
 
/* ➢ Handle outliers in the 'WarehouseToHome' column by deleting rows where the 
values are greater than 100.*/

select WarehouseToHome from  customer_churn
order by WarehouseToHome desc;

delete from customer_churn
where  WarehouseToHome>100;


-- Dealing with Inconsistencies:  --

/* Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and 
“Mobile” in the 'PreferedOrderCat' column with “Mobile Phone” to ensure 
uniformity.*/


update customer_churn
set
PreferedOrderCat='Mobile Phone'
where
PreferredLoginDevice='Phone';


update customer_churn
set
PreferedOrderCat='Mobile Phone'
where
PreferedOrderCat='Mobile';



/* Standardize payment mode values: Replace "COD" with "Cash on Delivery" and 
"CC" with "Credit Card" in the PreferredPaymentMode column.*/

update customer_churn
set
PreferredPaymentMode='Cash on Delivery'
where PreferredPaymentMode='cod';
update customer_churn
set
PreferredPaymentMode='Credit Card'
where PreferredPaymentMode='cc';


/*  Create a new column named ‘ComplaintReceived’ with values "Yes" if the 
corresponding value in the ‘Complain’ is 1, and "No" otherwise.*/

 alter table customer_churn
 add column ComplaintReceived varchar(4);
 
 update customer_churn
 set
 ComplaintReceived = case
 when Complain= 1 then 'Yes'
 else 'No'
 end;
 
 /* Create a new column named 'ChurnStatus'. Set its value to “Churned” if the 
corresponding value in the 'Churn' column is 1, else assign “Active”. */
 
 alter table customer_churn
 add column ChurnStatus varchar(12);

 update customer_churn
 set
 ChurnStatus= case
 when Churn= 1 then 'Churned'
 else 'Active'
 end;
 
 
 -- Drop the columns "Churn" and "Complain" from the table.
 
 alter table customer_churn
 drop column Churn,
 drop column Complain;
 
 
 
 
 -- Q Retrieve the count of churned and active customers from the dataset.
 
 select ChurnStatus,count(*)  as count 
 from customer_churn
 group by ChurnStatus
 ;
 
 -- Q Display the average tenure and total cashback amount of customers who churned.
 select avg(tenure) as avg_tenure,
 sum(cashbackamount) as total_cash_back
 from customer_churn;
 
 -- Q- Determine the percentage of churned customers who complained. 
 select round( count(*)*100/(select count(ChurnStatus)  from customer_churn),2) as churned_percentage
 from customer_churn
 where churnstatus='churned'
 group by ChurnStatus
 ;
 
 
  /* Q- Identify the city tier with the highest number of churned customers whose 
preferred order category is Laptop & Accessory.*/

select citytier,count(*) as churned_customer from customer_churn
where preferredordercat='Laptop & Accessory'
and
churnstatus='churned'
group by citytier
order by churned_customer desc limit 1
;

-- Q- Identify the most preferred payment mode among active customers. 
select preferredpaymentmode,count(*) as paymentmode_count from customer_churn
where churnstatus='active'
group by 
preferredpaymentmode
order by paymentmode_count desc limit 1
;

 /* Q- Calculate the total order amount hike from last year for customers who are single 
and prefer mobile phones for ordering. */


select sum(OrderAmountHikeFromlastYear) as total_OrderAmountHikeFromlastYear from customer_churn
where   MaritalStatus ='single'
and
preferredordercat='mobile phone'
;

/* Q- Find the average number of devices registered among customers who used UPI as 
their preferred payment mode.*/
select round( avg(NumberOfDeviceRegistered),2) as avg_of_NumberOfDeviceRegistered from customer_churn
where  PreferredPaymentMode='upi'
;

-- Q- Determine the city tier with the highest number of customers
select citytier,count(customerid) as customer_count from customer_churn
group by citytier
order by customer_count desc limit 1
;

 -- Q- Identify the gender that utilized the highest number of coupons. 
 select gender,count(CouponUsed) as count from customer_churn
 group by gender
 order by count desc limit 1
 ;
 
/* Q- List the number of customers and the maximum hours spent on the app in each 
preferred order category.*/

select* from customer_churn;
select preferredordercat,
max(hoursspentonapp) as max_hours_spent,
count(customerid) as number_of_customer
from customer_churn
group by preferredordercat;

/* Q-  Calculate the total order count for customers who prefer using credit cards and 
have the maximum satisfaction score.*/

select sum(OrderCount) as total_order from customer_churn
where 
preferredpaymentmode='credit card'
and
SatisfactionScore=(select max(SatisfactionScore) from customer_churn)
;

-- Q- What is the average satisfaction score of customers who have complained? 
select avg(SatisfactionScore) as average_satisfaction from customer_churn
where complaintreceived='yes'
;       

/* Q List the preferred order category among customers who used more than 5 
coupons. */
 select preferredordercat from customer_churn
 where couponused>5
 group by preferredordercat
 ;

-- Q List the top 3 preferred order categories with the highest average cashback amount. 
 select preferredordercat,
 round(avg(cashbackamount),2) as avg_cashback from customer_churn
 group by preferredordercat
 order by avg_cashback desc limit 3
 ;
 
/* Q- Find the preferred payment modes of customers whose average tenure is 10 
months and have placed more than 500 orders. */

select preferredpaymentmode from customer_churn
group by preferredpaymentmode
having sum(ordercount)>500
and avg(tenure)=10;


/* Q- Categorize customers based on their distance from the warehouse to home such 
as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km, 
'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the 
churn status breakdown for each distance category.*/ 

select
case
when warehousetohome<=5 then 'very close distance' 
when warehousetohome<=10 then 'close distance'
when warehousetohome<=15 then 'moderate distance'
else 'far distance'
end as distance_category,
churnstatus,count(*) as count
from customer_churn
group by 
 distance_category,churnstatus
 order by distance_category
;

/* Q-List the customer’s order details who are married, live in City Tier-1, and their 
order counts are more than the average number of orders placed by all 
customers.*/

select * from customer_churn
where maritalstatus='married'
and
citytier=1
and
ordercount>(select avg(ordercount) from customer_churn);

 /* Q- Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the 
following data:*/

create table customer_returns(
ReturnId int primary key,
CustomerId  int,
ReturnDate date,
RefundAmount int
);
desc customer_returns;
insert into customer_returns values
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);



/* Q Display the return details along with the customer details of those who have 
churned and have made complaints.*/
select* from customer_returns;
select * from customer_churn;


select cc.*,cr.*
from customer_churn cc
inner join customer_returns cr
on cc.customerid=cr.customerid
where cc.churnstatus='churned'
and
cc.complaintreceived='yes';
