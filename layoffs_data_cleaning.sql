-- =========================================================
-- Layoffs Dataset Data Cleaning
-- Author: Nadim Abdu Nassar
-- Tool: MySQL
--
-- Objective:
-- Clean and standardize the layoffs dataset to prepare it
-- for further analysis.
--
-- Cleaning steps:
-- 1. Remove duplicate records
-- 2. Standardize text fields
-- 3. Handle NULL and blank values
-- 4. Remove unnecessary columns
-- =========================================================


-- ---------------------------------------------------------
-- STEP 1: Create staging table to preserve original dataset
-- ---------------------------------------------------------

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;



-- ---------------------------------------------------------
-- STEP 2: Identify duplicate records using ROW_NUMBER()
-- ---------------------------------------------------------

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;



-- ---------------------------------------------------------
-- STEP 3: Create second staging table with row numbers
-- ---------------------------------------------------------

CREATE TABLE layoffs_staging2 (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT DEFAULT NULL,
percentage_laid_off TEXT,
`date` TEXT,
stage TEXT,
country TEXT,
funds_raised_millions INT DEFAULT NULL,
row_num INT
);


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;



-- ---------------------------------------------------------
-- STEP 4: Remove duplicate rows
-- ---------------------------------------------------------

DELETE
FROM layoffs_staging2
WHERE row_num > 1;



-- ---------------------------------------------------------
-- STEP 5: Standardize company names (remove extra spaces)
-- ---------------------------------------------------------

UPDATE layoffs_staging2
SET company = TRIM(company);



-- ---------------------------------------------------------
-- STEP 6: Standardize industry names
-- Example: convert variations of 'Crypto'
-- ---------------------------------------------------------

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



-- ---------------------------------------------------------
-- STEP 7: Standardize country names
-- Remove trailing periods
-- ---------------------------------------------------------

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States';



-- ---------------------------------------------------------
-- STEP 8: Convert date column to proper DATE format
-- ---------------------------------------------------------

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- ---------------------------------------------------------
-- STEP 9: Handle blank industry values
-- Convert empty strings to NULL
-- ---------------------------------------------------------

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';



-- ---------------------------------------------------------
-- STEP 10: Populate missing industry values
-- using other rows from the same company
-- ---------------------------------------------------------

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;



-- ---------------------------------------------------------
-- STEP 11: Remove rows with no layoff data
-- ---------------------------------------------------------

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



-- ---------------------------------------------------------
-- STEP 12: Remove helper column used for duplicate detection
-- ---------------------------------------------------------

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
