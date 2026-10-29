# Banking Customer Segmentation & Product Strategy

A banking analytics project using PostgreSQL and Python to explore merchant-category opportunities and identify potential customer segments for a new financial product. The analysis combines transaction-level SQL analysis, rule-based RFM segmentation, and K-means clustering to translate customer behaviour into actionable product insights.

## Business Questions

1. Which merchant category offers a promising focus for a new financial product?
2. How can customers be segmented using their transaction behaviour?
3. Which customer segment presents a promising targeting opportunity, and what trade-offs should inform the decision?

## Dataset

The project uses three linked datasets:

- **5,645 customers**
- **11,290 accounts**
- **92,304 transaction records**

The source data spans March–October 2018. The main category and RFM analyses focus on April–September 2018 to compare complete months.

Customer, account, and transaction records are linked through customer and account identifiers. Transaction timestamps are converted to UTC before date extraction, and non-positive transaction amounts are excluded from the analysis.

The K-means comparison uses **5,473 customers** with available RFM metrics for the analysis period.

The original source data is not included in this repository. See the [data guide](data/README.md) for the expected CSV files and their relationships.

## Analytical Workflow

### 1. Data Preparation and Validation — PostgreSQL

- Defined relational tables for customer, account, and transaction data.
- Prepared an analysis-ready transaction table and checked transaction amounts and date coverage.
- Handled timezone-sensitive date conversion explicitly to improve the consistency of customer-level metrics.

### 2. Merchant-Category Analysis — SQL

Compared Food and Dining, Shopping, Home, Travel, and Entertainment using:

- Transaction volume
- Monthly customer penetration and overall customer reach
- Average monthly transaction frequency per customer
- Active merchant coverage

The analysis identifies Food and Dining as a promising category for further investigation and examines how engagement in this category varies across customer segments.

### 3. Rule-Based RFM Segmentation — SQL

Calculated customer-level Recency, Frequency, and Monetary (RFM) metrics using transaction activity from April–September 2018.

Applied mean-based thresholds to the three RFM dimensions to classify customers into eight rule-based segments, including:

- Key Value User
- General Value User
- Key Development User
- General Development User
- Key Retention User
- General Retention User

Summarised segment sizes and behavioural characteristics to support customer targeting decisions.

### 4. K-Means Clustering — Python

Applied unsupervised learning to the same three RFM dimensions to explore alternative customer groupings.

The workflow included:

- **Feature transformation:** Applied `log1p` to Recency, Frequency, and Monetary values to reduce skewness.
- **Feature scaling:** Used `StandardScaler` to standardise the transformed features before distance-based clustering.
- **Cluster selection:** Tested values of `k` from 2 to 6, comparing inertia and silhouette scores.
- **Model selection:** Selected three clusters because `k = 3` achieved the highest silhouette score among the tested configurations.
- **Cluster profiling:** Compared customer counts and average and median RFM characteristics across clusters.

### 5. Segmentation Comparison and Product Implications

Compared the K-means clusters with the rule-based RFM segments using cross-tabulation.

This comparison helps assess how the two approaches group customers with similar transaction behaviours and highlights segments that may warrant further product or engagement analysis.

## Key Findings

### K-Means Cluster Profiles

The selected three-cluster solution achieved a silhouette score of **0.338**, the highest among the tested values of `k` (2–6).

| Cluster | Customers | Avg. Recency (days) | Avg. Frequency | Avg. Monetary Value | Behavioural Profile |
| --- | ---: | ---: | ---: | ---: | --- |
| 0 | 1,895 | 36.45 | 7.22 | 4,131.67 | Less recently active, lower-frequency customers |
| 1 | 495 | 4.49 | 30.22 | 741.48 | Recently active, frequent transactors with relatively low total spending |
| 2 | 3,083 | 10.02 | 16.07 | 8,931.24 | Higher-spending customers with moderate transaction frequency |

*RFM metrics are calculated over April–September 2018, with recency measured relative to 30 September 2018. Monetary values are expressed in the dataset's currency units.*

### A Potential Target Segment

Cluster 1 contains **495 customers**, approximately 9.0% of the customers included in the clustering analysis.

This group has an average recency of 4.49 days and an average frequency of 30.22 transactions, while its average monetary value is comparatively low at 741.48.

A comparison with the rule-based RFM segmentation shows that **87.9% of this cluster were classified as General Value Users**.

The overlap suggests that two different segmentation approaches identify a similar group of recently active, frequent, relatively low-spending customers. This segment could be investigated further for a product proposition focused on everyday transactions and customer engagement.

## Tools and Technologies

- **Database and SQL:** PostgreSQL
- **Data analysis:** Python, Pandas, NumPy
- **Machine learning:** scikit-learn, K-means clustering, StandardScaler, silhouette analysis
- **Visualisation:** Matplotlib
- **Development environment:** Jupyter Notebook

## Repository Structure

```text
.
├── data/
│   └── README.md
├── notebooks/
│   └── rfm_kmeans.ipynb
├── sql/
│   ├── 01_schema.sql
│   ├── 02_data_preparation.sql
│   ├── 03_category_analysis.sql
│   ├── 04_rfm_segmentation.sql
│   └── 05_target_segment_analysis.sql
└── README.md
```

## Reproducing the Analysis

1. Obtain the source CSV files and load them into the PostgreSQL tables defined in `sql/01_schema.sql`.
2. Execute the SQL scripts in numerical order to prepare the data, analyse merchant categories, calculate RFM metrics, and investigate the target segment.
3. Export the resulting `rfm` and `rfm_segments` views to `data/processed/rfm.csv` and `data/processed/rfm_segments.csv`, respectively.
4. Install the Python dependencies and run `notebooks/rfm_kmeans.ipynb`.

Python dependencies used by the notebook can be installed with:

```bash
pip install pandas numpy scikit-learn matplotlib jupyter
```

The original source data and intermediate CSV files are not included in the public repository.