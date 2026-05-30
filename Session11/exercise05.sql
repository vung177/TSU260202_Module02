-- 1. Thiet ke co so du lieu
DROP PROCEDURE IF EXISTS place_order;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 2. Tao du lieu mau
INSERT INTO products (id, product_name, price, stock) VALUES
(1, 'Laptop Gaming', 20000000.00, 10);

-- 3. Viet Stored Procedure place_order
DELIMITER //
CREATE PROCEDURE place_order(
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(10, 2);
    
    -- Co che bao ve khi gap loi SQL bat ngo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Đã xảy ra lỗi hệ thống!' AS message;
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Lay thong tin ton kho va gia san pham
    SELECT stock, price INTO v_stock, v_price 
    FROM products 
    WHERE id = p_product_id;

    -- Kiem tra dieu kien ton kho
    IF v_stock IS NULL THEN
        ROLLBACK;
        SELECT 'Sản phẩm không tồn tại!' AS message;
    ELSEIF v_stock < p_quantity THEN
        -- Neu ton kho < so luong mua: rollback va bao loi
        ROLLBACK;
        SELECT 'Đặt hàng thất bại: Kho không đủ hàng!' AS message;
    ELSE
        -- Tru so luong ton kho
        UPDATE products 
        SET stock = stock - p_quantity 
        WHERE id = p_product_id;

        -- Tao ban ghi moi trong orders
        INSERT INTO orders (product_id, quantity, total_price)
        VALUES (p_product_id, p_quantity, v_price * p_quantity);

        -- Commit neu thanh cong
        COMMIT;
        SELECT 'Đặt hàng thành công!' AS message;
    END IF;
END //
DELIMITER ;

-- 4. Kiem thu (Testing)
-- Kiem tra truoc khi mua
SELECT * FROM products;

-- TEST 1: Mua hop le (Mua 2 cai)
CALL place_order(1, 2);

-- Kiem tra sau khi mua thanh cong
SELECT * FROM products;
SELECT * FROM orders;

-- TEST 2: Mua qua so luong (Mua 20 cai -> Thuy luc do chi con 8 cai)
CALL place_order(1, 20);

-- Kiem tra ket qua cuoi cung
SELECT * FROM products;
SELECT * FROM orders;
