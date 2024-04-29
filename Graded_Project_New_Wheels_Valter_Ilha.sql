/*		
-----------------------------------------------------------------------------------------------------------------------------------

											Database Creation
                                               
-----------------------------------------------------------------------------------------------------------------------------------
*/

-- [1] To begin with the project, you need to create the database first
-- Write the Query below to create a Database

DROP DATABASE IF EXISTS vehdb;
CREATE DATABASE vehdb;

-- [2] Now, after creating the database, you need to tell MYSQL which database is to be used.
-- Write the Query below to call your Database

USE vehdb;

/*-----------------------------------------------------------------------------------------------------------------------------------

                                               Tables Creation
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/

-- [3] Creating the tables:

/*Note:
---> To create the table, refer to the ER diagram and the solution architecture. 
---> Refer to the column names along with the data type while creating a table from the ER diagram.

/* List of tables to be created.

 Create a table temp_t, vehicles_t, order_t, customer_t, product_t, shipper_t */

DROP TABLE IF EXISTS temp_t; 
CREATE TABLE temp_t
(
	shipper_id INTEGER,
	shipper_name VARCHAR(50),
	shipper_contact_details VARCHAR(30),
	product_id INTEGER,
	vehicle_maker VARCHAR(60),
	vehicle_model VARCHAR(60),
	vehicle_color VARCHAR(60),
	vehicle_model_year INTEGER,
	vehicle_price DECIMAL(14,2),
	quantity INTEGER,
    discount DECIMAL(4,2),
	customer_id VARCHAR(25),
	customer_name VARCHAR(25),
	gender VARCHAR(15),
	job_title VARCHAR(50),
	phone_number VARCHAR(50),
	email_address VARCHAR(50),
	city VARCHAR(25),
	country VARCHAR(40),
	state VARCHAR(40),
	customer_address VARCHAR(50),
	order_date DATE,
	order_id VARCHAR(25),
	ship_date DATE,
	ship_mode VARCHAR(25),
	shipping VARCHAR(30),
	postal_code INTEGER,
	credit_card_type VARCHAR(40),
	credit_card_number BIGINT,
	customer_feedback VARCHAR(20),
	quarter_number INTEGER,
    PRIMARY KEY(order_id)
);

DROP TABLE IF EXISTS vehicles_t; 
CREATE TABLE vehicles_t
(
	shipper_id INTEGER,
	shipper_name VARCHAR(50),
	shipper_contact_details VARCHAR(30),
	product_id INTEGER,
	vehicle_maker VARCHAR(60),
	vehicle_model VARCHAR(60),
	vehicle_color VARCHAR(60),
	vehicle_model_year INTEGER,
	vehicle_price DECIMAL(14,2),
	quantity INTEGER,
    discount DECIMAL(4,2),
	customer_id VARCHAR(25),
	customer_name VARCHAR(25),
	gender VARCHAR(15),
	job_title VARCHAR(50),
	phone_number VARCHAR(50),
	email_address VARCHAR(50),
	city VARCHAR(25),
	country VARCHAR(40),
	state VARCHAR(40),
	customer_address VARCHAR(50),
	order_date DATE,
	order_id VARCHAR(25),
	ship_date DATE,
	ship_mode VARCHAR(25),
	shipping VARCHAR(30),
	postal_code INTEGER,
	credit_card_type VARCHAR(40),
	credit_card_number BIGINT,
	customer_feedback VARCHAR(20),
	quarter_number INTEGER,
    PRIMARY KEY(order_id)
);

DROP TABLE IF EXISTS order_t; 
CREATE TABLE order_t
(
	order_id VARCHAR(25),
	customer_id VARCHAR(25),
	shipper_id INTEGER,
	product_id INTEGER,
	quantity INTEGER,
    vehicle_price DECIMAL(14,2),
    order_date DATE,
    ship_date DATE,
    discount DECIMAL(4,2),
    ship_mode VARCHAR(25),
	shipping VARCHAR(30),
    customer_feedback VARCHAR(20),
    quarter_number INTEGER,
    PRIMARY KEY(order_id)
);

