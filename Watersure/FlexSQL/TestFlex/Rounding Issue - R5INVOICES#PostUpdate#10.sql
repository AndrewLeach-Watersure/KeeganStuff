DECLARE @i NVARCHAR(100);
BEGIN
SELECT @i = COUNT(IVL_SQLIDENTITY)
FROM r5invoices
	LEFT OUTER JOIN R5INVOICELINES ON IVL_INVOICE = INV_CODE
WHERE inv_status <> 'U'
	AND IVL_TAX IS NULL
	AND inv_sqlidentity = :ROWID;
SELECT @i = @I + COUNT(IVD_SQLIDENTITY)
FROM r5invoices
	LEFT OUTER JOIN r5invdistributions ON IVD_INVOICE = INV_CODE
WHERE inv_status <> 'U'
	AND IVD_TAX IS NULL
	AND inv_sqlidentity = :ROWID;
IF @i > 0 BEGIN RAISERROR('Tax Code is missing from 1 or more lines', 16, 1);
END
END 

BEGIN
	UPDATE R5INVOICES
	SET INV_UDFCHKBOX01 = '-',
		INV_STATUS = 'U',
		INV_RSTATUS = 'U'
	WHERE INV_SQLIDENTITY = :rowid
		AND INV_UDFCHKBOX01 = '+'
		AND INV_STATUS = 'A'
		AND INV_TYPE = 'N'
END

BEGIN

DECLARE
@net NUMERIC(24, 6),
@tax NUMERIC(24, 6),
@gross NUMERIC(24, 6);

SELECT @tax = (SELECT SUM((IVL_TOTTAXAMOUNT) / IVL_EXCH) FROM R5INVOICELINES WHERE IVL_INVOICE = INV_CODE),
@gross = (SELECT SUM(((IVL_INVQTY * IVL_PRICE) + IVL_TOTTAXAMOUNT + IVL_TOTEXTRA) / IVL_EXCH) FROM R5INVOICELINES WHERE IVL_INVOICE = INV_CODE),
@net = @gross - @tax
FROM R5INVOICES
WHERE INV_SQLIDENTITY = :rowid
AND INV_STATUS <> 'U'

SELECT @tax = ROUND(@tax,2,1),
@gross = ROUND(@gross,2,1),
@net = ROUND(@net,2,1)

IF (@tax + @net - @gross <> 0)
BEGIN
RAISERROR('Lines will not balance in SUN',16,1)
END
END