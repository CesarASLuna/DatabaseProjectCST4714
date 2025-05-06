CREATE PROCEDURE sp_SwitchInstructor_ProfG_FP
  @CourseOfferingID INT,
  @NewInstructorID INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Classes_ProfG_FP
    SET InstructorID = @NewInstructorID
    WHERE CourseOfferingID = @CourseOfferingID
      AND ClassDate >= CAST(GETDATE() AS DATE);

    COMMIT;
  END TRY
  BEGIN CATCH
    ROLLBACK;
    THROW 50020, 'Error switching instructor. Check input IDs.', 1;
  END CATCH
END

-- Step 1: View current instructor assignments
SELECT ClassID, ClassDate, InstructorID
FROM Classes_ProfG_FP
WHERE CourseOfferingID = 5
ORDER BY ClassDate;

-- Step 2: Begin transaction
BEGIN TRANSACTION;

-- Step 3: Switch instructor
EXEC sp_SwitchInstructor_ProfG_FP
  @CourseOfferingID = 5,
  @NewInstructorID = 3;

-- Step 4: View updated assignments
SELECT ClassID, ClassDate, InstructorID
FROM Classes_ProfG_FP
WHERE CourseOfferingID = 5
ORDER BY ClassDate;

-- Step 5: Roll back the test
ROLLBACK;
