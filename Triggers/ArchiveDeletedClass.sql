CREATE TABLE Archived_Classes_ProfG_FP (
  ArchiveID INT IDENTITY(1,1) PRIMARY KEY,
  ClassID INT,
  CourseOfferingID INT,
  InstructorID INT,
  LocationID INT,
  ClassDate DATE,
  StartTime TIME,
  EndTime TIME,
  Capacity INT,
  DeletedDate DATETIME DEFAULT GETDATE()
);


CREATE TRIGGER trg_ArchiveClassOnDelete_ProfG_FP
ON Classes_ProfG_FP
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO Archived_Classes_ProfG_FP (
    ClassID, CourseOfferingID, InstructorID, LocationID,
    ClassDate, StartTime, EndTime, Capacity
  )
  SELECT
    d.ClassID, d.CourseOfferingID, d.InstructorID, d.LocationID,
    d.ClassDate, d.StartTime, d.EndTime, d.Capacity
  FROM DELETED d;
END

-- Step 1: Find a test class
SELECT TOP 1 * FROM Classes_ProfG_FP WHERE CourseOfferingID = 5;

-- Step 2: Run safe test
BEGIN TRANSACTION;

DELETE FROM Classes_ProfG_FP
WHERE ClassID = 5;  -- Replace with valid ID

SELECT * FROM Archived_Classes_ProfG_FP;

ROLLBACK;
