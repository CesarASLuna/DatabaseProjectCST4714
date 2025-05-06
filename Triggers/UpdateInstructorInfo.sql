CREATE TABLE InstructorAudit_ProfG_FP (
  AuditID INT IDENTITY(1,1) PRIMARY KEY,
  InstructorID INT,
  OldEmail VARCHAR(100),
  NewEmail VARCHAR(100),
  OldPhone VARCHAR(15),
  NewPhone VARCHAR(15),
  OldCertifications VARCHAR(MAX),
  NewCertifications VARCHAR(MAX),
  ChangeDate DATETIME DEFAULT GETDATE()
);
CREATE TRIGGER trg_AuditInstructorUpdate_ProfG_FP
ON Instructors_ProfG_FP
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO InstructorAudit_ProfG_FP (
    InstructorID,
    OldEmail, NewEmail,
    OldPhone, NewPhone,
    OldCertifications, NewCertifications
  )
  SELECT
    i.InstructorID,
    d.Email, i.Email,
    d.PhoneNumber, i.PhoneNumber,
    d.Certifications, i.Certifications
  FROM INSERTED i
  JOIN DELETED d ON i.InstructorID = d.InstructorID
  WHERE 
    ISNULL(d.Email, '') <> ISNULL(i.Email, '')
    OR ISNULL(d.PhoneNumber, '') <> ISNULL(i.PhoneNumber, '')
    OR ISNULL(d.Certifications, '') <> ISNULL(i.Certifications, '');
END

-- Check before
SELECT * FROM Instructors_ProfG_FP WHERE InstructorID = 1;

BEGIN TRANSACTION;

UPDATE Instructors_ProfG_FP
SET Email = 'newemail@example.com',
    Certifications = 'CPR, First Aid'
WHERE InstructorID = 1;

-- Confirm audit
SELECT * FROM InstructorAudit_ProfG_FP;

ROLLBACK;
