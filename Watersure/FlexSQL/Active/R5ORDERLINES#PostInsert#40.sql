DECLARE
  @snew   nvarchar(4),
  @dept  nvarchar(10),  
  @cost   nvarchar(4),
  @costcheck nvarchar(10),
  @deptcheck nvarchar(10),
  @evnt nvarchar(20),
  @Wmrc nvarchar(10),
  @req nvarchar(10),
  @rql nvarchar(10),
  @i nvarchar(1);

BEGIN
  SELECT 
    @snew = ORL_STATUS, 
    @dept = ORL_UDFCHAR07,
    @cost = ORL_COSTCODE,
    @evnt = ORL_EVENT,
    @i = ORL_UDFCHKBOX01,
    @req = ORL_REQ,
    @rql = ORL_REQLINE
   FROM R5ORDERLINES 
   WHERE  orl_sqlidentity = :rowid; 
 
  SELECT @Wmrc = EVT_MRC FROM R5EVENTS WHERE EVT_CODE = @evnt;

 
  IF @evnt IS NOT NULL
    BEGIN
       IF @dept IS NULL
        SET @dept = @Wmrc;
    END
    ELSE IF @evnt IS NULL
      BEGIN
        SELECT @dept = RQL_UDFCHAR05 
          FROM R5REQUISLINES 
          WHERE RQL_REQ = @req AND RQL_REQLINE = @rql
        END

      UPDATE R5ORDERLINES 
      SET ORL_UDFCHAR07 = @dept
      WHERE ORL_SQLIDENTITY = :rowid AND COALESCE(ORL_UDFCHAR07,'x') <> @dept; 

  SELECT @costcheck = COUNT(CST_CODE) FROM R5COSTCODES WHERE CST_CODE = @cost AND CST_NOTUSED = '-';
  SELECT @deptcheck = COUNT(MRC_CODE) FROM R5MRCS WHERE MRC_CODE = @dept AND MRC_NOTUSED = '-';

  IF 
      (
            ((@costcheck < 1 OR  @cost IS NULL) 
            OR ((@deptcheck  < 1 AND @cost NOT LIKE '0%') OR (@dept IS NULL AND @cost NOT LIKE '0%')))   
      )
      BEGIN
        RAISERROR('GL Code or Cost Centre are not valid. Please Check', 16, 2);
      END
    
    IF @dept <> @Wmrc AND @evnt IS NOT NULL
        BEGIN	--Raise error when Requisition Department does not match WO Department
        RAISERROR('Order Line Department does not match WO department.',16,1);
        END    
    END
