USE module2_sql;

-- Vì bài tập 1 đã có bảng nên cần phải xóa bảng students cũ
DROP TABLE IF EXISTS students;

CREATE TABLE classes (
class_id INT PRIMARY KEY AUTO_INCREMENT,
class_name VARCHAR(255) NOT NULL,
school_year VARCHAR(20) NOT NULL
);

CREATE TABLE students (
student_id INT PRIMARY KEY AUTO_INCREMENT,
student_name VARCHAR(255) NOT NULL,
date_of_birth DATE,
gender VARCHAR(10),
class_id INT,
FOREIGN KEY (class_id) REFERENCES classes(class_id)
)