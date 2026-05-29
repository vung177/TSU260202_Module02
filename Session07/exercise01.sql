-- 1. Tao bang students va du lieu mau
DROP VIEW IF EXISTS v_student_basic;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_year INT,
    class_name VARCHAR(50),
    address VARCHAR(255)
);

INSERT INTO students (full_name, birth_year, class_name, address) VALUES
('Nguyen Van A', 2002, 'IT01', 'Ha Noi'),
('Tran Thi B', 2003, 'HR02', 'HCM'),
('Le Tuan C', 2001, 'IT01', 'Da Nang');

-- 2. Tao VIEW v_student_basic chi hien thi ma sinh vien, ho ten, va lop hoc
CREATE VIEW v_student_basic AS
SELECT student_id, full_name, class_name
FROM students;

-- 3. Truy van du lieu tu VIEW de kiem tra
SELECT * FROM v_student_basic;
