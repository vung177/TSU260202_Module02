-- ============
-- Phan 1
-- ============
CREATE TABLE Passengers (
passenger_id VARCHAR(5) PRIMARY KEY NOT NULL,
passenger_full_name VARCHAR(100) NOT NULL,
passenger_email VARCHAR(100) NOT NULL,
passenger_phone VARCHAR(15) NOT NULL,
passenger_cccd VARCHAR(20) NOT NULL
);

CREATE TABLE Trains (
train_id VARCHAR(5) PRIMARY KEY NOT NULL,
train_name VARCHAR(100) NOT NULL,
train_type VARCHAR(100) NOT NULL,
total_seats INT NOT NULL
);

CREATE TABLE Tickets (
ticket_id VARCHAR(5) PRIMARY KEY NOT NULL,
passenger_id VARCHAR(5) NOT NULL,
train_id VARCHAR(5) NOT NULL,
departure_date DATE NOT NULL,
seat_number VARCHAR(10) NOT NULL,
ticket_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

CREATE TABLE PaymentTransactions (
transaction_id VARCHAR(5) PRIMARY KEY NOT NULL,
ticket_id VARCHAR(5) NOT NULL,
payment_method VARCHAR(50) NOT NULL,
transaction_date DATE NOT NULL,
amount DECIMAL(10,2) NOT NULL,
FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Passengers (passenger_id, passenger_full_name, passenger_email, passenger_phone, passenger_cccd)
VALUE
('P001','Nguyen Van An','an.nguyen@example.com',0912345678,001234567890),
('P002','Tran Thi Binh','binh.tran@example.com',0923456789,002345678901),
('P003','Le Minh Chau','chau.le@example.com',0934567890,003456789012),
('P004','Pham Quoc Dat','dat.pham@example.com',0945678901,004567890123),
('P005','Vo Thanh Em','em.vo@example.com',0956789012,005678901234)
;

INSERT INTO Trains (train_id, train_name, train_type, total_seats)
VALUE
('T001','Tau Thong Nhat 1','SE',500),
('T002','Tau Thong Nhat 2','TN',450),
('T003','Tau Sai Gon - Hue','SE',400),
('T004','Tau Ha Noi - Lao Cai','TN',350),
('T005','Tau Da Nang Express','SE',300)
;

INSERT INTO Tickets (ticket_id, passenger_id, train_id, departure_date, seat_number, ticket_price)
VALUE
('TK001','P001','T001','2025-06-10','A01',850000),
('TK002','P002','T002','2025-06-11','B05',650000),
('TK003','P003','T003','2025-06-12','C10',720000),
('TK004','P004','T004','2025-06-13','D12',500000),
('TK005','P005','T005','2025-06-14','E08',900000)
;

INSERT INTO PaymentTransactions (transaction_id, ticket_id, payment_method, transaction_date, amount)
VALUE
('TR001','TK001','Credit Card','2025-06-10',850000),
('TR002','TK002','Cash','2025-06-11',650000),
('TR003','TK003','Bank Transfer','2025-06-12',720000),
('TR004','TK004','E-Wallet','2025-06-13',500000),
('TR005','TK005','Credit Card','2025-06-14',900000)
;

SET SQL_SAFE_UPDATES = 0;

-- Cap nhat gia ve giam 15% cho cac ve khoi hanh truoc 2025 05 01
UPDATE Tickets
SET ticket_price = ticket_price * 0.85
WHERE departure_date < '2025-05-01';

-- Xoa giao dich co phuong thuc la E-Wallet va so tien nho hon 2000000
DELETE FROM PaymentTransactions
WHERE payment_method = 'E-Wallet' AND amount < 200000;

SET SQL_SAFE_UPDATES = 1;

-- ============
-- Phan 2
-- ============

-- Sap xep theo ho va ten giam dan
SELECT passenger_id, passenger_full_name, passenger_email, passenger_phone
FROM Passengers
ORDER BY passenger_full_name DESC;

-- Sap xep theo so ghe tang dan
SELECT train_id, train_name, total_seats
FROM Trains
ORDER BY total_seats ASC;

-- Thong tin ve da dat gom: ho ten, ten tau, ngay khoi hanh, so ghe
SELECT p.passenger_full_name, t.departure_date, t.seat_number
FROM Tickets AS t
INNER JOIN Passengers AS p ON t.passenger_id = p.passenger_id;

-- Danh sach hanh khach, tong so tien da thanh toan
SELECT p.passenger_id, p.passenger_full_name, pt.payment_method, SUM(pt.amount) AS total_amount
FROM Passengers AS p
INNER JOIN Tickets AS t ON p.passenger_id = t.passenger_id
INNER JOIN PaymentTransactions AS pt ON t.ticket_id = pt.ticket_id
GROUP BY p.passenger_id, p.passenger_full_name, pt.payment_method
ORDER BY total_amount ASC;

-- Thong tin hanh khach tu vi tri thu 3 den 5 trong bang Passenger, sap xep theo ho ten
SELECT passenger_id, passenger_full_name, passenger_email, passenger_phone
FROM Passengers 
ORDER By passenger_full_name DESC
LIMIT 3 OFFSET 2;

-- Hanh khach dat it nhat 3 ve tau
SELECT p.passenger_id, p.passenger_full_name, COUNT(t.ticket_id) AS ticket_amount
FROM Passengers AS p
INNER JOIN Tickets AS t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id, p.passenger_full_name
HAVING ticket_amount >=3;

-- Cac doan tau co 10 luot khach dat 
SELECT t.train_id, t.train_name, COUNT(ts.ticket_id) AS p_amount
FROM Trains AS t
INNER JOIN Tickets AS ts ON t.train_id = ts.train_id
GROUP BY t.train_id, t.train_name
HAVING p_amount > 10;

-- Danh sach hanh khach co tong tien giao dich >2000000
SELECT p.passenger_id, p.passenger_full_name, t.train_id, SUM(pt.amount) AS total_amount
FROM Passengers AS p
INNER JOIN Tickets AS t ON p.passenger_id = t.passenger_id
INNER JOIN PaymentTransactions AS pt ON t.ticket_id = pt.ticket_id
GROUP BY p.passenger_id, p.passenger_full_name, t.train_id
HAVING total_amount > 2000000;

-- Danh sach hanh khach co ten co chu "Hoang" hoac dia chi email "@gmail.com", sap xep tang dan
SELECT passenger_id, passenger_full_name, passenger_email, passenger_phone
FROM Passengers
WHERE passenger_full_name LIKE '%Hoàng%' OR passenger_email LIKE '%@gmail.com%'
ORDER BY passenger_full_name ASC;

-- Danh sach doan tau sap xep theo so ghe giam dan
SELECT t.train_id, t.train_name, ts.seat_number
FROM Trains AS t
INNER JOIN Tickets AS ts ON t.train_id = ts.train_id
ORDER BY ts.seat_number DESC
LIMIT 5 OFFSET 5;

-- ============
-- Phan 3
-- ============

-- View vw_UpcomingTrips
CREATE VIEW vw_UpcomingTrips AS
SELECT p.passenger_id, ts.train_id, t.seat_number, t.ticket_price, t.departure_date
FROM Tickets AS t
INNER JOIN Passengers AS p ON t.passenger_id = p.passenger_id
INNER JOIN Trains AS ts ON t.train_id = ts.train_id
WHERE t.departure_date > '2025-06-01';

-- vw_HighValueTickets
CREATE VIEW vw_HighValueTickets AS
SELECT p.passenger_full_name, ts.train_name, t.seat_number, t.ticket_price
FROM Tickets AS t
INNER JOIN Passengers AS p ON t.passenger_id = p.passenger_id
INNER JOIN Trains AS ts ON t.train_id = ts.train_id
WHERE v.ticket_price > 500000;