-- 1. Tai thiet lap bang customers va du lieu mau de dam bao file chay doc lap duoc
DROP VIEW IF EXISTS view_customer_contact;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);

INSERT INTO customers (customer_name, email, phone, address) VALUES
('Alice', 'alice@example.com', '1234567890', 'Ha Noi'),
('Bob', 'bob@example.com', '1234567891', 'HCM'),
('Carol', 'carol@example.com', '1234567892', 'Da Nang'),
('David', 'david@example.com', '1234567893', 'Ha Noi'),
('Eva', 'eva@example.com', '1234567894', 'HCM'),
('Frank', 'frank@example.com', '1234567895', 'Da Nang'),
('Grace', 'grace@example.com', '1234567896', 'Ha Noi'),
('Hannah', 'hannah@example.com', '1234567897', 'HCM');

-- 2. Tao VIEW view_customer_contact chi chua cac thong tin lien he cong khai
CREATE VIEW view_customer_contact AS
SELECT customer_id, customer_name, email, phone
FROM customers;

-- 3. Truy van kiem tra ket qua tu VIEW
SELECT * FROM view_customer_contact;
