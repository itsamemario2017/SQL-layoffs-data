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




