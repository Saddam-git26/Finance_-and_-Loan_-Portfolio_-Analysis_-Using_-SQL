CREATE DATABASE FinanceDB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    loan_status VARCHAR(20),
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    loan_id INT,
    payment_amount DECIMAL(12,2),
    payment_date DATE,
    FOREIGN KEY (loan_id)
        REFERENCES Loans(loan_id)
);

INSERT INTO Customers VALUES
(1, 'Amit Sharma', 'Pune'),
(2, 'Sara Khan', 'Solapur'),
(3, 'Rahul Patil', 'Mumbai'),
(4, 'Neha Shaikh', 'Pune'),
(5, 'Imran Patel', 'Solapur');

INSERT INTO Loans VALUES
(101, 1, 100000, 10.5, 'Active'),
(102, 2, 150000, 12.0, 'Active'),
(103, 3, 200000, 11.0, 'Closed'),
(104, 4, 80000, 13.0, 'Active'),
(105, 5, 120000, 10.0, 'Active'),
(106, 1, 50000, 12.5, 'Closed');

INSERT INTO Payments VALUES
(1, 101, 20000, '2026-01-10'),
(2, 101, 15000, '2026-02-10'),
(3, 102, 30000, '2026-02-15'),
(4, 103, 100000, '2026-01-20'),
(5, 103, 100000, '2026-02-20'),
(6, 104, 10000, '2026-03-01'),
(7, 105, 25000, '2026-03-05'),
(8, 106, 50000, '2026-03-10');

SELECT * FROM Customers;

-- Active loans

SELECT loan_id, customer_id, loan_amount
FROM Loans
WHERE loan_status = 'Active';

-- Total Loan Amount

SELECT SUM(loan_amount) AS total_loan_amount
FROM Loans;

-- Count loans by Status

SELECT loan_status,
       COUNT(*) AS total_loans
FROM Loans
GROUP BY loan_status;


-- Customer name with loan amounts

SELECT c.customer_name,
       l.loan_id,
       l.loan_amount,
       l.loan_status
FROM Customers c
JOIN Loans l
    ON c.customer_id = l.customer_id;

-- Total Payment received

SELECT SUM(payment_amount) AS total_payments
FROM Payments;

-- Outstanding loan principal

SELECT
    l.loan_id,
    c.customer_name,
    l.loan_amount,
    COALESCE(SUM(p.payment_amount), 0) AS total_paid,
    l.loan_amount -
        COALESCE(SUM(p.payment_amount), 0)
        AS outstanding_principal
FROM Loans l
JOIN Customers c
    ON l.customer_id = c.customer_id
LEFT JOIN Payments p
    ON l.loan_id = p.loan_id
GROUP BY
    l.loan_id,
    c.customer_name,
    l.loan_amount;

-- Customers with multiple loans

SELECT
    c.customer_name,
    COUNT(l.loan_id) AS total_loans
FROM Customers c
JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(l.loan_id) > 1;

-- Loan portfolio summary

SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_amount,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    MIN(loan_amount) AS smallest_loan,
    MAX(loan_amount) AS largest_loan
FROM Loans;

-- Loan status analysis

SELECT
    loan_status,
    COUNT(*) AS number_of_loans,
    SUM(loan_amount) AS total_principal
FROM Loans
GROUP BY loan_status
ORDER BY total_principal DESC;

-- Collection by Month

SELECT
    TO_CHAR(payment_date, 'YYYY-MM') AS payment_month,
    SUM(payment_amount) AS total_collections,
    COUNT(*) AS payment_transactions
FROM Payments
GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
ORDER BY payment_month;


-- Outstanding principal by loan

SELECT
    l.loan_id,
    c.customer_name,
    l.loan_amount,
    COALESCE(p.total_paid, 0) AS total_paid,
    l.loan_amount - COALESCE(p.total_paid, 0)
        AS outstanding_principal
FROM Loans l
JOIN Customers c
    ON l.customer_id = c.customer_id
LEFT JOIN (
    SELECT
        loan_id,
        SUM(payment_amount) AS total_paid
    FROM Payments
    GROUP BY loan_id
) p
    ON l.loan_id = p.loan_id
ORDER BY outstanding_principal DESC;

-- Rank customers by total borrowing

SELECT
    c.customer_name,
    COUNT(l.loan_id) AS number_of_loans,
    SUM(l.loan_amount) AS total_borrowed,
    DENSE_RANK() OVER (
        ORDER BY SUM(l.loan_amount) DESC
    ) AS customer_rank
FROM Customers c
JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_rank;


-- Customers with outstanding balances above ₹80,000

SELECT
    c.customer_name,
    SUM(
        l.loan_amount - COALESCE(p.total_paid, 0)
    ) AS outstanding_principal
FROM Customers c
JOIN Loans l
    ON c.customer_id = l.customer_id
LEFT JOIN (
    SELECT
        loan_id,
        SUM(payment_amount) AS total_paid
    FROM Payments
    GROUP BY loan_id
) p
    ON l.loan_id = p.loan_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING
    SUM(l.loan_amount - COALESCE(p.total_paid, 0)) > 80000
ORDER BY outstanding_principal DESC;


