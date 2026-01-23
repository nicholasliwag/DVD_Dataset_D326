# Advanced_Data_Management_D326

A. Business Report
I will be running a report on the most popular film categories by rental amount per month. This will benefit the business in knowing which films of certain categories we need to supply more of. In result, we can generate more revenue for stores by increasing and retaining more customers in our rental business

A1. Specific Fields
The detailed report will list the rental_id, rental_month, film_title, and film_category. 
The summary report will list the film_category, rental_month, and rental_count.  

A2. Types of Data
Detailed Report 
rental_id: INT (integer) / the unique identification number of a rental 
rental_month: INT (integer) / the month 
film_title: VARCHAR(255) (variable length string with a 255-character maximum) / the title of a film
film_category: VARCHAR(25) (variable length string with a 25-character maximum) / the film category name
Summary Report
film_category: VARCHAR(25) (variable length string with a 25 character maximum) / the film category name
rental_month: INT (integer) / the month
rental_count – INT (integer) / the number of rentals

A3. Specific Tables
rental table: This contains the necessary data like the rental IDs.
film table: This contains the necessary data like the film title.
category table: This contains the necessary data like the film category name.

A4. Field Transformation
The field that requires a custom transformation using a user-defined function is rental_date to rental_month. This will improve readability for users. 

A5. Business Uses
The detailed table section will allow a stakeholder to analyze rental trends by the exact movie and its category.  The summary table will provide the stakeholder with an overview of rental behavior by movie category. Both reports can help with managing film inventory.

A6. Report Freshness
Since the report analyzes the rental amount for each month, it should be updated monthly to remain relevant.

B. Functions
CREATE OR REPLACE FUNCTION rental_month(rental_date timestamp)
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE month_of_rental int;
BEGIN 
SELECT EXTRACT(MONTH FROM rental_date) INTO month_of_rental;
RETURN month_of_rental;
END;
$$;

C. Creating Tables
DROP TABLE IF EXISTS detailed_table;
DROP TABLE IF EXISTS summary_table;
 
CREATE TABLE detailed_table (
rental_id INT,
rental_month INT,
film_title VARCHAR(255),
film_category VARCHAR(25)
);
 
CREATE TABLE summary_table (
film_category VARCHAR(25),
rental_month INT,
rental_count INT
);

D. SQL Query
INSERT INTO detailed_table
SELECT rental.rental_id,
rental_month(CAST(rental_date AS TIMESTAMP)),
film.title AS film_title,
category.name AS film_category
FROM rental
LEFT JOIN inventory 
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film 
ON inventory.film_id = film.film_id
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category 
ON film_category.category_id = category.category_id
ORDER BY rental.rental_date;

E. Triggers
CREATE OR REPLACE FUNCTION update_summary()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN 
DELETE FROM summary_table;
INSERT INTO summary_table 
SELECT film_category, rental_month, COUNT(*) AS rental_count
FROM detailed_table
GROUP BY film_category, rental_month
ORDER BY film_category, rental_month, rental_count;
RETURN NEW;
END;
$$;
CREATE TRIGGER trigger_summary_table
AFTER INSERT
ON detailed_table
FOR EACH ROW
EXECUTE PROCEDURE update_summary();

F. Stored Procedures
CREATE OR REPLACE PROCEDURE refresh_table()
LANGUAGE plpgsql
AS $$
BEGIN 
DELETE FROM detailed_table;
DELETE FROM summary_table;
INSERT INTO detailed_table
SELECT rental.rental_id,
rental_month(CAST(rental_date AS TIMESTAMP)),
film.title AS film_title,
category.name AS film_category
FROM rental
LEFT JOIN inventory 
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film 
ON inventory.film_id = film.film_id
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category 
ON film_category.category_id = category.category_id
ORDER BY rental.rental_date;
RETURN;
END;
$$;

F1. Job Scheduling Tool
Since this job-scheduling tool supports PostgreSQL, pgAgent would be the best option for automating the stored procedure. This tool can also be managed by PgAdmin4.
