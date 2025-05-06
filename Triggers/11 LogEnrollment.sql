CREATE TABLE EnrollmentAudit_ProfG_FP (
  AuditID INT IDENTITY(1,1) PRIMARY KEY,
  EnrollmentID INT,
  StudentID INT,
  CourseOfferingID INT,
  ActionTaken VARCHAR(50),
  ActionDate DATETIME DEFAULT GETDATE()
);


CREATE TRIGGER trg_AuditEnrollmentInsert_ProfG_FP
ON Enrollments_ProfG_FP
AFTER INSERT
AS
BEGIN
  INSERT INTO EnrollmentAudit_ProfG_FP (
    EnrollmentID, StudentID, CourseOfferingID, ActionTaken
  )
  SELECT
    i.EnrollmentID,
    i.StudentID,
    i.CourseOfferingID,
    'ENROLLMENT CREATED'
  FROM INSERTED i;
END

BEGIN TRANSACTION
-- Insert test enrollment (real IDs only)
INSERT INTO Enrollments_ProfG_FP (
  StudentID, CourseOfferingID, EnrollmentDate, Status
) VALUES (
  336, 5, GETDATE(), 'Enrolled'
);

-- View the audit
SELECT * FROM EnrollmentAudit_ProfG_FP;

ROLLBACK;