-- exploratory data analytics
select*
from layoffs_staging3;

-- checking max total laid off done by a company with its max percentage laid off
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging3; -- shows a company laying off 12000 employess with 1 meaning 100 percent of the company.

-- checking companies having 1 (100%) layoffs in the dataset, and the number of them with seeing which had the max number of laid off
select company, location, industry, total_laid_off, percentage_laid_off, stage, country, row_number() over(order by total_laid_off desc) as total_row
from layoffs_staging3
where percentage_laid_off=1
;-- although the action output shows number of rows present this is also another way to check using window functions that around 116 companies laid off all there employees in a given location in the dataset.
-- And Katerra laid off max number of their employees.

-- Checking which company who laid off all their employees had maximum funds raised
select*
from layoffs_staging3
where percentage_laid_off=1
ORDER by funds_raised_millions desc;-- British volt had maximum funds raised.

-- Check maximum total laid of done by comapnies in total by order. 
select company, sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc; -- This indicates Amazon followed by Google, Meta and Salesforce laid off maximum employees in total present in the dataset.

-- Checking which years of layoffs are covered in the dataset.
select min(`date`), max(`date`)
from layoffs_staging3;
-- Therefore the dataset contains layoffs from year 2020 to year 2023 (Showing job market distruption during covid era)

-- Now checking which industries has max layoffs in the dataset
select industry, sum(total_laid_off)
from layoffs_staging3
group by industry
order by 2 desc; -- The query shows Consumer got hit the worst follwed by Retail. Manufacturing, Fin-Tech Aerospace had minimum layoffs.
 
 select*
 from layoffs_staging3;
 
 -- Checking maximum layoffs by country in total.
 select country, sum(total_laid_off)
from layoffs_staging3
group by country
order by 2 desc; -- The United States recorded the highest number of layoffs, far exceeding those in India (613%), which ranked second.

-- To check layoffs per year
select year(`date`), sum(total_laid_off)
from layoffs_staging3
group by YEAR (`date`)
order by 1 desc;-- 2023 had the most layoffs

-- checking most layoffs per stage
select stage, sum(total_laid_off)
from layoffs_staging3
group by stage
order by 2 desc; -- Post-IPO stage companies had the most layoffs (Also has maximum employee counts)

-- progression of layoffs with time using cte and window functions (rolling total) 
with wow as
(
select substring(`date` ,1,7) as month_and_year, sum(total_laid_off) as total
from layoffs_staging3
group by month_and_year
having month_and_year is not null
order by 1
)
select month_and_year, total, sum(total) over(order by month_and_year) as progession_of_layoff
from wow; -- therefore total 383159 layoffs in the dataset




-- Top 5 layoffs by companies per year

-- Checking total laid off by each company (Amazon has the highest in the dataset)
select company, sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc;

-- Checking total laid off by companies each year (Google in 2023 laid off highest)
select company,year(`date`) as date_year, sum(total_laid_off)
from layoffs_staging3
group by company,year(`date`)
order by 3 desc ;

-- Finally to check top 5 layoffs by companies per year (Using dense ranking)
with company_year (company,years, total_laid_off) as
(
select company,year(`date`) as date_year, sum(total_laid_off)
from layoffs_staging3
group by company,year(`date`)
) ,company_year_rank as
(select*, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null and total_laid_off is not null
)
select* 
from company_year_rank
where ranking <=5; -- 2020 Uber had the most layoffs, 2021 Bytedance , 2022 Meta, 2023 Google had the most layoffs.



