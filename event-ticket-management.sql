CREATE DATABASE event_ticket_management;
USE event_ticket_management;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    city VARCHAR(50),
    registration_date DATE
);

CREATE TABLE Organizers (
    organizer_id INT PRIMARY KEY AUTO_INCREMENT,
    organizer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    city VARCHAR(50)
);

CREATE TABLE Venues (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(200),
    capacity INT
);

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    organizer_id INT NOT NULL,
    venue_id INT NOT NULL,
    event_name VARCHAR(150) NOT NULL,
    event_category VARCHAR(50),
    event_date DATE,
    start_time TIME,
    end_time TIME,
    event_status VARCHAR(30),

    FOREIGN KEY (organizer_id) REFERENCES Organizers(organizer_id),
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id)
);

CREATE TABLE Ticket_Types (
    ticket_type_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    ticket_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    total_quantity INT NOT NULL,
    available_quantity INT NOT NULL,

    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    ticket_type_id INT NOT NULL,
    booking_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(30),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (ticket_type_id) REFERENCES Ticket_Types(ticket_type_id)
);


CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    transaction_reference VARCHAR(100) UNIQUE,

    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    rating INT NOT NULL,
    review_text VARCHAR(500),
    review_date DATE NOT NULL,

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
--------------------------------------------------------------------

