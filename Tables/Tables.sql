
CREATE TABLE S23804121.Students_ProfG_FP (
  StudentID INT PRIMARY KEY IDENTITY(1, 1),
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  DOB DATE NOT NULL,
  PhoneNumber VARCHAR(25),
  Email VARCHAR(100),
  Address VARCHAR(255),
  City VARCHAR(50),
  State CHAR(2),
  ZipCode VARCHAR(10),
  AgencyID INT,
  Last4SSN_Plaintext VARCHAR(4),            -- TEMPORARY column for encryption
  Last4SSN_Encrypted VARBINARY(128),        -- Actual encrypted field
  IsActive BIT NOT NULL DEFAULT (1),
  CreatedDate DATETIME NOT NULL DEFAULT (GETDATE())
);
GO


CREATE TABLE [Instructors_ProfG_FP] (
  [InstructorID] INT PRIMARY KEY IDENTITY(1, 1),
  [FirstName] VARCHAR(50) NOT NULL,
  [LastName] VARCHAR(50) NOT NULL,
  [Email] VARCHAR(100),
  [PhoneNumber] VARCHAR(15),
  [Certifications] VARCHAR(MAX),
  [IsActive] BIT NOT NULL DEFAULT (1),
  [CreatedDate] DATETIME NOT NULL DEFAULT (GETDATE())
)
GO

CREATE TABLE [Courses_ProfG_FP] (
  [CourseID] INT PRIMARY KEY IDENTITY(1, 1),
  [CourseName] VARCHAR(100) NOT NULL,
  [Description] VARCHAR(MAX),
  [DurationHours] INT
)
GO

CREATE TABLE [Course_Offerings_ProfG_FP] (
  [CourseOfferingID] INT PRIMARY KEY IDENTITY(1, 1),
  [CourseID] INT NOT NULL,
  [StartDate] DATE,
  [EndDate] DATE,
  [Notes] VARCHAR(255)
)
GO

CREATE TABLE [Class_Locations_Method_ProfG_FP] (
  [LocationID] INT PRIMARY KEY IDENTITY(1, 1),
  [LocationName] VARCHAR(100) NOT NULL,
  [Address] VARCHAR(255),
  [City] VARCHAR(50),
  [State] CHAR(2),
  [ZipCode] VARCHAR(10),
  [IsVirtual] BIT NOT NULL DEFAULT (0),
  [Platform] VARCHAR(50)
)
GO

CREATE TABLE [Classes_ProfG_FP] (
  [ClassID] INT PRIMARY KEY IDENTITY(1, 1),
  [CourseOfferingID] INT NOT NULL,
  [InstructorID] INT NOT NULL,
  [LocationID] INT NOT NULL,
  [ClassDate] DATE NOT NULL,
  [StartTime] TIME,
  [EndTime] TIME,
  [Capacity] INT NOT NULL
)
GO

CREATE TABLE [Agencies_ProfG_FP] (
  [AgencyID] INT PRIMARY KEY IDENTITY(1, 1),
  [AgencyName] VARCHAR(100) NOT NULL,
  [ContactPerson] VARCHAR(100),
  [PhoneNumber] VARCHAR(15),
  [Email] VARCHAR(100),
  [Address] VARCHAR(255),
  [City] VARCHAR(50),
  [State] CHAR(2),
  [ZipCode] VARCHAR(10)
)
GO

CREATE TABLE [Enrollments_ProfG_FP] (
  [EnrollmentID] INT PRIMARY KEY IDENTITY(1, 1),
  [StudentID] INT NOT NULL,
  [PackageEnrollmentID] int,
  [CourseOfferingID] INT,
  [EnrollmentDate] DATE NOT NULL,
  [Status] VARCHAR(20) NOT NULL,
  [CompletionDate] DATE
)
GO

CREATE TABLE [Package_Enrollments_ProfG_FP] (
  [PackageEnrollmentID] INT PRIMARY KEY IDENTITY(1, 1),
  [StudentID] INT NOT NULL,
  [PackageID] INT NOT NULL,
  [PurchaseDate] DATE NOT NULL
)
GO

CREATE TABLE [Certificate_Types_ProfG_FP] (
  [CertificateTypeID] INT PRIMARY KEY IDENTITY(1, 1),
  [TypeName] VARCHAR(100) NOT NULL,
  [Description] VARCHAR(MAX)
)
GO

CREATE TABLE [Certificates_ProfG_FP] (
  [CertificateID] INT PRIMARY KEY IDENTITY(1, 1),
  [EnrollmentID] INT NOT NULL,
  [IssueDate] DATE,
  [ExpirationDate] DATE,
  [CertificateTypeID] INT NOT NULL
)
GO

CREATE TABLE [Attendance_ProfG_FP] (
  [AttendanceID] INT PRIMARY KEY IDENTITY(1, 1),
  [EnrollmentID] INT NOT NULL,
  [ClassID] INT NOT NULL,
  [ClassDate] DATE NOT NULL,
  [Present] BIT NOT NULL
)
GO

