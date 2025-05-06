CREATE TABLE Dropped_Enrollments_ProfG_FP (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  EnrollmentID INT,
  StudentID INT,
  CourseOfferingID INT,
  DropReason VARCHAR(255),
  DroppedBy VARCHAR(100),
  DropDate DATETIME DEFAULT GETDATE()
);



CREATE PROCEDURE sp_DropStudent_ProfG_FP
  @EnrollmentID INT,
  @DropReason VARCHAR(255) = NULL,
  @DroppedBy VARCHAR(100) = NULL
AS
BEGIN
  DECLARE @StudentID INT, @CourseOfferingID INT;

  BEGIN TRY
    BEGIN TRANSACTION;

    -- Get info before delete
    SELECT @StudentID = StudentID, @CourseOfferingID = CourseOfferingID
    FROM Enrollments_ProfG_FP
    WHERE EnrollmentID = @EnrollmentID;

    -- Validate: If nothing found, throw custom error
    IF @StudentID IS NULL
    BEGIN
      ROLLBACK;
      THROW 50002, 'Enrollment ID not found. Nothing to drop.', 1;
    END

    -- Clean related data
    DELETE FROM Attendance_ProfG_FP WHERE EnrollmentID = @EnrollmentID;
    DELETE FROM Payment_Confirmations_ProfG_FP WHERE EnrollmentID = @EnrollmentID;

    -- Delete from enrollments
    DELETE FROM Enrollments_ProfG_FP WHERE EnrollmentID = @EnrollmentID;

    -- Log to audit
    INSERT INTO Dropped_Enrollments_ProfG_FP (
      EnrollmentID, StudentID, CourseOfferingID, DropReason, DroppedBy
    )
    VALUES (
      @EnrollmentID, @StudentID, @CourseOfferingID, @DropReason, @DroppedBy
    );

    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;

    THROW 50003, 'Failed to drop enrollment. Check foreign keys or data integrity.', 1;
  END CATCH
END

BEGIN TRANSACTION;

EXEC sp_DropStudent_ProfG_FP
  @EnrollmentID = 2,
  @DropReason = 'Withdrew from course',
  @DroppedBy = 'admin@ggs.com';

-- Confirm deleted:
SELECT * FROM Enrollments_ProfG_FP WHERE EnrollmentID = 2;
SELECT * FROM Attendance_ProfG_FP WHERE EnrollmentID = 2;
SELECT * FROM Payment_Confirmations_ProfG_FP WHERE EnrollmentID = 2;
SELECT * FROM Dropped_Enrollments_ProfG_FP WHERE EnrollmentID = 2;

--  Nothing should be committed yet

--  Undo changes:
ROLLBACK;


