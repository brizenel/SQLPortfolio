/*   
Data Exploration
Skills Used: Data Cleansing, Aggregate Functions, Aliases, Wildcards, Operators 
*/

SELECT *
FROM [K-12VacRecs]

-- Data Cleansing

DELETE FROM [K-12VacRecs]
WHERE K_12_enrollment IS NULL OR K_12_enrollment = 0
EXEC sp_rename 'K-12VacRecs.School_Name', 'School', 'COLUMN'
EXEC sp_rename 'K-12VacRecs.K_12_enrollment', 'Enrollment', 'COLUMN'
EXEC sp_rename 'K-12VacRecs.Number_complete_for_all_immunizations', 'TotalImmunizations', 'COLUMN'
EXEC sp_rename 'K-12VacRecs.Number_with_any_exemption', 'TotalExemptions', 'COLUMN'
EXEC sp_rename 'K-12VacRecs.Number_with_personal_exemption', 'PersonalExemption', 'COLUMN'
EXEC sp_rename 'K-12VacRecs.Number_with_medical_exemption', 'MedicalExemption', 'COLUMN'
EXEC sp_rename 'K-12VacRecs.Number_with_religious_exemption', 'ReligiousExemption', 'COLUMN'

--Data we are going to be starting with

SELECT School, Enrollment, TotalImmunizations, TotalExemptions, PersonalExemption, MedicalExemption, ReligiousExemption
FROM [K-12VacRecs]

-- Show the schools where every student is immunized 

SELECT School, Enrollment, TotalImmunizations
FROM [K-12VacRecs]
WHERE Enrollment = TotalImmunizations
ORDER BY 1

--Show the schools and their immunization numbers from highest to lowest

SELECT School, TotalImmunizations 
FROM [K-12VacRecs]
ORDER BY 2 DESC

-- Show the highest number of immunized students

SELECT MAX(TotalImmunizations) as HighestImmunizationCount
FROM [K-12VacRecs]

-- Show religious exemptions of schools with 'Academy' or 'City' in the name

SELECT School, ReligiousExemption
FROM [K-12VacRecs]
WHERE School LIKE '%Academy%' OR School LIKE '%City%'

--Show a few schools where number of students exempt from Polio vaccine is higher than 50

SELECT TOP 10 School
FROM [K-12VacRecs]
WHERE PolioExemption > 50

-- Classify the remaining exemptions

SELECT School,
CASE   
    WHEN MedicalExemption >= 30 THEN 'High'
	ELSE 'Low'
END AS 'MedicalExemptionRank',
CASE
     WHEN PersonalExemption >= 30 THEN 'High' 
	 ELSE 'Low'
END AS 'PersonalExemptionRank'
FROM [K-12VacRecs]