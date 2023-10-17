![Logo](https://logowik.com/content/uploads/images/bellabeat3809.jpg)

# Bellabeat DA Case-Study

This project provides a thorough case study of the Google Data Analytics Professional Certificate program on Coursera. It focuses on Bellabeat, a high-tech manufacturer of health-focused products for women, and meets different characters and team members.

## Business Task

Identify usage patterns of smart devices to gain insights and use them to guide the company's marketing strategy.

## The Question for Analysis

- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## Dataset Details

- Fitbit Fitness Tracker Data (CC0: Public Domain, dataset made available through Mobius): This Kaggle dataset includes personal fitness tracker data from 30 Fitbit users. 
- The data is stored in 18 .csv files and provides data on physical activity, heart rate, steps, sleep monitoring and more.
- These data are recorded in daily, hourly, and minute formats and are recorded in date ranges. 04.12.2016 to 05.12.2016

## Organization and Transformation of Data

We will use the PostgreSQL tool to organize and transform our data. We chose this tool because it is free to download, highly effective, and easy to use.

### Transformation of the minutesMETs table

We should convert the data in the METs column as several websites suggest that the provided information not exceed 10 METs per minute. However, after researching with ChatGPT, I found that the METs should not exceed 20 per minute. For further information, visit: [Staying Active | The Nutrition Source | Harvard T.H. Chan School of Public Health](https://www.hsph.harvard.edu/nutritionsource/staying-active/).

```SQL
SELECT 
	MAX(mets) max_mets,
	MIN(mets) min_mets
FROM public."minuteMETs"
```

Output:
|      | max_mets | min_mets |
|------|----------|----------|
|  1   |   157    |    0     |

The METs in the minuteMETs table have a maximum value of 157, which is impossible. We conducted a data transformation by dividing the METs column by 10.0 to rectify any erroneous data.

```SQL
UPDATE public."minuteMETs"
SET mets = mets / 10.0
```

Then, we will use the command to recheck the highest and lowest values to verify if our objectives can be achieved.

```SQL
SELECT 
	MAX(mets) max_mets,
	MIN(mets) min_mets
FROM public."minuteMETs"
```

Output:
|   | max_mets | min_mets |
|---|----------|----------|
| 1 |   15.7   |    0     |

It is evident that our METs values are based on reality.

## Organization and Transformation of Data

We will use the PostgreSQL tool to organize and transform our data. We chose this tool because it is free to download, highly effective, and easy to use.

### Transformation of the minutesMETs table

We should convert the data in the METs column as several websites suggest that the provided information not exceed 10 METs per minute. However, after researching with ChatGPT, I found that the METs should not exceed 20 per minute. For further information, visit: [Staying Active | The Nutrition Source | Harvard T.H. Chan School of Public Health](https://www.hsph.harvard.edu/nutritionsource/staying-active/).

```SQL
SELECT 
	MAX(mets) max_mets,
	MIN(mets) min_mets
FROM public."minuteMETs"
```

Output:
|      | max_mets | min_mets |
|------|----------|----------|
|  1   |   157    |    0     |

The METs in the minuteMETs table have a maximum value of 157, which is impossible. We conducted a data transformation by dividing the METs column by 10.0 to rectify any erroneous data.

```SQL
UPDATE public."minuteMETs"
SET mets = mets / 10.0
```

Then, we will use the command to recheck the highest and lowest values to verify if our objectives can be achieved.

```SQL
SELECT 
	MAX(mets) max_mets,
	MIN(mets) min_mets
FROM public."minuteMETs"
```

Output:
|   | max_mets | min_mets |
|---|----------|----------|
| 1 |   15.7   |    0     |

It is evident that our METs values are based on reality.

### Organization and Merging the Data

We need to organize and merge the data. We collect data recorded in the same format:

- Daily Activity
- Hourly Activity
- Minute Activity
- Sleep Activity

#### Daily Activity

We will begin merging data from all tables related to daily activities, which include the tables dailyActivity and dailySteps.

```SQL
SELECT 
	*,  
	CASE 
		WHEN step_total > 10000
		THEN 'Very Active'
  
		WHEN step_total BETWEEN 7500 AND 9999
		THEN 'Moderately Active'
  
		WHEN step_total BETWEEN 5000 AND 7499
		THEN 'Light Active'
  
		ELSE 'Sedentary'
    
	END active_distance_level
FROM 
	(SELECT
		dailyActivity.*,               
		dailySteps.step_total          
	FROM public."dailyActivity" dailyActivity

	JOIN public."dailySteps" dailySteps
	ON dailyActivity.id = dailySteps.id
	AND dailyActivity.activity_date = dailySteps.activity_day) dailyActive
```

Output:
|   |     id      | activity_date | tracker_distance | logged_activity_distance | very_active_distance | moderately_active_distance | light_active_distance | sedentary_active_distance | very_active_minutes | fairly_active_minutes | lightly_active_minutes | sedentary_minutes | calories | step_total | active_distance_level |
|---|------------|---------------|------------------|--------------------------|----------------------|----------------------------|----------------------|--------------------------|---------------------|-----------------------|------------------------|-------------------|----------|------------|-----------------------|
| 1 | 1503960366 |  2016-04-12   |       8.5        |           0              | 1.88                 | 0.55                       | 6.06                 | 0                        |        25           |         13            |        328             |        728        |   1985   |   13162    |     Very Active     |
| 2 | 1503960366 |  2016-04-13   |      6.97        |           0              | 1.57                 | 0.69                       | 4.71                 | 0                        |        21           |         19            |        217             |        776        |   1797   |   10735    |     Very Active     |
| 3 | 1503960366 |  2016-04-14   |      6.74        |           0              | 2.44                 | 0.4                        | 3.91                 | 0                        |        30           |         11            |        181             |       1218        |   1776   |   10460    |     Very Active     |
| 4 | 1503960366 |  2016-04-15   |      6.28        |           0              | 2.14                 | 1.26                       | 2.83                 | 0                        |        29           |         34            |        209             |        726        |   1745   |    9762    |  Moderately Active  |
| 5 | 1503960366 |  2016-04-16   |      8.16        |           0              | 2.71                 | 0.41                       | 5.04                 | 0                        |        36           |         10            |        221             |        773        |   1863   |   12669    |     Very Active     |

The step_total data is pulled from the dailySteps table and merge with the dailyActivity table to obtain complete daily activity data. Additionally, a column named active_distance_level is created to classify tracker_distance into four levels, based on the dailyActivity table:

- Sedentary: less than 5,000 steps per day
- Lightly active: 5,000 to 7,499 steps per day
- Moderately active: 7,500 to 9,999 steps per day
- Very active: more than 10,000 steps per day

The reference for this information can be found at [Counting Your Steps](https://www.10000steps.org.au/articles/healthy-lifestyles/counting-steps/).

#### Hourly Activity

Next, we will follow the same approach as the first method, which involves gathering data from all tables associated with hourly activities. This includes the tables hourlyCalories, hourlyIntensities, and hourlySteps.

```SQL
SELECT 
	*,  
	CASE
		WHEN total_intensity = 180
		THEN 'Moderate'
		
		WHEN total_intensity BETWEEN 120 AND 179
		THEN 'Light'
  
		WHEN total_intensity BETWEEN 60 AND 119
		THEN 'Very Light'

		WHEN total_intensity BETWEEN 30 AND 59
		THEN 'Just Noticeable'
  
		WHEN total_intensity BETWEEN 0 AND 29
		THEN 'Nothing'
  
 	END intensity_level
 
FROM
	(SELECT 
		hourlyCalories.*,              
		hourlyIntensities.total_intensity,   
		hourlyIntensities.average_intensity, 
		hourlySteps.step_total               
	FROM
		public."hourlyCalories" hourlyCalories

	JOIN public."hourlyIntensities" hourlyIntensities
	ON hourlyCalories.id = hourlyIntensities.id 
	AND hourlyCalories.activity_hour = hourlyIntensities.activity_hour

 	JOIN public."hourlySteps" hourlySteps
 	ON hourlyCalories.id = hourlySteps.id 
 	AND hourlyCalories.activity_hour = hourlySteps.activity_hour) hourlyActive
```

Output:
|   |     id      |     activity_hour     | calories | total_intensity | average_intensity | step_total | intensity_level |
|---|------------|-----------------------|----------|------------------|-------------------|------------|-----------------|
| 1 | 1503960366 | 2016-04-12 12:00:00 |    73    |        20        |      0.333333     |    373     |    Nothing    |
| 2 | 1503960366 | 2016-04-12 01:00:00 |    61    |        8         |      0.133333     |    160     |    Nothing    |
| 3 | 1503960366 | 2016-04-12 02:00:00 |    59    |        7         |      0.116667     |    151     |    Nothing    |
| 4 | 1503960366 | 2016-04-12 03:00:00 |    47    |        0         |         0          |     0      |    Nothing    |
| 5 | 1503960366 | 2016-04-12 04:00:00 |    48    |        0         |         0          |     0      |    Nothing    |

We pull the total_intensity and average_intensity from the table. We also pull the hourlyIntensities and step_total data from the hourlySteps table, and combine it with the data in the hourlyCalories table to obtain information about all hourly activities. To categorize intensity values, we create an intensity_level column based on the [Rated Perceived Exertion (RPE) Scale](https://my.clevelandclinic.org/health/articles/17450-rated-perceived-exertion-rpe-scale) website. However, since this website and others present intensity data per minutes, we require data that indicates hourly activity and the total_intensity column. Intensity values are also recorded at the hourly level. Therefore, we take the intensity range from the website and multiply it by 60 to accurately classify the intensity. The intensity categories are divided as follows:

- 0 to 29 - Nothing
- 30 to 59 - Just noticeable
- 60 to 119 - Very Light
- 120 to 179 - Light
- 180 - Moderate

#### Minute Activity

Step 3: Aggregate data from all tables related to minute activities, including minuteCalories, minuteIntensities, minuteMETs, and minuteSteps tables.

```SQL
SELECT 
	*,  
 	CASE
  		WHEN intensity = 3
  		THEN 'Moderate'
  
  		WHEN intensity = 2
  		THEN 'Light'
  
  		WHEN intensity = 1
  		THEN 'Very Light'
  
  		WHEN intensity = 0
  		THEN 'Nothing'
  
 	END intensity_level,
 
 	CASE
 		WHEN mets > 6
 		THEN 'Vigorous Intensity'
  
  		WHEN mets BETWEEN 3.01 AND 6
  		THEN 'Moderate Intensity'
  
 		WHEN mets BETWEEN 1.6 AND 3
 		THEN 'Light Intensity'
  
  		WHEN mets BETWEEN 0 AND 1.59
 		THEN 'Sedentary'
  
 	END mets_level
 
FROM
 	(SELECT 
  		minuteCalories.*,                 
  		minuteIntensities.intensity,      
  		minuteMETs.mets,                  
  		minuteSteps.steps                 
 	FROM public."minuteCaloriesNarrow" minuteCalories

 	JOIN public."minuteIntensitiesNarrow" minuteIntensities
 	ON minuteCalories.id = minuteIntensities.id
 	AND minuteCalories.activity_minute = minuteIntensities.activity_minute

 	JOIN public."minuteMETs" minuteMETs
 	ON minuteCalories.id = minuteMETs.id
 	AND minuteCalories.activity_minute = minuteMETs.activity_minute

 	JOIN public."minuteStepsNarrow" minuteSteps
 	ON minuteCalories.id = minuteSteps.id
 	AND minuteCalories.activity_minute = minuteSteps.activity_minute) minuteActive
```

Output:
|   |     id      |     activity_minute     | calories | intensity | mets | steps | intensity_level |      mets_level       |
|---|------------|--------------------------|----------|-----------|------|-------|-----------------|------------------------|
| 1 | 1503960366 | 2016-04-12 12:40:00      | 2.5168   |    1      | 3.2  |  26   | Very Light  | Moderate Intensity  |
| 2 | 1503960366 | 2016-04-12 12:58:00      | 2.0449   |    1      | 2.6  |  11   | Very Light  | Light Intensity     |
| 3 | 1503960366 | 2016-04-12 01:35:00      | 0.7865   |    0      | 1.0  |   0   |   Nothing   | Sedentary           |
| 4 | 1503960366 | 2016-04-12 01:36:00      | 0.7865   |    0      | 1.0  |   0   |   Nothing   | Sedentary           |
| 5 | 1503960366 | 2016-04-12 02:17:00      | 0.7865   |    0      | 1.0  |   0   |   Nothing   | Sedentary           |

We pull intensity data from the minuteIntensities table, mets data from the minuteMETs table, and steps data from the minuteSteps table. We then combine this information with the minuteCalories table to obtain minute activity data. Additionally, we create columns called intensity_level and mets_level to categorize intensity and mets. The intensity is divided into the following levels:

- 0 – Nothing
- 0.5 – Just noticeable
- 1 – Very light
- 2 – Light
- 3 – Moderate

Read more about the [Rated Perceived Exertion (RPE) Scale](https://my.clevelandclinic.org/health/articles/17450-rated-perceived-exertion-rpe-scale).

We have classified mets into the following categories:

- 0 to 1.59 - Sedentary
- 1.6 to 3 - Light Intensity
- 3.01 to 6 - Moderate intensity
- 6 and above - Vigorous intensity

For more information, visit [Staying Active | The Nutrition Source | Harvard T.H. Chan School of Public Health](https://www.hsph.harvard.edu/nutritionsource/staying-active/).

#### Sleep Activity

Finally, before using the data in the data creation step, Visualization retrieves data from the sleepDay table.

```SQL
SELECT 
 	*,
 	(total_time_in_bed - total_minutes_asleep) AS total_time_before_asleep
FROM public."sleepDay"
```

Output:
|   |    id    |  sleep_day  | total_sleep_records | total_minutes_asleep | total_time_in_bed | total_time_before_asleep |
|---|----------|-------------|---------------------|-----------------------|-------------------|--------------------------|
| 1 | 1503960366 | 2016-04-12 |         1          |         327           |        346        |           19             |
| 2 | 1503960366 | 2016-04-13 |         2          |         384           |        407        |           23             |
| 3 | 1503960366 | 2016-04-15 |         1          |         412           |        442        |           30             |
| 4 | 1503960366 | 2016-04-16 |         2          |         340           |        367        |           27             |
| 5 | 1503960366 | 2016-04-17 |         1          |         700           |        712        |           12             |

In this step, we have created a column called "total_time_before_asleep" to gather information on the time spent in bed before falling asleep. We calculate this by subtracting the time spent asleep (from the column "total_minutes_asleep") from the total time spent in bed (from the column "total_time_in_bed"). This data will be used in the next visualization step.

## Activity Visualization

We will use an example of the results obtained from generating data visualizations with Looker Studio. These visualizations aim to provide a clearer understanding for everyone. The focus will be on:

- Daily Activity
- Hourly Activity
- Minute Activity
- Sleep Activity

#### Daily Activity

![Activity Distribution Chart](https://github.com/saponnness/Bellabeat-DA-Case-Study/assets/145140484/a835e75f-69f3-4eb1-b733-b54c6234ad42)

This is a pie chart illustrating the distribution of daily activity values. The proportions are divided as follows:

- Very Active: 32.2%
- Sedentary: 32.2%
- Light Active: 18.2%
- Moderately Active: 17.3%

It is that a significant portion of daily activities is devoted to Very Active (32.2%) and Sedentary (32.2%).

#### Hourly Activity

![Intensity Level Distribution Chart](https://github.com/saponnness/Bellabeat-DA-Case-Study/assets/145140484/bc0dc701-eda4-45f1-9df2-50f47d42ce37)

However upon further examination of the hourly activity intensity, which can be categorized as follows:

- Nothing: 88.2%
- Just Noticeable: 8.2%
- Very Light: 2.9%
- Light: 0.69%
- Moderate: 0.02%

The pie chart reveals that the largest proportion of intensity values falls under the Nothing level, reaching a significant 88.2%. This indicates that this particular group engages in very minimal physical activity.

#### Minute Activity

![METs and Intensity Level Distribution Chart](https://github.com/saponnness/Bellabeat-DA-Case-Study/assets/145140484/06d0fad8-2f25-404b-92ad-1293e8c04dc4)

And upon further examination at the minute level, a chart reveals the breakdown of METs and Intensity values. The distribution of METs is as follows:

- Sedentary: 83.5%
- Light Intensity: 14.4%
- Moderate Intensity: 1.1%
- Vigorous Intensity: 0.96%

Similarly, the distribution of Intensity is as follows:

- Nothing: 83.5%
- Very Light: 8.9%
- Moderate: 6.4%
- Light: 1.2%

Both pie charts depict a dominant Sedentary distribution, with METs accounting for 83.5% and Intensity at Nothing also at 83.5%. This clearly indicates that the majority of activities within these groups involve little to no movement at all.

#### Sleep Activity

![Average Minutes Before Falling Asleep vs  Average Hours of Asleep](https://github.com/saponnness/Bellabeat-DA-Case-Study/assets/145140484/8b295a67-73b5-4898-b2f6-2fb8f98b8c88)

Another crucial aspect is getting enough sleep. The following graph illustrates the sleep quality of individuals, specifically the correlation between the Minutes Before Falling Asleep and the Hours of Asleep. The majority of the data in this graph indicates the following:

- Most individuals take approximately 13.29 to 44.53 minutes to enter the sleep cycle. They typically sleep and rest for an average of 6 to 8 hours, considered adequate.
- However, there are still individuals who take an extended period to fall asleep, around 309 minutes or roughly 5 hours.
- Additionally, there are groups of people who only rest for 1 to 2.2 hours per day. It's worth noting that they might nap during the day and disconnect from smart devices before sleeping at night.

For more details on creating an Activity, please refer to my Visualizations available at [Activities Dashboard](https://lookerstudio.google.com/reporting/975e151c-8486-48f5-9c5c-69ce4e1d812b).

## Conclusion and Recommendations

#### Recommendations for improving movement activities for this group

- Based on the analysis, it appears that this group of women engages in relatively little movement activity, particularly at the hourly and minute levels. This suggests that the group may consist of working-age individuals who spend most of their time sitting and working.

#### Advice for improving sleep quality

- Most individuals in this group appear to get sufficient rest, and the app detects a relatively short time to enter the sleep cycle.
- However, some individuals take longer than average to enter the sleep cycle, which may indicate stress and anxiety related to work.

#### Instructions for utilizing smart devices

- Based on data analysis and trends in smart device usage, I recommend that the app incorporate a coach feature to remind individuals to move or stretch periodically.
- Additionally, I suggest adding a stress relief app feature to help individuals who may experience stress from prolonged periods of work to relax.

## References

- [Counting Your Steps](https://www.10000steps.org.au/articles/healthy-lifestyles/counting-steps/).
- [Rated Perceived Exertion (RPE) Scale](https://my.clevelandclinic.org/health/articles/17450-rated-perceived-exertion-rpe-scale).
- [Staying Active | The Nutrition Source | Harvard T.H. Chan School of Public Health](https://www.hsph.harvard.edu/nutritionsource/staying-active/).

#

![Thank you](https://i0.wp.com/winkgo.com/wp-content/uploads/2019/10/thank-you-memes-29.jpg?w=800&ssl=1)
