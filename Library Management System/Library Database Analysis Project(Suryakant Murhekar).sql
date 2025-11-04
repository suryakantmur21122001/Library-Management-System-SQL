create database Library;
use Library;

create table tbl_publisher (
    publisher_PublisherName varchar(255) primary key,
    publisher_PublisherAddress varchar(255),
    publisher_PublisherPhone varchar(30)
);

-- Library Branch Table
CREATE TABLE tbl_library_branch (
    library_branch_BranchID int auto_increment primary key,
    library_branch_BranchName varchar(255) not null,
    library_branch_BranchAddress varchar(255) not null
);

-- Borrower Table
CREATE TABLE tbl_borrower (
    borrower_CardNo int auto_increment primary key,
    borrower_BorrowerName varchar(255) not null,
    borrower_BorrowerAddress varchar(255) not null,
    borrower_BorrowerPhone varchar(50) not null
);

-- Book Table
create table tbl_book (
    book_BookID int auto_increment primary key,
    book_Title varchar(255) not null,
    book_PublisherName varchar(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Author Table
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID int auto_increment primary key,
    book_authors_BookID int,
    book_authors_AuthorName varchar(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Book Copies Table
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID int auto_increment primary key,
    book_copies_BookID int,
    book_copies_BranchID int,
    book_copies_No_Of_Copies int check (book_copies_No_Of_Copies >= 0),
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Book Loans Table
CREATE TABLE tbl_book_loans (
    book_loans_LoansID int auto_increment primary key,
    book_loans_BookID int,
    book_loans_BranchID int,
    book_loans_CardNo int,
    book_loans_DateOut varchar(10) not null,  
    book_loans_DueDate varchar(10) not null,  
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
    ON DELETE CASCADE ON UPDATE CASCADE
);

SET SQL_SAFE_UPDATES = 0;
UPDATE tbl_book_loans 
SET book_loans_DateOut = STR_TO_DATE(book_loans_DateOut, '%m/%d/%y'),
    book_loans_DueDate = STR_TO_DATE(book_loans_DueDate, '%m/%d/%y');

alter table tbl_book_loans 
modify column book_loans_DateOut DATE not null,
modify column book_loans_DueDate DATE not null;

describe tbl_book_loans;
select book_loans_DateOut, book_loans_DueDate FROM tbl_book_loans LIMIT 5;

select * from tbl_publisher;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_library_branch;
select * from tbl_book_copies;
select * from tbl_borrower;
select * from tbl_book_loans;

-- Q1) How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select bc.book_copies_No_Of_Copies 
from tbl_book_copies bc
join tbl_book b on bc.book_copies_BookID = b.book_BookID
join tbl_library_branch lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = 'The Lost Tribe' and lb.library_branch_BranchName = 'Sharpstown';

-- Q2) How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select lb.library_branch_BranchName, SUM(bc.book_copies_No_Of_Copies) as Total_Copies
from tbl_book_copies bc
join tbl_book b on bc.book_copies_BookID = b.book_BookID
join tbl_library_branch lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = 'The Lost Tribe'
group by lb.library_branch_BranchName;


-- Q3) Retrieve the names of all borrowers who do not have any books checked out.
select b.borrower_BorrowerName
from tbl_borrower b
left join tbl_book_loans bl on b.borrower_CardNo = bl.book_loans_CardNo
where bl.book_loans_CardNo is null;


-- Q4) For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select b.book_Title as BookTitle, 
       br.borrower_BorrowerName as BorrowerName, 
       br.borrower_BorrowerAddress as BorrowerAddress
from tbl_book_loans bl
join tbl_book b on bl.book_loans_BookID = b.book_BookID
join tbl_borrower br on bl.book_loans_CardNo = br.borrower_CardNo
join tbl_library_branch lb on bl.book_loans_BranchID = lb.library_branch_BranchID
where lb.library_branch_BranchName = 'Sharpstown'
and bl.book_loans_DueDate = '2018-02-03';


-- Q5) For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_BranchName as BranchName, 
       COUNT(bl.book_loans_BookID) as TotalBooksLoaned
from tbl_library_branch lb
left join tbl_book_loans bl on lb.library_branch_BranchID = bl.book_loans_BranchID
group by lb.library_branch_BranchName;


-- Q6) Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select br.borrower_BorrowerName as BorrowerName, 
       br.borrower_BorrowerAddress as BorrowerAddress, 
       COUNT(bl.book_loans_BookID) as NumBooksCheckedOut
from tbl_borrower br
join tbl_book_loans bl on br.borrower_CardNo = bl.book_loans_CardNo
group by br.borrower_CardNo, br.borrower_BorrowerName, br.borrower_BorrowerAddress
having COUNT(bl.book_loans_BookID) > 5;


-- Q7) For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.book_Title as BookTitle, 
       bc.book_copies_No_Of_Copies as NumCopies
from tbl_book_authors ba
join tbl_book b on ba.book_authors_BookID = b.book_BookID
join tbl_book_copies bc on b.book_BookID = bc.book_copies_BookID
join tbl_library_branch lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where ba.book_authors_AuthorName = 'Stephen King'
and lb.library_branch_BranchName = 'Central';