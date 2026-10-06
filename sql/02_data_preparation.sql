-- Check imported row counts
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM transactions;

-- Check transaction amount range
SELECT
    MIN(currency_amount) AS min_amount,
    MAX(currency_amount) AS max_amount
FROM transactions;

-- Create analysis-ready transaction table
DROP TABLE IF EXISTS valid_transactions;

CREATE TABLE valid_transactions AS
SELECT
    *,
    -- Convert timestamps to UTC before extracting the date to avoid
    -- month-boundary shifts caused by the PostgreSQL session timezone.
    (origination_datetime AT TIME ZONE 'UTC')::DATE AS transaction_date
FROM transactions
WHERE currency_amount > 0;

-- Check cleaned row count
SELECT COUNT(*)
FROM valid_transactions;

-- Check date coverage
SELECT
    MIN(transaction_date) AS first_date,
    MAX(transaction_date) AS last_date,
    COUNT(DISTINCT transaction_date) AS number_of_days
FROM valid_transactions;

SELECT
    transaction_date,
    COUNT(*) AS transaction_count
FROM valid_transactions
GROUP BY transaction_date
ORDER BY transaction_date;

-- Add month
ALTER TABLE valid_transactions
ADD COLUMN month INTEGER;

UPDATE valid_transactions
SET month = EXTRACT(MONTH FROM transaction_date)::INTEGER;

-- Check monthly distribution
SELECT
    month,
    COUNT(*) AS transaction_count
FROM valid_transactions
GROUP BY month
ORDER BY month;