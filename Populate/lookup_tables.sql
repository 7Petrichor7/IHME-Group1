USE IHME_GROUP_1
GO

SELECT* FROM IHME_raw_data
GO

INSERT INTO tblREGION (RegionName) SELECT distinct region FROM IHME_raw_data WHERE region IS NOT NULL
SELECT*FROM tblREGION

INSERT INTO tblDSTYPE (DstypeName) SELECT distinct ds_type_name FROM IHME_raw_data WHERE ds_type_name IS NOT NULL
SELECT*FROM tblDSTYPE

INSERT INTO tblSEX (SexName) SELECT distinct sex_name FROM IHME_raw_data WHERE sex_name IS NOT NULL
SELECT*FROM tblSEX

INSERT INTO tblAGE (AgeGroupName) SELECT distinct age_group_name FROM IHME_raw_data WHERE age_group_name IS NOT NULL
SELECT*FROM tblAGE


