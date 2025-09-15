Create Database Hotel_bookings;
use Hotel_bookings;

SELECT * FROM HOTELS_SQL_READY;
SELECT * FROM REVIEWS_SQL_READY;
SELECT * FROM USERS_SQL_READY;

# 1. Total number of users
SELECT COUNT(*) AS total_users 
FROM users_sql_ready;

# 2. Total number of hotels
SELECT COUNT(*) AS total_hotels 
FROM hotels_sql_ready;

# 3. Total number of reviews
SELECT COUNT(*) AS total_reviews 
FROM reviews_sql_ready;

# 4. Average overall score across all hotels
SELECT AVG(score_overall) AS avg_overall_score
FROM reviews_sql_ready;

# 5. Average overall score by hotel (Top 10 hotels)
SELECT h.hotel_name, AVG(r.score_overall) AS avg_score
FROM reviews_sql_ready r JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_name
ORDER BY avg_score DESC LIMIT 10;

# 6. Number of reviews by traveller type
SELECT u.traveller_type, COUNT(r.review_id) AS review_count
FROM reviews_sql_ready r JOIN users_sql_ready u ON r.user_id = u.user_id
GROUP BY u.traveller_type
ORDER BY review_count DESC ;

# 7. Top 5 countries by number of reviews
SELECT u.country, COUNT(r.review_id) AS total_reviews
FROM reviews_sql_ready r JOIN users_sql_ready u ON r.user_id = u.user_id
GROUP BY u.country
ORDER BY total_reviews DESC LIMIT 5;

# 8. Average hotel rating by star level
SELECT h.star_rating, AVG(r.score_overall) AS avg_rating
FROM reviews_sql_ready r JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.star_rating
ORDER BY h.star_rating;

# 9. Most reviewed hotel
SELECT h.hotel_name, COUNT(r.review_id) AS review_count
FROM reviews_sql_ready r
JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_name
ORDER BY review_count DESC LIMIT 1;

# 10. Top traveller type for each hotel
SELECT h.hotel_name, u.traveller_type, COUNT(*) AS total
FROM reviews_sql_ready r
JOIN users_sql_ready u ON r.user_id = u.user_id 
JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_name, u.traveller_type
HAVING total = (
   SELECT MAX(cnt) 
   FROM (
     SELECT COUNT(*) AS cnt
     FROM reviews_sql_ready r2
     JOIN users_sql_ready u2 ON r2.user_id = u2.user_id
     WHERE r2.hotel_id = h.hotel_id
     GROUP BY u2.traveller_type
   ) sub
);

# 11. Average score by traveller type
SELECT u.traveller_type, AVG(r.score_overall) AS avg_score
FROM reviews_sql_ready r
JOIN users_sql_ready u ON r.user_id = u.user_id
GROUP BY u.traveller_type;

# 12. Hotels with average staff score below 8
SELECT h.hotel_name, AVG(r.score_staff) AS avg_staff_score
FROM reviews_sql_ready r
JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_name
HAVING AVG(r.score_staff) < 8
ORDER BY avg_staff_score;

# 13. Most popular city (by number of reviews)
SELECT h.city, COUNT(r.review_id) AS total_reviews
FROM reviews_sql_ready r
JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.city
ORDER BY total_reviews DESC
LIMIT 1;

# 14. Country with highest average hotel value-for-money score
SELECT h.country, AVG(r.score_value_for_money) AS avg_value
FROM reviews_sql_ready r
JOIN hotels_sql_ready h ON r.hotel_id = h.hotel_id
GROUP BY h.country
ORDER BY avg_value DESC
LIMIT 1;

# 15. Recent user growth (users joined by year)
SELECT YEAR(join_date) AS join_year, COUNT(user_id) AS new_users
FROM users_sql_ready
GROUP BY YEAR(join_date)
ORDER BY join_year;
