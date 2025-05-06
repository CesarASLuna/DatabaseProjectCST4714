CREATE TRIGGER trg_AutoInsertOptOut_ProfG_FP
ON Students_ProfG_FP
AFTER INSERT
AS
BEGIN
  INSERT INTO EmailOptOuts_ProfG_FP (StudentID, Reason)
  SELECT StudentID, NULL
  FROM INSERTED;
END

BEGIN TRANSACTION;

INSERT INTO Students_ProfG_FP (
  FirstName, LastName, DOB, PhoneNumber, Email, Address, City, State, ZipCode, AgencyID
)
VALUES (
  'Trigger', 'Test', '1995-06-01', '555-111-2222', 'trigger.test@example.com',
  '456 Trigger Ln', 'Bronx', 'NY', '10453', 1
);

-- Confirm the trigger fired
SELECT *
FROM EmailOptOuts_ProfG_FP
WHERE StudentID IN (
  SELECT StudentID
  FROM Students_ProfG_FP
  WHERE FirstName = 'Trigger' AND LastName = 'Test'
);

-- Undo test
ROLLBACK;