DROP TABLE IF EXISTS customer_t; 
CREATE TABLE customer_t
(
	customer_id VARCHAR(25),
    customer_name VARCHAR(25),
    gender VARCHAR(15),
    job_title VARCHAR(50),
    phone_number VARCHAR(50),
	email_address VARCHAR(50),
    city VARCHAR(25),
	country VARCHAR(40),
    state VARCHAR(40),
	customer_address VARCHAR(50),
    postal_code INTEGER,
    credit_card_type VARCHAR(40),
    credit_card_number BIGINT,
    PRIMARY KEY(customer_id)
);

DROP TABLE IF EXISTS shipper_t; 
CREATE TABLE shipper_t
(
	shipper_id INTEGER,
	shipper_name VARCHAR(50),
	shipper_contact_details VARCHAR(30),
    PRIMARY KEY(shipper_id)
);

DROP TABLE IF EXISTS product_t; 
CREATE TABLE product_t
(
	product_id INTEGER,
	vehicle_maker VARCHAR(60),
	vehicle_model VARCHAR(60),
	vehicle_color VARCHAR(60),
	vehicle_model_year INTEGER,
	vehicle_price DECIMAL(14,2),
    PRIMARY KEY(product_id)
);

/*-----------------------------------------------------------------------------------------------------------------------------------

                                               Stored Procedures Creation
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/

-- [4] Creating the Stored Procedures:

/* List of stored procedures to be created.

   Creating the stored procedure for vehicles_p, order_p, customer_p, product_p, shipper_p*/

DROP PROCEDURE IF EXISTS vehicles_p;
DELIMITER $$ 
CREATE PROCEDURE vehicles_p()
BEGIN
	INSERT INTO vehicles_t (
		shipper_id,
		shipper_name,
		shipper_contact_details,
		product_id,
		vehicle_maker,
		vehicle_model,
		vehicle_color,
		vehicle_model_year,
		vehicle_price,
		quantity,
        discount,
		customer_id,
		customer_name,
		gender,
		job_title,
		phone_number,
		email_address,
		city,
		country,
		state,
		customer_address,
		order_date,
		order_id,
		ship_date,
		ship_mode,
		shipping,
		postal_code,
		credit_card_type,
		credit_card_number,
		customer_feedback,
		quarter_number
) SELECT * FROM temp_t;
END $$;

DROP PROCEDURE IF EXISTS order_p;
DELIMITER $$ 
CREATE PROCEDURE order_p(qtr_number INTEGER)
BEGIN
	INSERT INTO order_t (
		order_id,
		customer_id,
		shipper_id,
		product_id,
		quantity,
		vehicle_price,
		order_date,
		ship_date,
		discount,
		ship_mode,
		shipping,
		customer_feedback,
		quarter_number
) SELECT
		order_id,
		customer_id,
		shipper_id,
		product_id,
		quantity,
		vehicle_price,
		order_date,
		ship_date,
		discount,
		ship_mode,
		shipping,
		customer_feedback,
		quarter_number
FROM
	vehicles_t
WHERE quarter_number = qtr_number;
END $$;

DROP PROCEDURE IF EXISTS customer_p;
DELIMITER $$ 
CREATE PROCEDURE customer_p()
BEGIN
	INSERT INTO customer_t (
		customer_id,
		customer_name,
		gender,
		job_title,
		phone_number,
		email_address,
		city,
		country,
		state,
		customer_address,
		postal_code,
		credit_card_type,
		credit_card_number
) SELECT
	DISTINCT
		customer_id,
		customer_name,
		gender,
		job_title,
		phone_number,
		email_address,
		city,
		country,
		state,
		customer_address,
		postal_code,
		credit_card_type,
		credit_card_number
FROM vehicles_t
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM customer_t);
END $$;

DROP PROCEDURE IF EXISTS shipper_p;
DELIMITER $$ 
CREATE PROCEDURE shipper_p()
BEGIN
	INSERT INTO shipper_t (
		shipper_id,
		shipper_name,
		shipper_contact_details
) SELECT
	DISTINCT
		shipper_id,
		shipper_name,
		shipper_contact_details
FROM vehicles_t
WHERE shipper_id NOT IN (SELECT DISTINCT shipper_id FROM shipper_t);
END $$;

