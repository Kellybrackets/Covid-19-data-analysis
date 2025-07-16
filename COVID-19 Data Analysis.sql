-- Create database
CREATE DATABASE covid_analysis;
USE covid_analysis;

-- Create main table
CREATE TABLE covid_patients (
    usmer INT,
    medical_unit INT,
    sex INT,
    patient_type INT,
    date_died VARCHAR(10),
    intubed INT,
    pneumonia INT,
    age INT,
    pregnant INT,
    diabetes INT,
    copd INT,
    asthma INT,
    inmsupr INT,
    hipertension INT,
    other_disease INT,
    cardiovascular INT,
    obesity INT,
    renal_chronic INT,
    tobacco INT,
    classification_final INT,
    icu INT
);

--Data Cleaning and Preparation
-- Clean date_died field (9999-99-99 represents patients who survived)
UPDATE covid_patients 
SET date_died = NULL 
WHERE date_died = '9999-99-99';

-- Convert date_died to proper date format for those who died
UPDATE covid_patients 
SET date_died = STR_TO_DATE(date_died, '%d/%m/%Y') 
WHERE date_died IS NOT NULL;

-- Create a survived flag
ALTER TABLE covid_patients ADD COLUMN survived BOOLEAN;
UPDATE covid_patients SET survived = (date_died IS NULL);

-- Clean special values (97, 98, 99 typically represent unknown/missing data)
-- For analysis, we'll treat them as NULL
UPDATE covid_patients SET intubed = NULL WHERE intubed IN (97, 98, 99);
UPDATE covid_patients SET pneumonia = NULL WHERE pneumonia IN (97, 98, 99);
UPDATE covid_patients SET pregnant = NULL WHERE pregnant IN (97, 98, 99);
UPDATE covid_patients SET icu = NULL WHERE icu IN (97, 98, 99);

--Data Exploration and Analysis
--Basic Statistics

-- Total number of patients
SELECT COUNT(*) AS total_patients FROM covid_patients;

-- Mortality rate
SELECT 
    COUNT(*) AS total_patients,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate
FROM covid_patients;

-- Age distribution
SELECT 
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    AVG(age) AS avg_age,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) AS median_age
FROM covid_patients;

-- Gender distribution
SELECT 
    sex,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM covid_patients), 2) AS percentage
FROM covid_patients
GROUP BY sex;

