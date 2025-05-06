CREATE VIEW vw_MaskedInstructors_ProfG_FP AS
SELECT
  InstructorID,
  FirstName,
  LastName,
  LEFT(Email, 3) + '***@***.com' AS MaskedEmail,
  PhoneNumber,
  CreatedDate
FROM Instructors_ProfG_FP;

SELECT * FROM vw_MaskedInstructors_ProfG_FP;
