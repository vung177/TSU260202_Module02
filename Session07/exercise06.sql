-- 1. Tao bang orders
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL
);

-- 2. Tao INDEX ket hop phuc vu tim kiem theo trang thai va ngay dat hang
-- Thu tu: order_status truoc, order_date sau
CREATE INDEX idx_search_status_date ON orders(order_status, order_date);
