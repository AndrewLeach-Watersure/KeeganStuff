--This is illogical, there can be no Work Orders on a Object being inserted, its a new object.

BEGIN
	UPDATE R5EVENTS 
	SET EVT_UDFCHAR09 = isnull(SUBSTRING(OBJ.OBJ_UDFCHAR19,5,2),'00'),
		EVT_UDFCHKBOX02 = OBJ.OBJ_PRODUCTION,
		EVT_SAFETY = OBJ.OBJ_SAFETY,
		EVT_CAMPAIGN_SURVEY = OBJ.obj_UDFCHKBOX03,
		EVT_UDFCHAR25 = CASE OBJ_UDFCHKBOX02 WHEN '+' THEN 'YES' ELSE 'NO' END
	FROM R5OBJECTS OBJ
	WHERE R5EVENTS.EVT_OBJECT = OBJ.OBJ_CODE
		AND R5EVENTS.EVT_OBJECT_ORG = OBJ.OBJ_ORG
		AND OBJ.OBJ_SQLIDENTITY = :ROWID
		AND R5EVENTS.EVT_STATUS NOT IN ('C', 'CANC', 'CLOS')
END
