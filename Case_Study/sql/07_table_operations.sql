-- Databricks notebook source
-- creatind a database in databricks --
CREATE CATALOG IF NOT EXISTS course_enrollment;

USE CATALOG course_enrollment;

-- CREATE SCHEMA IF NOT EXISTS students_hh;
-- To drop is to delete schema --
--==DROP SCHEMA students_hh;

CREATE SCHEMA IF NOT EXISTS students;

-- ceating a table in a database and given schema --
CREATE OR REPLACE TABLE course_enrollment.students.profiles (
    student_ID INT,
    name STRING,
    surname STRING,
    age INT,
    email STRING,
    registration_dt DATE);

INSERT INTO course_enrollment.students.profiles
    VALUES
        (101, 'Rochester', 'Jones', 28, 'roch@google.com', '2019-01-18'),
        (102, 'Sive', 'Mgazi', 21, 'sive@gmail.com', '2022-01-28'),
        (103, 'Estella', 'James', 24, 'stellaR@yahoo.com', '2023-02-15');
SELECT *
FROM course_enrollment.students.profiles;

UPDATE course_enrollment.students.profiles
SET age = 25
WHERE student_ID = 101;



