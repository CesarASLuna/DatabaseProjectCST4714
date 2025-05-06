CREATE PROCEDURE sp_GenerateClassSessions_ProfG_FP
  @CourseOfferingID INT
AS
BEGIN
  DECLARE @CourseID INT, @DurationHours INT, @SessionCount INT, @i INT = 0

  -- Get course duration
  SELECT @CourseID = CourseID FROM Course_Offerings_ProfG_FP WHERE CourseOfferingID = @CourseOfferingID
  SELECT @DurationHours = DurationHours FROM Courses_ProfG_FP WHERE CourseID = @CourseID

  -- Assume 8 hours per session
  SET @SessionCount = CEILING(@DurationHours / 8.0)

  -- Generate sessions starting the day after StartDate
  WHILE @i < @SessionCount
  BEGIN
    INSERT INTO Classes_ProfG_FP (
      CourseOfferingID, InstructorID, LocationID,
      ClassDate, StartTime, EndTime, Capacity
    )
    SELECT
      co.CourseOfferingID,
      1, -- placeholder instructor
      1, -- placeholder location
      DATEADD(DAY, @i, co.StartDate),
      '09:00', '17:00',
      20
    FROM Course_Offerings_ProfG_FP co
    WHERE co.CourseOfferingID = @CourseOfferingID

    SET @i += 1
  END
END
