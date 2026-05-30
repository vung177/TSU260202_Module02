-- 1. Tao bang students
DROP PROCEDURE IF EXISTS sp_classify_student;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    avg_score DECIMAL(4, 2) NOT NULL
);

-- 2. Tao Stored Procedure co 1 tham so IN, 1 tham so OUT, dung bien trung gian va cau lenh CASE
DELIMITER //
CREATE PROCEDURE sp_classify_student(
    IN p_avg_score DECIMAL(4, 2),
    OUT p_classification VARCHAR(20)
)
BEGIN
    -- Khai bao bien trung gian
    DECLARE v_class VARCHAR(20);
    
    -- Su dung cau lenh CASE de phan loai hoc luc
    CASE 
        WHEN p_avg_score >= 8.0 THEN
            SET v_class = 'Giỏi';
        WHEN p_avg_score >= 6.5 AND p_avg_score < 8.0 THEN
            SET v_class = 'Khá';
        WHEN p_avg_score >= 5.0 AND p_avg_score < 6.5 THEN
            SET v_class = 'Trung bình';
        ELSE
            SET v_class = 'Yếu';
    END CASE;
    
    -- Gan ket qua xep loai cho tham so OUT
    SET p_classification = v_class;
END //
DELIMITER ;

-- 3. Goi procedure bang CALL va su dung bien nguoi dung de nhan gia tri OUT
CALL sp_classify_student(8.5, @result_gioi);
SELECT @result_gioi AS classification_8_5;

CALL sp_classify_student(7.2, @result_kha);
SELECT @result_kha AS classification_7_2;

CALL sp_classify_student(5.5, @result_tb);
SELECT @result_tb AS classification_5_5;

CALL sp_classify_student(4.0, @result_yeu);
SELECT @result_yeu AS classification_4_0;
