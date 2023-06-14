DECLARE @RECV DECIMAL(19,5),
                  @ORD   DECIMAL(19,5)
BEGIN
SELECT @RECV = ORL_RECVVALUE,
                @ORD = ORL_ORDQTY*ORL_PRICE
FROM R5ORDERLINES WHERE ORL_SQLIDENTITY = :rowid

IF @RECV > @ORD 
RAISERROR('Amount to be receipted exceeds PO balance.  This receipt will not be accepted.',16,1);

IF @RECV = @ORD
BEGIN
IF TRIGGER_NESTLEVEL() > 7
RETURN
UPDATE R5ORDERLINES
SET ORL_ACTIVE = '-'
WHERE ORL_SQLIDENTITY = :rowid
END
END

