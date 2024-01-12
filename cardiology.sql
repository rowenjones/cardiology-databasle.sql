-- This database is for use in hospital cardiac diagnostics. It allows for the recording of referrals, waiting times, tests ordered and results. This means that queries
-- can be used to analyse the performance of the department and the waiting times for patients. It allows analysis of the tests ordered depending on patient symptoms and the
-- results from the tests performed. The Database can be updated if the patient undergoes further tests and results can also be added. Patients are identified by their ID number.
-- Tables are connected by primary key of ID.

-- Delete database called Cardiology
DROP DATABASE Cardiology;

-- Create database and name it Cardiology
CREATE DATABASE Cardiology;
 
 -- Use the Cardiology database to create tables
USE Cardiology;

CREATE TABLE Referral (
	id int NOT NULL UNIQUE,
    Last_name varchar(50),
    First_name varchar(50),
    Date_of_birth date,
    Referral_reason varchar(100) DEFAULT 'Palpitations',
    Doctor varchar(50)
);

CREATE TABLE Tests_ordered (
	Patient_id int NOT NULL UNIQUE,
    Wait_time_days int,
    Test_1 varchar(50),
    Test_2 varchar(50),
    Test_3 varchar(50)
);

CREATE TABLE Echo_results (
	Patient_id int NOT NULL UNIQUE,
    LVEF_percent int,
    Overall_systolic_function varchar(50)
);

CREATE TABLE ECG_results (
	Patient_id int NOT NULL UNIQUE,
    Rhythm varchar(50),
    Rate_bpm int,
    Bundle_branch_block varchar(50),
    AV_block varchar(50)
);

-- Insert data into the tables

INSERT INTO Referral (id, Last_name, First_name, Date_of_birth, Referral_reason, Doctor)
VALUES
(52084, 'Jones', 'Peter', '1986-04-30', 'Dizziness', 'Dr Hart'),
(85466, 'Smith', 'Dorothy', '1975-03-28', DEFAULT, 'Dr Fraser'),
(74699, 'Clary', 'Jacob', '1990-12-01', 'Shortness of breath', 'Dr Hart'),
(42362, 'Philips', 'Sophie', '1945-06-12', 'Swollen legs', 'Dr McDonald'),
(12871, 'Fitzpatrick', 'Matilda', '1958-07-03', 'Hypertension', 'Dr Fraser'),
(94520, 'Jones', 'Peter', '1967-04-16', 'Systolic murmur', 'Dr Choudhury'),
(54287, 'Collins', 'William', '2000-05-06', DEFAULT, 'Dr McDonald'),
(67428, 'Holland', 'Lily', '1945-09-09', 'Pulmonary oedema', 'Dr Dobson'),
(24690, 'Horn', 'Paul', '1972-02-01', 'Dizziness', 'Dr Hart'),
(41284, 'Clarke', 'Lisa', '1988-07-10', 'Systolic murmur', 'Dr Jones');

INSERT INTO Tests_ordered (Patient_id, Wait_time_days, Test_1, Test_2, Test_3)
VALUES
(52084, 21, 'Echo', 'ECG', 'Holter'),
(85466, 52, 'ECG', 'Holter', ''),
(74699, 50, 'Echo', 'ECG', 'Holter'),
(42362, 15, 'Echo', 'ECG', ''),
(12871, 32, '24hr BP', 'ECG', 'Echo'),
(94520, 45, 'Echo', 'ECG', ''),
(54287, 76, 'ECG', 'Holter', ''),
(67428, 29, 'Echo', '', ''),
(24690, 61, 'Echo', 'ECG', 'Holter'),
(41284, 99, 'Echo', '', '');

INSERT INTO Echo_results (Patient_id, LVEF_percent, Overall_systolic_function)
Values
(52084, 70, 'Hyperdynamic'),
(85466, NULL , ''),
(74699, 60, 'Normal'),
(42362, 54, 'Borderline low'),
(12871, 32, 'Severely impaired'),
(94520, 49, 'Impaired'),
(54287, 23, 'Severely impaired'),
(67428, 63, 'Normal'),
(24690, 50, 'Borderline low'),
(41284, 38, 'Impaired');
    
INSERT INTO ECG_results (Patient_id, Rhythm, Rate_bpm, Bundle_branch_block, AV_block)
Values
(52084, 'Sinus', 60, 'LBBB', ''),
(85466, 'Atrial Fibrillation', 120, '', ''),
(74699, 'Sinus', 100, '', 'First degree'),
(42362, '', NULL, '', ''),
(12871, 'Sinus', 40, 'LBBB', 'Complete'),
(94520, 'Atrial flutter', 120, 'RBBB', ''),
(54287, 'Sinus', 110, '', ''),
(67428, '', NULL, '', ''),
(24690, 'Atrial fibrillation', 87, 'RBBB', ''),
(41284, 'SVT', 130, '', '');

