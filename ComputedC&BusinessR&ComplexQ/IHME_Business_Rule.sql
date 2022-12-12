USE IHME_GROUP_1
GO
--- Business Rule: No Male in the age group of 30 to 34 in Japan should chew tobacco because it's bad for reproducing.
CREATE FUNCTION No_Male_30_34_Japan()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS(SELECT * FROM tblCase C
JOIN tblCountry CO ON C.CountryID = CO.CountryID
JOIN tblSEX S ON C.SexID = S.SexID
JOIN tblAGE A ON C.AgeID = A.AgeID
JOIN tblDSTYPE DT ON C.DstypeID = DT.DstypeID
WHERE CO.CountryName = 'Japan'
AND S.SexName = 'Male'
AND A.AgeGroupName = '30 to 34'
AND C.CaseValue= 0)

SET @RET = 1

RETURN @RET
END
GO

ALTER TABLE tblCASE WITH NOCHECK
ADD CONSTRAINT RestrictAgeCountry
CHECK (dbo.No_Male_30_34_Japan() = 0)
GO