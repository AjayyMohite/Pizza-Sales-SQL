--Calculate the total count of orders 
SELECT
	COUNT(*) AS TOTAL_ORDERS_PLACED
FROM
	ORDERS;

--Calculate the total revenue generated from pizza sales 
SELECT
	SUM(OD.QUANTITY * PI.PRICE) AS "Total_Revenue"
FROM
	ORDER_DETAILS OD
	JOIN PIZZAS PI ON OD.PIZZA_ID = PI.PIZZA_ID;

SELECT * From pizza_types;

SELECT * From pizzas;

-- Identify Highest priced pizza name and it's cost
SELECT
	PT.NAME,
	PI.PRICE
FROM
	PIZZA_TYPES PT
	JOIN PIZZAS PI ON PT.PIZZA_TYPE_ID = PI.PIZZA_TYPE_ID
ORDER BY
	PI.PRICE DESC LIMIT
	1;

--Identify most common pizza size ordered
SELECT
	PI.SIZE,
	COUNT(OD.ORDER_DETAILS_ID) AS TOTAL_ORDERS
FROM
	PIZZAS PI
	JOIN ORDER_DETAILS OD ON PI.PIZZA_ID = OD.PIZZA_ID
GROUP BY
	PI.SIZE
ORDER BY
	TOTAL_ORDERS DESC 
	LIMIT 1;

SELECT * From pizza_types;
SELECT * From pizzas;
SELECT * FROM Orders;
SELECT * FROM Order_Details;

--Top 5 most ordered pizza types along with quantities
SELECT
	PT.NAME,
	SUM(OD.QUANTITY) AS TOTAL_QUANTITY
FROM
	PIZZA_TYPES PT
	JOIN PIZZAS PI ON PT.PIZZA_TYPE_ID = PI.PIZZA_TYPE_ID
	JOIN ORDER_DETAILS OD ON OD.PIZZA_ID = PI.PIZZA_ID
GROUP BY
	PT.NAME
ORDER BY
	TOTAL_QUANTITY DESC LIMIT
	5;

--Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT
	PT.CATEGORY,
	SUM(OD.QUANTITY) AS TOTAL_QUANTITY
FROM
	PIZZA_TYPES PT
	JOIN PIZZAS PI ON PT.PIZZA_TYPE_ID = PI.PIZZA_TYPE_ID
	JOIN ORDER_DETAILS OD ON OD.PIZZA_ID = PI.PIZZA_ID
GROUP BY
	PT.CATEGORY
ORDER BY
	TOTAL_QUANTITY DESC
	LIMIT 5;

SELECT * From pizza_types;
SELECT * From pizzas;
SELECT * FROM Orders;
SELECT * FROM Order_Details;

--Determine the distribution of orders by hour of the day
SELECT
	COUNT(ORDER_ID) AS TOTAL_ORDERS,
	EXTRACT(
		HOUR
		FROM
			ORDER_TIME
	) AS EXTRACTED_HOURS
FROM
	ORDERS
GROUP BY
	EXTRACT(
		HOUR
		FROM
			ORDER_TIME
	) ORDER BY
	TOTAL_ORDERS DESC;

--Find category wise distribution of pizzas
SELECT
	COUNT(PT.NAME) AS TOTAL_COUNT,
	PT.CATEGORY
FROM
	PIZZA_TYPES PT
	JOIN PIZZA_TYPES PTY ON PT.PIZZA_TYPE_ID = PTY.PIZZA_TYPE_ID
GROUP BY
	PT.CATEGORY;

--Group the orders by date and calculate the average no. of pizzas oerderd per day
SELECT
	ROUND(AVG(DAILY_ORDERS.AVG_NO_PIZZAS), 0) AS AVG_NO_PIZZAS_PER_DAY
FROM
	(
		SELECT
			OS.ORDER_DATE,
			SUM(OD.QUANTITY) AS AVG_NO_PIZZAS
		FROM
			ORDERS OS
			JOIN ORDER_DETAILS OD ON OS.ORDER_ID = OD.ORDER_ID
		GROUP BY
			OS.ORDER_DATE
	) AS DAILY_ORDERS;


--Find top 3 most ordered pizza types based on revenue.
SELECT pt.name, 
	SUM(OD.QUANTITY * Ps.PRICE) AS TOTAL_REVENUE
FROM pizza_types pt
	JOIN Pizzas ps ON ps.pizza_type_id = pt.pizza_type_id
	JOIN Order_Details od ON od.pizza_id = ps.pizza_id
	GROUP BY pt.name
	ORDER BY TOTAL_REVENUE DESC
	LIMIT 3;

--Calculate the percentage contribution of each pizza types to total_revenue
SELECT
	PT.CATEGORY,
	ROUND(
		SUM(OD.QUANTITY * PI.PRICE) / (
			SELECT
				ROUND(SUM(OD.QUANTITY * PI.PRICE), 2) AS TOTAL_SALES
			FROM
				ORDER_DETAILS OD
				JOIN PIZZAS PI ON PI.PIZZA_ID = OD.PIZZA_ID
		) * 100,
		2
	) AS TOTAL_REVENUE
FROM
	PIZZA_TYPES PT
	JOIN PIZZAS PI ON PT.PIZZA_TYPE_ID = PI.PIZZA_TYPE_ID
	JOIN ORDER_DETAILS OD ON OD.PIZZA_ID = PI.PIZZA_ID
GROUP BY
	PT.CATEGORY
ORDER BY
	TOTAL_REVENUE DESC;

--Analyze the cumulative revenue generated over time.
SELECT
	ORDER_DATE,
	SUM(REVENUE) OVER (
		ORDER BY
			ORDER_DATE
	) AS CUM_REVENUE
FROM
	(
		SELECT
			OS.ORDER_DATE,
			SUM(OD.QUANTITY * PI.PRICE) AS REVENUE
		FROM
			ORDER_DETAILS OD
			JOIN PIZZAS PI ON OD.PIZZA_ID = PI.PIZZA_ID
			JOIN ORDERS OS ON OS.ORDER_ID = OD.ORDER_ID
		GROUP BY
			OS.ORDER_DATE
	) AS SALES;


--Determine top 3 most ordered pizza types based on revenue for each pizza category.
SELECT
	NAME,
	revenue FROM
	(Select Category, name, revenue, 
	RANK() OVER (Partition BY Category order by revenue DESC) as rn FROM
	(SELECT
			PT.CATEGORY,
			PT.NAME,
			SUM((OD.QUANTITY) * PI.PRICE) AS Revenue
		FROM
			PIZZA_TYPES PT
			JOIN PIZZAS PI ON PT.PIZZA_TYPE_ID = PI.PIZZA_TYPE_ID
			JOIN ORDER_DETAILS OD ON OD.PIZZA_ID = PI.PIZZA_ID
		GROUP BY
			PT.CATEGORY,
			PT.NAME
	) AS A) AS B
	WHERE rn <= 3 LIMIT 3;



SELECT * From pizza_types;
SELECT * From pizzas;
SELECT * FROM Orders;
SELECT * FROM Order_Details;








