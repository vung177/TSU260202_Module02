-- 1. Tao cac bang
DROP TRIGGER IF EXISTS trg_after_update_salary;
DROP TABLE IF EXISTS salary_logs;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15)
);

CREATE TABLE salary_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    old_salary DECIMAL(10, 2) NOT NULL,
    new_salary DECIMAL(10, 2) NOT NULL,
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- Them 10 ban ghi vao bang employees
INSERT INTO employees (first_name, last_name, salary, email, phone_number) VALUES
('John', 'Doe', 5000.00, 'john@example.com', '1234567890'),
('Jane', 'Smith', 6000.00, 'jane@example.com', '1234567891'),
('Bob', 'Johnson', 4500.00, 'bob@example.com', '1234567892'),
('Alice', 'Williams', 7000.00, 'alice@example.com', '1234567893'),
('Michael', 'Brown', 5500.00, 'michael@example.com', '1234567894'),
('Emily', 'Jones', 6200.00, 'emily@example.com', '1234567895'),
('David', 'Miller', 4800.00, 'david@example.com', '1234567896'),
('Sarah', 'Davis', 7200.00, 'sarah@example.com', '1234567897'),
('James', 'Garcia', 5300.00, 'james@example.com', '1234567898'),
('Linda', 'Rodriguez', 6400.00, 'linda@example.com', '1234567899');

-- 2. Tao Trigger trg_after_update_salary
DELIMITER //
CREATE TRIGGER trg_after_update_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Chi ghi log khi co su thay doi ve luong (salary)
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_logs (employee_id, old_salary, new_salary)
        VALUES (NEW.id, OLD.salary, NEW.salary);
    END IF;
END //
DELIMITER ;

-- 3. Kiem tra trigger bang cach cap nhat luong cua nhan vien
SET SQL_SAFE_UPDATES = 0;
UPDATE employees SET salary = 5500.00 WHERE id = 1;
UPDATE employees SET salary = 6500.00 WHERE id = 2;
SET SQL_SAFE_UPDATES = 1;

-- 4. Truy van bang ghi lich su luong de xem ket qua
SELECT * FROM salary_logs;