DROP PROCEDURE IF EXISTS product_p;
DELIMITER $$ 
CREATE PROCEDURE product_p()
BEGIN
	INSERT INTO product_t (
		product_id,
		vehicle_maker,
		vehicle_model,
		vehicle_color,
		vehicle_model_year,
		vehicle_price
) SELECT
	DISTINCT
		product_id,
		vehicle_maker,
		vehicle_model,
		vehicle_color,
		vehicle_model_year,
		vehicle_price
FROM vehicles_t
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM product_t);
END $$;

/*-----------------------------------------------------------------------------------------------------------------------------------

                                               Data Ingestion
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/

-- [5] Ingesting the data:

SET global LOCAL_INFILE=1;

TRUNCATE temp_t;

LOAD DATA LOCAL INFILE "C:/Users/Asus/Desktop/Pen USB/4. SQL & Databases/Week 5 - Graded Project/new_wheels_proj/Data/new_wheels_sales_qtr_1.csv"
INTO TABLE temp_t
FIELDS TERMINATED by ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

call vehicles_p();
call customer_p();
call product_p();
call shipper_p();
call order_p(1);

TRUNCATE temp_t;

LOAD DATA LOCAL INFILE "C:/Users/Asus/Desktop/Pen USB/4. SQL & Databases/Week 5 - Graded Project/new_wheels_proj/Data/new_wheels_sales_qtr_2.csv"
INTO TABLE temp_t
FIELDS TERMINATED by ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

call vehicles_p();
call customer_p();
call product_p();
call shipper_p();
call order_p(2);

TRUNCATE temp_t;

LOAD DATA LOCAL INFILE "C:/Users/Asus/Desktop/Pen USB/4. SQL & Databases/Week 5 - Graded Project/new_wheels_proj/Data/new_wheels_sales_qtr_3.csv"
INTO TABLE temp_t
FIELDS TERMINATED by ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

call vehicles_p();
call customer_p();
call product_p();
call shipper_p();
call order_p(3);

TRUNCATE temp_t;

LOAD DATA LOCAL INFILE "C:/Users/Asus/Desktop/Pen USB/4. SQL & Databases/Week 5 - Graded Project/new_wheels_proj/Data/new_wheels_sales_qtr_4.csv"
INTO TABLE temp_t
FIELDS TERMINATED by ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

call vehicles_p();
call customer_p();
call product_p();
call shipper_p();
call order_p(4);

/*-----------------------------------------------------------------------------------------------------------------------------------

                                               Views Creation
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/

-- [6] Creating the views:

-- List of views to be created are "veh_prod_cust_v" , "veh_ord_cust_v"

DROP VIEW IF EXISTS veh_ord_cust_v;

CREATE VIEW veh_ord_cust_v AS
    SELECT
		c.customer_id,
		c.customer_name,
		c.city,
		c.state,
		c.credit_card_type,
        o.order_id,
		o.shipper_id,
		o.product_id,
		o.quantity,
		o.vehicle_price,
		o.order_date,
		o.ship_date,
		o.discount,
		o.customer_feedback,
		o.quarter_number
FROM customer_t as c
	INNER JOIN order_t as o
	    ON c.customer_id = o.customer_id;

DROP VIEW IF EXISTS veh_prod_cust_v;

CREATE VIEW veh_prod_cust_v AS
    SELECT
		c.customer_id,
		c.customer_name,
		c.state,
		c.credit_card_type,
        o.order_id,
		o.customer_feedback,
		p.product_id,
		p.vehicle_maker,
		p.vehicle_model,
		p.vehicle_color,
		p.vehicle_model_year
FROM customer_t as c
	INNER JOIN order_t as o
	    ON c.customer_id = o.customer_id
	INNER JOIN product_t as p
	    ON o.product_id = p.product_id;

/*-----------------------------------------------------------------------------------------------------------------------------------

                                               Functions Creation
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/

-- [7] Creating the functions:

-- Create the function calc_revenue_f

DROP FUNCTION IF EXISTS calc_revenue_f;

DELIMITER $$  
CREATE FUNCTION calc_revenue_f (vehicle_price DECIMAL(14,2), discount DECIMAL(4,2), quantity INTEGER) 
RETURNS DECIMAL(14,2)
DETERMINISTIC  
BEGIN  
	DECLARE revenue DECIMAL(14,2);
		SET revenue = vehicle_price * discount * quantity;
	RETURN revenue;
END $$;

-- select calc_revenue_f (vehicle_price, discount, quantity) revenue
-- from veh_ord_cust_v;

-- Create the function days_to_ship_f-

DROP FUNCTION IF EXISTS days_to_ship_f;

DELIMITER $$
CREATE FUNCTION days_to_ship_f (ship_date DATE, order_date DATE) 
RETURNS INTEGER 
DETERMINISTIC
BEGIN  
	DECLARE days_to_ship INTEGER;
		SET days_to_ship  = ship_date - order_date;
	RETURN days_to_ship;
END $$;

-- select days_to_ship_f (ship_date, order_date)
-- from veh_ord_cust_v;

/*-----------------------------------------------------------------------------------------------------------------------------------
Note: 
After creating tables, stored procedures, views and functions, attempt the below questions.
Once you have got the answer to the below questions, download the csv file for each question and use it in Python for visualisations.
------------------------------------------------------------------------------------------------------------------------------------ 

  
  
-----------------------------------------------------------------------------------------------------------------------------------

                                                         Queries
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/
  
/*-- QUESTIONS RELATED TO CUSTOMERS
     [Q1] What is the distribution of customers across states?
     Hint: For each state, count the number of customers.*/

