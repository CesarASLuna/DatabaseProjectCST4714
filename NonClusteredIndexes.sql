-- Enrollments: fast lookup by course
CREATE NONCLUSTERED INDEX IX_Enrollments_CourseOfferingID
ON Enrollments_ProfG_FP (CourseOfferingID);

-- Classes: fast lookup by course offering
CREATE NONCLUSTERED INDEX IX_Classes_CourseOfferingID
ON Classes_ProfG_FP (CourseOfferingID);

-- Attendance: fast lookup by enrollment
CREATE NONCLUSTERED INDEX IX_Attendance_EnrollmentID
ON Attendance_ProfG_FP (EnrollmentID);

-- Students: for filtering/joining by Agency
CREATE NONCLUSTERED INDEX IX_Students_AgencyID
ON Students_ProfG_FP (AgencyID);
