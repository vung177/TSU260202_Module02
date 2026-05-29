-- 1. Tao bang employees
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL
);

-- 2. Tao INDEX cho cot department (phong ban) giup toi uu hoa tim kiem
CREATE INDEX idx_department ON employees(department);
