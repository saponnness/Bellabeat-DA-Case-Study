-- This SQL query combines daily activity data with daily step totals.
-- It joins rows where id and activity_date match between two tables.

SELECT
	dailyActivity.*,               -- All columns from dailyActivity
	dailySteps.step_total          -- step_total from dailySteps
FROM public."dailyActivity" dailyActivity

-- Joining dailyActivity and dailySteps on id
-- And joining dailyActivity on activity_date and dailySteps on activity_day
JOIN public."dailySteps" dailySteps
ON dailyActivity.id = dailySteps.id
AND dailyActivity.activity_date = dailySteps.activity_day
