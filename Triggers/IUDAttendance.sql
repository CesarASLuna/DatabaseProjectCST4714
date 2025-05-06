CREATE TABLE AttendanceAudit_ProfG_FP (
  AuditID INT IDENTITY(1,1) PRIMARY KEY,
  ActionType VARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'
  AttendanceID INT,
  EnrollmentID INT,
  ClassID INT,
  ClassDate DATE,
  Present BIT,
  ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_AuditAttendanceChanges_ProfG_FP
ON Attendance_ProfG_FP
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;

  -- INSERT
  INSERT INTO AttendanceAudit_ProfG_FP (
    ActionType, AttendanceID, EnrollmentID, ClassID, ClassDate, Present
  )
  SELECT
    'INSERT', AttendanceID, EnrollmentID, ClassID, ClassDate, Present
  FROM INSERTED
  WHERE NOT EXISTS (SELECT 1 FROM DELETED WHERE DELETED.AttendanceID = INSERTED.AttendanceID);

  -- DELETE
  INSERT INTO AttendanceAudit_ProfG_FP (
    ActionType, AttendanceID, EnrollmentID, ClassID, ClassDate, Present
  )
  SELECT
    'DELETE', AttendanceID, EnrollmentID, ClassID, ClassDate, Present
  FROM DELETED
  WHERE NOT EXISTS (SELECT 1 FROM INSERTED WHERE INSERTED.AttendanceID = DELETED.AttendanceID);

  -- UPDATE
  INSERT INTO AttendanceAudit_ProfG_FP (
    ActionType, AttendanceID, EnrollmentID, ClassID, ClassDate, Present
  )
  SELECT
    'UPDATE', i.AttendanceID, i.EnrollmentID, i.ClassID, i.ClassDate, i.Present
  FROM INSERTED i
  JOIN DELETED d ON i.AttendanceID = d.AttendanceID
  WHERE
    ISNULL(i.Present, 0) <> ISNULL(d.Present, 0)
    OR ISNULL(i.ClassDate, '') <> ISNULL(d.ClassDate, '')
    OR ISNULL(i.ClassID, 0) <> ISNULL(d.ClassID, 0);
END

-- Insert test
BEGIN TRANSACTION;

INSERT INTO Attendance_ProfG_FP (EnrollmentID, ClassID, ClassDate, Present)
VALUES (1, 1, GETDATE(), 1);

-- Update test
UPDATE Attendance_ProfG_FP
SET Present = 0
WHERE AttendanceID = 1;

-- Delete test
DELETE FROM Attendance_ProfG_FP
WHERE AttendanceID = 1;

SELECT * FROM AttendanceAudit_ProfG_FP;

ROLLBACK;
