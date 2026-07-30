-- Databricks notebook source
--------------------------------------------------
-- Duplicate Subscribers
--------------------------------------------------

SELECT UserID,
COUNT(*) AS duplicate_count
FROM bright_tv.dataset.user_profiles
GROUP BY UserID
HAVING COUNT(*)>1;

--------------------------------------------------
-- Missing User IDs
--------------------------------------------------

SELECT COUNT(*) AS null_id
FROM bright_tv.dataset.user_profiles
WHERE UserID IS NULL;

--------------------------------------------------
-- Missing Age
--------------------------------------------------

SELECT COUNT(*) AS null_age
FROM bright_tv.dataset.user_profiles
WHERE Age IS NULL;

--------------------------------------------------
-- Age Range
--------------------------------------------------

SELECT MIN(Age),MAX(Age)
FROM bright_tv.dataset.user_profiles;

--------------------------------------------------
-- Missing Gender
--------------------------------------------------

SELECT COUNT(*) AS null_gender
FROM bright_tv.dataset.user_profiles
WHERE Gender=' ';

--------------------------------------------------
-- Missing Province
--------------------------------------------------

SELECT COUNT(*) AS null_province
FROM bright_tv.dataset.user_profiles
WHERE Province=' ';

--------------------------------------------------
-- Missing Race
--------------------------------------------------

SELECT COUNT(*) AS null_race
FROM bright_tv.dataset.user_profiles
WHERE Race=' ';

-- viewership exploration --
SELECT *
FROM bright_tv.dataset.viewership
WHERE userid0 <> userid4;



