# Source datasets

The project uses three CSV files with headers:

| Expected filename | Record represents | Main fields |
| --- | --- | --- |
| `Customers.csv` | One customer | Customer ID (`id`), birth date, demographic attributes, employment, and income |
| `Accounts.csv` | One account | Account ID (`id`), customer ID (`cust_id`), account type, opening date, balance, and currency |
| `Transaction.csv` | One transaction record | Customer ID (`customerId`), account ID (`accountId`), merchant ID, amount, timestamp recorded in UTC, and merchant category |

Transaction timestamps are recorded in UTC in the source data. When imported as PostgreSQL `TIMESTAMPTZ`, they may be displayed in the session timezone, so UTC is applied explicitly before date extraction in the analysis.

Customer IDs link accounts and transactions to customers; account IDs link transactions to accounts.

The original source data is not included in the public repository. Local copies can be placed under `data/raw/` when reproducing the analysis.