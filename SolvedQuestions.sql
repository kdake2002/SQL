create database pizzahut;

use pizzahut;

select * from orders;
select * from orders_details;
select * from pizza_types;
select * from pizzas;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) );


show tables;

-- Basic:

-- 1 Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- 2 Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
FROM
    orders_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

-- 3 Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- 4 Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    orders_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC limit 1;

-- 5 List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.pizza_type_id, pt.name, SUM(od.quantity) as quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    orders_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.pizza_type_id, pt.name
ORDER BY quantity desc limit 5;

-- Intermediate:
-- 6 Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS qnt
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    orders_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY qnt DESC;

-- 7 Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS oth, COUNT(order_id)
FROM
    orders
GROUP BY oth;

-- 8 Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) from pizza_types group by category;

-- 9 Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN orders_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_quantity;

-- 10 Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, SUM(od.quantity * p.price) AS quantity
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    orders_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 3;

-- Advanced:
-- 11 Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.category,
    (SUM(od.quantity * p.price) / total_sales.total) * 100 AS revenue
FROM 
    pizza_types pt
JOIN 
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN 
    orders_details od ON od.pizza_id = p.pizza_id
JOIN 
    (
        SELECT 
            SUM(od.quantity * p.price) AS total
        FROM 
            orders_details od
        JOIN 
            pizzas p ON od.pizza_id = p.pizza_id
    ) AS total_sales
GROUP BY 
    pt.category, total_sales.total
ORDER BY 
    revenue DESC
LIMIT 5000;


-- 12 Analyze the cumulative revenue generated over time.
select order_date, sum(revenue) over(order by order_date) as cum_revenue from
(select o.order_date,
sum(od.quantity * price) as revenue from
orders_details od join pizzas p on od.pizza_id = p.pizza_id
join orders o on o.order_id = od.order_id
group by o.order_date) as sales;

-- 13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue from
(select category, name , revenue, 
rank() over(partition by category order by revenue desc) as rn
from
(select pt.category, pt.name, sum(od.quantity * p.price) as revenue
from pizza_types pt join pizzas p on pt.pizza_type_id = p.pizza_type_id
join orders_details od
on od.pizza_id = p.pizza_id
group by pt.category, pt.name) as a) as b
where rn <= 3;

