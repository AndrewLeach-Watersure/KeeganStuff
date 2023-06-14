DECLARE
  @note      NVARCHAR(80),   -- r5orders.ord_udfchar02%type
  @reqnote   NVARCHAR(80),   -- r5requisitions.req_udfchar05%type
  @noteToSupplier    NVARCHAR(80),   -- r5orders.ord_udfchar02%type
  @aggrelen  INTEGER,
  @desc  NVARCHAR(80),
  @olddesc  NVARCHAR(80),
  @order NVARCHAR(30);

BEGIN
  SELECT  @note = ORD_UDFCHAR02,
          @reqnote = REQ_UDFCHAR05,
          @aggrelen = LEN(ORD_UDFCHAR02+REQ_UDFCHAR05)+3,
          @desc = REQ_DESC,
          @olddesc = ORD_DESC,
          @order = ORL_ORDER
  FROM R5ORDERS, R5ORDERLINES, R5REQUISITIONS
  WHERE ORL_ORDER = ORD_CODE AND 
        ORL_REQ = REQ_CODE AND 
        ORL_SQLIDENTITY = :rowid;

  IF (@olddesc <> '(DEFAULT PURCHASE ORDER DESCRIPTION)')
    SET @desc = @olddesc;
               
  IF (@note IS NULL ) SET @noteToSupplier = @reqnote;
    ELSE
      BEGIN
        IF(@note = @reqnote) RETURN
        IF (@aggrelen<=80)
          SET @noteToSupplier = @note+' | ' + @reqnote;
        ELSE
          SET @noteToSupplier = LEFT( @note+' | '+@reqnote, 74) + ' (...)';
      END

  UPDATE R5ORDERS
  SET ORD_UDFCHAR02 = @noteToSupplier,
      ORD_DESC = @desc
  FROM R5ORDERS
  WHERE ORD_CODE = @order;
  
  UPDATE R5REQUISLINES
     SET RQL_UDFCHAR02 = ORL_ORDER, RQL_UDFCHAR03 = ORL_ORDLINE
  FROM R5ORDERLINES
  WHERE ORL_REQ = RQL_REQ 
     AND ORL_REQLINE = RQL_REQLINE
     AND ORL_SQLIDENTITY = :rowid

END
