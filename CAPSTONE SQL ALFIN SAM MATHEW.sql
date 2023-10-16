--  CAPSTONE PROJECT 1
-- MOVIE RENTAL ANALYSIS 

use sakila;
-- ------------------------------------------------------------------------ --
-- TASK 1: Display the full names of actors available in the database
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM actor;
-- THERE ARE TOTAL 200 ACTORS IN THE DATASET.
-- ------------------------------------------------------------------------ --

-- TASK 2: Management wants to know if there are any names of the actors appearing frequently
-- i) Display the number of times each first name appears in the database
SELECT first_name, COUNT(*) AS name_count FROM actor
GROUP BY first_name ORDER BY name_count DESC;
-- THE MAXIMUM NUMBER OF SAME FIRST NAME APPEARED IS 4.

-- ii) What is the count of actors that have unique first names in the database? Display the first names of all these actors.
SELECT first_name, COUNT(*) AS name_count FROM actor
GROUP BY first_name HAVING name_count=1;
-- THERE ARE TOTAL 76 ACTORS WITH UNIQUE FIRSTNAMES (NO REPETITION).
-- -------------------------------------------------------------------------------- --

-- TASK 3: The management is interested to analyze the similiarity in the last names of the actors
-- i) Display the number of times each last name appears in the database
SELECT last_name, COUNT(*) AS name_count FROM actor
GROUP BY last_name ORDER BY name_count DESC;
-- THE MAXIMUM NUMBER OF SAME LAST NAME REPEATED IS 5. 

-- ii) Display all unique last names in the database
SELECT last_name, COUNT(*) AS name_count FROM actor
GROUP BY last_name HAVING name_count=1;
-- THERE ARE 66 UNIQUE LAST NAMES IN THE DATASET
-- --------------------------------------------------------------------------------------

/* TASK 4: The management wants to analyze the movies based on their ratings to determine if they are suitable for kids or some parental assistance is required. 
Perform the following tasks to perform the required analysis. */

-- i) Display the list of records for the movies with the rating "R". (The movies with the rating "R" are not suitable for audience under 17 years of age).
SELECT film_id, title, rating FROM film WHERE rating='R';
-- THERE ARE TOTAL OF 195 MOVIES WITH RATING R (UNDER 17 MUST NEED PARENT OR ADULT ACCOMPANYING)

-- ii) Display the list of records for the movies that are not rated "R".
SELECT film_id, title, rating FROM film WHERE rating <> 'R';
-- THERE ARE TOTAL OF 805 MOVIES OTHER THAN WITH R RATING.

-- iii) Display the list of records for the movies that are suitable for audience below 13 years of age
 SELECT film_id, title, rating FROM film WHERE rating IN ('G','PG');
-- THERE ARE TOTAL 372 MOVIES WITH G RATING WHICH IS ALL AGES AND PG WHICH SUGGEST PARENTAL GUIDANCE. 
-- ----------------------------------------------------------------------------------------------------

/* TASK 5: The board members want to understand the replacement cost of a movie copy(disc- DVD/BlueRay). 
The replacement cost refers to the amount charged to the customer if the movie disc is not returned or is returned in a damaged state*/

-- i) Display the list of records for the movies where the replacement cost is up to $11
SELECT film_id, title, replacement_cost FROM film
WHERE replacement_cost <= 11.00;
-- 90 FILMS ARE THERE, WHOSE REPAYMENT COST ARE UPTO $11. 

-- ii) Display the list of records for the movies where the replacement cost is between $11 and $20.
SELECT film_id, title, replacement_cost FROM film
WHERE replacement_cost BETWEEN 11.00 AND 20.00;
-- 424 FILMS ARE THERE, WHOSE REPAYMENT COST ARE BETWEEN 11 AND 20.

