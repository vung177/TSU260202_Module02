-- 1. Cai dat moi truong (Tao cac bang va du lieu mau)
DROP TRIGGER IF EXISTS before_insert_order_item;
DROP TRIGGER IF EXISTS after_insert_order_item;
DROP TRIGGER IF EXISTS before_update_order_item;
DROP TRIGGER IF EXISTS after_update_order_item;
DROP TRIGGER IF EXISTS before_delete_order;
DROP TRIGGER IF EXISTS after_delete_order_item;

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

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 0.00, 'Pending'),
(2, 0.00, 'Completed');


-- 2. Dinh nghia cac Trigger theo yeu cau ky thuat

-- Trigger BEFORE INSERT tren order_items: Kiem tra so luong ton kho
DELIMITER //
CREATE TRIGGER before_insert_order_item
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    
    SELECT stock_quantity INTO v_stock FROM inventory WHERE product_id = NEW.product_id;
    
    IF v_stock IS NULL OR NEW.quantity > v_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ hàng tồn kho';
    END IF;
END //
DELIMITER ;

-- Trigger AFTER INSERT tren order_items: Cap nhat total_amount trong orders va tru ton kho
DELIMITER //
CREATE TRIGGER after_insert_order_item
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    -- Cap nhat tong tien don hang
    UPDATE orders 
    SET total_amount = total_amount + (NEW.quantity * NEW.price)
    WHERE order_id = NEW.order_id;
    
    -- Tru bot so luong trong kho
    UPDATE inventory
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //
DELIMITER ;

-- Trigger BEFORE UPDATE tren order_items: Kiem tra so luong ton kho truoc khi cap nhat
DELIMITER //
CREATE TRIGGER before_update_order_item
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    
    SELECT stock_quantity INTO v_stock FROM inventory WHERE product_id = NEW.product_id;
    
    -- Chi kiem tra neu tang so luong (chenh lech giua NEW va OLD > stock hien tai)
    IF (NEW.quantity - OLD.quantity) > v_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ hàng tồn kho';
    END IF;
END //
DELIMITER ;

-- Trigger AFTER UPDATE tren order_items: Cap nhat lai total_amount va stock_quantity
DELIMITER //
CREATE TRIGGER after_update_order_item
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    -- Cap nhat lai total_amount don hang
    UPDATE orders 
    SET total_amount = total_amount - (OLD.quantity * OLD.price) + (NEW.quantity * NEW.price)
    WHERE order_id = NEW.order_id;
    
    -- Cap nhat lai stock_quantity
    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //
DELIMITER ;

-- Trigger BEFORE DELETE tren orders: Ngan chan xoa don hang da Completed
DELIMITER //
CREATE TRIGGER before_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa đơn hàng đã hoàn thành';
    END IF;
END //
DELIMITER ;

-- Trigger AFTER DELETE tren order_items: Hoan tra so luong vao kho va giam total_amount
DELIMITER //
CREATE TRIGGER after_delete_order_item
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    -- Hoan tra lai so luong vao kho
    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;
    
    -- Tru bot total_amount
    UPDATE orders
    SET total_amount = total_amount - (OLD.quantity * OLD.price)
    WHERE order_id = OLD.order_id;
END //
DELIMITER ;


-- 3. Kiem thu (Testing)

-- --- Kiem thu Trigger BEFORE/AFTER INSERT ---
-- Them hop le: Mua 2 iPhone 15 (Stock 10 -> con 8; total_amount = 40.000.000)
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (1, 1, 2, 20000000.00);
SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM inventory WHERE product_id = 1;

-- Them khong hop le: Mua 10 iPad Air (Stock 5 -> Bao loi SQLSTATE 45000)
-- INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (1, 2, 10, 15000000.00);

-- --- Kiem thu Trigger BEFORE/AFTER UPDATE ---
-- Cap nhat hop le: Thay doi so luong iPhone tu 2 thanh 5 (Stock 8 -> con 5; total_amount = 100.000.000)
UPDATE order_items SET quantity = 5 WHERE order_id = 1 AND product_id = 1;
SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM inventory WHERE product_id = 1;

-- Cap nhat khong hop le: Cap nhat iPhone 15 len so luong 20 (Stock 5 -> Bao loi SQLSTATE 45000)
-- UPDATE order_items SET quantity = 20 WHERE order_id = 1 AND product_id = 1;

-- --- Kiem thu Trigger BEFORE DELETE ---
-- Khong hop le: Xoa don hang Completed (Bao loi SQLSTATE 45000)
-- DELETE FROM orders WHERE order_id = 2;

-- --- Kiem thu Trigger AFTER DELETE ---
-- Xoa iPhone 15 khoi order_items (Hoan tra 5 iPhone vao kho -> Stock ve 10; total_amount ve 0)
DELETE FROM order_items WHERE order_id = 1 AND product_id = 1;
SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM inventory WHERE product_id = 1;


-- 4. Xoa Trigger (Neu muon xoa tat ca cac Trigger da tao)
-- DROP TRIGGER IF EXISTS before_insert_order_item;
-- DROP TRIGGER IF EXISTS after_insert_order_item;
-- DROP TRIGGER IF EXISTS before_update_order_item;
-- DROP TRIGGER IF EXISTS after_update_order_item;
-- DROP TRIGGER IF EXISTS before_delete_order;
-- DROP TRIGGER IF EXISTS after_delete_order_item;
