SELECT PPA_PPM,
PPA_ACT	,PPA_TRADE	,PPA_DURATION	,PPA_EST	,PPA_TASK	,PPA_MATLIST	,PPA_PERSONS	,PPA_START	,PPA_SPECIAL	,PPA_HIRE	,PPA_REVISION	,PPA_QTY,
DBO.REPGETADDTEXT('PPM', 'EN',PPA_PPM+'#0#'+CAST(PPA_ACT AS NVARCHAR(10))) ACT_COMMENTS


FROM R5PPMACTS