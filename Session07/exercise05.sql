-- 1. Tao bang employees va du lieu mau
DROP VIEW IF EXISTS v_employee_public;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    national_id VARCHAR(20) NOT NULL -- So CMND
);

INSERT INTO employees (full_name, department, salary, national_id) VALUES
('Nguyen Van A', 'IT', 15000000.00, '123456789'),
('Tran Thi B', 'HR', 12000000.00, '987654321');

-- 2. Tao VIEW v_employee_public chi hien thi: ma nhan vien, ho ten, phong ban
CREATE VIEW v_employee_public AS
SELECT emp_id, full_name, department
FROM employees;

-- 3. Truy van kiem tra VIEW
SELECT * FROM v_employee_public;