CREATE TEMPORARY TABLE FirstNames (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO FirstNames (name) VALUES
('Arun'),('Priya'),('Karthik'),('Divya'),('Rahul'),
('Sneha'),('Vignesh'),('Anjali'),('Suresh'),('Meena'),
('Rohit'),('Pooja'),('Vivek'),('Swathi'),('Ajay'),
('Keerthana'),('Pradeep'),('Nandhini'),('Dinesh'),('Deepika'),
('Hari'),('Kavya'),('Santhosh'),('Aishwarya'),('Manoj'),
('Shalini'),('Gokul'),('Harini'),('Surya'),('Lavanya'),
('Naveen'),('Reshma'),('Bharath'),('Shreya'),('Mohan'),
('Vaishnavi'),('Ashwin'),('Sowmya'),('Rakesh'),('Ramya'),
('Sanjay'),('Nithya'),('Vijay'),('Pavithra'),('Kiran'),
('Swetha'),('Aravind'),('Janani'),('Madhan'),('Dharani'),
('Sathish'),('Aarthi'),('Ramesh'),('Monika'),('Vinoth'),
('Gayathri'),('Lokesh'),('Deepa'),('Suraj'),('Nisha');

CREATE TEMPORARY TABLE LastNames (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO LastNames (name) VALUES
('Kumar'),('Sharma'),('Raj'),('Nair'),('Reddy'),
('Iyer'),('Patel'),('Singh'),('Verma'),('Das'),
('Menon'),('Pillai'),('Krishnan'),('Rao'),('Mehta'),
('Gupta'),('Joshi'),('Shah'),('Bose'),('Choudhary'),
('Mishra'),('Kapoor'),('Malhotra'),('Bansal'),('Agarwal'),
('Srinivasan'),('Subramanian'),('Murugan'),('Prasad'),('Naidu'),
('Varma'),('Thomas'),('Mathew'),('George'),('Joseph'),
('Francis'),('Antony'),('Alexander'),('Das'),('Roy');


INSERT INTO Users
(user_name, email, phone, city, registration_date)

SELECT
    CONCAT(
        ELT(1 + MOD(n, 20),
            'Arun','Priya','Karthik','Divya','Rahul',
            'Sneha','Vignesh','Anjali','Suresh','Meena',
            'Rohit','Pooja','Vivek','Swathi','Ajay',
            'Keerthana','Pradeep','Nandhini','Dinesh','Deepika'
        ),
        ' ',
        ELT(1 + MOD(n * 3, 20),
            'Kumar','Sharma','Raj','Nair','Reddy',
            'Iyer','Patel','Singh','Verma','Das',
            'Menon','Pillai','Krishnan','Rao','Mehta',
            'Gupta','Joshi','Shah','Bose','Mishra'
        )
    ),

    CONCAT(
        LOWER(
            ELT(1 + MOD(n, 20),
                'Arun','Priya','Karthik','Divya','Rahul',
                'Sneha','Vignesh','Anjali','Suresh','Meena',
                'Rohit','Pooja','Vivek','Swathi','Ajay',
                'Keerthana','Pradeep','Nandhini','Dinesh','Deepika'
            )
        ),
        n,
        '@gmail.com'
    ),

    CONCAT(
        ELT(1 + MOD(n, 5),
            '987','876','934','912','998'
        ),
        LPAD(n, 7, '0')
    ),

    ELT(1 + MOD(n, 15),
        'Chennai',
        'Coimbatore',
        'Madurai',
        'Trichy',
        'Salem',
        'Tirunelveli',
        'Bangalore',
        'Hyderabad',
        'Mumbai',
        'Delhi',
        'Pune',
        'Kochi',
        'Kolkata',
        'Ahmedabad',
        'Jaipur'
    ),

    DATE_ADD(
        '2023-01-01',
        INTERVAL MOD(n * 17, 1200) DAY
    )

FROM
(
    SELECT
        a.n
        + b.n * 10
        + c.n * 100
        + d.n * 1000
        + 1 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
         SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
         SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a

    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
         SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
         SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b

    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
         SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
         SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c

    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1) d
) numbers;

INSERT INTO Organizers
(organizer_name, email, phone, city)

SELECT
    CONCAT(
        ELT(1 + MOD(n, 20),
            'Bright Star Events',
            'Dream World Events',
            'Elite Event Management',
            'Grand Stage Events',
            'Blue Sky Events',
            'Royal Celebrations',
            'Galaxy Events',
            'Prime Event Solutions',
            'Golden Events',
            'City Lights Events',
            'Sunrise Productions',
            'Vision Event Planners',
            'Spark Events',
            'Infinity Events',
            'Celebration Hub',
            'Live Wave Events',
            'Starline Productions',
            'Mega Events India',
            'Future Events',
            'Harmony Events'
        ),
        ' ',
        n
    ),

    CONCAT('organizer', n, '@gmail.com'),

    CONCAT(
        ELT(1 + MOD(n, 5),
            '987','876','934','912','998'
        ),
        LPAD(n, 7, '0')
    ),

    ELT(1 + MOD(n, 15),
        'Chennai',
        'Coimbatore',
        'Madurai',
        'Trichy',
        'Salem',
        'Tirunelveli',
        'Bangalore',
        'Hyderabad',
        'Mumbai',
        'Delhi',
        'Pune',
        'Kochi',
        'Kolkata',
        'Ahmedabad',
        'Jaipur'
    )

FROM
(
    SELECT
        a.n + b.n * 10 + 1 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
         SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
         SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a

    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
         SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
         SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
) numbers;


INSERT INTO Venues
(venue_name, city, address, capacity)
VALUES
('Chennai Trade Centre', 'Chennai', 'Nandambakkam, Chennai', 5000),
('YMCA Grounds', 'Chennai', 'Nandanam, Chennai', 3000),
('Island Grounds', 'Chennai', 'Island Grounds, Chennai', 8000),
('VGP Golden Beach Resort', 'Chennai', 'East Coast Road, Chennai', 2500),
('The Leela Palace', 'Chennai', 'Adyar, Chennai', 1200),
('ITC Grand Chola', 'Chennai', 'Guindy, Chennai', 2000),
('Codissia Trade Fair Complex', 'Coimbatore', 'Avinashi Road, Coimbatore', 6000),
('Hindusthan College Auditorium', 'Coimbatore', 'Avinashi Road, Coimbatore', 1800),
('Suguna Auditorium', 'Coimbatore', 'Kalapatti, Coimbatore', 1200),
('Hotel Residency Towers', 'Chennai', 'T Nagar, Chennai', 900),
('Madurai Tamukkam Grounds', 'Madurai', 'Tallakulam, Madurai', 7000),
('Madurai Convention Centre', 'Madurai', 'Mattuthavani, Madurai', 2500),
('Anna Stadium', 'Tirunelveli', 'Palayamkottai, Tirunelveli', 4500),
('VOC Ground', 'Tuticorin', 'Millerpuram, Tuticorin', 5000),
('Bharathidasan University Auditorium', 'Trichy', 'Palkalaiperur, Trichy', 1800),
('Kongunadu Convention Hall', 'Trichy', 'Woraiyur, Trichy', 1500),
('Salem Steel Auditorium', 'Salem', 'Salem Steel Plant, Salem', 2200),
('Sona College Auditorium', 'Salem', 'Junction Main Road, Salem', 1600),
('Bangalore Palace Grounds', 'Bangalore', 'Vasanth Nagar, Bangalore', 10000),
('Palace Grounds Convention Centre', 'Bangalore', 'Jayamahal Road, Bangalore', 6000),
('Manpho Convention Centre', 'Bangalore', 'Nagawara, Bangalore', 3000),
('KTPO Convention Centre', 'Bangalore', 'Whitefield, Bangalore', 5000),
('NIMHANS Convention Centre', 'Bangalore', 'Hosur Road, Bangalore', 2000),
('Hitex Exhibition Centre', 'Hyderabad', 'Hitech City, Hyderabad', 8000),
('Shilpakala Vedika', 'Hyderabad', 'Madhapur, Hyderabad', 2000),
('Novotel Hyderabad Convention Centre', 'Hyderabad', 'Hitech City, Hyderabad', 3500),
('LB Stadium', 'Hyderabad', 'Basheerbagh, Hyderabad', 7000),
('Ramoji Film City', 'Hyderabad', 'Ramoji Film City, Hyderabad', 10000),
('Bombay Exhibition Centre', 'Mumbai', 'Goregaon East, Mumbai', 12000),
('Jio World Convention Centre', 'Mumbai', 'Bandra Kurla Complex, Mumbai', 5000),
('Nesco Convention Centre', 'Mumbai', 'Goregaon East, Mumbai', 6000),
('Yashwantrao Chavan Auditorium', 'Mumbai', 'Nariman Point, Mumbai', 1800),
('NSCI Dome', 'Mumbai', 'Worli, Mumbai', 5000),
('Pragati Maidan', 'Delhi', 'Mathura Road, New Delhi', 15000),
('India Habitat Centre', 'Delhi', 'Lodhi Road, New Delhi', 2500),
('Jawaharlal Nehru Stadium', 'Delhi', 'Lodhi Road, New Delhi', 6000),
('Talkatora Indoor Stadium', 'Delhi', 'President Estate, Delhi', 3000),
('Major Dhyan Chand National Stadium', 'Delhi', 'India Gate, Delhi', 5000),
('Auto Cluster Exhibition Centre', 'Pune', 'Chinchwad, Pune', 5000),
('Balewadi Stadium', 'Pune', 'Balewadi, Pune', 8000),
('MCCIA Trade Tower', 'Pune', 'Senapati Bapat Road, Pune', 1800),
('Bharat Ratna Auditorium', 'Pune', 'Shivajinagar, Pune', 1500),
('Cochin Convention Centre', 'Kochi', 'Kaloor, Kochi', 3000),
('Bolgatty Palace', 'Kochi', 'Mulavukad, Kochi', 1800),
('Jawaharlal Nehru Stadium', 'Kochi', 'Kaloor, Kochi', 5000),
('Adlux International Convention Centre', 'Kochi', 'Angamaly, Kochi', 4000),
('Marine Drive Ground', 'Kochi', 'Marine Drive, Kochi', 7000),
('Biswa Bangla Convention Centre', 'Kolkata', 'New Town, Kolkata', 5000),
('Science City Auditorium', 'Kolkata', 'JBS Haldane Avenue, Kolkata', 2500),
('Netaji Indoor Stadium', 'Kolkata', 'Strand Road, Kolkata', 12000),
('Nazrul Mancha', 'Kolkata', 'Rabindra Sarobar, Kolkata', 2500),
('Ahmedabad Convention Centre', 'Ahmedabad', 'SG Highway, Ahmedabad', 4000),
('Gujarat University Convention Hall', 'Ahmedabad', 'Navrangpura, Ahmedabad', 2500),
('Riverfront Event Centre', 'Ahmedabad', 'Sabarmati Riverfront, Ahmedabad', 3500),
('JECC Convention Centre', 'Jaipur', 'Sitapura, Jaipur', 6000),
('Birla Auditorium', 'Jaipur', 'Statue Circle, Jaipur', 2000),
('Jaipur Exhibition Centre', 'Jaipur', 'Sitapura, Jaipur', 7000),
('City Palace Courtyard', 'Jaipur', 'City Palace, Jaipur', 1200),
('Goa Convention Centre', 'Panaji', 'Dona Paula, Goa', 2500),
('Kala Academy', 'Panaji', 'Campal, Panaji', 1800),
('Dr Shyama Prasad Mukherjee Stadium', 'Goa', 'Bambolim, Goa', 4000),
('Grand Hyatt Goa', 'Goa', 'Bambolim, Goa', 1500),
('Bhubaneswar Convention Centre', 'Bhubaneswar', 'Nayapalli, Bhubaneswar', 3000),
('Kalinga Stadium', 'Bhubaneswar', 'Nayapalli, Bhubaneswar', 8000),
('Lucknow International Convention Centre', 'Lucknow', 'Gomti Nagar, Lucknow', 5000),
('Indira Gandhi Pratishthan', 'Lucknow', 'Gomti Nagar, Lucknow', 3500),
('Chandigarh Convention Centre', 'Chandigarh', 'Sector 17, Chandigarh', 3000),
('Tagore Theatre', 'Chandigarh', 'Sector 18, Chandigarh', 1500),
('Mohali Cricket Stadium', 'Mohali', 'Phase 9, Mohali', 8000),
('Ranchi Convention Centre', 'Ranchi', 'Dhurwa, Ranchi', 2500),
('JSCA International Stadium', 'Ranchi', 'Dhurwa, Ranchi', 7000),
('Patna Convention Centre', 'Patna', 'Gandhi Maidan, Patna', 3500),
('Gyan Bhawan', 'Patna', 'Gandhi Maidan, Patna', 2500),
('Indore Convention Centre', 'Indore', 'Vijay Nagar, Indore', 4000),
('Brilliant Convention Centre', 'Indore', 'Scheme 78, Indore', 3000),
('Bhopal Convention Centre', 'Bhopal', 'Arera Hills, Bhopal', 2500),
('Ravindra Bhavan', 'Bhopal', 'Shamla Hills, Bhopal', 1800),
('Visakhapatnam Convention Centre', 'Visakhapatnam', 'Madhurawada, Visakhapatnam', 3500),
('RK Beach Grounds', 'Visakhapatnam', 'Beach Road, Visakhapatnam', 7000),
('Vijayawada Convention Hall', 'Vijayawada', 'Benz Circle, Vijayawada', 2500),
('Siddhartha Auditorium', 'Vijayawada', 'Mogalrajpuram, Vijayawada', 1600),
('Mysore Palace Grounds', 'Mysore', 'Mysore Palace, Mysore', 6000),
('Dasara Exhibition Grounds', 'Mysore', 'Dhanvanthri Road, Mysore', 5000),
('Mangalore Convention Centre', 'Mangalore', 'Bejai, Mangalore', 2500),
('TMA Pai Convention Centre', 'Mangalore', 'MG Road, Mangalore', 1800),
('Thiruvananthapuram Convention Centre', 'Thiruvananthapuram', 'Kazhakoottam, Kerala', 3000),
('Nishagandhi Auditorium', 'Thiruvananthapuram', 'Kanakakkunnu, Kerala', 2500),
('Kozhikode Beach Grounds', 'Kozhikode', 'Beach Road, Kozhikode', 6000),
('Lulu Convention Centre', 'Thrissur', 'Edappal, Thrissur', 3500),
('Thrissur Town Hall', 'Thrissur', 'Town Hall Road, Thrissur', 1800),
('Erode Convention Hall', 'Erode', 'Perundurai Road, Erode', 1500),
('Bharathi Auditorium', 'Erode', 'Erode Main Road, Erode', 1200),
('Vellore Convention Centre', 'Vellore', 'Katpadi Road, Vellore', 2000),
('VIT Convention Centre', 'Vellore', 'VIT Campus, Vellore', 2500),
('Pondicherry Convention Centre', 'Puducherry', 'White Town, Puducherry', 2000),
('Jawaharlal Nehru Auditorium', 'Puducherry', 'Lawspet, Puducherry', 1500),
('Nagercoil Convention Hall', 'Nagercoil', 'Kottar, Nagercoil', 1300),
('Tirunelveli Exhibition Hall', 'Tirunelveli', 'Vannarpettai, Tirunelveli', 1800),
('Chennai Convention Arena', 'Chennai', 'OMR, Chennai', 4000),
('Marina Event Grounds', 'Chennai', 'Marina Beach Road, Chennai', 7500),
('Guindy Event Pavilion', 'Chennai', 'Guindy, Chennai', 2200),
('T Nagar Convention Hall', 'Chennai', 'T Nagar, Chennai', 1300),
('Anna Nagar Community Hall', 'Chennai', 'Anna Nagar, Chennai', 1000),
('Tambaram Convention Centre', 'Chennai', 'Tambaram, Chennai', 1800),
('OMR Event Arena', 'Chennai', 'Sholinganallur, Chennai', 3500),
('Mahabalipuram Beach Resort', 'Chennai', 'East Coast Road, Chennai', 2200);





INSERT INTO Events
(
    organizer_id,
    venue_id,
    event_name,
    event_category,
    event_date,
    start_time,
    end_time,
    event_status
)
SELECT
    1 + MOD(n * 7 - 1, 100) AS organizer_id,
    1 + MOD(n - 1, 100) AS venue_id,

    CONCAT(
        ELT(
            1 + MOD(n - 1, 20),
            'Rhythm',
            'Future Tech',
            'Grand',
            'City',
            'Innovation',
            'Cultural',
            'Startup',
            'Comedy',
            'Food',
            'Art',
            'Sports',
            'Music',
            'Business',
            'Youth',
            'Digital',
            'Heritage',
            'Summer',
            'Winter',
            'Creative',
            'Entertainment'
        ),
        ' ',
        ELT(
            1 + MOD(n * 3 - 1, 15),
            'Festival',
            'Summit',
            'Expo',
            'Carnival',
            'Conference',
            'Show',
            'Meetup',
            'Conclave',
            'Challenge',
            'Workshop',
            'Celebration',
            'Championship',
            'Fair',
            'Night',
            'Experience'
        ),
        ' - ',
        v.city,
        ' ',
        YEAR(
            DATE_ADD(
                '2025-01-01',
                INTERVAL MOD(n * 13, 1095) DAY
            )
        )
    ) AS event_name,

    ELT(
        1 + MOD(n - 1, 15),
        'Music',
        'Technology',
        'Sports',
        'Comedy',
        'Business',
        'Workshop',
        'Conference',
        'Cultural',
        'Food Festival',
        'Art',
        'Education',
        'Networking',
        'Exhibition',
        'Theatre',
        'Entertainment'
    ) AS event_category,

    DATE_ADD(
        '2025-01-01',
        INTERVAL MOD(n * 13, 1095) DAY
    ) AS event_date,

    CASE MOD(n, 6)
        WHEN 0 THEN '09:00:00'
        WHEN 1 THEN '10:00:00'
        WHEN 2 THEN '14:00:00'
        WHEN 3 THEN '17:00:00'
        WHEN 4 THEN '18:00:00'
        ELSE '19:00:00'
    END AS start_time,

    CASE MOD(n, 6)
        WHEN 0 THEN '12:00:00'
        WHEN 1 THEN '13:00:00'
        WHEN 2 THEN '17:00:00'
        WHEN 3 THEN '20:00:00'
        WHEN 4 THEN '21:00:00'
        ELSE '22:00:00'
    END AS end_time,

    CASE
        WHEN MOD(n, 25) = 0 THEN 'Cancelled'
        WHEN DATE_ADD(
            '2025-01-01',
            INTERVAL MOD(n * 13, 1095) DAY
        ) < '2026-09-12'
        THEN 'Completed'
        ELSE 'Upcoming'
    END AS event_status

FROM
(
    SELECT
        a.n + b.n * 10 + c.n * 100 + 1 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
         UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
         UNION ALL SELECT 8 UNION ALL SELECT 9) b
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4) c
) numbers

