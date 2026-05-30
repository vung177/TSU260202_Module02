-- 1. Tao cac bang
DROP TRIGGER IF EXISTS after_order_status_update;
DROP TABLE IF EXISTS order_logs;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL
);

CREATE TABLE order_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 2. Tao Trigger after_order_status_update
DELIMITER //
CREATE TRIGGER after_order_status_update
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- Ghi log chi khi co su thay doi ve trang thai (status)
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_logs (order_id, old_status, new_status)
        VALUES (NEW.id, OLD.status, NEW.status);
    END IF;
END //
DELIMITER ;

-- 3. Them mot don hang moi voi trang thai 'Pending'
INSERT INTO orders (customer_name, total_amount, status) 
VALUES ('Nguyen Van A', 10250000.00, 'Pending');

-- 4. Kiem thu cac truong hop cap nhat
SET SQL_SAFE_UPDATES = 0;

-- Case 1: Doi trang thai (Se duoc ghi log)
UPDATE orders SET status = 'Shipping' WHERE id = 1;

-- Case 2: Chi sua ten khach hang, giu nguyen trang thai (Khong ghi log)
UPDATE orders SET customer_name = 'Nguyen Van B' WHERE id = 1;

SET SQL_SAFE_UPDATES = 1;

-- 5. Hien thi lich su thay doi trang thai don hang
SELECT * FROM order_logs;
