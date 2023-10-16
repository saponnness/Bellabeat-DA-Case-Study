-- This SQL query combines data from three tables: 
-- 	● hourlyCalories 
-- 	● hourlyIntensities 
-- 	● hourlySteps
-- It joins rows where the id and activity_hour columns match in all three tables.

SELECT 
    hourlyCalories.*,           		 -- All columns from hourlyCalories
    hourlyIntensities.total_intensity,   -- Total intensity from hourlyIntensities
    hourlyIntensities.average_intensity, -- Average intensity from hourlyIntensities
    hourlySteps.step_total               -- Step total from hourlySteps
FROM
    public."hourlyCalories" hourlyCalories
	
-- Joining hourlyCalories and hourlyIntensities on id and activity_hour
JOIN public."hourlyIntensities" hourlyIntensities
ON hourlyCalories.id = hourlyIntensities.id 
AND hourlyCalories.activity_hour = hourlyIntensities.activity_hour

-- Joining hourlyCalories and hourlySteps on id and activity_hour
JOIN public."hourlySteps" hourlySteps
ON hourlyCalories.id = hourlySteps.id 
AND hourlyCalories.activity_hour = hourlySteps.activity_hour