-- SELECT *
-- FROM Referral;

-- SELECT *
-- FROM Tests_ordered;

 -- SELECT *
--  FROM Echo_results;

-- SELECT *
-- FROM ECG_results;

-- Update the rhythm in ECG_results if the rate is over 100 and the rhythm is sinus
UPDATE ECG_results AS e
SET Rhythm = 'Sinus Tachycardia'
WHERE e.Rate_bpm > 100 AND e.Rhythm = 'Sinus';

-- SELECT *
-- FROM ECG_results;

-- Add primary and foreign keys to the tables
ALTER TABLE Referral
ADD PRIMARY KEY (id);

-- For Tests_ordered table
ALTER TABLE Tests_ordered
ADD CONSTRAINT FK_Tests_ordered_Patient_id
FOREIGN KEY (Patient_id)
REFERENCES Referral(id);

-- For Echo_results table
ALTER TABLE Echo_results
ADD CONSTRAINT FK_Echo_results_Patient_id
FOREIGN KEY (Patient_id)
REFERENCES Referral(id);

-- For ECG_results table
ALTER TABLE ECG_results
ADD CONSTRAINT FK_ECG_results_Patient_id
FOREIGN KEY (Patient_id)
REFERENCES Referral(id);

-- Delete the rows where there are no ECG/Echo results
DELETE FROM ECG_results AS e
WHERE e.Patient_id = 42362 OR e.Patient_id = 67428;

DELETE FROM Echo_results AS ech
WHERE ech.LVEF_percent IS Null;

-- SELECT *
-- FROM Echo_results;

-- SELECT *
-- FROM ECG_results;

-- Aggregate functions
-- Calculate the average rate in the ECG_results table
SELECT AVG(Rate_bpm)
FROM ECG_results;

-- Find the maximum wait time
SELECT MAX(Wait_time_days)
FROM Tests_ordered;

-- Find the minimum wait time
SELECT MIN(Wait_time_days)
FROM Tests_ordered;

-- Select all the patients who waited more than 30 days and display them in descending order
SELECT *
FROM Tests_ordered AS t
WHERE t.Wait_time_days > 30
ORDER BY t.Wait_time_days DESC;

-- Select all the patients with firt name beginning with L and order them by date of birth
SELECT *
FROM Referral AS r
WHERE r.First_name LIKE 'L%'
ORDER BY r.Date_of_birth ASC;

-- Select the referral reasons as distinct reasons
SELECT DISTINCT Referral_reason
FROM Referral;

-- Count the number of distinct tests ordered for test_1
SELECT COUNT(DISTINCT Test_1) 
FROM Tests_ordered;

-- select all the echo results where the LVEF is 35-49 and order the results in descending order
SELECT *
FROM Echo_results AS Ech
WHERE LVEF_percent BETWEEN 35 and 49
ORDER BY Ech.LVEF_percent DESC;


-- Joins
-- To compare heart rates and rhtyhms with systolic function - not including values which don't exist in either table
SELECT e.Patient_id, e.rate_bpm, e.rhythm, ech.Overall_systolic_function
FROM ECG_results AS e
INNER JOIN Echo_results AS ech
ON e.Patient_id = ech.Patient_id;

-- To compare compare tests ordered by different doctors for symptoms
SELECT r.id, r.Referral_reason, r.Doctor, t.Test_1, t.Test_2, t.Test_3
FROM Referral AS r
LEFT JOIN tests_ordered AS t
ON r.id = t.patient_id
ORDER BY r.Doctor ASC

-- stored procedure to get all patients who are over the age of 50
DELIMITER //
CREATE PROCEDURE GetPatientsOlderThan50()
BEGIN
    DECLARE cutoff_date DATE;
    SET cutoff_date = DATE_SUB(CURDATE(), INTERVAL 50 YEAR);

    SELECT *
    FROM Referral
    WHERE Date_of_birth <= cutoff_date;
END //
DELIMITER ;

CALL GetPatientsOlderThan50();

-- The hospital merges with another hospital and the id's change to include a 0 at the beginning
SELECT
        CONCAT('0', CAST(id AS CHAR)) AS HospitalNumber,
        Last_name,
        First_name,
        Date_of_birth
    FROM Referral;

SELECT
        CONCAT('0', CAST(patient_id AS CHAR)) AS HospitalNumber,
		Wait_time_days,
		Test_1,
		Test_2,
		Test_3
    FROM Tests_ordered;
    
SELECT
        CONCAT('0', CAST(patient_id AS CHAR)) AS HospitalNumber,
		Rhythm,
		Rate_bpm,
		Bundle_branch_block,
		AV_block
    FROM ECG_results;
    
SELECT
        CONCAT('0', CAST(patient_id AS CHAR)) AS HospitalNumber,
		LVEF_percent,
		Overall_systolic_function
    FROM Echo_results;
