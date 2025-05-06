SELECT 
  a.AgencyName,
  s.StudentID,
  s.FirstName,
  s.LastName,
  co.CourseOfferingID,
  c.CourseName
FROM Students_ProfG_FP s
JOIN Agencies_ProfG_FP a ON s.AgencyID = a.AgencyID
JOIN Enrollments_ProfG_FP e ON s.StudentID = e.StudentID
JOIN Course_Offerings_ProfG_FP co ON e.CourseOfferingID = co.CourseOfferingID
JOIN Courses_ProfG_FP c ON co.CourseID = c.CourseID
WHERE s.IsActive = 1
FOR JSON AUTO, INCLUDE_NULL_VALUES;
