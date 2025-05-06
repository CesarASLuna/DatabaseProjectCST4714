CREATE VIEW vw_MaskedClassRoster_ProfG_FP AS
SELECT
  c.ClassID,
  s.StudentID,
  s.FirstName,
  s.LastName,
  LEFT(s.Email, 3) + '***@***.com' AS MaskedEmail,
  a.AgencyName,
  att.ClassDate,
  att.Present
FROM Attendance_ProfG_FP att
JOIN Enrollments_ProfG_FP e ON att.EnrollmentID = e.EnrollmentID
JOIN Students_ProfG_FP s ON e.StudentID = s.StudentID
LEFT JOIN Agencies_ProfG_FP a ON s.AgencyID = a.AgencyID
JOIN Classes_ProfG_FP c ON att.ClassID = c.ClassID;

SELECT * FROM vw_MaskedClassRoster_ProfG_FP;
