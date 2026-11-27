create database case_diabetes;
use case_diabetes;
RENAME TABLE cleaned_clinical_trials TO clinical_trials;

-- 1. Trial Status Funnel & Percentage Share
SELECT 
    study_status,
    COUNT(*) AS total_trials,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS share_pct
FROM clinical_trials
GROUP BY study_status
ORDER BY total_trials DESC;

-- 2. Top 10 Pharma & Institutional Sponsors by Trial Count & Patient Enrollment
SELECT 
    sponsor,
    COUNT(*) AS total_trials,
    SUM(enrollment) AS total_patients_enrolled,
    ROUND(AVG(site_count), 1) AS avg_hospital_sites
FROM clinical_trials
GROUP BY sponsor
ORDER BY total_trials DESC
LIMIT 10;

-- 3. Pharma Industry vs. Academic/Hospital Funder Breakdown
SELECT 
    funder_type,
    COUNT(*) AS trial_count,
    SUM(enrollment) AS total_enrolled,
    ROUND(AVG(enrollment), 0) AS avg_patients_per_trial
FROM clinical_trials
GROUP BY funder_type
ORDER BY trial_count DESC;

-- 4. Drug Pipeline Breakdown & Halt Rate (Terminated / Withdrawn / Suspended) by Phase
SELECT 
    phases,
    COUNT(*) AS total_trials,
    SUM(CASE WHEN study_status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN study_status IN ('TERMINATED', 'WITHDRAWN', 'SUSPENDED') THEN 1 ELSE 0 END) AS halted,
    ROUND(
        SUM(CASE WHEN study_status IN ('TERMINATED', 'WITHDRAWN', 'SUSPENDED') THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS halt_rate_pct
FROM clinical_trials
GROUP BY phases
ORDER BY total_trials DESC;

-- 5. Top 10 Specific Diabetes Sub-Conditions Studied
SELECT 
    primary_condition,
    COUNT(*) AS trial_count,
    SUM(enrollment) AS total_patients
FROM clinical_trials
GROUP BY primary_condition
ORDER BY trial_count DESC
LIMIT 10;

-- 6. Year-over-Year Trial Launch Trend (2015–2026)
SELECT 
    start_year,
    COUNT(*) AS trials_started,
    SUM(enrollment) AS patients_enrolled
FROM clinical_trials
WHERE start_year BETWEEN 2015 AND 2026
GROUP BY start_year
ORDER BY start_year ASC;

-- 7. Rank Top 3 Sponsors Within Each Clinical Phase (Window Function)
WITH sponsor_phase_counts AS (
    SELECT 
        phases,
        sponsor,
        COUNT(*) AS trial_count,
        DENSE_RANK() OVER (PARTITION BY phases ORDER BY COUNT(*) DESC) AS phase_rank
    FROM clinical_trials
    WHERE phases != 'Not Applicable'
    GROUP BY phases, sponsor
)
SELECT phases, sponsor, trial_count, phase_rank
FROM sponsor_phase_counts
WHERE phase_rank <= 3
ORDER BY phases, phase_rank;