--Risk Factor Analysis
-- Mortality by comorbidity
SELECT 
    'Diabetes' AS comorbidity,
    AVG(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) AS prevalence,
    AVG(CASE WHEN diabetes = 1 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_with,
    AVG(CASE WHEN diabetes = 2 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_without
FROM covid_patients
UNION ALL
SELECT 
    'Hypertension' AS comorbidity,
    AVG(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END) AS prevalence,
    AVG(CASE WHEN hipertension = 1 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_with,
    AVG(CASE WHEN hipertension = 2 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_without
FROM covid_patients
UNION ALL
SELECT 
    'Obesity' AS comorbidity,
    AVG(CASE WHEN obesity = 1 THEN 1 ELSE 0 END) AS prevalence,
    AVG(CASE WHEN obesity = 1 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_with,
    AVG(CASE WHEN obesity = 2 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_without
FROM covid_patients
UNION ALL
SELECT 
    'COPD' AS comorbidity,
    AVG(CASE WHEN copd = 1 THEN 1 ELSE 0 END) AS prevalence,
    AVG(CASE WHEN copd = 1 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_with,
    AVG(CASE WHEN copd = 2 AND survived = 0 THEN 1 ELSE 0 END) AS mortality_without
FROM covid_patients;

--Treatment Outcomes
-- Intubation and mortality
SELECT 
    intubed,
    COUNT(*) AS patient_count,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate
FROM covid_patients
WHERE intubed IS NOT NULL
GROUP BY intubed;

-- ICU admission and outcomes
SELECT 
    icu,
    COUNT(*) AS patient_count,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate
FROM covid_patients
WHERE icu IS NOT NULL
GROUP BY icu;

-- Pneumonia and outcomes
SELECT 
    pneumonia,
    COUNT(*) AS patient_count,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate
FROM covid_patients
WHERE pneumonia IS NOT NULL
GROUP BY pneumonia;

--Age-Specific Analysis
-- Mortality by age group
SELECT 
    CASE 
        WHEN age < 20 THEN '0-19'
        WHEN age BETWEEN 20 AND 39 THEN '20-39'
        WHEN age BETWEEN 40 AND 59 THEN '40-59'
        WHEN age >= 60 THEN '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate
FROM covid_patients
GROUP BY age_group
ORDER BY age_group;

-- Comorbidities by age group
SELECT 
    CASE 
        WHEN age < 20 THEN '0-19'
        WHEN age BETWEEN 20 AND 39 THEN '20-39'
        WHEN age BETWEEN 40 AND 59 THEN '40-59'
        WHEN age >= 60 THEN '60+'
    END AS age_group,
    AVG(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) AS diabetes_rate,
    AVG(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END) AS hypertension_rate,
    AVG(CASE WHEN obesity = 1 THEN 1 ELSE 0 END) AS obesity_rate,
    AVG(CASE WHEN copd = 1 THEN 1 ELSE 0 END) AS copd_rate
FROM covid_patients
GROUP BY age_group
ORDER BY age_group;

--Time-Based Analysis
-- Mortality over time (monthly)
SELECT 
    YEAR(date_died) AS year,
    MONTH(date_died) AS month,
    COUNT(*) AS death_count
FROM covid_patients
WHERE date_died IS NOT NULL
GROUP BY YEAR(date_died), MONTH(date_died)
ORDER BY year, month;

-- Compare early vs late pandemic outcomes
SELECT 
    CASE 
        WHEN date_died IS NULL THEN 'Survived'
        WHEN date_died < '2020-04-01' THEN 'Early pandemic (before April 2020)'
        ELSE 'Later pandemic (April 2020 or after)'
    END AS period,
    COUNT(*) AS patient_count,
    AVG(age) AS avg_age,
    AVG(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) AS diabetes_rate,
    AVG(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END) AS hypertension_rate,
    AVG(CASE WHEN intubed = 1 THEN 1 ELSE 0 END) AS intubation_rate,
    AVG(CASE WHEN icu = 1 THEN 1 ELSE 0 END) AS icu_rate
FROM covid_patients
GROUP BY period;

--Risk Factor Combinations
-- Mortality for patients with multiple comorbidities
SELECT 
    (diabetes + hipertension + obesity + copd) AS comorbidity_count,
    COUNT(*) AS patient_count,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate
FROM covid_patients
WHERE diabetes IN (1,2) AND hipertension IN (1,2) AND obesity IN (1,2) AND copd IN (1,2)
GROUP BY comorbidity_count
ORDER BY comorbidity_count;

--Predictive Factors for ICU Admission
-- Factors associated with ICU admission
SELECT 
    'Age ≥ 60' AS factor,
    AVG(CASE WHEN age >= 60 AND icu = 1 THEN 1 ELSE 0 END) AS icu_rate_with_factor,
    AVG(CASE WHEN age < 60 AND icu = 1 THEN 1 ELSE 0 END) AS icu_rate_without_factor
FROM covid_patients
WHERE icu IS NOT NULL
UNION ALL
SELECT 
    'Diabetes' AS factor,
    AVG(CASE WHEN diabetes = 1 AND icu = 1 THEN 1 ELSE 0 END) AS icu_rate_with_factor,
    AVG(CASE WHEN diabetes = 2 AND icu = 1 THEN 1 ELSE 0 END) AS icu_rate_without_factor
FROM covid_patients
WHERE icu IS NOT NULL AND diabetes IS NOT NULL
UNION ALL
SELECT 
    'Hypertension' AS factor,
    AVG(CASE WHEN hipertension = 1 AND icu = 1 THEN 1 ELSE 0 END) AS icu_rate_with_factor,
    AVG(CASE WHEN hipertension = 2 AND icu = 1 THEN 1 ELSE 0 END) AS icu_rate_without_factor
FROM covid_patients
WHERE icu IS NOT NULL AND hipertension IS NOT NULL;

--Survival Analysis by Treatment
-- Survival rates by treatment combination
SELECT 
    CASE 
        WHEN intubed = 1 AND icu = 1 THEN 'Intubated and ICU'
        WHEN intubed = 1 THEN 'Intubated only'
        WHEN icu = 1 THEN 'ICU only'
        ELSE 'Neither'
    END AS treatment_group,
    COUNT(*) AS patient_count,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deceased_count,
    ROUND(SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate,
    AVG(age) AS avg_age
FROM covid_patients
WHERE intubed IS NOT NULL AND icu IS NOT NULL
GROUP BY treatment_group
ORDER BY mortality_rate DESC;

---- Mortality trend by month (for line chart)
SELECT 
    YEAR(date_died) AS year,
    MONTH(date_died) AS month,
    COUNT(*) AS death_count,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM covid_patients WHERE date_died IS NOT NULL) AS percentage_of_total_deaths
FROM covid_patients
WHERE date_died IS NOT NULL
GROUP BY YEAR(date_died), MONTH(date_died)
ORDER BY year, month;

-- Comorbidity prevalence (for bar chart)
SELECT 
    'Diabetes' AS comorbidity,
    AVG(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) * 100 AS prevalence_percentage
FROM covid_patients
UNION ALL
SELECT 
    'Hypertension' AS comorbidity,
    AVG(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END) * 100 AS prevalence_percentage
FROM covid_patients
UNION ALL
SELECT 
    'Obesity' AS comorbidity,
    AVG(CASE WHEN obesity = 1 THEN 1 ELSE 0 END) * 100 AS prevalence_percentage
FROM covid_patients
UNION ALL
SELECT 
    'COPD' AS comorbidity,
    AVG(CASE WHEN copd = 1 THEN 1 ELSE 0 END) * 100 AS prevalence_percentage
FROM covid_patients;

-- Age distribution pyramid (for population pyramid)
SELECT 
    FLOOR(age/5)*5 AS age_group,
    SUM(CASE WHEN sex = 1 THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN sex = 2 THEN 1 ELSE 0 END) AS female_count
FROM covid_patients
GROUP BY FLOOR(age/5)*5
ORDER BY age_group;

