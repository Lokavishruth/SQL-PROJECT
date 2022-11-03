# Question 1: Find the top 3 customers who have the maximum number of orders
select * from
(select customer_name,sum(sales),dense_rank()over(order by sum(sales) desc) rnk from
cust_dimen cd join market_fact mf
using(cust_id) group by customer_name)t
where rnk <=3;


# Question 2: Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.
select order_id,order_date,ship_date, datediff(str_to_date(ship_date,'%d-%m-%Y'),str_to_date(order_date,'%d-%m-%Y')) as daystakenfordelivery
from orders_dimen od join shipping_dimen sd
using(order_id) 

# Question 3: Find the customer whose order took the maximum time to get delivered. 
select customer_name from cust_dimen where cust_id = (select cust_id from market_fact where ord_id=
(select ord_id from orders_dimen where order_id=(select order_id from 
(select order_id,order_date,ship_date, 
datediff(str_to_date(ship_date,'%d-%m-%Y'),str_to_date(order_date,'%d-%m-%Y')) 
as diff from orders_dimen od join shipping_dimen sd
using(order_id) order by diff desc limit 1)t)))

# Question 4: Retrieve total sales made by each product from the data (use Windows function)
select mf.prod_id,sum(sales)over(partition by mf.prod_id) from market_fact mf join prod_dimen pd on
pd.prod_id=mf.prod_id
group by  mf.prod_id;

# Question 5: Retrieve the total profit made from each product from the data (use windows function)
select mf.prod_id,pd.product_sub_category,sum(Profit)over(partition by mf.prod_id) as profit from market_fact mf join prod_dimen pd on
pd.prod_id=mf.prod_id
group by  mf.prod_id,pd.product_sub_category;



# Question 6: Count the total number of unique customers in January and how many of them came back every month 
# over the entire year in 2011

select *,count(cust_id) from (select cust_id,str_to_date(order_date,'%d-%m-%Y') orderdate,


lead(str_to_date(order_date,'%d-%m-%Y'))over(partition by cust_id order by str_to_date(order_date,'%d-%m-%Y')) as nextorder
from market_fact join orders_dimen
using(ord_id) 
where year(str_to_date(order_date,'%d-%m-%Y'))=2011)t
where datediff(nextorder,orderdate) < 30
group by cust_id
having count(cust_id) >=12
 

 




select count(employee_id)over(partition by department_id order bu count(emloyee_id)) from employees;

select count(employee_)