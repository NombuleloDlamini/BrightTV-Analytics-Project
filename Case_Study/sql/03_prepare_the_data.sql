-- Databricks notebook source
--==============================================
-- 03. PREPARE THE DATA
-- ================================================

------------------------------------------------
-- Gender: standardize blanks/None to 'Unkown'
-- What if 'None' means user "prefered not to say"???

------------------------------------------------
SELECT DISTINCT
    COUNT(DISTINCT UserID) AS subs,
    CASE
        WHEN Gender = ' ' THEN 'None'  -- missing/ not captured
        WHEN Gender = 'None' THEN 'Unkown'
        ELSE Gender 
    END AS Gender
FROM bright_tv.dataset.user_profiles
GROUP BY Gender;

------------------------------------------------
-- Race: standardize blanks'/'None' and 'other' to 'Unkown'
------------------------------------------------
SELECT DISTINCT
    CASE
        WHEN Race = 'other' THEN 'Unkown'
        WHEN Race = ' '     THEN 'Unkown'
        WHEN Race = 'None'     THEN 'Unkown'
        ELSE Race
    END AS Race
FROM bright_tv.dataset.user_profiles;

------------------------------------------------
-- Province: standardize blanks/'None' to 'Uncategorized'
-- and rename the field to Region for reporting
------------------------------------------------
SELECT DISTINCT
    CASE
        WHEN Province = ' '    THEN 'Uncategorized'
        WHEN Province = 'None' THEN 'Uncategorized'
        ELSE Province
    END AS Region
FROM bright_tv.dataset.user_profiles;

-- COMMAND ----------


