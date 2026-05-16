use module2_sql;

create table students_constraint (
student_id INT PRIMARY KEY AUTO_INCREMENT,
student_name VARCHAR(255) NOT NULL,
student_email VARCHAR(255) UNIQUE,
student_age INT CHECK (student_age >= 18)
)