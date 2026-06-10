# Customer Transactions Analysis

## Overview

An end-to-end data analysis project focused on customer transaction data, covering data cleaning, exploratory data analysis (EDA), and dashboard development. The dataset was cleaned and analyzed using MySQL and visualized in Power BI to provide meaningful business insights.


## Tools & Technologies

- **MySQL** – Data cleaning, duplicate removal, and exploratory data analysis
- **Power BI** – Interactive dashboard creation and data visualization


## Project Files

| File | Description |
|------|-------------|
| `transactions_analysis.sql` | SQL script containing data cleaning, EDA, and business insight queries |
| `dashboard.pbix` | Interactive Power BI dashboard with visualizations and slicers |


## Data Cleaning

- Removed duplicate records using `ROW_NUMBER()` with `PARTITION BY`
- Validated all columns for null values and empty strings
- Standardized values in the `Gender` field for consistency


## Exploratory Data Analysis

The analysis included:

- Total and average spending by category
- Monthly and yearly transaction trends
- Top customers ranked by total spend
- Gender-based transaction counts and revenue
- Revenue contribution by category


## Business Insights

- Calculated the percentage contribution of each category to total revenue
- Identified the highest-performing transaction category
- Measured average spending per unique customer
- Analyzed customer spending patterns and transaction distribution


## Dashboard Features

The Power BI dashboard includes:

- KPI cards for Total Spend, Average Transaction Value, and Top Category
- Top 3 Transaction Categories
- Distribution of Customer Transaction Sizes
- Monthly Spend Trend combining transaction count and total amount
- Top 5 Customers by Spend
- Interactive slicers for Category, Year/Quarter, and Date Range


## Key Findings

- Travel generated **12.90M** in spending, nearly three times more than Electronics (**4.39M**).
- Monthly spending remained relatively stable between **2.15M** and **2.48M**, indicating minimal seasonality.
- Most transactions were in the **0–1,000** range, suggesting a high volume of low-to-mid value purchases.
- The top five customers spent between **10K** and **19K**, with no single customer dominating total revenue.
- October spending appears lower because the dataset contains transactions only through **October 14, 2023**.
