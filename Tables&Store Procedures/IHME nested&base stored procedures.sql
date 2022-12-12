USE IHME_GROUP_1
GO


SELECT* FROM IHME_raw_data
GO
--Get ID stored procedures----------------------------------------------------------
CREATE PROCEDURE GetRegionID
@RN varchar(50),
@Region_ID INT OUTPUT
AS
SET @Region_ID = (SELECT RegionID FROM tblREGION WHERE RegionName = @RN)
GO

CREATE PROCEDURE GetCountryID
@CN varchar(50),
@Country_ID INT OUTPUT
AS
SET @Country_ID = (SELECT CountryID FROM tblCOUNTRY WHERE CountryName = @CN)
GO

CREATE PROCEDURE GetDstypeID
@DSTN varchar(50),
@Dstype_ID INT OUTPUT
AS
SET @Dstype_ID = (SELECT DstypeID FROM tblDSTYPE WHERE DstypeName = @DSTN)
GO

CREATE PROCEDURE GetSexID
@SN varchar(8),
@Sex_ID INT OUTPUT
AS
SET @Sex_ID = (SELECT SexID FROM tblSEX WHERE SexName = @SN)
GO

CREATE PROCEDURE GetAgeID
@AGN varchar(8),
@MAX INT,
@MIN INT,
@Age_ID INT OUTPUT
AS
SET @Age_ID = (SELECT AgeID FROM tblAGE WHERE AgeGroupName = @AGN AND MaxAgeGroup = @MAX AND MinAgeGroup = @MIN)
GO

--Insert stored procedures----------------------------------------------------------
CREATE OR ALTER PROCEDURE INSERT_Country
@RN2 varchar(50),
@CountryN varchar(50)
AS
DECLARE @regionid INT

EXECUTE GetRegionID
@RN = @RN2,
@Region_ID = @regionid OUTPUT

IF @regionid IS NULL
   BEGIN
      PRINT '@regionid is empty...check spelling';
      THROW 51131, '@regionid cannot be NULL; process is terminating', 1;
   END

BEGIN TRANSACTION T2
INSERT INTO tblCOUNTRY(RegionID, CountryName)
VALUES (@regionid, @CountryN)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T2
    END
ELSE
   COMMIT TRANSACTION T2
GO

------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE INSERT_Case
@CN2 varchar(50),
@DSTN2 varchar(50),
@SN2 varchar(8),
@AGN2 varchar(8),
@MAX2 INT,
@MIN2 INT,
@Year char(4),
@Value numeric(15,8)
AS
DECLARE @countryid INT, @dstypeid INT, @sexid INT, @ageid INT

EXECUTE GetCountryID
@CN = @CN2,
@Country_ID = @countryid OUTPUT

IF @countryid IS NULL
   BEGIN
      PRINT '@countryid is empty...check spelling';
      THROW 51121, '@countryid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetDstypeID
@DSTN = @DSTN2,
@Dstype_ID = @dstypeid OUTPUT

IF @dstypeid IS NULL
   BEGIN
      PRINT '@dstypeid is empty...check spelling';
      THROW 51122, '@dstypeid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetSexID
@SN = @SN2,
@Sex_ID = @sexid OUTPUT

IF @sexid IS NULL
   BEGIN
      PRINT '@sexid is empty...check spelling';
      THROW 51123, '@sexid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetAgeID
@AGN = @AGN2,
@MAX = @MIN2,
@MIN = @MIN2,
@Age_ID = @ageid OUTPUT
IF @ageid IS NULL
   BEGIN
      PRINT '@ageid is empty...check spelling';
      THROW 51124, '@ageid cannot be NULL; process is terminating', 1;
   END

BEGIN TRANSACTION T2
INSERT INTO tblCASE(CountryID, DstypeID, SexID, AgeID, CaseYear, CaseValue)
VALUES (@countryid, @dstypeid, @sexid, @ageid, @Year, @Value)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T2
    END
ELSE
    COMMIT TRANSACTION T2
GO