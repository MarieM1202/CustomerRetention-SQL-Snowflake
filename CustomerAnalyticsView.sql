-- Set the Role to Account Admin
USE ROLE ACCOUNTADMIN;

-- Set the Warehouse to Compute_WH
USE WAREHOUSE COMPUTE_WH;

-- Use the customer_db Database
USE DATABASE customer_db;

-- Use the Public Schema
USE SCHEMA PUBLIC;

-- Create or Replace a View named CUSTOMERS_VW
-- This view filters and transforms the data in the CUSTOMERS table
CREATE OR REPLACE VIEW CUSTOMERS_VW AS (
    
    -- CTE to identify the latest transaction for each email
    WITH LISTIDs AS (
        SELECT 
            ID, Name, Email, LastTransaction,
            -- Ranking emails by latest transaction date
            rank() over (partition by email order by TO_DATE(LastTransaction, 'AUTO') desc) RANK 
        FROM CUSTOMERS
        -- Only the latest transaction for each email is considered
        QUALIFY RANK = 1
    )
    
    SELECT 
        ID,
        -- Parsing First and Last Name from Name Column
        SPLIT_PART(TRIM(NAME, ' 0'), ',', 1) AS FIRST_NAME,
        SPLIT_PART(TRIM(NAME, ' 0'), ', ', 2) AS LAST_NAME,
        EMAIL,
        
        -- Convert DoB into date format and calculate age
        TO_DATE(DoB, 'MMMM DD, YYYY') AS DoB,
        DATEDIFF(year, TO_DATE(DoB, 'MMMM DD, YYYY'), current_date()) AS AGE,
        
        -- Formatting LastTransaction and calculating Days Since Last Transaction
        TO_DATE(LastTransaction, 'AUTO') AS LastTransaction,
        DATEDIFF(days, LastTransaction, current_date()) AS DaysSinceLastTrans,
        
        -- Handling null or empty Company Names
        IFF(((COMPANY IS NULL) OR (COMPANY = '')), 'N/A', COMPANY) AS COMPANY,
        
        -- Formatting Phone Numbers
        LTRIM(PHONE, '+0') AS PHONE,
        
        ADDRESS, postalZip, Region, COUNTRY
    FROM
        CUSTOMERS
    WHERE
        -- Filter out records with null or empty emails and only include IDs from the LISTIDs CTE
        NOT(email IS NULL OR email = '') AND ID IN (SELECT ID FROM LISTIDs)
);

-- Query to identify customers who have not made transactions in over 90 days
SELECT * 
FROM CUSTOMERS_VW
WHERE DaysSinceLastTrans > 90;
