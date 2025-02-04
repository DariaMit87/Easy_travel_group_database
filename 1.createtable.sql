
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);


CREATE TABLE Regular_Customer (
    customer_id INT PRIMARY KEY,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);


CREATE TABLE Loyalty_Customer (
    customer_id INT PRIMARY KEY,
    membership_id INT UNIQUE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);


CREATE TABLE Loyalty_Program (
    membership_id SERIAL PRIMARY KEY,
    customer_id INT UNIQUE NOT NULL,
    membership_tier VARCHAR(50) CHECK (membership_tier IN ('Silver', 'Gold', 'Platinum')),
    available_points INT DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);


ALTER TABLE Loyalty_Customer
ADD FOREIGN KEY (membership_id) REFERENCES Loyalty_Program(membership_id) ON DELETE CASCADE;


CREATE TABLE Flight (
    flight_id SERIAL PRIMARY KEY,
    airline_name VARCHAR(255) NOT NULL,
    departure_location VARCHAR(255) NOT NULL,
    arrival_location VARCHAR(255) NOT NULL,
    departure_date_time TIMESTAMP NOT NULL,
    seat_capacity INT NOT NULL,
    price_per_seat DECIMAL(10,2) NOT NULL,
    optional_services TEXT
);

CREATE TABLE Accommodation (
    accommodation_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL CHECK (type IN ('Hotel', 'Resort', 'Apartment', 'Vacation Home')),
    room_type VARCHAR(100) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    add_ons TEXT
);

CREATE TABLE Transfer (
    transfer_id SERIAL PRIMARY KEY,
    transfer_type VARCHAR(50) NOT NULL CHECK (transfer_type IN ('Shared', 'Private')),
    price DECIMAL(10,2) NOT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    drop_off_location VARCHAR(255) NOT NULL,
    special_requests TEXT
);


CREATE TABLE Travel_Agent (
    agent_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    agency_name VARCHAR(255),
    clients_managed INT DEFAULT 0
);

CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    agent_id INT NULL,
    flight_id INT NULL,
    accommodation_id INT NULL,
    transfer_id INT NULL,
    
    number_of_days INT DEFAULT 1,
    seat_class VARCHAR(50) CHECK (seat_class IN ('Economy', 'Business', 'First Class')),
    points_earned INT DEFAULT 0,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10,2) NOT NULL,
    payment_id INT NULL,

    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Travel_Agent(agent_id) ON DELETE SET NULL,
    
    -- Each service references its actual table
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id) ON DELETE CASCADE,
    FOREIGN KEY (accommodation_id) REFERENCES Accommodation(accommodation_id) ON DELETE CASCADE,
    FOREIGN KEY (transfer_id) REFERENCES Transfer(transfer_id) ON DELETE CASCADE
);


CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'Loyalty Points')),
    refund_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);


CREATE TABLE Pays_With (
    membership_id INT NOT NULL,
    payment_id INT NOT NULL,
    PRIMARY KEY (membership_id, payment_id),
    FOREIGN KEY (membership_id) REFERENCES Loyalty_Program(membership_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE CASCADE
);


CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    feedback_type VARCHAR(50) CHECK (feedback_type IN ('Flight', 'Accommodation', 'Transfer', 'Overall')),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);






