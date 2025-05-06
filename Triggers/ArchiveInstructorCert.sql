CREATE TABLE Archived_Instructor_Course_ProfG_FP (
  ArchiveID INT IDENTITY(1,1) PRIMARY KEY,
  InstructorID INT,
  CourseID INT,
  RemovedDate DATETIME DEFAULT GETDATE()
);
CREATE TRIGGER trg_ArchiveInstructorCourseOnDelete_ProfG_FP
ON Instructor_Course_ProfG_FP
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO Archived_Instructor_Course_ProfG_FP (
    InstructorID, CourseID
  )
  SELECT
    InstructorID, CourseID
  FROM DELETED;
END
-- Check what's in the mapping table
SELECT * FROM Instructor_Course_ProfG_FP;

-- Begin safe test
BEGIN TRANSACTION;

DELETE FROM Instructor_Course_ProfG_FP
WHERE InstructorID = 1 AND CourseID = 2; -- Replace with real combo

-- Verify archive
SELECT * FROM Archived_Instructor_Course_ProfG_FP;

ROLLBACK;

  
