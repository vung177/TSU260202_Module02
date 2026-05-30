-- 1. Tao bang students va du lieu mau
DROP PROCEDURE IF EXISTS sp_get_all_students;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    class_name VARCHAR(50) NOT NULL
);

INSERT INTO students (full_name, class_name) VALUES
('Nguyen Van A', 'IT01'),
('Tran Thi B', 'HR02'),
('Le Tuan C', 'IT01');

-- 2. Tao Stored Procedure khong co tham so de lay toan bo danh sach sinh vien
DELIMITER //
CREATE PROCEDURE sp_get_all_students()
BEGIN
    SELECT * FROM students;
END //
DELIMITER ;

-- 3. Goi procedure bang CALL
CALL sp_get_all_students();
