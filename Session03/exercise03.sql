USE module2_sql;
DROP TABLE IF EXISTS MuonSach;
DROP TABLE IF EXISTS Sach;
DROP TABLE IF EXISTS DocGia;

CREATE TABLE DocGia (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15)
);

CREATE TABLE Sach (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    author VARCHAR(100)
);

CREATE TABLE MuonSach (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (reader_id) REFERENCES DocGia(reader_id),
    FOREIGN KEY (book_id) REFERENCES Sach(book_id)
);

ALTER TABLE MuonSach MODIFY borrow_date DATE NOT NULL;
