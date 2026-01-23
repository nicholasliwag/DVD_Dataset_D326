--Part B. Functions
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

--Part C. Creating Tables
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

--Part D. SQL Query
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

--Part E. Triggers
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

--F. Stored Procedures
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