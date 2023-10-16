-- This SQL query combines daily activity data with daily step totals.
-- It joins rows where id and activity_date match between two tables.

SELECT 
	*, 	-- Selecting all column from the dailyActive
	CASE 
	-- Determine the level of activity based on the "step_total" column.
	
        -- If "step_total" is greater than 10,000, it's considered Very Active.
        WHEN step_total > 10000
        THEN 'Very Active'
		
        -- If "step_total" is between 7,500 and 9,999, it's Moderately Active.
        WHEN step_total BETWEEN 7500 AND 9999
        THEN 'Moderately Active'
		
        -- If "step_total" is between 5,000 and 7,499, it's Light Active.
        WHEN step_total BETWEEN 5000 AND 7499
        THEN 'Light Active'
		
        -- For "step_total" values below 5,000, it's considered Sedentary.
        ELSE 'Sedentary'
    
    -- Create a new column 'active_distance_level' based on the CASE conditions	
    END active_distance_level
FROM 
	(SELECT
		dailyActivity.*,               -- All columns from dailyActivity
		dailySteps.step_total          -- step_total from dailySteps
	FROM public."dailyActivity" dailyActivity

	-- Joining dailyActivity and dailySteps on id
    -- And joining dailyActivity on activity_date and dailySteps on activity_day
	JOIN public."dailySteps" dailySteps
	ON dailyActivity.id = dailySteps.id
	AND dailyActivity.activity_date = dailySteps.activity_day) dailyActive