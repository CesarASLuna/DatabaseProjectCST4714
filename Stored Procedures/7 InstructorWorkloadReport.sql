CREATE PROCEDURE sp_InstructorWorkloadReport_ProfG_FP
AS
BEGIN
  SET NOCOUNT ON;

  SELECT 
    i.InstructorID,
    i.FirstName,
    i.LastName,
    COUNT(DISTINCT a.EnrollmentID) AS StudentsTrained
  FROM Instructors_ProfG_FP i
  JOIN Classes_ProfG_FP c ON i.InstructorID = c.InstructorID
  JOIN Attendance_ProfG_FP a ON c.ClassID = a.ClassID
  WHERE a.Present = 1
  GROUP BY i.InstructorID, i.FirstName, i.LastName
  FOR JSON AUTO
END


EXEC sp_InstructorWorkloadReport_ProfG_FP;
