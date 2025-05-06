CREATE PROCEDURE sp_IssueCertificate_ProfG_FP
  @EnrollmentID INT,
  @CertificateTypeID INT
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @IsEligible BIT;

  -- Check eligibility
  SET @IsEligible = S23804121.fn_ValidateCertificateEligibility_ProfG_FP(@EnrollmentID);

  IF @IsEligible = 0
  BEGIN
    THROW 50001, 'Student is not eligible for certificate. Check attendance and payment.', 1;
    RETURN;
  END

  -- Issue certificate
  INSERT INTO Certificates_ProfG_FP (
    EnrollmentID,
    IssueDate,
    ExpirationDate,
    CertificateTypeID
  )
  VALUES (
    @EnrollmentID,
    GETDATE(),
    DATEADD(YEAR, 2, GETDATE()),  -- 2-year default expiration
    @CertificateTypeID
  );
END

EXEC sp_IssueCertificate_ProfG_FP
  @EnrollmentID = 1001,
  @CertificateTypeID = 1;
