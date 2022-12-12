USE IHME_GROUP_1
GO

-- Temp Table Country---------------------------------------------------------------
CREATE TABLE ##tblCOUNTRY (
    PK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    location_name varchar(50),
    region varchar(50)
)

INSERT INTO ##tblCOUNTRY (location_name, region)
SELECT DISTINCT location_name, region FROM IHME_raw_data
GO

-- Synthetic Transaction Country----------------------------------------------------
CREATE OR ALTER PROCEDURE wrapper_INSERT_Country
AS

DECLARE @CountryName varchar(50)
DECLARE @RegionName varchar(50)
DECLARE @RUN INT
SET @RUN = (SELECT COUNT(*) FROM ##tblCOUNTRY)

WHILE @Run > 0
BEGIN

SET @CountryName = (SELECT location_name FROM ##tblCOUNTRY WHERE @Run = PK)
SET @RegionName = (SELECT region FROM ##tblCOUNTRY WHERE @Run = PK)

EXEC INSERT_Country
@RN2 = @RegionName,
@CountryN = @CountryName

SET @Run = @Run -1
END
GO

-- Temp Table Case------------------------------------------------------------------
CREATE TABLE ##tblCASE (
    PK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    location_name varchar(50),
    sex_name varchar(8),
    age_group_name varchar(8),
    ds_type_name varchar(50),
    [year] char(4),
    val float,
    region varchar(50)
)

INSERT INTO ##tblCASE (location_name, sex_name, age_group_name, ds_type_name, [year], val, region)
SELECT location_name, sex_name, age_group_name, ds_type_name, [year], val, region FROM IHME_raw_data
GO

-- Synthetic Transaction Case-------------------------------------------------------
CREATE OR ALTER PROCEDURE wrapper_INSERT_Case
AS

DECLARE @CountryName varchar(50)
DECLARE @Dstype varchar(50)
DECLARE @Sex varchar(50)
DECLARE @Age varchar(50)
DECLARE @CaseYear char(4)
DECLARE @CaseValue float
DECLARE @RUN INT
SET @RUN = (SELECT COUNT(*) FROM ##tblCASE)

WHILE @Run > 0
BEGIN

SET @CountryName = (SELECT location_name FROM ##tblCASE WHERE @Run = PK)
SET @Dstype = (SELECT ds_type_name FROM ##tblCASE WHERE @Run = PK)
SET @Sex = (SELECT sex_name FROM ##tblCASE WHERE @Run = PK)
SET @Age = (SELECT age_group_name FROM ##tblCASE WHERE @Run = PK)
SET @CaseYear = (SELECT [year] FROM ##tblCASE WHERE @Run = PK)
SET @CaseValue = (SELECT val FROM ##tblCASE WHERE @Run = PK)

EXEC INSERT_Case
@CN2 = @CountryName,
@DSTN2 = @Dstype,
@SN2 = @Sex,
@AGN2 = @Age,
@Year = @CaseYear,
@Value = @CaseValue

SET @Run = @Run -1
END
GO


SELECT COUNT(*) FROM tblCASE