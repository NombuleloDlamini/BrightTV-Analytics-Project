-- Databricks notebook source
-- the system recognizes the date format as 'yyyy-MM-dd'


SELECT CURRENT_DATE() AS today_date;  -- display current date
SELECT CURRENT_TIMESTAMP() AS time; -- display current time

-- converting string to read as a date

SELECT TO_DATE('2026-07-31') AS date;

-- converting a date to read as string/ Extracting parts of date
SELECT TO_CHAR(TO_DATE('2026-07-31'),'yyyy') AS year_id;
SELECT TO_CHAR(TO_DATE('2026-07-31'),'MM') AS Month_id;
SELECT TO_CHAR(TO_DATE('2026-07-31'),'dd') AS day_id;
SELECT YEAR('2026-07-31') AS year_dt; --also for DAY & MONTH
-- DAYNAME/MONTHNAME will return the names(Wed/Jul)

-- date difference: DATEDIFF(end_date,start_date)
SELECT DATEDIFF('2026-07-30','2026-07-11') AS duration;

-- DATE_ADD(date, number of days you want to add)
-- putting a negative interger will subtract(date back)  OR use DATE_SUB()
-- ADD_MONTHS will add number of months

SELECT DATE_ADD('2026-07-11',20) AS new_date;


