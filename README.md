# Customer Data Cleaning & Analysis for Marketing Campaign in Snowflake

## Project Summary

This project aims to identify a list of inactive customers for the next marketing campaign. These are the customers who have not made any transactions in the last 90 days. However, the available data in Snowflake has numerous challenges like:

- Duplicated customers
- Missing emails
- Merged columns
- Non-standardized phone numbers
- Incorrect data types

We address these issues by reformatting and cleaning the data using SQL functions in Snowflake. Once the data is cleaned and optimized, a final list of target customers is generated.

## Technology Stack

- **SQL**: for data manipulation and transformation
- **Snowflake**: for data warehousing

## SQL Code

The SQL code is designed to:

1. Remove duplicated records based on the email address, while keeping the record with the latest transaction date.
2. Split and standardize customer's name into `FIRST_NAME` and `LAST_NAME`.
3. Convert date of birth and last transaction to a standard date format.
4. Calculate the age of the customer.
5. Calculate the days since the last transaction for each customer.
6. Clean and standardize phone numbers.
7. Address other data quality issues.

Here's a snippet from the code:

```sql
SELECT ID, NAME, EMAIL, LASTTRANSACTION,
    RANK() over (partition by EMAIL order by to_date(LASTTRANSACTION,'AUTO')DESC) as RANK
FROM CUSTOMERS QUALIFY RANK -1;

-- ... (rest of the SQL code)
```
The full code can be found in the repository.

## How to Run

1. Log in to your Snowflake account.
2. Open a SQL worksheet.
3. Copy and paste the SQL code into the worksheet.
4. Execute the code.

You should now have a view named `CUSTOMERS_VW` containing the cleaned data, and a final query to extract the list of customers who have been inactive for more than 90 days.


## Acknowledgments

* [Snowflake Documentation](https://docs.snowflake.com/en/)
* [SQL Functions Reference](https://docs.snowflake.com/en/sql-reference-functions.html)