-- iii) Display the list of records for the all movies in descending order of their replacement costs
SELECT film_id, title, replacement_cost FROM film
ORDER BY replacement_cost DESC;
-- THE HIGHEST REPLACEMENT COST FOR MOVIES IS 29.99.
-- ------------------------------------------------------------------------------------------------

-- TASK 6: Display the names of the top 3 movies with the greatest number of actors
SELECT film.title, COUNT(film_actor.actor_id) AS actor_count FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id ORDER BY actor_count DESC LIMIT 3;
-- THE MOVIES WITH GREATEST NUMBER OF ACTORS ARE LAMBS CINCINATTI, CHITTY LOCK AND BOONDOCK BALLROOM WITH 15,13 AND 13.
-- ---------------------------------------------------------------------------------------------

/* TASK 7: 'Music of Queen' and 'Kris Kristofferson' have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
Display the titles of the movies starting with the letters `"K` and `Q`. */
SELECT title FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%';
-- TOTAL OF 15 MOVIES WHOSE NAMES ARE STARTING WITH K AND Q.
-- ------------------------------------------------------------------------------------------------

-- TASK 8: The film 'Agent Truman' has been a great success. Display the names of all actors who appeared in this film
SELECT actor.first_name, actor.last_name FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Agent Truman';
-- THERE ARE 7 ACTORS IN THE FILM AGENT_TRUMAN. ACTORS ARE KIRSTEN, SANDRA, JAYNE, WARREN, MORGAN, KENNETH AND REESE.
-- ------------------------------------------------------------------------------------------------

-- TASK 9: Sales have been lagging among young families, so the management wants to promote family movies. 
-- Identify all the movies categorized as family films.
SELECT film.title,category.name AS category FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';
-- 69 FILMS ARE THERE WHICH ARE SUITABLE FOR FAMILY.
-- -----------------------------------------------------------------------------------------------------
-- TASK 10: The management wants to observe the rental rates and rental frequencies(Number of time the movie disc is rented).
-- i) Display the maximum, minimum, and average rental rates of movies based on their on their ratings. 
-- The output must be sorted in descending order of the average rental rates.
SELECT rating, MAX(rental_rate) AS max_rental_rate, MIN(rental_rate) AS min_rental_rate, AVG(rental_rate) AS avg_rental_rate
FROM film GROUP BY rating
ORDER BY avg_rental_rate DESC;
-- THE MAX RENTAL RATE FOR PG,PG-13,NC-17,R AND G IS 4.99 AND MIN RENTAL RATE FOR THESE IS 0.99.
-- AND, AVERAGE RENTAL RATE FOR PG IS 3.05, PG-13 IS 3.03, NC-17 IS 2.97,R IS 2.93 AND G IS 2.88.

-- ii) Display the movies in descending order of their rental frequencies, so the management can maintain more copies of those movies.
SELECT film.film_id, film.title, COUNT(rental.rental_id) AS rental_count FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
ORDER BY rental_count DESC;
-- THE HIGHEST RENTAL COUNT IS 34 AND THE MOVIE WITH 34 RENTAL COUNT IS BUCKET BROTHERHOOD.
-- --------------------------------------------------------------------------------------------

/* TASK 11: In how many film categories, the difference between the average film replacement cost (disc- DVD/Blue Ray) 
and the average film rental rate is greater than $15? */
SELECT category.name, AVG(film.replacement_cost) AS Avg_replacement, AVG(film.rental_rate) as Avg_rental,
AVG(film.replacement_cost) - AVG(film.rental_rate) AS cost_difference FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name HAVING cost_difference > 15;
-- ALL CATEGORIES HAVE COST DIFFERENCE GREATER THAN $15.
-- ----------------------------------------------------------------------------------------

-- TASK 12: Display the film categories in which the number of movies is greater than 70
SELECT category.name, COUNT(film_category.film_id) AS movies_count FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
GROUP BY category.name HAVING movies_count>70;
-- FOREIGN CATEGORY AND SPORTS CATEGORY HAVE MORE THAN 70 MOVIE COUNT.
