DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    customer_type TEXT,
    gender TEXT,
    birth_date DATE,
    work_activity TEXT,
    occupation_industry TEXT,
    total_income NUMERIC,
    relationship_status TEXT,
    habitation_status TEXT,
    province TEXT,
    school_attendance TEXT,
    schools TEXT
);

CREATE TABLE accounts (
    branch_number INTEGER,
    account_type TEXT,
    open_date DATE,
    account_id TEXT PRIMARY KEY,
    iban TEXT,
    balance NUMERIC(18,2),
    currency VARCHAR(3),
    customer_id TEXT
);

CREATE TABLE transactions (
    description TEXT,
    currency_amount NUMERIC(18,4),
    location_region TEXT,
    location_city TEXT,
    origination_datetime TIMESTAMPTZ,
    customer_id TEXT,
    merchant_id TEXT,
    account_id TEXT,
    category_tags TEXT
);