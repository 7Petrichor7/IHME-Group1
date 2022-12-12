USE IHME_GROUP_1
GO

-- Determine the country that has a obesity rate greater than 0.04 in the region of Asia in 2014
-- that also has at least 0.05 chewing tobacco rate in that year.

SELECT *
FROM
(SELECT CO.CountryID, CO.CountryName
FROM tblREGION R
    JOIN tblCOUNTRY CO ON R.RegionID = CO.RegionID
    JOIN tblCASE C ON CO.CountryID = C.CountryID
    JOIN tblDSTYPE DS ON C.DstypeID = DS.DstypeID
WHERE R.RegionName = 'Asia'
    AND DS.DstypeName = 'Obese'
    AND C.CaseValue > 0.04
    AND C.CaseYear = '2014'
GROUP BY CO.CountryID, CO.CountryName) A,

(SELECT CO.CountryID, CO.CountryName
FROM tblDSTYPE DS
    JOIN tblCASE C ON DS.DstypeID = C.DstypeID
WHERE DS.DstypeName = 'Chewing tobacco'
    AND C.CaseYear = '2014'
    AND C.CaseValue >= 0.05
GROUP BY CO.CountryID, CO.CountryName) B

WHERE A.CountryID = B.CountryID
GO
