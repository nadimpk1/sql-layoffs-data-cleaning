# Layoffs Data Cleaning (SQL)

## Project Overview

This project focuses on cleaning and preparing a layoffs dataset using SQL.  
The objective is to transform raw data into a structured and consistent format that can be used for further analysis and reporting.

The cleaning process includes identifying duplicate records, standardizing text fields, handling missing values, and ensuring consistency across the dataset.

---

## Dataset

The dataset contains information about layoffs reported by companies across multiple industries and locations.

Key columns in the dataset include:

- **company** – Name of the company  
- **location** – City or region where layoffs occurred  
- **industry** – Industry sector of the company  
- **total_laid_off** – Number of employees laid off  
- **percentage_laid_off** – Percentage of workforce affected  
- **date** – Date when layoffs occurred  
- **stage** – Funding stage of the company  
- **country** – Country where the company operates  
- **funds_raised_millions** – Total funding raised by the company  

---

## Data Cleaning Steps

The following data cleaning steps were performed using SQL:

1. Created staging tables to preserve the original dataset.
2. Identified duplicate records using window functions.
3. Removed duplicate records from the dataset.
4. Standardized company names by removing extra spaces.
5. Standardized industry categories (for example consolidating variations of "Crypto").
6. Standardized country names by removing trailing punctuation.
7. Converted date values into proper SQL DATE format.
8. Replaced blank values with NULL where appropriate.
9. Filled missing industry values using matching records from the same company.
10. Removed rows containing no layoff information.
11. Dropped helper columns used during the cleaning process.

---

## SQL Skills Demonstrated

This project demonstrates several SQL concepts used in real-world data cleaning workflows:

- Data cleaning and transformation
- Window functions (**ROW_NUMBER**)
- Removing duplicate records
- Handling NULL and blank values
- String standardization and trimming
- Date conversion and formatting
- Table restructuring and column modification

---

## Tools Used

- SQL (MySQL dialect)
- GitHub for version control and project sharing

---

## Example Query

Example query used to identify duplicate rows:

```sql
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, date,
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;
```

---

## Key Insights

Although the primary focus of this project was data cleaning, preparing a clean dataset enables meaningful analysis such as:

- Identifying industries that experienced the highest number of layoffs.
- Tracking layoff trends across different time periods.
- Comparing layoffs across countries or company growth stages.
- Exploring possible relationships between company funding levels and layoffs.

---

## Data Source

The dataset used in this project is derived from the layoffs dataset used in the Data Cleaning in SQL tutorial by Alex The Analyst.

The dataset is used for educational purposes to practice SQL data cleaning techniques.

---

## Course Context

This project was completed while following the Data Cleaning in SQL tutorial from the Alex The Analyst YouTube channel.

The tutorial demonstrates practical SQL techniques used to clean and prepare datasets for analysis.

---

## Author

Nadim Abdu Nassar

Business Analyst | SQL | Excel | Power BI

GitHub: https://github.com/nadimpk1