JOIN Venues v
    ON v.venue_id = 1 + MOD(numbers.n - 1, 100);





INSERT INTO Ticket_Types
(
    event_id,
    ticket_name,
    price,
    total_quantity,
    available_quantity
)
SELECT
    event_id,

    CASE ticket_no
        WHEN 1 THEN
            ELT(
                1 + MOD(event_id - 1, 5),
                'General Admission',
                'Standard',
                'Regular',
                'Early Bird',
                'Basic Pass'
            )
        ELSE
            ELT(
                1 + MOD(event_id - 1, 6),
                'VIP',
                'Premium',
                'Platinum',
                'Gold Pass',
                'Premium Pass',
                'Executive Pass'
            )
    END AS ticket_name,

    CASE ticket_no
        WHEN 1 THEN
            CASE MOD(event_id, 6)
                WHEN 0 THEN 499.00
                WHEN 1 THEN 599.00
                WHEN 2 THEN 799.00
                WHEN 3 THEN 999.00
                WHEN 4 THEN 399.00
                ELSE 699.00
            END
        ELSE
            CASE MOD(event_id, 6)
                WHEN 0 THEN 1499.00
                WHEN 1 THEN 1999.00
                WHEN 2 THEN 2499.00
                WHEN 3 THEN 2999.00
                WHEN 4 THEN 1299.00
                ELSE 1799.00
            END
    END AS price,

    CASE ticket_no
        WHEN 1 THEN 100 + MOD(event_id * 17, 401)
        ELSE 30 + MOD(event_id * 11, 171)
    END AS total_quantity,

    CASE ticket_no
        WHEN 1 THEN
            FLOOR(
                (100 + MOD(event_id * 17, 401))
                * (0.25 + MOD(event_id, 50) / 100)
            )
        ELSE
            FLOOR(
                (30 + MOD(event_id * 11, 171))
                * (0.20 + MOD(event_id, 60) / 100)
            )
    END AS available_quantity

