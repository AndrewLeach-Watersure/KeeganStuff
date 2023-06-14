DECLARE @whereused nvarchar(100),
        @check nvarchar(5);
BEGIN
SELECT @whereused = 'EXTF' + CAST(EFR_SQLIDENTITY as nvarchar(10)) + '#' + CAST(EFR_UPDATECOUNT as nvarchar(10))
FROM R5EXTENSIBLEFRAMEWORK
WHERE EFR_SQLIDENTITY = :rowid
SELECT @check = COUNT(*)
FROM R5DOCUMENTS
WHERE DOC_CODE = @whereused IF @check < 1 BEGIN
INSERT INTO R5DOCUMENTS(
        DOC_CODE,
        DOC_DESC,
        DOC_ORG,
        DOC_TYPE,
        DOC_RTYPE,
        DOC_CONTENT,
        DOC_UDFCHAR20,
        DOC_UDFCHAR21,
        DOC_UDFCHKBOX01,
        DOC_CLASS,
        DOC_CLASS_ORG
    )
SELECT  'EXTF' + CAST(EFR_SQLIDENTITY as nvarchar(10)) + '#' + CAST(EFR_UPDATECOUNT as nvarchar(10)),
    EFR_NAME + '#' + EFR_USERFUNCTION + '.js',
    'VDP',
    'S',
    'S',
    EFR_SOURCECODE,
    EFR_NAME,
    EFR_USERFUNCTION,
    EFR_ACTIVE,
    'EXTF',
    'VDP'
FROM R5EXTENSIBLEFRAMEWORK
WHERE EFR_SQLIDENTITY = :rowid
END
END
