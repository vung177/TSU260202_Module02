-- 1. Cai dat moi truong (Tao cac bang va du lieu mau)
DROP TRIGGER IF EXISTS before_insert_check_payment;
DROP TRIGGER IF EXISTS after_update_order_status;
DROP PROCEDURE IF EXISTS sp_update_order_status_with_payment;

DROP TABLE IF EXISTS order_logs;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Tao bang customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tao bang products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tao bang orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- Tao bang order_items
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Tao bang payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Tao bang inventory
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Tao bang order_logs de luu lich su thay doi trang thai don hang
CREATE TABLE order_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status ENUM('Pending', 'Completed', 'Cancelled'),
    new_status ENUM('Pending', 'Completed', 'Cancelled'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Them du lieu mau
INSERT INTO customers (name, email, phone, address) VALUES
('Nguyễn Văn A', 'a@example.com', '0123456789', 'Hà Nội');

INSERT INTO products (name, price, description) VALUES
('iPhone 15', 20000000.00, 'Apple iPhone 15');

INSERT INTO inventory (product_id, stock_quantity) VALUES
(1, 10);

-- Tao hai don hang ban dau
INSERT INTO orders (order_id, customer_id, total_amount, status) VALUES
(1, 1, 20000000.00, 'Pending'),
(2, 1, 40000000.00, 'Pending');


-- 2. Dinh nghia cac Trigger va Stored Procedure

-- Trigger BEFORE INSERT tren payments: Kiem tra so tien thanh toan
DELIMITER //
CREATE TRIGGER before_insert_check_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    -- Lay tong tien cua don hang
    SELECT total_amount INTO v_total FROM orders WHERE order_id = NEW.order_id;
    
    -- Neu so tien thanh toan khong khop voi tong tien don hang thi bao loi
    IF NEW.amount <> v_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số tiền thanh toán không khớp với tổng tiền đơn hàng';
    END IF;
END //
DELIMITER ;

-- Trigger AFTER UPDATE tren orders: Ghi log khi trang thai thay doi
DELIMITER //
CREATE TRIGGER after_update_order_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_logs (order_id, old_status, new_status)
        VALUES (NEW.order_id, OLD.status, NEW.status);
    END IF;
END //
DELIMITER ;

-- Stored Procedure sp_update_order_status_with_payment
DELIMITER //
CREATE PROCEDURE sp_update_order_status_with_payment(
    IN p_order_id INT,
    IN p_new_status VARCHAR(50),
    IN p_payment_amount DECIMAL(10, 2),
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_status VARCHAR(50);

    -- Co che tu dong rollback khi xay ra bat ky loi SQL nao
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Lay trang thai hien tai cua don hang
    SELECT status INTO v_status FROM orders WHERE order_id = p_order_id;

    IF v_status IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đơn hàng không tồn tại';
    END IF;

    -- Kiem tra neu trang thai moi trung voi trang thai cu thi rollback va bao loi
    IF v_status = p_new_status THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trạng thái đơn hàng đã giống với trạng thái mới';
    END IF;

    -- Neu trang thai moi la 'Completed' thi thuc hien thanh toan
    IF p_new_status = 'Completed' THEN
        -- Trigger before_insert_check_payment se tu dong kiem tra so tien co khop khong
        INSERT INTO payments (order_id, amount, payment_method, status)
        VALUES (p_order_id, p_payment_amount, p_payment_method, 'Completed');
    END IF;

    -- Cap nhat trang thai don hang (Trigger after_update_order_status se tu dong ghi log)
    UPDATE orders 
    SET status = p_new_status 
    WHERE order_id = p_order_id;

    -- Commit giao dich
    COMMIT;
END //
DELIMITER ;


-- 3. Kiem thu (Testing)

-- --- Test Case 1: Cap nhat don hang sang 'Completed' voi dung so tien (Thanh cong) ---
-- Cap nhat don hang ID = 1 thanh 'Completed', thanh toan 20.000.000 (Thanh cong)
CALL sp_update_order_status_with_payment(1, 'Completed', 20000000.00, 'Credit Card');

-- Kiem tra lai cac bang de xem thong tin da duoc cap nhat dung chua
SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM payments WHERE order_id = 1;
SELECT * FROM order_logs;

-- --- Test Case 2: Cap nhat sang 'Completed' voi sai so tien (That bai) ---
-- Cap nhat don hang ID = 2 thanh 'Completed', thanh toan 10.000 (Sai so tien -> Phai rollback va bao loi)
-- CALL sp_update_order_status_with_payment(2, 'Completed', 10000.00, 'Cash');

-- --- Test Case 3: Cap nhat voi trang thai trung lap (That bai) ---
-- Thu chuyen don hang ID = 2 sang 'Pending' (Vi trang thai hien tai dang la 'Pending' -> Phai rollback va bao loi)
-- CALL sp_update_order_status_with_payment(2, 'Pending', 0.00, 'None');


-- 4. Xoa tat ca cac doi tuong (Neu can)
-- DROP TRIGGER IF EXISTS before_insert_check_payment;
-- DROP TRIGGER IF EXISTS after_update_order_status;
-- DROP PROCEDURE IF EXISTS sp_update_order_status_with_payment;
