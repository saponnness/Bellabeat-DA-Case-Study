-- Update the "mets" column by dividing it by 10.0 to correct data inaccuracies.
-- The original data contains two-digit values for "mets," but in reality, "mets" should have one decimal place.

UPDATE public."minuteMETs"
SET mets = mets / 10.0
