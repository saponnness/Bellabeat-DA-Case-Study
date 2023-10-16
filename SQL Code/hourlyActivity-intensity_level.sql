-- This SQL query combines data from three tables: 
-- 	● hourlyCalories 
-- 	● hourlyIntensities 
-- 	● hourlySteps
-- It joins rows where the id and activity_hour columns match in all three tables.

SELECT 
	*,  -- Selecting all column from the hourlyActive
	CASE
	-- Determine the intensity level based on the "total_intensity" column.
	
		-- If total_intensity is 180, it's classified as 'Moderate'
		WHEN total_intensity = 180
		THEN 'Moderate'
		
		-- If total_intensity is between 120 and 179, it's 'Light'
		WHEN total_intensity BETWEEN 120 AND 179
		THEN 'Light'
		
		-- If total_intensity is between 60 and 119, it's 'Very Light'
		WHEN total_intensity BETWEEN 60 AND 119
		THEN 'Very Light'
		
		-- If total_intensity is between 0 and 59, it's 'Just Noticeable'
		WHEN total_intensity BETWEEN 30 AND 59
		THEN 'Just Noticeable'
		
		-- If total_intensity is between 0 and 29, it's 'Nothing'
		WHEN total_intensity BETWEEN 0 AND 29
		THEN 'Nothing'
		
	-- Create a new column 'intensity_level' based on the CASE conditions	
	END intensity_level
	
FROM
	(SELECT 
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
	AND hourlyCalories.activity_hour = hourlySteps.activity_hour) hourlyActive