SELECT
	state,
    COUNT(DISTINCT customer_id) customers_per_state
FROM veh_prod_cust_v
GROUP BY state
ORDER BY customers_per_state DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q2] What is the average rating in each quarter?
-- Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5.

Hint: Use a common table expression and in that CTE, assign numbers to the different customer ratings. 
      Now average the feedback for each quarter. 

Note: For reference, refer to question number 10. Week-2: Hands-on (Practice)-GL_EATS_PRACTICE_EXERCISE_SOLUTION.SQL. 
      You'll get an overview of how to use common table expressions from this question.*/

WITH rating_bucket AS
(
	SELECT
    quarter_number,
		CASE
			WHEN customer_feedback = 'Very Bad' THEN 1
			WHEN customer_feedback = 'Bad' THEN 2
			WHEN customer_feedback = 'Okay' THEN 3
			WHEN customer_feedback = 'Good' THEN 4
			WHEN customer_feedback = 'Very Good' THEN 5
		END AS customer_feedback_bucket
	FROM 
		veh_ord_cust_v
)
SELECT
	quarter_number,
    AVG (customer_feedback_bucket) as avg_customer_rating 
FROM rating_bucket
GROUP BY quarter_number
ORDER BY quarter_number;

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q3] Are customers getting more dissatisfied over time?

Hint: Need the percentage of different types of customer feedback in each quarter. Use a common table expression and
	  determine the number of customer feedback in each category as well as the total number of customer feedback in each quarter.
	  Now use that common table expression to find out the percentage of different types of customer feedback in each quarter.
      Eg: (total number of very good feedback/total customer feedback)* 100 gives you the percentage of very good feedback.
      
Note: For reference, refer to question number 10. Week-2: Hands-on (Practice)-GL_EATS_PRACTICE_EXERCISE_SOLUTION.SQL. 
      You'll get an overview of how to use common table expressions from this question*/
 
