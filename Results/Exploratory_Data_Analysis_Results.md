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
