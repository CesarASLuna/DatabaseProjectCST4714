CREATE VIEW vw_CourseSessionsByLocation_ProfG_FP AS
SELECT
  l.LocationID,
  l.LocationName,
  c.CourseName,
  COUNT(cls.ClassID) AS TotalSessions
FROM Classes_ProfG_FP cls
JOIN Course_Offerings_ProfG_FP co ON cls.CourseOfferingID = co.CourseOfferingID
JOIN Courses_ProfG_FP c ON co.CourseID = c.CourseID
JOIN Class_Locations_Method_ProfG_FP l ON cls.LocationID = l.LocationID
GROUP BY l.LocationID, l.LocationName, c.CourseName;

SELECT * 
FROM vw_CourseSessionsByLocation_ProfG_FP 
WHERE LocationID = 1;
