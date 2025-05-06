CREATE FUNCTION fn_ValidateCertificateEligibility_ProfG_FP (
  @EnrollmentID INT
)
RETURNS BIT
AS
BEGIN
  DECLARE @CourseOfferingID INT
  DECLARE @IsPaid BIT = 0
  DECLARE @TotalSessions INT
  DECLARE @PresentSessions INT
  DECLARE @Eligible BIT = 0

  -- Get course offering tied to this enrollment
  SELECT @CourseOfferingID = CourseOfferingID
  FROM Enrollments_ProfG_FP
  WHERE EnrollmentID = @EnrollmentID

  -- Confirm payment
  IF EXISTS (
    SELECT 1 FROM Payment_Confirmations_ProfG_FP
    WHERE EnrollmentID = @EnrollmentID
  )
    SET @IsPaid = 1

  -- Total expected sessions for that course offering
  SELECT @TotalSessions = COUNT(*)
  FROM Classes_ProfG_FP
  WHERE CourseOfferingID = @CourseOfferingID

  -- Total sessions marked Present
  SELECT @PresentSessions = COUNT(*)
  FROM Attendance_ProfG_FP
  WHERE EnrollmentID = @EnrollmentID AND Present = 1

  -- Final eligibility check
  IF @IsPaid = 1 AND @TotalSessions = @PresentSessions AND @TotalSessions > 0
    SET @Eligible = 1

  RETURN @Eligible
END

-- Test
SELECT S23804121.fn_ValidateCertificateEligibility_ProfG_FP(2001)

