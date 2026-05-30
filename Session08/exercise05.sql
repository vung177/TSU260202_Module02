-- 1. Tao bang employees
DROP PROCEDURE IF EXISTS sp_check_employee_income;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    department VARCHAR(100) NOT NULL
);

-- 2. Tao Stored Procedure su dung IF - ELSE IF - ELSE de phan loai thu nhap
DELIMITER //
CREATE PROCEDURE sp_check_employee_income(
    IN p_emp_name VARCHAR(100),
    IN p_salary DECIMAL(15, 2)
)
BEGIN
    -- Khai bao bien trung gian de luu muc thu nhap
    DECLARE v_income_level VARCHAR(50);
    
    IF p_salary >= 15000000.00 THEN
        SET v_income_level = 'Thu nhập cao';
    ELSEIF p_salary >= 8000000.00 AND p_salary < 15000000.00 THEN
        SET v_income_level = 'Thu nhập trung bình';
    ELSE
        SET v_income_level = 'Thu nhập thấp';
    END IF;
    
    -- Hien thi ket qua gom ten nhan vien va muc thu nhap
    SELECT p_emp_name AS employee_name, v_income_level AS income_level;
END //
DELIMITER ;

-- 3. Goi procedure voi cac muc luong khac nhau de kiem tra
CALL sp_check_employee_income('Nguyen Van A', 16000000.00);
CALL sp_check_employee_income('Tran Thi B', 12000000.00);
CALL sp_check_employee_income('Le Van C', 6000000.00);
