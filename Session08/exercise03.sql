-- 1. Tao bang employees va du lieu mau
DROP PROCEDURE IF EXISTS sp_get_avg_salary;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL
);

INSERT INTO employees (full_name, salary) VALUES
('Nguyen Van A', 15000000.00),
('Tran Thi B', 12000000.00),
('Le Van C', 9000000.00);

-- 2. Tao Stored Procedure khai bao bien de tinh luong trung binh va hien thi
DELIMITER //
CREATE PROCEDURE sp_get_avg_salary()
BEGIN
    -- Khai bao bien cuc bo de luu tru luong trung binh
    DECLARE avg_sal DECIMAL(15, 2);
    
    -- Gan gia tri cho bien tu ket qua truy van AVG
    SELECT AVG(salary) INTO avg_sal FROM employees;
    
    -- Hien thi gia tri cua bien ra man hinh
    SELECT avg_sal AS average_salary;
END //
DELIMITER ;

-- 3. Goi procedure de kiem tra
CALL sp_get_avg_salary();
