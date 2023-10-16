-- This SQL query combines data from multiple tables related to minute-level health data.
-- 	● minuteCaloriesNarrow
-- 	● minuteIntensitiesNarrow
-- 	● minuteMETs
-- 	● minuteStepsNarrow
-- It joins rows where id and activity_minute match across four tables.

SELECT 
	*,  -- Selecting all column from the minuteActive
	CASE
	-- Determine the intensity level based on the "intensity" column.
	
		-- If intensity is 3, it's classified as 'Moderate'
		WHEN intensity = 3
		THEN 'Moderate'
		
		-- If intensity is 2, it's classified as 'Light'
		WHEN intensity = 2
		THEN 'Light'
		
		-- If intensity is 1, it's classified as 'Very Light'
		WHEN intensity = 1
		THEN 'Very Light'
		
		-- If intensity is 0, it's classified as 'Nothing'
		WHEN intensity = 0
		THEN 'Nothing'
		
	-- Create a new column 'intensity_level' based on the CASE conditions	
	END intensity_level,
	
	CASE
	-- Determine the mets level based on the "mets" column.
	
		-- If mets greater than 6, it's classified as 'Vigorous Intensity'
		WHEN mets > 6
		THEN 'Vigorous Intensity'
		
		-- If mets is between 3.01 and 6, it's 'Moderate Intensity'
		WHEN mets BETWEEN 3.01 AND 6
		THEN 'Moderate Intensity'
		
		-- If mets is between 1.6 and 3, it's 'Light Intensity'
		WHEN mets BETWEEN 1.6 AND 3
		THEN 'Light Intensity'
		
		-- If mets is between 0 and 1.59, it's 'Just Sedentary'
		WHEN mets BETWEEN 0 AND 1.59
		THEN 'Sedentary'
		
	-- Create a new column 'mets_level' based on the CASE conditions	
	END mets_level
	
FROM
	(SELECT 
		minuteCalories.*,                 -- All columns from minuteCaloriesNarrow
		minuteIntensities.intensity,      -- intensity from minuteIntensitiesNarrow
		minuteMETs.mets,                  -- mets from minuteMETs
		minuteSteps.steps                 -- steps from minuteStepsNarrow
	FROM public."minuteCaloriesNarrow" minuteCalories

	-- Joining minuteCalories and minuteIntensities on id and activity_minute
	JOIN public."minuteIntensitiesNarrow" minuteIntensities
	ON minuteCalories.id = minuteIntensities.id
	AND minuteCalories.activity_minute = minuteIntensities.activity_minute

	-- Joining minuteCalories and minuteMETs on id and activity_minute
	JOIN public."minuteMETs" minuteMETs
	ON minuteCalories.id = minuteMETs.id
	AND minuteCalories.activity_minute = minuteMETs.activity_minute

	-- Joining minuteCalories and minuteSteps on id and activity_minute
	JOIN public."minuteStepsNarrow" minuteSteps
	ON minuteCalories.id = minuteSteps.id
	AND minuteCalories.activity_minute = minuteSteps.activity_minute) minuteActive
