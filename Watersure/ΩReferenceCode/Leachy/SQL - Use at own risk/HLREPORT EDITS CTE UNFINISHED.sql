;WITH WEEKS 
(
SELECT 
ACT_START,
ACT_START + ACT_DURATION ACT_END,
ACT_ACT Activity,
ACT_EST,
ACT_REM,
ACT_TRADE,
ACT_PERSONS,
AVT_EVENT
FROM R5ACTIVITIES
AND ACT_REM IS NOT NULL 
AND ACT_REM > '0'


)
SELECT

CASE WHEN EVT_PPM IS NOT NULL THEN '3 - Preventative Maintenance'
           WHEN EVT_PPM IS NULL AND EVT_CLASS IS NOT NULL THEN '3 - Preventative Maintenance'
           WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '+' AND EVT_UDFCHAR08 IS NULL THEN '2 - Change'
           WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '+' AND EVT_UDFCHAR08 IS NOT NULL THEN '1 - Projects'
           WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '-' THEN '4 - Corrective Maintenance'
END HLSUM1,


CASE      WHEN EVT_PPM IS NOT NULL     
                           THEN ISNULL(EVT_CLASS,'OTHER') + ' - ' +  ISNULL(CLS_DESC,'Not in Strategy')
                WHEN EVT_PPM IS NULL AND EVT_CLASS IS NOT NULL 
                           THEN EVT_CLASS + ' - ' +  CLS_DESC
                WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '+' 
                          THEN ISNULL((CASE WHEN EVT_UDFCHAR08 IS NULL THEN SCG_DESC 
                                                                                                  ELSE 'PROJ' END),'Z - No Owner Assigned')
                WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '-' AND EVT_MRC = 'FAC' THEN 'FAC'
                WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '-'  
                          THEN ISNULL(TRD_CLASS,'zGeneric')
END HLSUM2,


CASE     WHEN EVT_UDFCHKBOX03 = '+' AND  EVT_UDFCHAR08 IS NOT NULL  AND EVT_UDFCHKBOX04  = '+'            
                           THEN EVT_UDFCHAR08 + ' - ' + EVT_DESC
               WHEN EVT_UDFCHKBOX03 = '+' AND EVT_UDFCHAR08 IS NOT NULL AND EVT_UDFCHKBOX04  = '-'  AND EVT_UDFCHAR13 = 'Closeout' 
                           THEN 'Closeout - PROJ'
               WHEN EVT_UDFCHKBOX03 = '+' AND  EVT_UDFCHAR08 IS NOT NULL AND EVT_UDFCHKBOX04  = '-'              
                           THEN 'Summary - PROJ'
               WHEN EVT_UDFCHKBOX03 = '+' AND  EVT_UDFCHAR08 IS NULL AND EVT_UDFCHKBOX04  = '+'
                           THEN EVT_CODE + ' - ' + EVT_DESC
               WHEN EVT_UDFCHKBOX03 = '+' AND  EVT_UDFCHAR08 IS NULL AND EVT_UDFCHKBOX04  = '-'
                           THEN 'Change Summary - ' + EVT_SCHEDGRP
               WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '-' AND EVT_UDFCHKBOX04  = '+'
                           THEN EVT_CODE + ' - ' + EVT_DESC
               WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '-' AND EVT_UDFCHKBOX04  = '-' AND EVT_MRC = 'FAC' 
                           THEN 'Corr. Summary - FAC'
               WHEN EVT_PPM IS NULL AND EVT_UDFCHKBOX03 = '-' AND EVT_UDFCHKBOX04  = '-'
                           THEN 'Corr. Summary - ' + TRD_CLASS
               WHEN EVT_UDFCHKBOX04  = '-'  AND EVT_PPM IS NOT NULL
                           THEN 'PM Summary - ' + EVT_CLASS
               WHEN EVT_UDFCHKBOX04  = '+' AND EVT_PPM IS NOT NULL 
                           THEN EVT_PPM + ' - ' + PPM_DESC
               ELSE 'Other - Summary'
               
END HLSUM3,


CASE     WHEN EVT_UDFCHKBOX04  = '-'
                           THEN 
                                    CASE WHEN  EVT_PPM IS NOT NULL 
                                                           THEN EVT_PPM+' - '+PPM_DESC
                                               WHEN  EVT_UDFCHKBOX03 = '+' AND  EVT_UDFCHAR08 IS NOT NULL              
                                                           THEN EVT_UDFCHAR08 + ' - ' + EVT_DESC
                                               ELSE   EVT_CODE + ' - ' + EVT_DESC END
                                     ELSE EVT_CODE + ' - ' + EVT_OBJECT END HLSUM4, 
EVT_CODE + '-' + CAST(ACT_ACT AS varchar(4)) HLSUM5,
EVT_CODE,
EVT_DESC,
EVT_OBJECT,
EVT_JOBTYPE,
EVT_LOCATION,
EVT_MRC,
EVT_STATUS,
EVT_UDFCHKBOX04 EVT_SIGWO,
EVT_UDFCHKBOX03 EVT_CHANGETICK,
ACT_START,
ACT_START + ACT_DURATION ACT_END,
EVT_SCHEDGRP,
EVT_UDFDATE02 EVT_DUEDATE,
EVT_CLASS,
EVT_PPM,
EVT_PRIORITY,
EVT_COSTCODE,
EVT_UDFCHAR08 EVT_PROJ,
ACT_ACT Activity,
ACT_EST,
ACT_REM,
ACT_TRADE,
ACT_PERSONS,
TRD_CLASS


FROM R5EVENTS
LEFT OUTER JOIN R5ACTIVITIES ON ACT_EVENT = EVT_CODE
LEFT OUTER JOIN R5TRADES ON ACT_TRADE = TRD_CODE
LEFT OUTER JOIN R5PPMS ON EVT_PPM = PPM_CODE
LEFT OUTER JOIN R5CLASSES ON EVT_CLASS = CLS_CODE AND CLS_ENTITY = 'EVNT'
LEFT OUTER JOIN R5SCHEDGROUPS ON EVT_SCHEDGRP =SCG_CODE
WHERE EVT_JOBTYPE IS NOT NULL AND EVT_RSTATUS NOT IN ('C','A')
AND EVT_STATUS NOT IN ('CLOS','CANC','CHWA','RQST','B')
AND(EVT_JOBTYPE NOT IN ('MEC','SYSUPD','AMPACT','NMST','NMTR'))
AND ACT_REM IS NOT NULL 
AND ACT_REM > '0'