-- Databricks notebook source

-- =====================================================================
-- 04. ENGINEER FEATURES
-- Purpose : Apply the cleaning rules from step 03, derive the new
--           analytical fields needed for reporting, and join
--           user_profiles to viewership to produce the analysis-ready
--           dataset used in steps 05 and 06.
--
-- Derived fields:
--   user_profiles -> Region, age_groups, email_flag, sm_flag,
--                     Race, Gender
--   viewership     -> month_id, watch_date, day_of_week, day_name,
--                      day_classification, month_name, Tv_channel,
--                      watch_time, time_of_day, duration,
--                      screen_time_bucket, hour_of_day
--
-- Grain: one row per viewing session, enriched with subscriber
--        attributes (one-to-many join on UserID).
-- =====================================================================

WITH user_profiles AS (
    SELECT
        UserID,
        CASE
            WHEN Province = ' '    THEN 'Uncategorized'
            WHEN Province = 'None' THEN 'Uncategorized'
            ELSE Province
        END AS Region,
        Age,
        CASE
            WHEN Age = 0                  THEN 'Infants'
            WHEN Age BETWEEN 1  AND 12    THEN 'Kids'
            WHEN Age BETWEEN 13 AND 19    THEN 'Teenager'
            WHEN Age BETWEEN 20 AND 35    THEN 'Youth'
            WHEN Age BETWEEN 36 AND 50    THEN 'Adult'
            WHEN Age BETWEEN 51 AND 65    THEN 'Elder'
            WHEN Age > 65                 THEN 'Pensioner'
        END AS age_groups,
        -- NOTE: review this flag before using it downstream - as written
        -- it evaluates to 1 for almost every row. See chat for details.
        CASE
            WHEN (Email IS NOT NULL) OR (Email = ' ') OR (Email NOT IN ('None')) THEN 1
            ELSE 0
        END AS email_flag,
        CASE
            WHEN `Social Media Handle` IS NOT NULL
                OR `Social Media Handle` = ' '
                OR `Social Media Handle` NOT IN ('None') THEN 1
            ELSE 0
        END AS sm_flag,
        CASE
            WHEN Race = 'other' THEN 'None'
            WHEN Race = ' '     THEN 'None'
            ELSE Race
        END AS Race,
        CASE
            WHEN Gender = ' ' THEN 'None'
            ELSE Gender
        END AS Gender
    FROM bright_tv.dataset.user_profiles
),

viewership AS (
    SELECT
        COALESCE(UserID0, UserID4)         AS UserID,
        TO_CHAR(RecordDate2, 'yyyyMM')     AS month_id,
        TO_DATE(RecordDate2)               AS watch_date,
        TO_CHAR(RecordDate2, 'DD')         AS day_of_week,
        DAYNAME(RecordDate2)               AS day_name,
        CASE
            WHEN DAYNAME(RecordDate2) IN ('Sat', 'Sun') THEN 'weekend'
            ELSE 'weekday'
        END AS day_classification,
        MONTHNAME(RecordDate2)             AS month_name,
        CASE
            WHEN Channel2 IN ('SawSee', 'Sawsee') THEN 'SawSee'
            WHEN Channel2 IN (
                'SuperSport Live Events', 'Live on SuperSport',
                'Supersport Live Events', 'DStv Events 1'
            ) THEN 'Live Events'
            ELSE Channel2
        END AS Tv_channel,
        DATE_FORMAT(RecordDate2, 'HH:mm:ss')       AS watch_time,
        DATE_FORMAT(`Duration 2`, 'HH:mm:ss')      AS duration,
        HOUR(RecordDate2)                          AS hour_of_day
    FROM bright_tv.dataset.viewership
),

viewership_enriched AS (
    SELECT
        *,
        CASE
            WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'
            WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
            WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'
            WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'
        END AS time_of_day,
        CASE
            WHEN duration BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min'
            WHEN duration BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min'
            WHEN duration > '00:59:59'                      THEN '03. High Usage: >60 min'
            ELSE '04. No Usage'
        END AS screen_time_bucket
    FROM viewership
)

--------------------------------------------------------------------
-- Final Analysis-Ready Dataset
-- (consider saving this as a view/table, e.g. bright_tv.dataset.vw_analysis_base,
--  so steps 05 and 06 can simply SELECT FROM it)
--------------------------------------------------------------------
SELECT
    COALESCE(A.UserID, B.UserID) AS sub_id,
    A.month_id,
    A.watch_date,
    A.day_of_week,
    A.day_name,
    A.day_classification,
    A.month_name,
    A.Tv_channel,
    A.time_of_day,
    A.hour_of_day,
    A.screen_time_bucket,
    A.duration,
    B.Region,
    B.age_groups,
    B.email_flag,
    B.sm_flag,
    B.Race,
    B.Gender
FROM viewership_enriched AS A
LEFT JOIN user_profiles AS B
    ON A.UserID = B.UserID;
