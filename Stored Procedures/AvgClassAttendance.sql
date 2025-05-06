CREATE VIEW vw_AvgClassSizeByCourse_ProfG_FP AS
SELECT
  crs.CourseID,
  crs.CourseName,
  COUNT(DISTINCT cls.ClassID) AS TotalClasses,
  COUNT(DISTINCT att.EnrollmentID) AS TotalEnrollments,
  CAST(COUNT(DISTINCT att.EnrollmentID) * 1.0 / NULLIF(COUNT(DISTINCT cls.ClassID), 0) AS DECIMAL(5,2)) AS AvgClassSize
FROM Courses_ProfG_FP crs
JOIN Course_Offerings_ProfG_FP cof ON crs.CourseID = cof.CourseID
JOIN Classes_ProfG_FP cls ON cof.CourseOfferingID = cls.CourseOfferingID
JOIN Attendance_ProfG_FP att ON cls.ClassID = att.ClassID
WHERE att.Present = 1
  AND cls.ClassDate < CAST(GETDATE() AS DATE)
GROUP BY crs.CourseID, crs.CourseName;

SELECT * FROM vw_AvgClassSizeByCourse_ProfG_FP;
