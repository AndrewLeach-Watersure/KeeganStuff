BEGIN
DECLARE
  @WO nvarchar(10),
  @Act nvarchar(10),
  @lab numeric(20,2),
  @mat numeric(20,2),
  @total numeric(20,2),
  @calc nvarchar(1),
  @supplier NVARCHAR(30);

SELECT
  @WO = ACT_EVENT,
  @act = ACT_ACT,
  @calc = ACT_UDFCHKBOX03,
  @supplier = ACT_SUPPLIER 
FROM R5ACTIVITIES 
WHERE ACT_SQLIDENTITY = :rowid

SELECT @lab = (   SELECT ISNULL(SUM(Lab),0) Labour
                    FROM (  SELECT ACT_EVENT,
                                   ACT_ACT,
                                   CASE WHEN ACT_HIRE = '+' THEN (RQL_PRICE * RQL_QTY * RQL_EXCH) ELSE (ACT_EST * TRR_NTRATE) END as Lab
                                   FROM R5ACTIVITIES 
                                   LEFT OUTER JOIN R5REQUISLINES ON RQL_EVENT = ACT_EVENT AND RQL_ACT = ACT_ACT AND RQL_RSTATUS = 'A' AND RQL_RTYPE LIKE 'S_'
                                   LEFT OUTER JOIN R5TRADERATES ON ACT_TRADE = TRR_TRADE AND TRR_OCTYPE = 'N'
                                   WHERE ACT_EVENT = @WO AND ACT_ACT = @act
                          ) labourCalc
                ),
         @mat = (   SELECT ISNULL(SUM(Mat),0) Material
                    FROM(   SELECT  ACT_EVENT,
                                    ACT_ACT,
                                    RQL_EXCH * RQL_PRICE * RQL_QTY as Mat,
                                    'RQL' as Type
                            FROM R5ACTIVITIES 
                            LEFT OUTER JOIN R5REQUISLINES ON RQL_EVENT = ACT_EVENT 
                                                          AND RQL_ACT = ACT_ACT 
                                                          AND RQL_RSTATUS = 'A' 
                                                          AND RQL_RTYPE LIKE 'P%'
                            
                            WHERE (RQL_EXCH * RQL_PRICE * RQL_QTY) IS NOT NULL 
                                AND ACT_EVENT = @WO 
                                AND ACT_ACT = @act
                            UNION
                            SELECT  ACT_EVENT,
                                    ACT_ACT,
                                    DBO.O7PLNQTY(TRL_EVENT,TRL_ACT,TRL_PART,TRL_PART_ORG,TRL_STORE,TRL_LINE)*PPR_AVGPRICE as Mat,
                                    'TRL' as Type
                            FROM R5ACTIVITIES
                            LEFT OUTER JOIN R5WORKORDERPARTSUMMARY ON ACT_ACT = trl_ACT AND ACT_EVENT = TRL_EVENT
                            LEFT OUTER JOIN R5PARTPRICES ON PPR_PART = TRL_PART
                            WHERE TRL_LINE != 0 
                                AND ACT_EVENT = @WO 
                                AND ACT_ACT = @act
                        ) as matCalc
                    GROUP BY ACT_EVENT,ACT_ACT),@total = ISNULL(@lab,0) + ISNULL(@mat,0)
FROM DUAL

IF @calc = '-'
  BEGIN
    UPDATE R5ACTIVITIES
    SET ACT_UDFCHAR02 = @lab,
        ACT_UDFCHAR03 = @mat,
        ACT_UDFCHAR05 = @total,
        ACT_SUPPLIER = CASE WHEN @supplier = '*' THEN NULL ELSE ACT_SUPPLIER END,
        ACT_SUPPLIER_ORG = CASE WHEN @supplier = '*' THEN NULL ELSE ACT_SUPPLIER END
    WHERE ACT_SQLIDENTITY=:rowid
  END

IF @calc = '+'
  BEGIN
    UPDATE R5ACTIVITIES
    SET ACT_UDFCHAR02 = @lab,
        ACT_UDFCHAR03 = @mat,
        ACT_UDFCHAR05 = @total,
        ACT_ESTLABORCOST = @lab,
        ACT_ESTMATLCOST = @mat,
        ACT_SUPPLIER = CASE WHEN @supplier = '*' THEN NULL ELSE ACT_SUPPLIER END,
        ACT_SUPPLIER_ORG = CASE WHEN @supplier = '*' THEN NULL ELSE ACT_SUPPLIER END
    WHERE ACT_SQLIDENTITY=:rowid
  END

END
