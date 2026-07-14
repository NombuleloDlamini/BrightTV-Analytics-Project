-- Databricks notebook source
-- Databricks notebook source
-- =====================================================================
-- 05. EXPLORE THE DATA
-- Purpose : Open-ended exploration of the analysis-ready dataset built
--           in step 04, organized around the three business questions
--           from the BRD (who watches, how they engage, what they
--           watch) to surface patterns worth designing the dashboard
--           around.
--
-- TODO: This file is a starting scaffold - the queries below are
-- placeholders. Replace/extend them with your own exploration once
-- step 04's output is saved as a table or view.
-- Source: bright_tv.dataset.vw_analysis_base (or your equivalent)
-- =====================================================================

--------------------------------------------------------------------
-- WHO watches BrightTV? (subscriber demographics)
--------------------------------------------------------------------
-- TODO: distribution of subscribers by Region, age_groups, Gender, Race
SELECT
    Region,
    age_groups,
    Gender,
    COUNT(DISTINCT sub_id) AS subscribers
FROM bright_tv.dataset.vw_analysis_base
GROUP BY Region, age_groups, Gender
ORDER BY subscribers DESC;

--------------------------------------------------------------------
-- HOW do they engage? (viewing behavior)
--------------------------------------------------------------------
-- TODO: sessions and screen time by day_classification, time_of_day
SELECT
    day_classification,
    time_of_day,
    COUNT(*)                       AS sessions,
    COUNT(DISTINCT sub_id)         AS active_viewers
FROM bright_tv.dataset.vw_analysis_base
GROUP BY day_classification, time_of_day
ORDER BY sessions DESC;

-- TODO: screen_time_bucket distribution
SELECT
    screen_time_bucket,
    COUNT(*) AS sessions
FROM bright_tv.dataset.vw_analysis_base
GROUP BY screen_time_bucket
ORDER BY sessions DESC;

--------------------------------------------------------------------
-- WHAT do they watch? (content/channel preferences)
--------------------------------------------------------------------
-- TODO: most-watched channels overall, and by demographic cut
SELECT
    Tv_channel,
    COUNT(*)                       AS sessions,
    COUNT(DISTINCT sub_id)         AS unique_viewers
FROM bright_tv.dataset.vw_analysis_base
GROUP BY Tv_channel
ORDER BY sessions DESC;