FROM Events e

CROSS JOIN
(
    SELECT 1 AS ticket_no
    UNION ALL
    SELECT 2 AS ticket_no
) t;



INSERT INTO Bookings
(
    user_id,
    ticket_type_id,
    booking_date,
    quantity,
    total_amount,
    booking_status
)
SELECT
    1 + MOD(n * 37 - 1, 2000) AS user_id,

    1 + MOD(n * 17 - 1, 1000) AS ticket_type_id,

    DATE_ADD(
        '2025-01-01',
        INTERVAL MOD(n * 7, 615) DAY
    ) AS booking_date,

    1 + MOD(n * 5, 5) AS quantity,

    (
        1 + MOD(n * 5, 5)
    ) * tt.price AS total_amount,

    CASE
        WHEN MOD(n, 20) = 0 THEN 'Cancelled'
        WHEN MOD(n, 10) = 0 THEN 'Pending'
        ELSE 'Confirmed'
    END AS booking_status

FROM
(
    SELECT
        a.n + b.n * 10 + c.n * 100 + 1 AS n
    FROM
        (
            SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
            UNION ALL SELECT 8 UNION ALL SELECT 9
        ) a
    CROSS JOIN
        (
            SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
            UNION ALL SELECT 8 UNION ALL SELECT 9
        ) b
    CROSS JOIN
        (
            SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
            UNION ALL SELECT 8 UNION ALL SELECT 9
        ) c
) numbers

