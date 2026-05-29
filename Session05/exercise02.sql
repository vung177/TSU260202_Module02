-- 1. Tao bang employees
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    salary DECIMAL(15, 2)
);

-- 2. Them du lieu mau
INSERT INTO employees (full_name, department, salary) VALUES
('Nguyen Van A', 'IT', 15000000.00),
('Tran Thi B', 'IT', 18000000.00),
('Le Van C', 'IT', 22000000.00),
('Pham Minh D', 'IT', 10000000.00),
('Hoang Lan E', 'HR', 12000000.00),
('Vu Hoang F', 'HR', 13000000.00),
('Do Thi G', 'Sales', 9000000.00),
('Ngo Van H', 'Sales', 9500000.00),
('Bui Thi I', 'Sales', 10000000.00),
('Ly Van J', 'Sales', 11000000.00),
('Nguyen Hoang K', 'Marketing', 8000000.00);

-- 3. Truy van theo yeu cau
-- a. Thong ke moi phong ban co bao nhieu nhan vien
SELECT department, COUNT(*) AS total_employees 
FROM employees 
GROUP BY department;

-- b. Tinh muc luong trung binh cua tung phong ban
SELECT department, AVG(salary) AS average_salary 
FROM employees 
GROUP BY department;

-- c. Chi hien thi cac phong ban co tren 3 nhan vien
SELECT department, COUNT(*) AS total_employees 
FROM employees 
GROUP BY department 
HAVING COUNT(*) > 3;

-- d. Chi hien thi cac phong ban co luong trung binh lon hon 12.000.000
SELECT department, AVG(salary) AS average_salary 
FROM employees 
GROUP BY department 
HAVING AVG(salary) > 12000000;
