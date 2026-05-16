-- Tạo database
CREATE DATABASE module2_sql;

-- Dùng database là module2
USE module2_sql;

-- Tạo bảng student
CREATE TABLE students (
student_id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(255) NOT NULL,
date_of_birth DATE,
gender VARCHAR(10)
);

