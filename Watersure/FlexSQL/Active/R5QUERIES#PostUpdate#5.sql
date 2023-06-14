DECLARE @whereused nvarchar(100),
    @check nvarchar(5);
BEGIN
SELECT @whereused = 'QUER' + CAST(QUE_SQLIDENTITY as nvarchar(10)) + '#' + CAST(QUE_UPDATECOUNT as nvarchar(10))
FROM R5QUERIES
WHERE QUE_SQLIDENTITY = :rowid
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
SELECT 'QUER' + CAST(QUE_SQLIDENTITY as nvarchar(10)) + '#' + CAST(QUE_UPDATECOUNT as nvarchar(10)),
    QUE_CODE + '.sql',
    'VDP',
    'S',
    'S',
    QUE_TEXT,
    QUE_CODE,
    QUE_NOTE,
    QUE_DESC,
    QUE_INBOX,
    QUE_CHART,
    QUE_NORMAL,
    QUE_ASSET,
    QUE_LOOKUP,
    QUE_EQUIPMENTRANKING,
    QUE_KPI,
    'QUER','VDP'

FROM R5QUERIES
WHERE QUE_SQLIDENTITY = :rowid
END
END
