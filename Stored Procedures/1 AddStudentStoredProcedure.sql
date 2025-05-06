CREATE PROCEDURE sp_AddStudent_ProfG_FP
  @FirstName VARCHAR(50),
  @LastName VARCHAR(50),
  @DOB DATE,
  @PhoneNumber VARCHAR(15),
  @Email VARCHAR(100),
  @Address VARCHAR(255),
  @City VARCHAR(50),
  @State CHAR(2),
  @ZipCode VARCHAR(10),
  @AgencyID INT,
  @Last4SSN_Plaintext CHAR(4) = NULL
AS
BEGIN
  DECLARE @EncryptedSSN VARBINARY(128)

  IF @Last4SSN_Plaintext IS NOT NULL
  BEGIN
    SET @EncryptedSSN = EncryptByPassPhrase('YourStrongPassphrase!', @Last4SSN_Plaintext)
  END

  INSERT INTO Students_ProfG_FP (
    FirstName, LastName, DOB, PhoneNumber, Email, Address,
    City, State, ZipCode, AgencyID, Last4SSN_Encrypted, IsActive, CreatedDate
  )
  VALUES (
    @FirstName, @LastName, @DOB, @PhoneNumber, @Email, @Address,
    @City, @State, @ZipCode, @AgencyID, @EncryptedSSN, 1, GETDATE()
  )
END

BEGIN TRANSACTION

EXEC sp_AddStudent_ProfG_FP
  @FirstName = 'Testy',
  @LastName = 'McTestface',
  @DOB = '2000-01-01',
  @PhoneNumber = '555-000-0000',
  @Email = 'test@example.com',
  @Address = '123 Test St',
  @City = 'Testville',
  @State = 'NY',
  @ZipCode = '12345',
  @AgencyID = 1,
  @Last4SSN_Plaintext = '1111';

-- Check it worked:
SELECT * FROM Students_ProfG_FP WHERE Email = 'test@example.com';

-- To undo it:
ROLLBACK;

