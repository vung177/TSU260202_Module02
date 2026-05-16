USE module2_sql;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

CREATE TABLE orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
order_date DATE NOT NULL,
order_status VARCHAR(20) NOT NULL CHECK (order_status IN ('NEW','PAID'))
);

CREATE TABLE products (
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(255) NOT NULL,
product_price INT NOT NULL
);

CREATE TABLE order_items(
order_id INT,
product_id INT,
quantity INT NOT NULL,

PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
)
