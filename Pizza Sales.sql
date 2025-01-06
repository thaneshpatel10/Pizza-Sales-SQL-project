create database pizzahut;
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

select *
from order_details;

###Retrieve the total number of orders placed###
SELECT 
    COUNT(order_id) AS total_orders_placed
FROM
    orders;

### Calculate Total Revenue generated##
SELECT 
    ROUND((SUM(order_details.quantity * pizzas.price)),
            2) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
##Identify the highest priced pizza##
select *
from pizza_types;
select pizza_types.name, pizzas.price
from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 1 ;

## identify the most common pizza size ordered##
select * 
from pizzas;

select distinct(pizzas.size ), count(order_details.pizza_id) as order_count
from order_details
join pizzas
on order_details.pizza_id=pizzas.pizza_id
group by pizzas.size order by order_count desc;

##list the top 5 most ordered pizzas along with their quantity##
select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;

##Join the necessary table to find the total quantity of each pizza category ordered##
select * 
from order_details;

select pizza_types.category, sum(quantity)
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by sum(quantity) desc;

##determine the distribution of orders by hour of the day##
select hour(order_time), count(order_id) from orders
group by hour(order_time);

##join relevant tables to find the category wise distribution of pizzas##
select category, count(pizza_types.name)
from pizza_types
group by category;

##group the orders by date and calcute the avg pizzas ordered per day;
select avg(summm) from
(select orders.order_date, sum(order_details.quantity) as summm
from order_details
join orders
on order_details.order_id=orders.order_id
group by orders.order_date) as order_quantity;

##determine the top 3 most ordered pizza by revenue##
select*
from pizzas;
select pizza_types.name, (sum(order_details.quantity*pizzas.price)) as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by revenue desc;

##calculate the percentage contribution of each pizza type to revenue##
select pizza_types.category, round(((sum(order_details.quantity*pizzas.price))/(select 
round((sum(order_details.quantity*pizzas.price)),2)as Total_Revenue
from order_details
join pizzas
	on order_details.pizza_id=pizzas.pizza_id))*100,2) as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by revenue desc;

##Analyze the cumulative revenue generated over time##
select order_date, sum(revenue) over(order by order_date) as Cumulative_Revenue
from
(select distinct orders.order_date,(sum(order_details.quantity*pizzas.price)) as revenue
from order_details
join pizzas
on pizzas.pizza_id=order_details.pizza_id
join orders
on order_details.pizza_id=pizzas.pizza_id
group by orders.order_date) as sales;
SELECT 
    *
FROM
    orders;

###determine the top 3 most ordered pizza based on revenue for each categor##
select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name, sum(order_details.quantity*pizzas.price) as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a;