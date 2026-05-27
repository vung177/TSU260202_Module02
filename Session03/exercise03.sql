USE module2_sql;
DROP TABLE IF EXISTS borrow;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS readers;
CREATE TABLE readers (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15)
);
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    author VARCHAR(100)
);
CREATE TABLE borrow (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (reader_id) REFERENCES readers(reader_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
ALTER TABLE borrow
MODIFY borrow_date DATE NOT NULL;