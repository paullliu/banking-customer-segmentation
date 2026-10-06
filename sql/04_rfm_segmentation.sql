-- Calculate RFM metrics for each customer
DROP VIEW IF EXISTS rfm;

CREATE VIEW rfm AS
SELECT
    customer_id,
    '2018-09-30'::DATE - MAX(transaction_date) AS recency,
    COUNT(*) AS frequency,
    ROUND(SUM(currency_amount), 2) AS monetary
FROM valid_transactions
WHERE month BETWEEN 4 AND 9
GROUP BY customer_id;

-- Calculate average RFM thresholds
DROP VIEW IF EXISTS rfm_thresholds;

CREATE VIEW rfm_thresholds AS
SELECT
    AVG(recency) AS avg_recency,
    AVG(frequency) AS avg_frequency,
    AVG(monetary) AS avg_monetary
FROM rfm;

SELECT *
FROM rfm_thresholds;

-- Segment customers using average RFM thresholds
DROP VIEW IF EXISTS rfm_segments;

CREATE VIEW rfm_segments AS
SELECT
    r.customer_id,
    r.recency,
    r.frequency,
    r.monetary,
    CASE
        WHEN r.recency < t.avg_recency
             AND r.frequency >= t.avg_frequency
             AND r.monetary >= t.avg_monetary
            THEN 'Key Value User'
        WHEN r.recency < t.avg_recency
             AND r.frequency >= t.avg_frequency
             AND r.monetary < t.avg_monetary
            THEN 'General Value User'
        WHEN r.recency < t.avg_recency
             AND r.frequency < t.avg_frequency
             AND r.monetary >= t.avg_monetary
            THEN 'Key Development User'
        WHEN r.recency < t.avg_recency
             AND r.frequency < t.avg_frequency
             AND r.monetary < t.avg_monetary
            THEN 'General Development User'
        WHEN r.recency >= t.avg_recency
             AND r.frequency >= t.avg_frequency
             AND r.monetary >= t.avg_monetary
            THEN 'Key Re-arrangement User'
        WHEN r.recency >= t.avg_recency
             AND r.frequency >= t.avg_frequency
             AND r.monetary < t.avg_monetary
            THEN 'General Re-arrangement User'
        WHEN r.recency >= t.avg_recency
             AND r.frequency < t.avg_frequency
             AND r.monetary >= t.avg_monetary
            THEN 'Key Retention User'
        ELSE 'General Retention User'
    END AS segment
FROM rfm AS r
CROSS JOIN rfm_thresholds AS t;

SELECT *
FROM rfm_segments
LIMIT 10;

-- Count customers by RFM segment
SELECT
    segment,
    COUNT(*) AS customer_count
FROM rfm_segments
GROUP BY segment
ORDER BY customer_count DESC;

-- Summarise RFM characteristics by segment
SELECT
    segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(recency), 2) AS avg_recency,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(monetary), 2) AS avg_monetary
FROM rfm_segments
GROUP BY segment
ORDER BY customer_count DESC;