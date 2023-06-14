UPDATE R5INVOICELINES
SET IVL_TAXAMOUNT = ROUND(IVL_TAXAMOUNT, 2),
	IVL_AMOUNT = ROUND(IVL_AMOUNT, 2)
WHERE IVL_SQLIDENTITY = :rowid
	AND (
		IVL_AMOUNT <> ROUND(IVL_AMOUNT, 2)
		OR IVL_TAXAMOUNT <> ROUND(IVL_TAXAMOUNT, 2)
	)