-- Identify customers with high Food and Dining activity
DROP VIEW IF EXISTS food_segments;

CREATE VIEW food_segments AS
SELECT
    customer_id,
    CASE
        WHEN food_transactions * 1.0 / total_transactions >= 0.5 THEN 1
        ELSE 0
    END AS food_segment,
    food_transactions,
    total_transactions,
    food_spend
FROM (
    SELECT
        customer_id,
        SUM(
            CASE
                WHEN category_tags = 'Food and Dining' THEN 1
                ELSE 0
            END
        ) AS food_transactions,
        COUNT(*) AS total_transactions,
        SUM(
            CASE
                WHEN category_tags = 'Food and Dining' THEN currency_amount
                ELSE 0
            END
        ) AS food_spend
    FROM valid_transactions
    WHERE month BETWEEN 4 AND 9
    GROUP BY customer_id
) AS customer_food_activity;

SELECT
    food_segment,
    COUNT(*) AS customer_count
FROM food_segments
GROUP BY food_segment
ORDER BY food_segment DESC;

-- Compare the share of high Food and Dining activity within each RFM segment
SELECT
    r.segment,
    COUNT(*) AS customer_count,
    SUM(
        CASE WHEN f.food_segment = 1 THEN 1 ELSE 0 END
    ) AS high_food_customers,
    ROUND(
        SUM(CASE WHEN f.food_segment = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS high_food_customer_pct
FROM food_segments AS f
JOIN rfm_segments AS r
    ON f.customer_id = r.customer_id
GROUP BY r.segment
ORDER BY high_food_customer_pct DESC;

-- Summarise high Food and Dining activity within each RFM segment
SELECT
    r.segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN f.food_segment = 1 THEN 1 ELSE 0 END) AS high_food_customers,
    ROUND(
        AVG(CASE WHEN f.food_segment = 1 THEN r.frequency END),
        2
    ) AS avg_frequency_high_food,
    ROUND(
        AVG(CASE WHEN f.food_segment = 1 THEN r.monetary END),
        2
    ) AS avg_monetary_high_food
FROM rfm_segments AS r
JOIN food_segments AS f
    ON r.customer_id = f.customer_id
GROUP BY r.segment
ORDER BY high_food_customers DESC;