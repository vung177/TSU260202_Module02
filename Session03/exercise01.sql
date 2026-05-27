USE module2_sql;

DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS classes;

CREATE TABLE classes (
class_id INT AUTO_INCREMENT PRIMARY KEY,
class_name VARCHAR(100) NOT NULL
);

CREATE TABLE students (
student_id INT AUTO_INCREMENT PRIMARY KEY,
student_name VARCHAR(100) NOT NULL,
dob DATE,
class_id INT NOT NULL,
FOREIGN KEY (class_id) REFERENCES classes(class_id)
);