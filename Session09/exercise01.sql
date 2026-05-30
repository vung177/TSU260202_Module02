-- 1. Tao bang customers va du lieu mau nhu yeu cau
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Them du lieu mau cho 8 khach hang
INSERT INTO customers (customer_name, email, phone, address) VALUES
('Alice', 'alice@example.com', '1234567890', 'Ha Noi'),
('Bob', 'bob@example.com', '1234567891', 'HCM'),
('Carol', 'carol@example.com', '1234567892', 'Da Nang'),
('David', 'david@example.com', '1234567893', 'Ha Noi'),
('Eva', 'eva@example.com', '1234567894', 'HCM'),
('Frank', 'frank@example.com', '1234567895', 'Da Nang'),
('Grace', 'grace@example.com', '1234567896', 'Ha Noi'),
('Hannah', 'hannah@example.com', '1234567897', 'HCM');

-- 2. Kiem tra hieu nang va khoa index TRUOC KHI tao index
EXPLAIN SELECT * FROM customers WHERE email = 'alice@example.com';
EXPLAIN SELECT * FROM customers WHERE phone = '1234567890';

-- 3. Tao Index
-- Unique Index cho cot email (vi email khong duoc trung)
CREATE UNIQUE INDEX idx_email ON customers(email);

-- Index thuong (Non-Unique) cho cot phone
CREATE INDEX idx_phone ON customers(phone);

-- 4. Kiem tra hieu nang va khoa index SAU KHI tao index
EXPLAIN SELECT * FROM customers WHERE email = 'alice@example.com';
EXPLAIN SELECT * FROM customers WHERE phone = '1234567890';
