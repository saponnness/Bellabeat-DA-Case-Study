-- This SQL query combines data from multiple tables related to minute-level health data.
-- 	● minuteCaloriesNarrow
-- 	● minuteIntensitiesNarrow
-- 	● minuteMETs
-- 	● minuteStepsNarrow
-- It joins rows where id and activity_minute (or date) match across five tables.

SELECT 
    minuteCalories.*,                 -- All columns from minuteCaloriesNarrow
    minuteIntensities.intensity,      -- intensity from minuteIntensitiesNarrow
    minuteMETs.mets,                  -- mets from minuteMETs
    minuteSleep.log_id,               -- log_id from minuteSleep
    minuteSleep."value",              -- "value" from minuteSleep
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
AND minuteCalories.activity_minute = minuteSteps.activity_minute
