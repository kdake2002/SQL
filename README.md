🍕 Pizza Sales Dataset
This dataset represents pizza sales information for a fictional pizza place. It includes details about orders, the pizzas sold, and their types. This data can be used for SQL practice, data analysis, data visualization, or building business intelligence dashboards.

📁 Dataset Files
1. orders.csv
Contains metadata about each order placed.

Column Name	Data Type	Description
order_id	Integer	Unique ID for each order
date	Date	Date the order was placed
time	Time	Time the order was placed

2. order_details.csv
Contains detailed line items for each order, i.e., which pizzas were ordered.

Column Name	Data Type	Description
order_details_id	Integer	Unique ID for each line item
order_id	Integer	Foreign key linking to orders.csv
pizza_id	String	Foreign key linking to pizzas.csv
quantity	Integer	Number of pizzas ordered

3. pizzas.csv
Describes available pizzas and their sizes.

Column Name	Data Type	Description
pizza_id	String	Unique ID for each pizza (e.g., 'bbq_ckn_l')
pizza_type_id	String	Foreign key linking to pizza_types.csv
size	String	Size of the pizza (S, M, L, XL, XXL)
price	Float	Price of the pizza

4. pizza_types.csv
Contains descriptions of each pizza type, including category and ingredients.

Column Name	Data Type	Description
pizza_type_id	String	Unique pizza type ID
name	String	Full name of the pizza
category	String	Pizza category (Classic, Chicken, Veggie)
ingredients	String	Comma-separated list of ingredients

🔗 Relationships
orders → order_details: One-to-many (one order can have multiple line items)

order_details → pizzas: Many-to-one (each line item is a pizza)

pizzas → pizza_types: Many-to-one (each pizza belongs to a type)

🛠️ Use Cases
You can use this dataset to:

Analyze most popular pizzas and sizes

Track sales performance over time

Determine peak ordering hours/days

Build a dashboard in SQL, Excel, Power BI, or Python

Practice SQL joins, aggregations, and subqueries
