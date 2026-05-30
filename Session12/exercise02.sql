-- 1. Tai thiet lap co so du lieu (Dam bao chay doc lap, khong bi anh huong boi Trigger cua bai 1)
DROP TRIGGER IF EXISTS before_insert_order_item;
DROP TRIGGER IF EXISTS after_insert_order_item;
DROP TRIGGER IF EXISTS before_update_order_item;
DROP TRIGGER IF EXISTS after_update_order_item;
DROP TRIGGER IF EXISTS before_delete_order;
DROP TRIGGER IF EXISTS after_delete_order_item;

DROP PROCEDURE IF EXISTS sp_create_order;
DROP PROCEDURE IF EXISTS sp_pay_order;
DROP PROCEDURE IF EXISTS sp_cancel_order;

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
    status VARCHAR(50) DEFAULT 'Pending',
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

-- Them du lieu mau
INSERT INTO customers (name, email, phone, address) VALUES
('Nguyễn Văn A', 'a@example.com', '0123456789', 'Hà Nội'),
('Trần Thị B', 'b@example.com', '0987654321', 'TP.HCM');

INSERT INTO products (name, price, description) VALUES
('iPhone 15', 20000000.00, 'Apple iPhone 15'),
('iPad Air', 15000000.00, 'Apple iPad Air');

INSERT INTO inventory (product_id, stock_quantity) VALUES
(1, 10),
(2, 5);


-- 2. Viet cac Stored Procedure theo yeu cau

-- Stored Procedure sp_create_order
DELIMITER //
CREATE PROCEDURE sp_create_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_order_id INT;

    -- Co che tu dong rollback khi xay ra loi SQL bat ngo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi hệ thống: Giao dịch tạo đơn hàng bị hủy.';
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Kiem tra so luong ton kho
    SELECT stock_quantity INTO v_stock FROM inventory WHERE product_id = p_product_id;

    IF v_stock IS NULL OR v_stock < p_quantity THEN
        -- Khong du hang, rollback va bao loi
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không đủ hàng tồn kho';
    ELSE
        -- 1. Them mot don hang moi vao orders
        INSERT INTO orders (customer_id, total_amount, status)
        VALUES (p_customer_id, p_quantity * p_price, 'Pending');

        -- 2. Lay order_id vua tao
        SET v_order_id = LAST_INSERT_ID();

        -- 3. Them san pham vao order_items
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (v_order_id, p_product_id, p_quantity, p_price);

        -- 4. Cap nhat (giam) so luong ton kho trong inventory
        UPDATE inventory 
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;

        -- Commit thanh cong
        COMMIT;
    END IF;
END //
DELIMITER ;


-- Stored Procedure sp_pay_order
DELIMITER //
CREATE PROCEDURE sp_pay_order(
    IN p_order_id INT,
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_status VARCHAR(50);
    DECLARE v_amount DECIMAL(10, 2);

    -- Co che tu dong rollback khi xay ra loi SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi hệ thống: Giao dịch thanh toán bị hủy.';
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Kiem tra trang thai va tong tien cua don hang
    SELECT status, total_amount INTO v_status, v_amount FROM orders WHERE order_id = p_order_id;

    IF v_status IS NULL OR v_status <> 'Pending' THEN
        -- Khong phai 'Pending', rollback va bao loi
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đơn hàng không ở trạng thái Pending để thanh toán';
    ELSE
        -- 1. Them ban ghi thanh toan vao payments
        INSERT INTO payments (order_id, amount, payment_method, status)
        VALUES (p_order_id, v_amount, p_payment_method, 'Completed');

        -- 2. Cap nhat trang thai don hang thanh 'Completed'
        UPDATE orders 
        SET status = 'Completed'
        WHERE order_id = p_order_id;

        -- Commit thanh cong
        COMMIT;
    END IF;
END //
DELIMITER ;


-- Stored Procedure sp_cancel_order
DELIMITER //
CREATE PROCEDURE sp_cancel_order(
    IN p_order_id INT
)
BEGIN
    DECLARE v_status VARCHAR(50);

    -- Co che tu dong rollback khi xay ra loi SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi hệ thống: Giao dịch hủy đơn hàng bị thất bại.';
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Kiem tra trang thai don hang
    SELECT status INTO v_status FROM orders WHERE order_id = p_order_id;

    IF v_status IS NULL OR v_status <> 'Pending' THEN
        -- Khong phai 'Pending', rollback va bao loi
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đơn hàng không ở trạng thái Pending để hủy';
    ELSE
        -- 1. Hoan tra so luong hang vao kho (inventory)
        UPDATE inventory i
        INNER JOIN order_items oi ON i.product_id = oi.product_id
        SET i.stock_quantity = i.stock_quantity + oi.quantity
        WHERE oi.order_id = p_order_id;

        -- 2. Xoa cac san pham lien quan khoi order_items
        DELETE FROM order_items WHERE order_id = p_order_id;

        -- 3. Cap nhat trang thai don hang thanh 'Cancelled'
        UPDATE orders 
        SET status = 'Cancelled'
        WHERE order_id = p_order_id;

        -- Commit thanh cong
        COMMIT;
    END IF;
END //
DELIMITER ;


-- 3. Kiem thu (Testing)

-- --- Test Case 1: Tao don hang moi thanh cong (sp_create_order) ---
-- Mua 2 iPhone 15 (Stock 10 -> con 8)
CALL sp_create_order(1, 1, 2, 20000000.00);
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM inventory WHERE product_id = 1;

-- --- Test Case 2: Thanh toan don hang vua tao thanh cong (sp_pay_order) ---
-- Thanh toan cho don hang ID = 1 bang phuong thuc 'Cash'
CALL sp_pay_order(1, 'Cash');
SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM payments;

-- --- Test Case 3: Thu thanh toan lai hoac huy don hang da Completed (sp_cancel_order / sp_pay_order) ---
-- Thu huy don hang ID = 1 (Da Completed -> Se bao loi SQLSTATE 45000)
-- CALL sp_cancel_order(1);

-- --- Test Case 4: Tao don hang moi, sau do huy thanh cong ---
-- Mua 1 iPad Air (Stock 5 -> con 4)
CALL sp_create_order(2, 2, 1, 15000000.00);
SELECT * FROM orders WHERE order_id = 2;
SELECT * FROM inventory WHERE product_id = 2;

-- Huy don hang ID = 2 (Se xoa order_items, cap nhat trang thai orders ve 'Cancelled', hoan tra stock ve 5)
CALL sp_cancel_order(2);
SELECT * FROM orders WHERE order_id = 2;
SELECT * FROM order_items WHERE order_id = 2;
SELECT * FROM inventory WHERE product_id = 2;


-- 4. Xoa tat ca cac doi tuong (Neu can thiet)
-- DROP PROCEDURE IF EXISTS sp_create_order;
-- DROP PROCEDURE IF EXISTS sp_pay_order;
-- DROP PROCEDURE IF EXISTS sp_cancel_order;
