-- Create Database
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Table: Members
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address TEXT
);

-- Table: Authors
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Bio TEXT
);

-- Table: Books
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Publisher VARCHAR(100),
    YearPublished YEAR,
    CopiesAvailable INT DEFAULT 1,
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table: Loans
CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table: Genres
CREATE TABLE Genres (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(50) UNIQUE NOT NULL
);

-- Many-to-Many Relationship: BookGenres
CREATE TABLE BookGenres (
    BookID INT,
    GenreID INT,
    PRIMARY KEY (BookID, GenreID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
        ON DELETE CASCADE,
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
        ON DELETE CASCADE
);

-- Table: Librarians
CREATE TABLE Librarians (
    LibrarianID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    HiredDate DATE NOT NULL
);

-- Optional: Logs table to track actions (1:M from Librarian)
CREATE TABLE ActionLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    LibrarianID INT,
    ActionDescription TEXT NOT NULL,
    ActionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (LibrarianID) REFERENCES Librarians(LibrarianID)
        ON DELETE SET NULL
);

-- Insert Members
INSERT INTO Members (FullName, Email, Phone, Address) VALUES
('Alice Johnson', 'alice@example.com', '555-1234', '123 Elm St'),
('Bob Smith', 'bob@example.com', '555-5678', '456 Oak Ave'),
('Charlie Brown', 'charlie@example.com', '555-8765', '789 Maple Rd');

-- Insert Authors
INSERT INTO Authors (Name, Bio) VALUES
('J.K. Rowling', 'Author of the Harry Potter series.'),
('George R.R. Martin', 'Author of A Song of Ice and Fire.'),
('J.R.R. Tolkien', 'Author of The Lord of the Rings.');

-- Insert Books
INSERT INTO Books (Title, ISBN, Publisher, YearPublished, CopiesAvailable, AuthorID) VALUES
('Harry Potter and the Sorcerer''s Stone', '9780747532699', 'Bloomsbury', 1997, 5, 1),
('A Game of Thrones', '9780553573404', 'Bantam', 1996, 3, 2),
('The Hobbit', '9780547928227', 'Houghton Mifflin', 1937, 4, 3),
('Harry Potter and the Chamber of Secrets', '9780747538493', 'Bloomsbury', 1998, 2, 1);

-- Insert Genres
INSERT INTO Genres (GenreName) VALUES
('Fantasy'),
('Adventure'),
('Drama'),
('Science Fiction');

-- Insert BookGenres (M:M Relationship)
INSERT INTO BookGenres (BookID, GenreID) VALUES
(1, 1), -- Harry Potter 1 → Fantasy
(1, 2), -- Harry Potter 1 → Adventure
(2, 1), -- GoT → Fantasy
(2, 3), -- GoT → Drama
(3, 1), -- The Hobbit → Fantasy
(3, 2), -- The Hobbit → Adventure
(4, 1), -- Harry Potter 2 → Fantasy

-- Insert Librarians
INSERT INTO Librarians (Name, Email, HiredDate) VALUES
('Dana White', 'dana@library.org', '2020-01-15'),
('Eli Turner', 'eli@library.org', '2021-06-10');

-- Insert ActionLogs
INSERT INTO ActionLogs (LibrarianID, ActionDescription) VALUES
(1, 'Checked inventory for damaged books.'),
(2, 'Added new member records.'),
(1, 'Updated book availability after returns.');

-- Insert Loans
INSERT INTO Loans (MemberID, BookID, LoanDate, DueDate, ReturnDate) VALUES
(1, 1, '2024-05-01', '2024-05-15', '2024-05-10'),
(1, 2, '2024-05-05', '2024-05-19', NULL),
(2, 3, '2024-04-28', '2024-05-12', '2024-05-11'),
(3, 4, '2024-05-02', '2024-05-16', NULL);