CREATE TABLE [EmailOptOuts_ProfG_FP] (
  [OptOutID] INT PRIMARY KEY IDENTITY(1, 1),
  [StudentID] INT NOT NULL,
  [OptOutDate] DATETIME NULL,
  [Reason] VARCHAR(255),
  [CreatedDate] DATETIME NOT NULL DEFAULT (GETDATE())
)
GO

CREATE TABLE [Payment_Confirmations_ProfG_FP] (
  [PaymentConfirmationID] INT PRIMARY KEY IDENTITY(1, 1),
  [EnrollmentID] INT NOT NULL,
  [SquareTransactionID] VARCHAR(100) NOT NULL,
  [PaymentDate] DATE NOT NULL,
  [Amount] DECIMAL(10,2) NOT NULL
)
GO

CREATE TABLE [Instructor_Course_ProfG_FP] (
  [InstructorID] INT,
  [CourseID] INT,
  PRIMARY KEY ([InstructorID], [CourseID])
)
GO

CREATE TABLE [Packages_ProfG_FP] (
  [PackageID] INT PRIMARY KEY IDENTITY(1, 1),
  [PackageName] VARCHAR(100) NOT NULL,
  [Description] VARCHAR(MAX),
  [Price] DECIMAL(10,2) NOT NULL,
  [IsActive] BIT NOT NULL DEFAULT (1),
  [CreatedDate] DATETIME NOT NULL DEFAULT (GETDATE())
)
GO

CREATE TABLE [Package_Course_ProfG_FP] (
  [PackageID] INT,
  [CourseID] INT,
  PRIMARY KEY ([PackageID], [CourseID])
)
GO

ALTER TABLE [EmailOptOuts_ProfG_FP] ADD FOREIGN KEY ([StudentID]) REFERENCES [Students_ProfG_FP] ([StudentID])
GO

ALTER TABLE [Students_ProfG_FP] ADD FOREIGN KEY ([AgencyID]) REFERENCES [Agencies_ProfG_FP] ([AgencyID])
GO

ALTER TABLE [Course_Offerings_ProfG_FP] ADD FOREIGN KEY ([CourseID]) REFERENCES [Courses_ProfG_FP] ([CourseID])
GO

ALTER TABLE [Classes_ProfG_FP] ADD FOREIGN KEY ([CourseOfferingID]) REFERENCES [Course_Offerings_ProfG_FP] ([CourseOfferingID])
GO

ALTER TABLE [Classes_ProfG_FP] ADD FOREIGN KEY ([InstructorID]) REFERENCES [Instructors_ProfG_FP] ([InstructorID])
GO

ALTER TABLE [Classes_ProfG_FP] ADD FOREIGN KEY ([LocationID]) REFERENCES [Class_Locations_Method_ProfG_FP] ([LocationID])
GO

ALTER TABLE [Enrollments_ProfG_FP] ADD FOREIGN KEY ([StudentID]) REFERENCES [Students_ProfG_FP] ([StudentID])
GO

ALTER TABLE [Enrollments_ProfG_FP] ADD FOREIGN KEY ([CourseOfferingID]) REFERENCES [Course_Offerings_ProfG_FP] ([CourseOfferingID])
GO

ALTER TABLE [Certificates_ProfG_FP] ADD FOREIGN KEY ([EnrollmentID]) REFERENCES [Enrollments_ProfG_FP] ([EnrollmentID])
GO

ALTER TABLE [Certificates_ProfG_FP] ADD FOREIGN KEY ([CertificateTypeID]) REFERENCES [Certificate_Types_ProfG_FP] ([CertificateTypeID])
GO

ALTER TABLE [Attendance_ProfG_FP] ADD FOREIGN KEY ([EnrollmentID]) REFERENCES [Enrollments_ProfG_FP] ([EnrollmentID])
GO

ALTER TABLE [Attendance_ProfG_FP] ADD FOREIGN KEY ([ClassID]) REFERENCES [Classes_ProfG_FP] ([ClassID])
GO

ALTER TABLE [Payment_Confirmations_ProfG_FP] ADD FOREIGN KEY ([EnrollmentID]) REFERENCES [Enrollments_ProfG_FP] ([EnrollmentID])
GO

ALTER TABLE [Instructor_Course_ProfG_FP] ADD FOREIGN KEY ([InstructorID]) REFERENCES [Instructors_ProfG_FP] ([InstructorID])
GO

ALTER TABLE [Instructor_Course_ProfG_FP] ADD FOREIGN KEY ([CourseID]) REFERENCES [Courses_ProfG_FP] ([CourseID])
GO

ALTER TABLE [Package_Course_ProfG_FP] ADD FOREIGN KEY ([PackageID]) REFERENCES [Packages_ProfG_FP] ([PackageID])
GO

ALTER TABLE [Package_Course_ProfG_FP] ADD FOREIGN KEY ([CourseID]) REFERENCES [Courses_ProfG_FP] ([CourseID])
GO

ALTER TABLE [Enrollments_ProfG_FP] ADD FOREIGN KEY ([PackageEnrollmentID]) REFERENCES [Package_Enrollments_ProfG_FP] ([PackageEnrollmentID])
GO
