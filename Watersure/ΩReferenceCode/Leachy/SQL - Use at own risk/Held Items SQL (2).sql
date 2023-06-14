SELECT *

FROM R5PARTS,R5STOCK
LEFT OUTER JOIN 
  R5ONREQUI ON STO_PART = ORE_PART AND STO_PART_ORG = ORE_PART_ORG AND STO_STORE = ORE_STORE
LEFT OUTER JOIN
  R5ONORDER ON STO_PART = ONO_PART AND STO_PART_ORG = ONO_PART_ORG AND STO_STORE = ONO_STORE
LEFT OUTER JOIN
        (
         SELECT   SUM(TST_QTY) INTRANSITQTY, 
                  TST_TOCODE 
         FROM     R5TRANSTOCK 
         WHERE    TST_PART = PAR_CODE AND 
                  TST_PART_ORG = PAR_ORG AND 
                  TST_ORDER IS NULL 
         GROUP BY TST_TOCODE
        ) transtock ON STO_STORE = transtock.TST_TOCODE
LEFT OUTER JOIN 
       (
        SELECT    SUM( RQL_QTY - COALESCE( RQL_RECVQTY, 0 ) - COALESCE( RQL_SCRAPQTY, 0 )) STSTQTY, 
                  REQ_FROMCODE 
        FROM      R5REQUISLINES,
                  R5REQUISITIONS  
        WHERE     REQ_CODE = RQL_REQ AND 
                  RQL_RSTATUS IN ( 'U', 'R', 'A' ) AND 
                  RQL_ACTIVE = '+' AND 
                  REQ_RTYPE  = 'STST' AND 
                  RQL_PART = PAR_CODE  AND 
                  RQL_PART_ORG = PAR_ORG AND 
                  NOT EXISTS (
                              SELECT 'x' 
                              FROM   R5TRANSACTIONS  
                              WHERE  TRA_RTYPE = 'I' AND 
                                     TRA_FROMRENTITY='STOR' AND 
                                     TRA_TORENTITY='STOR' AND 
                                     TRA_REQ = RQL_REQ
                              ) 
        GROUP BY REQ_FROMCODE
       ) storetostore ON STO_STORE = storetostore.REQ_FROMCODE
LEFT OUTER JOIN
       (
        SELECT   SUM(PIP_QTY - COALESCE(PIP_ISSUEQTY,0)) ONPICKLISTQTY, 
                 PIC_STORE FROM R5PICKLISTPARTS, 
                 R5PICKLISTS 
        WHERE PIC_RSTATUS = 'A' AND 
              PIC_CODE = PIP_PICKLIST AND 
              PIP_PART = PAR_CODE AND 
              PIP_PART_ORG = PAR_ORG AND 
              PIP_QTY > COALESCE(PIP_ISSUEQTY,0) 
        GROUP BY PIC_STORE) picklist ON STO_STORE = picklist.PIC_STORE
LEFT OUTER JOIN
       (
        SELECT SUM(RES_QTY) RESQTY, 
               SUM(RES_ALLQTY) ALLQTY, 
               RES_STORE 
        FROM   R5RESERVATIONS 
        WHERE  RES_PART = PAR_CODE AND 
               RES_PART_ORG = PAR_ORG 
        GROUP BY RES_STORE) reservations ON STO_STORE = reservations.RES_STORE,
R5STORES

WHERE   (
        STO_PART = PAR_CODE OR 
        (COALESCE(par_trackbycondition ,'-') = '+' AND par_parentpart = PAR_CODE)
        )
AND STO_PART_ORG = PAR_ORG
AND STO_STORE = STR_CODE
AND STO_PART = par_code 
AND STO_PART_ORG = par_org
