-- Data Cleaning
select*
from layoffs;

-- creating backup table
create table layoffs_staging
like layoffs; 

insert layoffs_staging
select*
from layoffs;

-- Remove duplicates in data

-- Add row numbers this counts similar rows
select*,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

-- making backup table for editing

CREATE TABLE `layoffs_staging3` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insering data to backup table
insert into layoffs_staging3
select*,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- checking all similar rows
with duplicate_cte as
(
select*,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select*
from duplicate_cte
where row_num>1;

-- Removing duplicates
delete
from layoffs_staging3
where row_num>1;

select* 
from layoffs_staging3
where row_num>1;

-- duplicates removed
-- standardizing data
 -- remove spaces from company column

select company, trim(company)
 from layoffs_staging3;
 
 update layoffs_staging3
 set company= trim(company);
 
-- Correcting data
-- Changing cryptocurrency to crypto
select*
 from layoffs_staging3
 where industry like 'Crypto%';

 update layoffs_staging3
 set industry= 'Crypto'
 where  industry like 'Crypto%';
 
 -- Removing . from United States
 
select distinct country
 from layoffs_staging3
 order by 1;
 
 select distinct country
 from layoffs_staging3
 where country like 'United States%';
 
 select distinct country, trim(trailing '.' from  country  )
 from layoffs_staging3
 ;
 
 update layoffs_staging3
 set country= trim(trailing '.' from  country)
 where country like 'United States%';
 
 -- Date formatting from text to date
 select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging3;

update layoffs_staging3
set `date`= str_to_date(`date`, '%m/%d/%Y');

select`date`
from layoffs_staging3;

alter table layoffs_staging3
modify column `date` date;

-- handling null and blank values
-- remove data with no valid exploratory potential having total_laid_off and percentage_laid_off as null
select*
from layoffs_staging3
where total_laid_off is null
and percentage_laid_off is null ;

delete
from layoffs_staging3
where total_laid_off is null
and percentage_laid_off is null ;

select*
from layoffs_staging3
where total_laid_off= ''
and percentage_laid_off='' ; -- no blank values

-- removing blanks from industry

select *
from layoffs_staging3
where industry='';

SELECT *
FROM layoffs_staging3
WHERE industry IS NULL;

update layoffs_staging3
set industry = null
where industry= '';

-- trying to fill null industries if the same company has information but in another row.

select company, industry
from layoffs_staging3
where company like 'Airbnb%';


select t1.company,t1.industry, t2.company, t2.industry
from layoffs_staging3 as t1
join layoffs_staging3 as t2
on t1.company=t2.company
where t1.industry is null and t2.industry is not null;

update layoffs_staging3 as t1
join layoffs_staging3 as t2
on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null and t2.industry is not null;
  
  -- remove row_num column as use over
alter table layoffs_staging3
drop column row_num;

-- Final cleaned data
Select*
from layoffs_staging3;

 








