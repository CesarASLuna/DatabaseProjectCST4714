CREATE TABLE ClassChangeLog_ProfG_FP (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  ClassID INT,
  OldClassDate DATE,
  NewClassDate DATE,
  OldLocationID INT,
  NewLocationID INT,
  ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_LogClassChange_ProfG_FP
ON Classes_ProfG_FP
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO ClassChangeLog_ProfG_FP (
    ClassID,
    OldClassDate, NewClassDate,
    OldLocationID, NewLocationID
  )
  SELECT
    i.ClassID,
    d.ClassDate, i.ClassDate,
    d.LocationID, i.LocationID
  FROM INSERTED i
  JOIN DELETED d ON i.ClassID = d.ClassID
  WHERE 
    ISNULL(d.ClassDate, '') <> ISNULL(i.ClassDate, '')
    OR ISNULL(d.LocationID, 0) <> ISNULL(i.LocationID, 0);
END

-- View class before
SELECT * FROM Classes_ProfG_FP WHERE ClassID = 1;

-- Safe update test
BEGIN TRANSACTION;

UPDATE Classes_ProfG_FP
SET ClassDate = DATEADD(DAY, 1, ClassDate),  -- move by 1 day
    LocationID = 2                            -- or change location
WHERE ClassID = 1;

-- Confirm audit
SELECT * FROM ClassChangeLog_ProfG_FP;

ROLLBACK;
