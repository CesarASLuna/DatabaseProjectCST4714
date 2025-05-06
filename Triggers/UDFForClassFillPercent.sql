CREATE FUNCTION S23804121.fn_ClassEnrollmentFillPercentage_ProfG_FP (
  @ClassID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
  DECLARE @CourseOfferingID INT;
  DECLARE @Capacity INT = 0;
  DECLARE @EnrolledStudents INT = 0;
  DECLARE @Percent DECIMAL(5,2) = 0;

  -- Get the course offering and capacity for this class
  SELECT 
    @CourseOfferingID = CourseOfferingID,
    @Capacity = Capacity
  FROM S23804121.Classes_ProfG_FP
  WHERE ClassID = @ClassID;

  -- Count how many students are enrolled in that offering
  SELECT @EnrolledStudents = COUNT(*)
  FROM S23804121.Enrollments_ProfG_FP
  WHERE CourseOfferingID = @CourseOfferingID;

  -- Avoid divide-by-zero
  IF @Capacity > 0
    SET @Percent = (CAST(@EnrolledStudents AS DECIMAL(5,2)) / @Capacity) * 100;

  RETURN @Percent;
END;


SELECT 
  c.ClassID,
  c.CourseOfferingID,
  c.ClassDate,
  c.Capacity,
  S23804121.fn_ClassEnrollmentFillPercentage_ProfG_FP(c.ClassID) AS FillPercent
FROM S23804121.Classes_ProfG_FP c;

CREATE PROCEDURE S23804121.sp_GetClassFillRates_ProfG_FP
  @CourseOfferingID INT
AS
BEGIN
  SET NOCOUNT ON;

  SELECT 
    c.ClassID,
    c.ClassDate,
    c.Capacity,
    S23804121.fn_ClassEnrollmentFillPercentage_ProfG_FP(c.ClassID) AS FillPercent
  FROM S23804121.Classes_ProfG_FP c
  WHERE c.CourseOfferingID = @CourseOfferingID;
END

EXEC S23804121.sp_GetClassFillRates_ProfG_FP @CourseOfferingID = 12;
