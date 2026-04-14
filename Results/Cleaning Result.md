Data Cleaning Results of Layoffs Data

``select*
from layoffs;``
<img width="801" height="145" alt="image" src="https://github.com/user-attachments/assets/297f62b0-c2a1-41fd-a99b-099a02e8036a" />

-- creating backup table
``create table layoffs_staging
like layoffs;`` 

``insert layoffs_staging
select*
from layoffs;``

--Remove duplicates in data
-- Add row numbers this counts similar rows
``select*,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;``
<img width="920" height="150" alt="image" src="https://github.com/user-attachments/assets/223e9c73-dde6-4352-943a-3f94d3368218" />

-- making backup table for editing
``CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int -- adding row column
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;``

-- insering data to backup table
``insert into layoffs_staging3
select*,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;``

-- checking all similar rows
``with duplicate_cte as
(
select*,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging3
)
select*
from duplicate_cte
where row_num>1;``
<img width="930" height="125" alt="Screenshot 2026-04-06 172020" src="https://github.com/user-attachments/assets/58ed52c3-93ea-43ae-8731-22480787dd68" />

-- Removing duplicates
``delete
from layoffs_staging3
where row_num>1;``

``select* 
from layoffs_staging3
where row_num>1;``
<img width="891" height="135" alt="image" src="https://github.com/user-attachments/assets/e299fbdd-dde1-4c56-8c47-9c35d14206d6" />

-- duplicates removed
-- standardizing data

 -- remove spaces from company column
``select company, trim(company)
 from layoffs_staging3;``
 <img width="211" height="133" alt="image" src="https://github.com/user-attachments/assets/d52b2c2d-1d22-44b5-90c3-10f3a72d9075" />
 
`` update layoffs_staging3
 set company= trim(company);``

 -- Correcting data
 
-- Changing cryptocurrency to crypto. In industry column it is written crypto and crypto currency which means the same. Therefore need to standardize
``select*
 from layoffs_staging3
 where industry like 'Crypto%';``
 <img width="897" height="147" alt="image" src="https://github.com/user-attachments/assets/077389a1-6f68-4839-8bac-2edb086e463b" />

 ``update layoffs_staging3
 set industry= 'Crypto'
 where  industry like 'Crypto%';``
**<img width="918" height="127" alt="image" src="https://github.com/user-attachments/assets/3f54414a-cb7e-41ef-9477-d310060afe74" />

 -- Removing '.' from United States using trim trailing. (Standardizing Data)
``select distinct country
 from layoffs_staging3
 order by 1;``
<img width="247" height="142" alt="image" src="https://github.com/user-attachments/assets/ae63efac-106b-4eaa-a100-1f9b104e5745" />

``select distinct country
 from layoffs_staging3
 where country like 'United States%';``
<img width="207" height="61" alt="image" src="https://github.com/user-attachments/assets/e6994964-9344-4c37-ac2c-b3f8b3cbbde8" />

``select distinct country, trim(trailing '.' from  country  )
 from layoffs_staging3
 ;``
 <img width="367" height="150" alt="image" src="https://github.com/user-attachments/assets/5475e73e-446d-49d3-ba0b-ff0787916452" />

 ``update layoffs_staging3
 set country= trim(trailing '.' from  country)
 where country like 'United States%';``

 -- Removed '.'
  ``select distinct country
 from layoffs_staging3
 where country like 'United States%';``
 <img width="228" height="115" alt="Screenshot 2026-04-09 214254" src="https://github.com/user-attachments/assets/e1e0cc62-f7cb-4014-b6a9-88a57dbb4a38" />
 
-- Date formatting from text to date
``select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging3;``
<img width="526" height="171" alt="image" src="https://github.com/user-attachments/assets/63a0eb3b-8298-41f6-9638-7e525a9e6edd" />

-- Update the table so that the `date` column values are stored as proper DATE type values
``update layoffs_staging3
set `date`= str_to_date(`date`, '%m/%d/%Y');``

-- Alter the table schema to change the `date` column’s datatype from string (VARCHAR) to DATE
``alter table layoffs_staging3
modify column `date` date;``

-- Verify the updated values in the `date` column
``select`date`
from layoffs_staging3;``
<img width="465" height="172" alt="image" src="https://github.com/user-attachments/assets/f71f8c60-dd2a-4c71-8d51-50a642f3fbcf" />

``  select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging3;``
<img width="321" height="158" alt="image" src="https://github.com/user-attachments/assets/6b70f379-c00a-4049-813f-a22dea3fb0f3" />

-- handling null and blank values
-- remove data with no valid exploratory potential having total_laid_off and percentage_laid_off as null

``select*
from layoffs_staging3
where total_laid_off is null
and percentage_laid_off is null ;``
<img width="922" height="144" alt="Screenshot 2026-04-09 220851" src="https://github.com/user-attachments/assets/8b89cf88-c009-4965-a6e1-69d3fb24ba75" />

-- Deleting the rows having both total_laid_off and percentage_laid_off as null
``delete
from layoffs_staging3
where total_laid_off is null
and percentage_laid_off is null ;``

-- Rows deleted 
``select*
from layoffs_staging3
where total_laid_off is null
and percentage_laid_off is null ;``
<img width="929" height="177" alt="Screenshot 2026-04-09 230353" src="https://github.com/user-attachments/assets/f05a8263-9d69-4ff3-9e95-c2ad28a43e71" />

-- Checking if ' ' values exist in both instead of null.
``select*
from layoffs_staging3
where total_laid_off= ''
and percentage_laid_off='' ;``
<img width="928" height="163" alt="image" src="https://github.com/user-attachments/assets/0265420f-5dfe-4526-a0c7-c01d67a0e1b1" />
-- no blank ' ' values

-- removing blanks from industry
``select *
from layoffs_staging3
where industry='';``
<img width="765" height="90" alt="Screenshot 2026-04-14 200038" src="https://github.com/user-attachments/assets/e08b2ae1-1264-49bb-be5e-9e171fafeaa4" />

``SELECT *
FROM layoffs_staging3
WHERE industry IS NULL;``
<img width="832" height="87" alt="image" src="https://github.com/user-attachments/assets/0842273a-a319-42c4-9a8f-e99c54f1f5b4" />

``update layoffs_staging3
set industry = null
where industry= '';``
-- all blanks in industry column changed to Null <img width="935" height="117" alt="image" src="https://github.com/user-attachments/assets/9d669dc0-fe07-4807-89f9-86525b0a71fd" />







