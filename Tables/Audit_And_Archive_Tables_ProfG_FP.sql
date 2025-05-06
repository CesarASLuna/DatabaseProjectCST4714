
-- Archive table for deleted Classes
CREATE TABLE Archived_Classes_ProfG_FP (
  ClassID INT,
  CourseOfferingID INT,
  InstructorID INT,
  LocationID INT,
  ClassDate DATE,
  StartTime TIME,
  EndTime TIME,
  Capacity INT
);
GO

-- Audit table for enrollment insertions
CREATE TABLE EnrollmentAudit_ProfG_FP (
  AuditID INT IDENTITY(1,1) PRIMARY KEY,
  EnrollmentID INT,
  StudentID INT,
  CourseOfferingID INT,
  ActionTaken VARCHAR(50),
  ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- Audit table for instructor updates
CREATE TABLE InstructorAudit_ProfG_FP (
  AuditID INT IDENTITY(1,1) PRIMARY KEY,
  InstructorID INT,
  OldEmail VARCHAR(100),
  NewEmail VARCHAR(100),
  OldPhone VARCHAR(15),
  NewPhone VARCHAR(15),
  OldCertifications VARCHAR(MAX),
  NewCertifications VARCHAR(MAX),
  ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- Log for class updates
CREATE TABLE ClassChangeLog_ProfG_FP (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  ClassID INT,
  OldClassDate DATE,
  NewClassDate DATE,
  OldLocationID INT,
  NewLocationID INT,
  ChangeDate DATETIME DEFAULT GETDATE()
);
GO

-- Audit for attendance changes
CREATE TABLE AttendanceAudit_ProfG_FP (
  AuditID INT IDENTITY(1,1) PRIMARY KEY,
  ActionType VARCHAR(10), -- INSERT, DELETE, UPDATE
  AttendanceID INT,
  EnrollmentID INT,
  ClassID INT,
  ClassDate DATE,
  Present BIT,
  ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- Archive table for deleted instructor-course mappings
CREATE TABLE Archived_Instructor_Course_ProfG_FP (
  InstructorID INT,
  CourseID INT,
  ArchiveDate DATETIME DEFAULT GETDATE()
);
GO

-- Log for dropped enrollments
CREATE TABLE Dropped_Enrollments_ProfG_FP (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  EnrollmentID INT,
  StudentID INT,
  CourseOfferingID INT,
  DropReason VARCHAR(255),
  DroppedBy VARCHAR(100),
  DropDate DATETIME DEFAULT GETDATE()
);
GO
