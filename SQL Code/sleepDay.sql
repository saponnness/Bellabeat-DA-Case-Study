-- Calculate the difference between "total_time_in_bed" and "total_minutes_asleep" 
-- to get the total time spent before falling asleep.
SELECT 
	*,
	(total_time_in_bed - total_minutes_asleep) AS total_time_before_asleep
FROM public."sleepDay"
