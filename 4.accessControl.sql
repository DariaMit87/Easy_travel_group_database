-- Create roles for different types of users
CREATE ROLE admin;
CREATE ROLE travel_agent;
CREATE ROLE customer;

-- Grant full access to admin
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin;
GRANT USAGE ON SCHEMA public TO daria_admin;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE flight_flight_id_seq TO daria_admin;

-- Grant permissions to travel_agent
GRANT SELECT, INSERT, UPDATE, DELETE ON Booking TO travel_agent;
GRANT SELECT ON Flight, Accommodation, Transfer TO travel_agent;

-- Grant permissions to customer
GRANT SELECT ON Customer TO customer;
GRANT SELECT ON Booking, Feedback, Loyalty_Program TO customer;


CREATE USER daria_admin WITH PASSWORD '123';
CREATE USER bill_agent WITH PASSWORD '456';
CREATE USER anna_customer WITH PASSWORD '789';

GRANT admin TO daria_admin;
GRANT travel_agent TO bill_agent;
GRANT customer TO anna_customer;

REVOKE ALL ON DATABASE easy_travel_database FROM PUBLIC;

ALTER ROLE admin WITH LOGIN;
ALTER ROLE customer WITH LOGIN;
ALTER ROLE travel_agent WITH LOGIN;

GRANT CONNECT ON DATABASE easy_travel_database TO daria_admin;
GRANT CONNECT ON DATABASE easy_travel_database TO bill_agent;
GRANT CONNECT ON DATABASE easy_travel_database TO anna_customer;



--Access Level for Admin
-U daria_admin -d easy_travel_database
--password 123
-- Admin have access to all commands of all tables
--View all bookings
SELECT * FROM Booking;
-- Add a new flight
INSERT INTO Flight (airline_name, departure_location, arrival_location, departure_date_time, seat_capacity, price_per_seat, optional_services)
VALUES ('New Airline', 'Paris', 'Berlin', '2025-03-10 10:30:00', 180, 250.00, 'WiFi Access');
-- Update customer information
UPDATE Customer SET email = 'newemail@example.com' WHERE customer_id = 5;
-- Delete an accommodation
DELETE FROM Accommodation WHERE accommodation_id = 10;


-- Access Level for Travel Agent
-U bill_agent -d easy_travel_database
--password 456
--Agent can do all on Booking and SELECT from Flight, Accommodation, Transfer
SELECT * FROM Flight;
SELECT * FROM Feedback;
--ERROR:  permission denied for table feedback
UPDATE Booking SET seat_class = 'First Class' WHERE booking_id = 9;
UPDATE Flight SET price_per_seat = 300.00 WHERE flight_id = 5;
--ERROR:  permission denied for table flight

--Access Level for Customer
psql -U anna_customer -d easy_travel_database
--password 789
--Customer can SELECT from Customer, Booking, Feedback, LoyaltyProgram
SELECT * FROM Customer WHERE customer_id = 30;
SELECT * FROM Booking WHERE customer_id = 30;
SELECT * FROM Loyalty_Program WHERE customer_id = 30;
INSERT INTO Accommodation (name, location, type, room_type, price_per_night, add_ons)
VALUES ('Oceanview Resort', 'Maldives', 'Resort', 'Suite', 500.00, 'Spa included');
--permission denied for table accommodation