SELECT
    quarter_number,
    COUNT(*) AS orders_count,
    ROUND(SUM(CASE WHEN customer_feedback = 'Very Bad' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) 'very_bad_%',
    ROUND(SUM(CASE WHEN customer_feedback = 'Bad' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) 'bad_rate_%',
    ROUND(SUM(CASE WHEN customer_feedback = 'Okay' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) 'okay_rate_%',
	ROUND(SUM(CASE WHEN customer_feedback = 'Good' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) 'good_rate_%',
	ROUND(SUM(CASE WHEN customer_feedback = 'Very Good' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) 'very_good_rate_%'
FROM veh_ord_cust_v
GROUP BY quarter_number
ORDER BY quarter_number;

-- ---------------------------------------------------------------------------------------------------------------------------------

/*[Q4] Which are the top 5 vehicle makers preferred by the customer.

Hint: For each vehicle make what is the count of the customers.*/

SELECT
	vehicle_maker,
    COUNT(DISTINCT customer_id) cust_prefered_maker
FROM veh_prod_cust_v
GROUP BY vehicle_maker
ORDER BY cust_prefered_maker DESC
LIMIT 5;

-- ---------------------------------------------------------------------------------------------------------------------------------

/*[Q5] What is the most preferred vehicle make in each state?

Hint: Use the window function RANK() to rank based on the count of customers for each state and vehicle maker. 
After ranking, take the vehicle maker whose rank is 1.*/

SELECT
	state,
    vehicle_maker,
    maker_units_sold
FROM (SELECT
	state,
    vehicle_maker,
    COUNT(vehicle_maker) as maker_units_sold,
    RANK() OVER(PARTITION BY state ORDER BY COUNT(vehicle_maker) DESC) highest_selling_maker
FROM veh_prod_cust_v
GROUP BY 
	state,
    vehicle_maker
) maker_rank
WHERE maker_rank.highest_selling_maker=1;

-- ---------------------------------------------------------------------------------------------------------------------------------

/*QUESTIONS RELATED TO REVENUE and ORDERS 

-- [Q6] What is the trend of number of orders by quarters?

Hint: Count the number of orders for each quarter.*/

SELECT
	quarter_number,
    COUNT(order_id) as orders
FROM veh_ord_cust_v
GROUP BY quarter_number
ORDER BY quarter_number;

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q7] What is the quarter over quarter % change in revenue? 

Hint: Quarter over Quarter percentage change in revenue means what is the change in revenue from the subsequent quarter to the previous quarter in percentage.
      To calculate you need to use the common table expression to find out the sum of revenue for each quarter.
      Then use that CTE along with the LAG function to calculate the QoQ percentage change in revenue.
      
Note: For reference, refer to question number 5. Week-2: Hands-on (Practice)-GL_EATS_PRACTICE_EXERCISE_SOLUTION.SQL. 
      You'll get an overview of how to use common table expressions and the LAG function from this question.*/
      
	WITH QoQ AS 
(
	SELECT
		quarter_number,
		SUM(calc_revenue_f (vehicle_price, discount, quantity)) AS revenue
	FROM 
		veh_ord_cust_v
	GROUP BY 1
)
SELECT
	quarter_number,
    revenue,
    LAG(revenue) OVER (ORDER BY quarter_number) AS previous_quarter_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY quarter_number))/LAG(revenue) OVER(ORDER BY quarter_number) * 100),1) AS "QUARTER OVER QUARTER REVENUE(%)"
FROM
	QoQ;      

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q8] What is the trend of revenue and orders by quarters?

Hint: Find out the sum of revenue and count the number of orders for each quarter.*/

SELECT 
	quarter_number,
    ROUND(SUM(calc_revenue_f (vehicle_price, discount, quantity)),0) AS quarter_revenue,
    COUNT(order_id) AS quarter_orders
FROM 
	veh_ord_cust_v
GROUP BY quarter_number;

-- ---------------------------------------------------------------------------------------------------------------------------------

/* QUESTIONS RELATED TO SHIPPING 
    [Q9] What is the average discount offered for different types of credit cards?

Hint: Find out the average of discount for each credit card type.*/

SELECT
	credit_card_type,
    ROUND(AVG(discount),2) AS avg_discount_per_card
FROM veh_ord_cust_v
GROUP BY credit_card_type
ORDER BY avg_discount_per_card DESC;


-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q10] What is the average time taken to ship the placed orders for each quarters?
   Use days_to_ship_f function to compute the time taken to ship the orders.

Hint: For each quarter, find out the average of the function that you created to calculate the difference between the ship date and the order date.*/

SELECT 
	quarter_number,
    ROUND(AVG(days_to_ship_f (ship_date, order_date)),0) AS days_to_ship_orders
FROM 
	veh_ord_cust_v
GROUP BY quarter_number
ORDER BY quarter_number;

-- --------------------------------------------------------Done----------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------
