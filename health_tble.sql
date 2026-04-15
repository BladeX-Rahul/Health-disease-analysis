USE health;
-- Total patients
SELECT COUNT(*) AS total_patients
FROM health_tble;

-- Gender Distribution
SELECT gender, COUNT(*) AS total
FROM health_tble
GROUP BY gender;

-- blood_pressure distribution
SELECT blood_pressure, COUNT(*) AS total
FROM health_tble
GROUP BY blood_pressure;

-- Diabetes percentage
SELECT 
    ROUND(AVG(CAST(diabetes AS FLOAT)) * 100, 2) AS diabetes_percentage
FROM health_tble;

-- Average age by gender
WITH age_cte AS (
    SELECT gender, AVG(age) AS avg_age
    FROM health_tble
    GROUP BY gender
)
SELECT * FROM age_cte;

-- High BP patients with diabetes
WITH high_bp AS (
    SELECT *
    FROM health_tble
    WHERE blood_pressure = 'High'
)
SELECT COUNT(*) AS diabetic_high_bp
FROM high_bp
WHERE diabetes = 1;

-- Rank patients by age
SELECT 
    age,
    gender,
    RANK() OVER (ORDER BY age DESC) AS age_rank
FROM health_tble;

-- Percentage of each BP category
SELECT 
    blood_pressure,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage
FROM health_tble
GROUP BY blood_pressure;


-- High risk Patients
SELECT COUNT(*) AS high_risk_patients
FROM health_tble
WHERE 
    blood_pressure = 'High'
    AND diabetes = 1
    AND age > 50;
    
    
   -- top 3 patients by age group 
    WITH ranked_data AS (
    SELECT 
        *,
        DENSE_RANK() OVER (ORDER BY age DESC) AS rnk
    FROM health_tble
)
SELECT *
FROM ranked_data
WHERE rnk <= 3;


-- rank for high-risk patients
SELECT 
    age,
    blood_pressure,
    diabetes,
    DENSE_RANK() OVER (ORDER BY age DESC) AS risk_rank
FROM health_tble
WHERE diabetes = 1;


-- Rank patients by Cholesterol
SELECT 
    age,
    gender,
    cholesterol,
    DENSE_RANK() OVER (ORDER BY cholesterol DESC) AS chol_rank
FROM health_tble;

-- cholesterol distribution
SELECT cholesterol, COUNT(*) AS total
FROM health_tble
GROUP BY cholesterol;


-- Diabetes and TB patients (high-risk group)
SELECT 
    a.age,
    a.gender,
    a.cholesterol
FROM health_tble a
JOIN health_tble b
ON a.age = b.age
WHERE a.diabetes = 1 
  AND b.tuberculosis = 1;