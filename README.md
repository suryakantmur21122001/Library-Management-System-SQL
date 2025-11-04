# 📚 Library Management System (SQL Project)

## 🧾 Overview
The **Library Management System** is a SQL-based database project designed to efficiently manage library operations — including tracking books, borrowers, authors, and publishers.  
This project demonstrates **database design, normalization**, and **SQL query implementation** for handling real-world library workflows.

---

## 🎯 Objectives
- 📘 Design a relational database for managing library operations  
- 🧱 Implement SQL queries for CRUD operations (Create, Read, Update, Delete)  
- 📊 Perform analysis on borrowing patterns and book availability  
- 🔒 Ensure data integrity using primary and foreign key constraints  

---

## 🗂️ Dataset Description
The project includes **7 CSV files** and **1 SQL script file**, all stored in the **Library Management System** folder.

| File Name | Description |
|------------|-------------|
| authors.csv | Contains details of book authors |
| books.csv | Contains book information (title, author, publisher, etc.) |
| book_copies.csv | Tracks the number of copies of each book in each branch |
| book_loans.csv | Records of borrowed books with issue and return dates |
| borrower.csv | Contains information about library members |
| library_branch.csv | Contains details of each library branch |
| publisher.csv | Contains information about book publishers |
| Library Database Analysis Project (Suryakant Murhekar).sql | SQL file for creating tables, inserting data, and running analytical queries |

---

## 🧩 Database Schema

The schema is designed to maintain referential integrity using **Primary Keys** and **Foreign Keys**.

### 🔗 Relationships:

- A **Book** can have multiple copies across different **Library Branches**  
- A **Borrower** can borrow multiple books  
- Each **Book** is linked to an **Author** and a **Publisher**

### 🗃️ Example ER Diagram (Conceptually)

Author ───< Books >─── Publisher

    │
    
    ▼
    
Book_Copies >─── Library_Branch

    │
    
    ▼
    
Book_Loans >─── Borrower


---

## ⚙️ SQL Operations Covered

### 🏗️ Database & Table Creation
```sql
CREATE DATABASE Library_Management;
USE Library_Management;

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    PublisherName VARCHAR(50),
    Pub_Year INT
);
```

🔐 Relationships
```sql
ALTER TABLE Books
ADD FOREIGN KEY (PublisherName) REFERENCES Publisher(PublisherName);
```

📊 Analytical Queries
```sql
-- Most Borrowed Books
SELECT B.Title, COUNT(*) AS TimesBorrowed
FROM Book_Loans BL
JOIN Books B ON BL.BookID = B.BookID
GROUP BY B.Title
ORDER BY TimesBorrowed DESC
LIMIT 5;
```

```sql
-- Active Borrowers
SELECT Bo.BorrowerName, COUNT(*) AS TotalLoans
FROM Borrower Bo
JOIN Book_Loans BL ON Bo.CardNo = BL.CardNo
GROUP BY Bo.BorrowerName
ORDER BY TotalLoans DESC;
```

## 🧠 Key Learnings

✅ Database design and normalization

✅ Writing optimized SQL queries

✅ Understanding entity relationships

✅ Extracting and reporting insights using SQL

## 🧰 Tools & Technologies

| Tool / Technology                   | Purpose                             |
| ----------------------------------- | ----------------------------------- |
| 🗄️ MySQL / PostgreSQL / SQL Server | Database creation & query execution |
| 📂 CSV Files                        | Dataset input                       |
| 💻 SQL Workbench                    | SQL script execution                |


## 🚀 How to Run the Project

1. Download all CSV files and the SQL script.

2. Open your SQL environment (MySQL Workbench, DBeaver, etc.).

3. Execute the SQL file to create the database and tables.

4. Import CSVs into respective tables.

5. Run the provided queries to explore insights.

## 📈 Sample Insights

- Most borrowed books by category

- Top performing library branches

- Borrowers with the highest number of issued books

- Publisher-wise distribution of books

## 👨‍💻 Author

Suryakant Murhekar
📍 SQL Developer | Data Analyst | Data Science Enthusiast

🔗 **[GitHub Profile](https://github.com/suryakantmur21122001)**

⭐ If you like this project, don’t forget to give it a star on GitHub! 🌟


