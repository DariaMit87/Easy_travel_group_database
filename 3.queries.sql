-- customers who have made a booking
SELECT customer_id, name, email
FROM Customer
WHERE customer_id IN (SELECT DISTINCT customer_id FROM Booking);


-- top 5 most expensive accommodations
SELECT name, location, type, price_per_night
FROM Accommodation
ORDER BY price_per_night DESC
LIMIT 5;


-- select bookings with the seat class "Economy"
SELECT booking_id, flight_id, booking_date, seat_class  
FROM Booking
WHERE seat_class = 'Economy';


-- select transfers and bookings, including transfers with no bookings
SELECT t.transfer_id, t.pickup_location, t.drop_off_location, b.booking_id, b.booking_date
FROM Booking b
RIGHT JOIN Transfer t ON t.transfer_id = b.transfer_id; 


-- customers and their bookings, including customers with no bookings
SELECT c.customer_id, c.name, b.booking_id, b.total_price
FROM Customer c
LEFT JOIN Booking b ON c.customer_id = b.customer_id;


-- join bookings, flights, and customers
SELECT b.booking_id, c.name, f.airline_name, b.total_price
FROM Booking b
INNER JOIN Customer c ON b.customer_id = c.customer_id
INNER JOIN Flight f ON b.flight_id = f.flight_id;


-- join Booking, Customer, Feedback, and Loyalty_Program
SELECT c.customer_id, c.name, b.booking_id, f.rating, f.comments, l.available_points
FROM Feedback f
JOIN Booking b ON f.booking_id = b.booking_id
JOIN Customer c ON b.customer_id = c.customer_id
LEFT JOIN Loyalty_Program l ON c.customer_id = l.customer_id
ORDER BY l.available_points DESC;


-- find the agent who has made the most revenue based on total booking prices
SELECT TA.agent_id, TA.name,
    SUM(B.total_price) AS total_revenue
FROM Travel_Agent TA
JOIN Booking B ON TA.agent_id = B.agent_id
GROUP BY TA.agent_id, name
ORDER BY total_revenue DESC
LIMIT 1;


-- make 10% discount on bookings made before 25th of January 
SELECT booking_id, customer_id, booking_date, total_price,
    CASE 
        WHEN booking_date <= '2025-01-25' THEN total_price * 0.9
        ELSE total_price
    END AS discounted_price
FROM Booking    
WHERE booking_date <= '2025-01-25';    


-- select refunded bookings with customer name
SELECT p.payment_id, p.payment_date, p.amount, 
    CASE 
        WHEN p.refund_status = TRUE THEN 'Refunded' 
        ELSE 'Not refunded'
    END AS refund_status,
    c.name, c.email
FROM Payment p
JOIN Booking b ON p.booking_id = b.booking_id
JOIN Customer c ON b.customer_id = c.customer_id;


-- categorize bookings based on the total price
SELECT booking_id, total_price,
       CASE 
           WHEN total_price < 3000 THEN 'Low Budget'
           WHEN total_price BETWEEN 3000 AND 5000 THEN 'Medium Budget'
           ELSE 'High Budget'
       END AS price_category
FROM Booking;


-- highest, lowest, and average price for flights
SELECT 
    MIN(price_per_seat) AS min_price,
    MAX(price_per_seat) AS max_price,
    AVG(price_per_seat) AS avg_price
FROM Flight;


-- find the average price of booking per customer
SELECT customer_id, AVG(total_price) AS avg_total_price
FROM Booking
GROUP BY customer_id;


-- customers' booking details and categorize bookings into budgets
SELECT c.customer_id, c.name, b.booking_id, b.total_price, f.airline_name,
    a.name AS accommodation_name,
    CASE
        WHEN b.total_price < 3000 THEN 'Low Budget'
        WHEN b.total_price BETWEEN 3000 AND 5000 THEN 'Medium Budget'
        ELSE 'High Budget'
    END AS price_category
FROM Booking b
INNER JOIN Customer c ON b.customer_id = c.customer_id
LEFT JOIN Flight f ON b.flight_id = f.flight_id
LEFT JOIN Accommodation a ON b.accommodation_id = a.accommodation_id;


-- categorize travel agents based on the number of customers they have served
SELECT TA.agent_id, TA.name,
    COUNT(DISTINCT B.customer_id) AS total_customers,
    CASE 
        WHEN COUNT(DISTINCT B.customer_id) >= 3 THEN 'Top Performer'
        WHEN COUNT(DISTINCT B.customer_id) BETWEEN 2 AND 3 THEN 'Average Performer'
        ELSE 'Needs Improvement'
    END AS performance_category
FROM Travel_Agent TA
LEFT JOIN Booking B ON TA.agent_id = B.agent_id
GROUP BY TA.agent_id, name
ORDER BY total_customers DESC;


-- find customers who booked a flight from "New York" to "London":
SELECT name, email
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM Booking
    WHERE flight_id IN (
        SELECT flight_id
        FROM Flight
        WHERE departure_location = 'New York' AND arrival_location = 'London'
    )
);


-- finds the most popular flight by the number of passengers and flight total revenue.
SELECT f.airline_name, f.flight_id, f.departure_location, f.price_per_seat,
    SUM(f.seat_capacity) AS total_passengers,
    SUM(f.seat_capacity * f.price_per_seat) AS total_revenue,
    CASE 
        WHEN SUM(f.seat_capacity) = MAX(SUM(f.seat_capacity)) OVER() THEN 'Most Popular Flight'
        ELSE 'Other Flight'
    END AS flight_status
FROM Flight f
JOIN Booking b ON f.flight_id = b.flight_id
GROUP BY f.airline_name, f.flight_id, f.departure_location, f.arrival_location
ORDER BY total_passengers DESC;




--TCL commands
BEGIN; 
INSERT INTO Booking (customer_id, agent_id, flight_id, accommodation_id, transfer_id, number_of_days, seat_class, points_earned, booking_date, total_price, payment_id)
VALUES (5, 2, 10, 4, NULL, 5, 'Business', 120, '2025-02-15', 1500.00, 8);
COMMIT; 

BEGIN; 
DELETE FROM Booking WHERE booking_id IN (12, 15, 18);
ROLLBACK;

BEGIN;
UPDATE Booking SET total_price = total_price * 0.9 WHERE booking_id = 5;
SAVEPOINT discount_applied; 
UPDATE Booking SET total_price = total_price * 1.1 WHERE booking_id = 10;
SAVEPOINT price_corrected; 
ROLLBACK TO discount_applied; 
COMMIT;



