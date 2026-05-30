-- 1. Tao bang orders
DROP PROCEDURE IF EXISTS sp_check_order_value;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    total_amount DECIMAL(15, 2) NOT NULL
);

-- 2. Tao Stored Procedure su dung cau lenh IF de kiem tra gia tri don hang (khong truy cap bang khac)
DELIMITER //
CREATE PROCEDURE sp_check_order_value(
    IN p_total_amount DECIMAL(15, 2)
)
BEGIN
    IF p_total_amount >= 5000000.00 THEN
        SELECT 'Đơn hàng giá trị cao' AS order_type;
    ELSE
        SELECT 'Đơn hàng bình thường' AS order_type;
    END IF;
END //
DELIMITER ;

-- 3. Goi procedure de kiem tra voi cac gia tri khac nhau
CALL sp_check_order_value(6500000.00);
CALL sp_check_order_value(3200000.00);
