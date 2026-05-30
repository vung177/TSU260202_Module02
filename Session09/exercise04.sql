-- 1. Tao bang customers va du lieu mau ban dau
DROP PROCEDURE IF EXISTS insert_customer;
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

-- 2. Tao Stored Procedure insert_customer de them khach hang va hien thi thong bao
DELIMITER //
CREATE PROCEDURE insert_customer(
    IN in_customer_name VARCHAR(50),
    IN in_email VARCHAR(100),
    IN in_phone VARCHAR(15),
    IN in_address VARCHAR(255)
)
BEGIN
    INSERT INTO customers (customer_name, email, phone, address)
    VALUES (in_customer_name, in_email, in_phone, in_address);
    
    SELECT 'Thêm mới khách hàng thành công !' AS message;
END //
DELIMITER ;

-- 3. Goi Stored Procedure voi tham so dung nhu anh chup man hinh
CALL insert_customer('Nguyễn Công Hưởng', 'huongcaoha@gmail.com', '0988888888', 'Hà Nội');
