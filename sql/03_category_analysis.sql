-- Check transaction volume by merchant category
SELECT
    category_tags,
    COUNT(*) AS transaction_count
FROM valid_transactions
GROUP BY category_tags
ORDER BY transaction_count DESC;

-- Compare selected categories across complete months
SELECT
    month,
    category_tags,
    COUNT(*) AS transaction_count
FROM valid_transactions
WHERE month BETWEEN 4 AND 9
  AND category_tags IN (
      'Food and Dining',
      'Shopping',
      'Home',
      'Travel',
      'Entertainment'
  )
GROUP BY month, category_tags
ORDER BY month, transaction_count DESC;

-- Average monthly penetration to reflect recurring customer activity
SELECT
    category_tags,
    ROUND(AVG(penetration_rate) * 100, 2) AS avg_monthly_penetration_pct
FROM (
    SELECT
        month,
        category_tags,
        COUNT(DISTINCT customer_id) * 1.0
            / (SELECT COUNT(*) FROM customers) AS penetration_rate
    FROM valid_transactions
    WHERE month BETWEEN 4 AND 9
      AND category_tags IN (
          'Food and Dining',
          'Shopping',
          'Home',
          'Travel',
          'Entertainment'
      )
    GROUP BY month, category_tags
) AS monthly_penetration
GROUP BY category_tags
ORDER BY avg_monthly_penetration_pct DESC;

-- Overall customer reach across April to September
SELECT
    category_tags,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0
        / (SELECT COUNT(*) FROM customers),
        2
    ) AS overall_penetration_pct
FROM valid_transactions
WHERE month BETWEEN 4 AND 9
  AND category_tags IN (
      'Food and Dining',
      'Shopping',
      'Home',
      'Travel',
      'Entertainment'
  )
GROUP BY category_tags
ORDER BY overall_penetration_pct DESC;

-- Average monthly transaction frequency per customer
SELECT
    category_tags,
    ROUND(AVG(transactions_per_customer), 2) AS avg_monthly_frequency
FROM (
    SELECT
        month,
        category_tags,
        COUNT(*) * 1.0 / COUNT(DISTINCT customer_id) AS transactions_per_customer
    FROM valid_transactions
    WHERE month BETWEEN 4 AND 9
      AND category_tags IN (
          'Food and Dining',
          'Shopping',
          'Home',
          'Travel',
          'Entertainment'
      )
    GROUP BY month, category_tags
) AS monthly_frequency
GROUP BY category_tags
ORDER BY avg_monthly_frequency DESC;

-- Average monthly active merchants by category
SELECT
    category_tags,
    ROUND(AVG(active_merchants), 0) AS avg_monthly_active_merchants
FROM (
    SELECT
        month,
        category_tags,
        COUNT(DISTINCT merchant_id) AS active_merchants
    FROM valid_transactions
    WHERE month BETWEEN 4 AND 9
      AND category_tags IN (
          'Food and Dining',
          'Shopping',
          'Home',
          'Travel',
          'Entertainment'
      )
    GROUP BY month, category_tags
) AS monthly_merchants
GROUP BY category_tags
ORDER BY avg_monthly_active_merchants DESC;

-- Food and Dining shows the strongest recurring engagement and merchant coverage.