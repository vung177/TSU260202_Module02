-- 1. Tai thiet lap co so du lieu tu bai truoc
DROP PROCEDURE IF EXISTS place_order;
DROP PROCEDURE IF EXISTS cancel_order;
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

-- Them du lieu mau ban dau
INSERT INTO products (id, product_name, price, stock) VALUES
(1, 'Laptop Gaming', 20000000.00, 10);

-- Viet lai place_order tu bai 5
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

-- Chay lai cac test case cua bai 5 de tao du lieu lich su
CALL place_order(1, 2); -- Tao Order ID = 1, stock con 8
CALL place_order(1, 1); -- Tao Order ID = 2, stock con 7 (lam gia su de bat dau test cho bai 6)

-- 2. Cap nhat cau truc bang orders (tu bai truoc)
ALTER TABLE orders ADD COLUMN status VARCHAR(50) DEFAULT 'Completed';
UPDATE orders SET status = 'Completed' WHERE status IS NULL;

-- 3. Viet Stored Procedure cancel_order
DELIMITER //
CREATE PROCEDURE cancel_order(
    IN p_order_id INT
)
BEGIN
    DECLARE v_status VARCHAR(50);
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;

    -- Co che bao ve rollback khi gap loi SQL bat ngo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Đã xảy ra lỗi hệ thống!' AS message;
    END;

    -- Lay thong tin don hang can huy
    SELECT status, product_id, quantity INTO v_status, v_product_id, v_quantity
    FROM orders
    WHERE id = p_order_id;

    -- Kiem tra dieu kien don hang co ton tai va trang thai da bi huy chua
    IF v_status IS NULL THEN
        SELECT 'Lỗi: Đơn hàng không tồn tại!' AS message;
    ELSEIF v_status = 'Cancelled' THEN
        SELECT 'Lỗi: Đơn hàng đã bị hủy trước đó!' AS message;
    ELSE
        -- Bat dau transaction
        START TRANSACTION;

        -- Cap nhat trang thai don hang thanh 'Cancelled'
        UPDATE orders 
        SET status = 'Cancelled'
        WHERE id = p_order_id;

        -- Cong lai so luong vao kho products
        UPDATE products
        SET stock = stock + v_quantity
        WHERE id = v_product_id;

        -- Commit giao dich
        COMMIT;
        SELECT 'Hủy đơn hàng thành công! Đã hoàn tồn kho.' AS message;
    END IF;
END //
DELIMITER ;

-- 4. Kiem thu (Testing)
-- TEST 1: Tao mot don hang moi (Mua 3 Laptop) -> Tao Order ID = 3, stock giam tu 7 con 4
CALL place_order(1, 3);

-- Kiem tra kho sau khi mua (Da bi tru con 4)
SELECT * FROM products WHERE id = 1;

-- TEST 2: Goi thu tuc de huy don hang ID = 3
CALL cancel_order(3);

-- Kiem tra lai sau khi huy (Trang thai doi sang 'Cancelled' va kho tang lai thanh 7)
SELECT * FROM orders WHERE id = 3;
SELECT * FROM products WHERE id = 1;
