DECLARE @whereused nvarchar(100),
    @check nvarchar(5);
BEGIN
SELECT @whereused = 'FLEX' + CAST(FLX_SQLIDENTITY as nvarchar(10)) + '#' + CAST(FLX_UPDATECOUNT as nvarchar(10))
FROM R5FLEXSQL
WHERE FLX_SQLIDENTITY = :rowid
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
SELECT 'FLEX' + CAST(FLX_SQLIDENTITY as nvarchar(10)) + '#' + CAST(FLX_UPDATECOUNT as nvarchar(10)),
    FLX_TABLE + '#' + CASE WHEN FLX_TRIGGER = 'POST-INSERT' THEN 'PostInsert' ELSE 'PostUpdate' END + '#' + CAST(FLX_SEQ as nvarchar(10)) + '.sql',
    'VDP',
    'S',
    'S',
    FLX_STMT,
    FLX_TABLE,
    FLX_TRIGGER,
    FLX_SEQ,
    FLX_MSGFAILURE,
    FLX_COMMENT,
    FLX_ABORTONFAILURE,
    FLX_REVERSERETURN,
    FLX_ACTIVE,
    FLX_MUSTEXIST,
    FLX_MOBILE,
    'FLEX','VDP'

FROM R5FLEXSQL
WHERE FLX_SQLIDENTITY = :rowid
END
END
