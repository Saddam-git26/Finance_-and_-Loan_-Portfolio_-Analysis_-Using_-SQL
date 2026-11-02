# Finance_-and_-Loan_-Portfolio_-Analysis_-Using_-SQL

A SQL project that analyses customer details, loan information, payment transactions, loan status, collections, and outstanding loan balances.

## Project Overview

This project focuses on analysing loan portfolio data using SQL.

The main objectives are:

* Analyse total loans and loan amounts.
* Identify active and closed loans.
* Calculate total payments received.
* Analyse outstanding loan principal.
* Identify customers with multiple loans.
* Analyse monthly payment collections.
* Rank customers based on total borrowing.

## Database Design

Database Name: `FinanceDB`

This project contains 3 tables:

**1. Customers**

* customer_id
* customer_name
* city

**2. Loans**

* loan_id
* customer_id
* loan_amount
* interest_rate
* loan_status

**3. Payments**

* payment_id
* loan_id
* payment_amount
* payment_date

## Key Analysis

* Active Loan Details
* Total Loan Amount
* Loan Count by Status
* Customer-wise Loan Details
* Total Payments Received
* Outstanding Principal by Loan
* Customers with Multiple Loans
* Loan Portfolio Summary
* Loan Status Analysis
* Monthly Payment Collections
* Customer Ranking by Total Borrowing
* Customers with Outstanding Balance Above ₹80,000

## SQL Concepts Used

* SELECT and WHERE
* INNER JOIN and LEFT JOIN
* Aggregate Functions (SUM, COUNT, AVG, MIN, MAX)
* GROUP BY and HAVING
* ORDER BY
* COALESCE()
* Subqueries
* DENSE_RANK()
* Date Formatting

## Tools Used

* SQL
* PostgreSQL-compatible SQL syntax
* Relational Database Concepts

## How to Run

1. Download the SQL file from this repository.
2. Open it in PostgreSQL or a compatible SQL environment.
3. Execute the database and table creation queries.
4. Insert the sample data.
5. Run the analysis queries.

**Note:** The monthly collection query uses PostgreSQL `TO_CHAR()` function.

## Author

|Saddam Pathan|

