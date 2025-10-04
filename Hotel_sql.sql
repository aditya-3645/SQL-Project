CREATE DATABASE hotels;
USE  hotels;

Create Table hotels(
      hotel_id int primary key,
      hotel_name text ,
      city text,
      country text,
      star_rating int ,
      lat float,
      lon float,
      cleanliness_base double,
      comfort_base double,
      facilities_base double,
      location_base double,
      staff_base double,
      value_for_money_base double
      );

SELECT * FROM users;
SELECT * FROM reviews;
SELECT * FROM hotels;

ALTER TABLE reviews
ADD rating double;
set sql_safe_updates =0;
UPDATE reviews
SET rating = round(
    ((score_overall + score_cleanliness + score_comfort + 
     score_facilities + score_location + score_staff + score_value_for_money) / 7),2
);

#Top 10 hotels with highest average rating
SELECT h.hotel_id, h.hotel_name, 
       ROUND(AVG(r.rating),2) AS avg_rating,
       COUNT(r.review_id) AS total_reviews
FROM hotels h
JOIN reviews r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 10;

#user who reviewed more than 2 different hotels 
SELECT u.user_id, COUNT(DISTINCT r.hotel_id) AS hotels_reviewed
FROM users u
JOIN reviews r ON u.user_id = r.user_id
GROUP BY u.user_id
HAVING COUNT(DISTINCT r.hotel_id) > 2;

# Top 10 cities according to number of review 
SELECT h.city, 
       COUNT(r.review_id) AS total_reviews
FROM hotels h
JOIN reviews r 
     ON h.hotel_id = r.hotel_id
GROUP BY h.city
ORDER BY total_reviews DESC limit 10;

#how many reviews each hotel has received.
SELECT h.hotel_name, COUNT(r.review_id) AS total_reviews
FROM hotels h
LEFT JOIN reviews r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name
ORDER BY total_reviews DESC;

#number of unique users who reviewed each hotel.
SELECT h.hotel_name, COUNT(DISTINCT r.user_id) AS unique_reviewers
FROM hotels h
JOIN reviews r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name;

#average rating given by travellers of type 'Family'.
SELECT hotel_name, ROUND(AVG(r.score_overall),2) AS avg_family_rating
FROM reviews r
JOIN users u ON r.user_id = u.user_id
JOIN hotels h ON r.hotel_id = h.hotel_id
WHERE u.traveller_type = 'Family'
GROUP BY hotel_name;

# top 3 countries with most registered users
SELECT country, COUNT(user_id) AS total_users
FROM users
GROUP BY country
ORDER BY total_users DESC
LIMIT 3;

#Most frequently reviewed hotel in each city 
SELECT h.city, h.hotel_name, COUNT(r.review_id) AS review_count
FROM hotels h
JOIN reviews r ON h.hotel_id = r.hotel_id
GROUP BY h.city, h.hotel_name
HAVING COUNT(r.review_id) = (
    SELECT MAX(cnt) 
    FROM (
        SELECT COUNT(r2.review_id) AS cnt
        FROM hotels h2
        JOIN reviews r2 ON h2.hotel_id = r2.hotel_id
        WHERE h2.city = h.city
        GROUP BY h2.hotel_name
    ) AS sub
);


#Top 5 most common age group of reviewers
SELECT u.age, COUNT(r.review_id) AS review_count
FROM users u
JOIN reviews r ON u.user_id = r.user_id
GROUP BY u.age
ORDER BY review_count DESC
LIMIT 5;


#Hotel with highest staff rating 
SELECT h.hotel_name, ROUND(AVG(r.score_staff),2) AS avg_staff_score
FROM hotels h
JOIN reviews r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name
ORDER BY avg_staff_score DESC
LIMIT 1;
