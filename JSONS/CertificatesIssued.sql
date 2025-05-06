SELECT 
  c.CertificateID,
  c.EnrollmentID,
  c.IssueDate,
  ct.TypeName,
  e.StudentID,
  s.FirstName,
  s.LastName
FROM Certificates_ProfG_FP c
JOIN Certificate_Types_ProfG_FP ct ON c.CertificateTypeID = ct.CertificateTypeID
JOIN Enrollments_ProfG_FP e ON c.EnrollmentID = e.EnrollmentID
JOIN Students_ProfG_FP s ON e.StudentID = s.StudentID
FOR JSON AUTO, INCLUDE_NULL_VALUES;
