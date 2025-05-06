CREATE PROCEDURE sp_AddCourseOffering_ProfG_FP
  @CourseID INT,
  @StartDate DATE,
  @EndDate DATE = NULL,
  @Notes VARCHAR(255) = NULL
AS
BEGIN
  DECLARE @NewOfferingID INT

  -- Insert the offering
  INSERT INTO Course_Offerings_ProfG_FP (CourseID, StartDate, EndDate, Notes)
  VALUES (@CourseID, @StartDate, @EndDate, @Notes)

  -- Get the new ID
  SET @NewOfferingID = SCOPE_IDENTITY()

  -- Call nested procedure to create class sessions
  EXEC sp_GenerateClassSessions_ProfG_FP @NewOfferingID
END

EXEC sp_AddCourseOffering_ProfG_FP
  @CourseID = 1,
  @StartDate = '2025-07-15',
  @Notes = 'Summer session';

SELECT * FROM Course_Offerings_ProfG_FP ORDER BY CourseOfferingID DESC;
SELECT * FROM Classes_ProfG_FP WHERE CourseOfferingID = 1006;
