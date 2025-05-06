-- Step 1: Delete from child/detail tables first
DELETE FROM S23804121.Attendance_ProfG_FP;
DELETE FROM S23804121.Enrollments_ProfG_FP;
DELETE FROM S23804121.Package_Enrollments_ProfG_FP;
DELETE FROM S23804121.Payment_Confirmations_ProfG_FP;
DELETE FROM S23804121.Certificates_ProfG_FP;
DELETE FROM S23804121.Classes_ProfG_FP;

-- Step 2: Delete from bridge tables (many-to-many)
DELETE FROM S23804121.Package_Course_ProfG_FP;
DELETE FROM S23804121.Instructor_Course_ProfG_FP;

-- Step 3: Delete from parent/toplevel entities
DELETE FROM S23804121.Course_Offerings_ProfG_FP;
DELETE FROM S23804121.Packages_ProfG_FP;
DELETE FROM S23804121.Courses_ProfG_FP;
DELETE FROM S23804121.Students_ProfG_FP;
DELETE FROM S23804121.Instructors_ProfG_FP;
DELETE FROM S23804121.Agencies_ProfG_FP;
DELETE FROM S23804121.Class_Locations_Method_ProfG_FP;
DELETE FROM S23804121.Certificate_Types_ProfG_FP;
DELETE FROM S23804121.EmailOptOuts_ProfG_FP;

DBCC CHECKIDENT ('S23804121.Students_ProfG_FP', RESEED, 0);
