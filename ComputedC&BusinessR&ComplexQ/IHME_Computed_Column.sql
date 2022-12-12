USE IHME_GROUP_1
GO
--- Computed Column: a column of the ratio of population and birth registration in each country
CREATE FUNCTION fn_RatioPopulationBirth(@PK INT)
RETURNS NUMERIC(10,2)
AS
BEGIN

DECLARE @RET NUMERIC(10,2) = (SELECT A.CaseValue/B.CaseValue AS RatioPopulationBirth
                             FROM
                            (SELECT C.CaseValue, CO.CountryID
                            FROM tblCase C
                                JOIN tblDsType DT ON C.DsTypeID = DT.DsTypeID
                                JOIN tblCountry CO ON C.CountryID = CO.CountryID
                            WHERE DT.DstypeName = 'Birth Regitration')A,

                            (SELECT C.CaseValue, CO.CountryID
                            FROM tblCase C
                                JOIN tblDsType DT ON C.DsTypeID = DT.DsTypeID
                                JOIN tblCountry CO ON C.CountryID = CO.CountryID
                            WHERE DT.DstypeName = 'Population')B
                            WHERE A.CountryID = B.CountryID
                                AND A.CountryID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblGENRE 
ADD NumMovie AS (dbo.fn_NumMovieEachGenre(GenreID))
GO

--- Computed Column: a column that count country numbers in different region
CREATE FUNCTION fn_CountryInRegion(@PK INT)
RETURNS NUMERIC(10,2)
AS
BEGIN

DECLARE @RET NUMERIC(10,2) = (SELECT COUNT(DISTINCT CO.CountryID) AS NumCountry
                            FROM tblCountry CO
                                JOIN tblRegion R ON CO.RegionID = R.RegionID
                            WHERE R.RegionID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblRegion
ADD NumCountry AS (dbo.fn_CountryInRegion(RegionID))
GO

