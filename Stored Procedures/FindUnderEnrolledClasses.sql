CREATE FUNCTION S23804121.fn_GetEnrollmentCountForOffering_ProfG_FP (
  @CourseOfferingID INT
)
RETURNS INT
AS
BEGIN
  DECLARE @Count INT

  SELECT @Count = COUNT(*)
  FROM Enrollments_ProfG_FP
  WHERE CourseOfferingID = @CourseOfferingID

  RETURN @Count
END
GO

CREATE PROCEDURE sp_FindLowEnrollmentOfferings_ProfG_FP
  @MinStudents INT = 5
AS
BEGIN
  SET NOCOUNT ON;

  SELECT 
    co.CourseOfferingID,
    c.CourseName,
    co.StartDate,
    co.EndDate,
    S23804121.fn_GetEnrollmentCountForOffering_ProfG_FP(co.CourseOfferingID) AS EnrolledCount
  FROM Course_Offerings_ProfG_FP co
  JOIN Courses_ProfG_FP c ON co.CourseID = c.CourseID
  WHERE S23804121.fn_GetEnrollmentCountForOffering_ProfG_FP(co.CourseOfferingID) < @MinStudents
END
GO

EXEC sp_FindLowEnrollmentOfferings_ProfG_FP @MinStudents = 3
