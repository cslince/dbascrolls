/*
For more please visit
https://www.dbascrolls.com/
*/
DECLARE @utcTime DATETIMEOFFSET;
DECLARE @bstTime DATETIMEOFFSET;
DECLARE @year INT;
DECLARE @transitionStart DATETIME;
DECLARE @transitionEnd DATETIME;
DECLARE @bstOffset INT;

-- Get the current UTC time
SET @utcTime = SYSUTCDATETIME();

-- Extract the year from the UTC time
SET @year = DATEPART(YEAR, @utcTime);

-- Calculate the start and end dates for the daylight saving transitions
SET @transitionStart = DATEADD(DAY, -(DATEPART(WEEKDAY, DATEFROMPARTS(@year, 3, 31)) + 7 - 1) % 7, DATEFROMPARTS(@year, 3, 31));
SET @transitionEnd = DATEADD(DAY, -(DATEPART(WEEKDAY, DATEFROMPARTS(@year, 10, 31)) + 7 - 1) % 7, DATEFROMPARTS(@year, 10, 31));

-- Calculate the BST offset for the current date
SET @bstOffset = CASE
    WHEN @utcTime >= @transitionStart AND @utcTime < @transitionEnd
        THEN 60 -- BST offset: +01:00 (1 hour ahead during daylight saving)
    ELSE 0 -- GMT offset: +00:00 (Greenwich Mean Time)
END;

-- Convert UTC time to BST
SET @bstTime = DATEADD(MINUTE, @bstOffset, @utcTime);

-- Display the converted BST time
SELECT @bstTime AS [Current_BST_Time];
