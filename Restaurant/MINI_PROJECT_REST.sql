select namefrom geoplaces2

#1 We need to find out the total visits to all restaurants under all alcohol categories available.
select alcohol,count(userid) as `TOTAL VISITS` from rating_final rf join geoplaces2 g
using(placeid)
group by alcohol

#2 Let's find out the average 
# rating according to alcohol and price so that we can understand the rating in respective price categories as well.
select alcohol,price,avg(rating) from rating_final rf join geoplaces2 g
using(placeid)
group by alcohol,price
order by price,alcohol

#3 Let’s write a query to quantify that what are the parking availability as well 
# in different alcohol categories along with the total number of restaurants.
select alcohol,parking_lot,count(placeid) from chefmozparking cp join geoplaces2
using(placeid)  
group by alcohol,parking_lot;

#4 Also take out the percentage of different cuisine in each alcohol type.
with temp as
(select alcohol,rcuisine,count(rcuisine) as countz
from geoplaces2 g join chefmozcuisine cc
on g.placeid=cc.placeid
group by alcohol,rcuisine 
order by alcohol)

select alcohol,rcuisine,countz,total,round((countz/total)*100,2) as percentage
from
(select alcohol,rcuisine,countz,sum(countz)over(partition by alcohol) as total from temp
group by alcohol,rcuisine)t
group by alcohol,rcuisine;

#5 let’s take out the average rating of each state.
select state,avg(rating) from geoplaces2 g join rating_final rf using(placeid)
group by state

#6 ' Tamaulipas' Is the lowest average rated state. 
# Quantify the reason why it is the lowest rated by providing the summary on the basis of State, alcohol, and Cuisine.
select name,rcuisine,avg(rating) as rating,state,alcohol,smoking_area,price,other_services from geoplaces2 g join rating_final r
using(placeid)
join chefmozcuisine c
on
c.placeid=r.placeid
 where state like '%Tamaulipas%'
group by name,rcuisine


#7 Find the average weight, food rating, and service rating of the customers 
# who have visited KFC and tried Mexican or Italian types of cuisine, and also their budget level is low.
# We encourage you to give it a try by not using joins.

select avg(weight),avg(food_rating),avg(service_rating) from rating_final r join userprofile u
using(userid) join geoplaces2 g
on
g.placeid=r.placeid
join
usercuisine uc
on
uc.userid=r.userid
where name like '%kfc%' and rcuisine in ('mexican','italian') and budget like '%low%'


#8 Which cuisine restaurant to start based on avg rating
select rcuisine,avg(rating) from rating_final r join chefmozcuisine
using(placeid) group by rcuisine order by avg(rating) desc 



select * from userprofile where marital_status='widow' 
and userid in(select distinct userID from userpayment where Upayment='cash' 
and userid in(select distinct userID from rating_final where  
placeID in  (select distinct placeID from geoplaces2  where country='Mexico')and 
placeID in  (select distinct placeID from rating_final where food_rating='2')));


with temp as 
(select placeId, g.name, g.address, g.city, g.state, g.country, r.rating, r.food_rating, r.service_rating,
dense_rank()over(partition by g.city order by r.food_rating desc) as Dns_Rnk 
from geoplaces2 g join rating_final r using(placeID)
where city<>'?')

Select * from temp where Dns_Rnk=1;