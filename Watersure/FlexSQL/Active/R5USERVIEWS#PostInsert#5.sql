DECLARE @whereused nvarchar(100),
    @check nvarchar(5);
BEGIN
SELECT @whereused = 'VIEW' + CAST(UVW_SQLIDENTITY as nvarchar(10)) + '#' + CAST(UVW_UPDATECOUNT as nvarchar(10))
FROM R5USERVIEWS
WHERE UVW_SQLIDENTITY = :rowid
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
        DOC_UDFCHAR22,
        DOC_FILENAME,
        DOC_TITLE,
        DOC_UDFCHKBOX01,
        DOC_UDFCHKBOX02,
        DOC_UDFCHKBOX03,
        DOC_UDFCHKBOX04,
        DOC_UDFCHKBOX05,
        DOC_CLASS,
        DOC_CLASS_ORG
    )
SELECT 'VIEW' + CAST(UVW_SQLIDENTITY as nvarchar(10)) + '#' + CAST(UVW_UPDATECOUNT as nvarchar(10)),
    UVW_CODE + '.sql',
    'VDP',
    'S',
    'S',
    UVW_STMT,
    UVW_CODE,
    UVW_NAME,
    UVW_DESC,
    NULL,
    NULL,
    UVW_ACTIVE,
    NULL,
    NULL,
    NULL,
    NULL,
    'VIEW','VDP'

FROM R5USERVIEWS
WHERE UVW_SQLIDENTITY = :rowid
END
END
