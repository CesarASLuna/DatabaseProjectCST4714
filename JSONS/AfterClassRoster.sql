CREATE VIEW vw_ClassRoster_ProfG_FP AS
SELECT
  c.ClassID,
  s.StudentID,
  s.FirstName,
  s.LastName,
  a.AgencyName,
  att.ClassDate,
  att.Present,
  CONVERT(VARCHAR(4), DECRYPTBYPASSPHRASE(
    'YourStrongPassphrase!',
    s.Last4SSN_Encrypted
  )) AS Last4SSN
FROM Attendance_ProfG_FP att
JOIN Enrollments_ProfG_FP e ON att.EnrollmentID = e.EnrollmentID
JOIN Students_ProfG_FP s ON e.StudentID = s.StudentID
LEFT JOIN Agencies_ProfG_FP a ON s.AgencyID = a.AgencyID
JOIN Classes_ProfG_FP c ON att.ClassID = c.ClassID;

SELECT *
FROM vw_ClassRoster_ProfG_FP
WHERE ClassID = 1001;
