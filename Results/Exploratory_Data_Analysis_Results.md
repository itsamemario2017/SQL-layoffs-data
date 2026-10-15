-- exploratory data analytics
`select*
from layoffs_staging3;`
<img width="1280" height="236" alt="Screenshot 2026-05-25 221258" src="https://github.com/user-attachments/assets/e18dbe53-efbc-4a94-a603-c4d2cc32487d" />

-- checking max total laid off done by a company with its max percentage laid off
`select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging3;` 
<img width="1222" height="194" alt="Screenshot 2026-05-25 221411" src="https://github.com/user-attachments/assets/7e9acedd-c9f3-49af-8256-89fac6e739a5" /> -- shows a company laying off 12000 employess with 1 meaning 100 percent of the company.

-- checking companies having 1 (100%) layoffs in the dataset, and the number of them with seeing which had the max number of laid off
`select company, location, industry, total_laid_off, percentage_laid_off, stage, country, row_number() over(order by total_laid_off desc) as total_row
from layoffs_staging3
where percentage_laid_off=1
;` <img width="1253" height="252" alt="Screenshot 2026-05-25 221641" src="https://github.com/user-attachments/assets/790a204b-1264-4c1f-89ee-6f63d2327421" /> -- although the action output shows number of rows present this is also another way to check using window functions that around 116 companies laid off all there employees in a given location in the dataset.
-- And Katerra laid off max number of their employees.

-- Checking which company who laid off all their employees had maximum funds raised
`select*
from layoffs_staging3
where percentage_laid_off=1
ORDER by funds_raised_millions desc;`
<img width="1272" height="235" alt="Screenshot 2026-05-25 221845" src="https://github.com/user-attachments/assets/547107e5-d70e-46b8-9b98-d703402bcd6d" /> -- British volt had maximum funds raised.

-- Check maximum total laid of done by comapnies in total by order. 
`select company, sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc;` 
<img width="927" height="257" alt="image" src="https://github.com/user-attachments/assets/1e767557-c02f-42ac-aff7-ca9512a52db1" /> -- This indicates Amazon followed by Google, Meta and Salesforce laid off maximum employees in total present in the dataset.

-- Checking which years of layoffs are covered in the dataset.
`select min(`date`), max(`date`)
from layoffs_staging3;`
<img width="933" height="266" alt="image" src="https://github.com/user-attachments/assets/21d5e90e-656f-49c8-b9f3-e9b7b8444d9e" /> -- Therefore the dataset contains layoffs from year 2020 to year 2023 (Showing job market distruption during covid era)

-- Now checking which industries has max layoffs in the dataset
`select industry, sum(total_laid_off)
from layoffs_staging3
group by industry
order by 2 desc;`
<img width="922" height="257" alt="image" src="https://github.com/user-attachments/assets/e3e58ff3-b21a-4734-b29c-c71199985059" />  -- The query shows Consumer got hit the worst follwed by Retail. Manufacturing, Fin-Tech Aerospace had minimum layoffs.

 -- Checking maximum layoffs by country in total.
 `select country, sum(total_laid_off)
from layoffs_staging3
group by country
order by 2 desc;`
<img width="925" height="260" alt="image" src="https://github.com/user-attachments/assets/367c6a47-b91a-46ba-91b1-b63fe556b74f" /> -- The United States recorded the highest number of layoffs, far exceeding those in India (613%), which ranked second.

-- To check layoffs per year
`select year(`date`), sum(total_laid_off)
from layoffs_staging3
group by YEAR (`date`)
order by 1 desc;`
<img width="930" height="238" alt="image" src="https://github.com/user-attachments/assets/d0c0fb90-794b-4294-af45-fb4687be575d" /> -- 2023 had the most layoffs

-- checking most layoffs per stage
`select stage, sum(total_laid_off)
from layoffs_staging3
group by stage
order by 2 desc;`
<img width="927" height="262" alt="image" src="https://github.com/user-attachments/assets/02fa00bf-ac0b-49f9-96ed-cf81c90d27de" /> -- Post-IPO stage companies had the most layoffs (Also has high employee counts)

-- progression of layoffs with time using cte and window functions (rolling total) 
`with wow as
(
select substring(`date` ,1,7) as month_and_year, sum(total_laid_off) as total
from layoffs_staging3
group by month_and_year
having month_and_year is not null
order by 1
)
select month_and_year, total, sum(total) over(order by month_and_year) as progession_of_layoff
from wow;`
<img width="928" height="266" alt="image" src="https://github.com/user-attachments/assets/3c059c7a-276d-4f92-b1b6-bbf83653c1f8" />
<img width="934" height="261" alt="Screenshot 2026-05-29 231656" src="https://github.com/user-attachments/assets/4da85998-4ce8-49f2-8a13-84a62fb8c048" />
<img width="930" height="255" alt="Screenshot 2026-05-29 231738" src="https://github.com/user-attachments/assets/be850618-9345-41b8-b85c-db7ee32a3a96" /> -- therefore total 383159 layoffs in the dataset

-- Top 5 layoffs by companies per year.

-- Checking total laid off by each company (Amazon has the highest in the dataset)
`select company, sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc;`
<img width="638" height="178" alt="image" src="https://github.com/user-attachments/assets/e934aa8a-b794-48a1-bcd2-b62f9846b3ba" />

-- Checking total laid off by companies per year (Google in 2023 laid off highest)
`select company,year(`date`) as date_year, sum(total_laid_off)
from layoffs_staging3
group by company,year(`date`)
order by 3 desc ;`
<img width="1265" height="262" alt="image" src="https://github.com/user-attachments/assets/3aa18d56-3769-4eea-846e-ba41f5004168" />

-- Finally to check top 5 layoffs by companies per year (Using dense ranking) 
`with company_year (company,years, total_laid_off) as
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
where ranking <=5;` -- 2020 Uber had the most layoffs, 2021 Bytedance , 2022 Meta, 2023 Google had the most layoffs.
<img width="1350" height="262" alt="Screenshot 2026-10-15 192246" src="https://github.com/user-attachments/assets/394c0a97-b7ef-46ac-9fa9-258c94486d59" />
<img width="1355" height="291" alt="Screenshot 2026-10-15 192320" src="https://github.com/user-attachments/assets/9557d3bc-9a01-430e-94ff-ca7d987a300c" />
<img width="1391" height="257" alt="image" src="https://github.com/user-attachments/assets/50aa2e71-59d3-4dd5-90aa-d39645f996ad" />















