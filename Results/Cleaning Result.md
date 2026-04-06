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
