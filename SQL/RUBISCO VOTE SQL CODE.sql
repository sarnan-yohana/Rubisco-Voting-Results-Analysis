-- Create simple database
CREATE DATABASE AwardsData;
GO

USE AwardsData;
GO


-- Create simple table
CREATE TABLE CleanVotes (
    VoterName VARCHAR(100),
    Category VARCHAR(50),
    Nominee VARCHAR(100)
    );
GO

 Simple check
 Check column names in your table
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'RUBISCO_Cleaned_Simple';

-- Count total votes
SELECT COUNT(*) AS TotalVotes FROM RUBISCO_Cleaned_Simple;

SELECT * FROM RUBISCO_Cleaned_Simple

-- Check categories
SELECT DISTINCT Category FROM RUBISCO_Cleaned_Simple;


--creates a virtual table showing top 5 per category
CREATE VIEW Top5Nominees AS
SELECT 
    Category,
    Nominee,
    COUNT(*) AS Votes,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY COUNT(*) DESC) AS Rank
FROM RUBISCO_Cleaned_Simple
GROUP BY Category, Nominee;
GO

SELECT * FROM Top5Nominees 
WHERE Rank <= 5
ORDER BY Category, Rank;


SELECT 
    Category,
    Nominee,
    Votes,
    CASE Rank 
        WHEN 1 THEN 'GOLD'
        WHEN 2 THEN 'SILVER' 
        WHEN 3 THEN 'BRONZE'
        ELSE 'Finalist'
    END AS Award
FROM Top5Nominees 
WHERE Rank <= 5
ORDER BY Category, Rank;


-- Find the most nominated name overall
SELECT TOP 1
    Nominee,
    COUNT(*) AS TotalVotes,
    COUNT(DISTINCT Category) AS CategoriesAppearedIn
FROM RUBISCO_Cleaned_Simple
GROUP BY Nominee
ORDER BY TotalVotes DESC;

-- For more detailed view (top 10 overall):
SELECT TOP 10
    Nominee,
    COUNT(*) AS TotalVotes,
    COUNT(DISTINCT Category) AS CategoriesAppearedIn
    -- Removed STRING_AGG which was causing the error
FROM RUBISCO_Cleaned_Simple
GROUP BY Nominee
ORDER BY TotalVotes DESC;
-- View category-wise breakdown:
SELECT 
    Nominee,
    Category,
    COUNT(*) AS VotesInCategory,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY COUNT(*) DESC) AS RankInCategory
FROM RUBISCO_Cleaned_Simple
WHERE Nominee = (
    SELECT TOP 1 Nominee 
    FROM RUBISCO_Cleaned_Simple 
    GROUP BY Nominee 
    ORDER BY COUNT(*) DESC
)
GROUP BY Nominee, Category
ORDER BY VotesInCategory DESC;

SELECT * 
from RUBISCO_Cleaned_Simple 
WHERE 
Nominee='Dajin Sarnan Yohana'

UPDATE RUBISCO_Cleaned_Simple 
SET Nominee='Dajin Sarnan Yohana'
where Nominee='Sarnan'

;SELECT 
    Category,
    COUNT(*) AS TotalVotes
FROM RUBISCO_Cleaned_Simple
WHERE Nominee = 'Dajin Sarnan Yohana'
GROUP BY Category
ORDER BY TotalVotes DESC;


SELECT *
FROM RUBISCO_Cleaned_Simple
WHERE VoterName='Sarnan Yohana'
;