JOIN Ticket_Types tt
    ON tt.ticket_type_id = 1 + MOD(numbers.n * 17 - 1, 1000);



INSERT INTO Payments
(
    booking_id,
    payment_date,
    amount,
    payment_method,
    payment_status,
    transaction_reference
)
SELECT
    b.booking_id,

    DATE_ADD(
        b.booking_date,
        INTERVAL MOD(b.booking_id, 3) DAY
    ) AS payment_date,

    b.total_amount AS amount,

    ELT(
        1 + MOD(b.booking_id - 1, 5),
        'UPI',
        'Credit Card',
        'Debit Card',
        'Net Banking',
        'Wallet'
    ) AS payment_method,

    CASE
        WHEN b.booking_status = 'Cancelled' THEN 'Refunded'
        WHEN b.booking_status = 'Pending' THEN 'Pending'
        WHEN MOD(b.booking_id, 25) = 0 THEN 'Failed'
        ELSE 'Completed'
    END AS payment_status,

    CONCAT(
        'TXN',
        DATE_FORMAT(b.booking_date, '%Y%m%d'),
        LPAD(b.booking_id, 6, '0')
    ) AS transaction_reference

FROM Bookings b;




INSERT INTO Reviews
(
    user_id,
    event_id,
    rating,
    review_text,
    review_date
)
SELECT
    1 + MOD(n * 31 - 1, 2000) AS user_id,

    1 + MOD(n * 17 - 1, 500) AS event_id,

    1 + MOD(n * 7, 5) AS rating,

    CASE (1 + MOD(n * 7, 5))
        WHEN 1 THEN
            ELT(
                1 + MOD(n, 5),
                'The event was not well organized.',
                'The experience was below my expectations.',
                'There were several issues during the event.',
                'The arrangements could have been much better.',
                'I was not fully satisfied with the event.'
            )

        WHEN 2 THEN
            ELT(
                1 + MOD(n, 5),
                'The event was average and needs improvement.',
                'Some parts were good but there were a few problems.',
                'The arrangements could be improved.',
                'The overall experience was okay.',
                'Expected better organization from the team.'
            )

        WHEN 3 THEN
            ELT(
                1 + MOD(n, 5),
                'It was a decent event with good arrangements.',
                'Overall it was a satisfactory experience.',
                'The event was good and reasonably organized.',
                'I enjoyed some parts of the event.',
                'A good experience with some room for improvement.'
            )

        WHEN 4 THEN
            ELT(
                1 + MOD(n, 5),
                'Very good event with excellent arrangements.',
                'I enjoyed the event and the overall experience.',
                'The organizers managed everything well.',
                'Good atmosphere and well planned event.',
                'Really enjoyed the event. Worth attending.'
            )

        WHEN 5 THEN
            ELT(
                1 + MOD(n, 5),
                'Excellent event! Everything was well organized.',
                'Amazing experience. I really enjoyed the event.',
                'Fantastic event with great arrangements.',
                'One of the best events I have attended.',
                'Outstanding experience. Highly recommended.'
            )
    END AS review_text,

    DATE_ADD(
        '2025-01-15',
        INTERVAL MOD(n * 9, 600) DAY
    ) AS review_date

FROM
(
    SELECT
        a.n + b.n * 10 + c.n * 100 + d.n * 1000 + 1 AS n
    FROM
        (
            SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
            UNION ALL SELECT 8 UNION ALL SELECT 9
        ) a
    CROSS JOIN
        (
            SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
            UNION ALL SELECT 8 UNION ALL SELECT 9
        ) b
    CROSS JOIN
        (
            SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
            UNION ALL SELECT 8 UNION ALL SELECT 9
        ) c
    CROSS JOIN
        (
            SELECT 0 n UNION ALL SELECT 1
        ) d
) numbers

WHERE n <= 1500;

-----------------------------------------------------------------------


select * from venues
order by organizer_name