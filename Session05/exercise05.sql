-- 1. Tao bang scores
DROP TABLE IF EXISTS scores;
CREATE TABLE scores (
    student_id INT,
    subject VARCHAR(100),
    score DECIMAL(4, 2),
    PRIMARY KEY (student_id, subject)
);

-- 2. Them du lieu mau
INSERT INTO scores (student_id, subject, score) VALUES
(1, 'Math', 8.5),
(1, 'Literature', 7.5),
(1, 'English', 9.0),
(2, 'Math', 6.0),
(2, 'Literature', 6.5),
(2, 'English', 7.0),
(3, 'Math', 7.5),
(3, 'Literature', 8.0),
(4, 'Math', 5.0),
(4, 'Literature', 4.5);

-- 3. Truy van theo yeu cau
-- a. Tinh diem trung binh cua moi sinh vien
SELECT student_id, AVG(score) AS average_score 
FROM scores 
GROUP BY student_id;

-- b. Chi hien thi cac sinh vien co diem trung binh >= 7.0
SELECT student_id, AVG(score) AS average_score 
FROM scores 
GROUP BY student_id 
HAVING AVG(score) >= 7.0;

-- c. Hien thi sinh vien co diem trung binh cao nhat trong toan bo danh sach
SELECT student_id, AVG(score) AS average_score 
FROM scores 
GROUP BY student_id 
ORDER BY average_score DESC 
LIMIT 1;

-- d. Hien thi cac sinh vien co diem trung binh cao hon diem trung binh chung cua tat ca sinh vien
SELECT student_id, AVG(score) AS average_score 
FROM scores 
GROUP BY student_id 
HAVING AVG(score) > (SELECT AVG(score) FROM scores);
