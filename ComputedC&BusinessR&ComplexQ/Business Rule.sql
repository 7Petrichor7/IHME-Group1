USE IHME_GROUP_1
GO

-- Business Rule: Age group 15 to 19 cannot chew tobacco in China because it is illegal
CREATE FUNCTION AgeGroup_Tobacco_Rule()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS(
SELECT * 
FROM tblDSTYPE DS 
    JOIN tblCASE C ON DS.DstypeID = C.DstypeID
    JOIN tblCOUNTRY CO ON C.CountryID = CO.CountryID
    JOIN tblAGE AGE ON C.AgeID = AGE.AgeID
WHERE DS.DstypeName = 'Chewing tobacco'
    AND CO.CountryName = 'China'
    AND AGE.AgeGroupName = '15 to 19'
    AND C.CaseValue = 0
)
SET @RET = 1

RETURN @RET
END
GO

ALTER TABLE tblCASE WITH NOCHECK
ADD CONSTRAINT AgeGroup_Tobacco
CHECK (dbo.AgeGroup_Tobacco_Rule() = 0)
GO


