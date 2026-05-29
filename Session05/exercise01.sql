-- 1. Tao bang students
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_year INT,
    gender VARCHAR(10),
    score DECIMAL(4, 2)
);
-- 2. Du lieu mau tu session 2
INSERT INTO students (full_name, birth_year, gender, score)
VALUES ('nguyen van a', 2002, 'Male', 8.45),
    ('tran thi b', 2003, 'Female', 7.82),
    ('le van c', 2001, 'Male', 9.15),
    ('pham minh d', 2002, 'Male', 6.54),
    ('hoang lan e', 2004, 'Female', 8.99);
-- 3. Truy van theo yeu cau
-- a. Ma sinh vien, ho ten viet hoa
SELECT student_id,
    UPPER(full_name) AS full_name_upper
FROM students;
-- b. Ho ten, tuoi dua tren nam hien tai
SELECT full_name,
    (YEAR(CURDATE()) - birth_year) AS age
FROM students;
-- c. Diem trung binh lam tron 1 chu so thap phan
SELECT student_id,
    full_name,
    ROUND(score, 1) AS rounded_score
FROM students;
-- d. Tong so sinh vien, diem cao nhat, diem thap nhat
SELECT COUNT(*) AS total_students,
    MAX(score) AS max_score,
    MIN(score) AS min_score
FROM students;