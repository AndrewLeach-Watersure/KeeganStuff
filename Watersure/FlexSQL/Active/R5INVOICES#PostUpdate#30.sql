--Invoice and Inv Rev
DECLARE 
		@vLid NVARCHAR(2) = 'A',
		@vType NVARCHAR(50) = 'EPI',
		@vRevType NVARCHAR(50) = 'EACC',
		@vAmount NUMERIC(24, 6),
		@vRevAmount NUMERIC(24, 6),
		@vTaxAmount NUMERIC(24, 6),
		@vSegment1 NVARCHAR(30),
		@vSegment2 NVARCHAR(30),
		@vSupplier NVARCHAR(60),
		@vDesc NVARCHAR(500),
		@vInvCode NVARCHAR(25),
		@vCurr NVARCHAR(10),
		@vOrlCurr NVARCHAR(10),
		@vTaxCode NVARCHAR(20),
		@vInvRef NVARCHAR(50),
		@vCreatedDate DATETIME,
		@vDueDate DATETIME,
		@nReturn INTEGER,
		@vIvlOrder NVARCHAR(50),
		@nGltransid NVARCHAR(32),
		@sChk NVARCHAR(8),
		@vOrdDesc NVARCHAR(250),
		@vCostcode NVARCHAR(750),
		@vExchRate NUMERIC(24, 12),
		@vOrlExchRate NUMERIC(24, 12),
		@nRunid NVARCHAR(32),
		@vActPeriod NVARCHAR(30),
		@vInvLine INTEGER,
		@vOrdline INTEGER,
		@nEntryid NVARCHAR(32),
		@vTotTaxAmount NUMERIC(24, 6),
		@vTotAmount NUMERIC(24, 6),
		@revCheck NVARCHAR(32);
BEGIN
	SELECT 
		@vInvCode = INV_CODE,
		@vOrdDesc = ORD_DESC,
		@vInvRef = INV_REF,
		@vCurr = INV_CURR,
		@vSupplier = INV_SUPPLIER,
		@vDesc = INV_DESC,
		@vCreatedDate = INV_DATE,
		@vDueDate = INV_PAYDATE,
		@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2), GETDATE(), 101),YEAR(GETDATE())),
		@vTotTaxAmount = (SELECT SUM((IVL_TOTTAXAMOUNT) / IVL_EXCH) FROM R5INVOICELINES WHERE IVL_INVOICE = INV_CODE),
		@vTotAmount = (SELECT SUM(((IVL_INVQTY * IVL_PRICE) + IVL_TOTTAXAMOUNT + IVL_TOTEXTRA) / IVL_EXCH) FROM R5INVOICELINES WHERE IVL_INVOICE = INV_CODE)
		FROM R5INVOICES,R5ORDERS
		WHERE INV_ORDER = ORD_CODE
			AND INV_UDFDATE01 IS NULL
			AND INV_TYPE = 'I'
			AND INV_STATUS = 'A'
			AND INV_RSTATUS = 'A'
			AND INV_CODE NOT LIKE 'EPI%'
			AND INV_SQLIDENTITY = :rowid;


	IF @vInvCode IS NOT NULL 
		BEGIN
			BEGIN 
			DECLARE cursor_invrev CURSOR LOCAL STATIC FOR
				SELECT 	IVL_TAX,
						IVL_ORDER,
						ORL_ORDLINE,
						(IVL_PRICE * IVL_INVQTY) / ORL_EXCH,
						ORL_COSTCODE,
						ORL_UDFCHAR07,
						ORL_UDFCHAR09,
						IVL_INVLINE
					FROM R5INVOICELINES,R5ORDERLINES
					WHERE IVL_ORDER = ORL_ORDER
					AND IVL_ORDLINE = ORL_ORDLINE
					AND IVL_MATCHED = 'M'
					AND ISNULL(IVL_UDFCHAR03, 'X') <> 'R'
					AND IVL_INVOICE = @vInvCode;
			
				OPEN cursor_invrev
				FETCH NEXT FROM cursor_invrev
				INTO @vTaxCode,@vIvlOrder,@vOrdline,@vRevAmount,@vCostcode,@vSegment1,@vSegment2,@vInvLine
				WHILE @@FETCH_STATUS = 0
				BEGIN
						execute @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT,N'GLR',N'1',@sChk OUTPUT 
						execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
						execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
							INSERT INTO R5GLINTERFACE (
									GLI_TRANSID,
									GLI_RUNID,
									GLI_STATUS,
									GLI_REFERENCE5,
									GLI_ACCOUNTINGDATE,
									GLI_DATECREATED,
									GLI_CREATEDBY,
									GLI_ACTUALFLAG,
									GLI_USERJECATEGORYNAME,
									GLI_USERJESOURCENAME,
									GLI_ENTEREDDR,
									GLI_CURRENCYCODE,
									GLI_TRANSACTIONDATE,
									GLI_ENTRYID,
									GLI_SEQNUM,
									GLI_INVOICEAMOUNT,
									GLI_SEGMENT1,
									GLI_SEGMENT2,
									GLI_SEGMENT3,
									GLI_SEGMENT6,
									GLI_CURRENCYCONVERSIONRATE,
									GLI_GLNOMACCT,
									GLI_REFERENCE1,
									GLI_REFERENCE2,
									GLI_GROUP,
									GLI_REFERENCE4,
									GLI_PROCESS,
									GLI_CURRENCYCONVERSIONDATE,
									GLI_INVOICEDATE,
									GLI_REFERENCE6,
									GLI_REFERENCE7
							)
							VALUES(
									CONVERT(INTEGER, @nGltransid),
									@nRunid,
									'NEW',
									@vLid,
									@vCreatedDate,
									GETDATE(),
									42,
									'D',
									NULL,
									'SS1',
									(-1 * @vRevAmount),
									'AUD',
									@vCreatedDate,
									CONVERT(INTEGER, @nEntryid),
									1,
									(-1 * @vRevAmount),
									@vSegment1,
									@vSegment2,
									@vTaxCode,
									@vSupplier,
									1,
									'0505',
									@vRevType,
									CONCAT(@vIvlOrder, '-', @vOrdline),
									'Inv Rev',
									@vOrdDesc,
									CONCAT(@vIvlOrder, '-', @vOrdline),
									@vCreatedDate,
									@vDueDate,
									CONCAT(@vIvlOrder, '-', @vOrdline),
									@vActPeriod
							) 
						execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
						execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
							INSERT INTO R5GLINTERFACE (
									GLI_TRANSID,
									GLI_RUNID,
									GLI_STATUS,
									GLI_REFERENCE5,
									GLI_ACCOUNTINGDATE,
									GLI_DATECREATED,
									GLI_CREATEDBY,
									GLI_ACTUALFLAG,
									GLI_USERJECATEGORYNAME,
									GLI_USERJESOURCENAME,
									GLI_ENTEREDCR,
									GLI_CURRENCYCODE,
									GLI_TRANSACTIONDATE,
									GLI_ENTRYID,
									GLI_SEQNUM,
									GLI_INVOICEAMOUNT,
									GLI_SEGMENT1,
									GLI_SEGMENT2,
									GLI_SEGMENT3,
									GLI_SEGMENT6,
									GLI_CURRENCYCONVERSIONRATE,
									GLI_GLNOMACCT,
									GLI_REFERENCE1,
									GLI_REFERENCE2,
									GLI_GROUP,
									GLI_REFERENCE4,
									GLI_PROCESS,
									GLI_CURRENCYCONVERSIONDATE,
									GLI_INVOICEDATE,
									GLI_REFERENCE6,
									GLI_REFERENCE7
							)
							VALUES(
									CONVERT(INTEGER, @nGltransid),
									@nRunid,
									'NEW',
									@vLid,
									@vCreatedDate,
									GETDATE(),
									42,
									'C',
									NULL,
									'SS1',
									@vRevAmount,
									'AUD',
									@vCreatedDate,
									CONVERT(INTEGER, @nEntryid),
									1,
									@vRevAmount,
									@vSegment1,
									@vSegment2,
									@vTaxCode,
									@vSupplier,
									1,
									@vCostcode,
									@vRevType,
									CONCAT(@vIvlOrder, '-', @vOrdline),
									'Inv Rev',
									@vOrdDesc,
									CONCAT(@vIvlOrder, '-', @vOrdline),
									@vCreatedDate,
									@vDueDate,
									CONCAT(@vIvlOrder, '-', @vOrdline),
									@vActPeriod
							)
						UPDATE R5INVOICELINES SET IVL_UDFCHAR03 = 'R' WHERE IVL_INVLINE = @vInvLine AND IVL_INVOICE = @vInvCode;
						FETCH NEXT FROM cursor_invrev
					INTO @vTaxCode,@vIvlOrder,@vOrdline,@vRevAmount,@vCostcode,@vSegment1,@vSegment2,@vInvLine
				END;
				CLOSE cursor_invrev
			DEALLOCATE cursor_invrev
			END;
		BEGIN
		execute @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT,N'GLR',N'1',@sChk OUTPUT 
		BEGIN 
			DECLARE cursor_invoice CURSOR LOCAL STATIC FOR
				SELECT 	IVL_TAX,
						IVL_ORDER,
						ORL_ORDLINE,
						(((IVL_INVQTY * IVL_PRICE) + IVL_TOTTAXAMOUNT + IVL_TOTEXTRA) / IVL_EXCH),
						(IVL_TOTTAXAMOUNT) / IVL_EXCH,
						ORL_COSTCODE,
						ORL_UDFCHAR07,
						ORL_UDFCHAR09,
						IVL_INVLINE
					FROM R5INVOICELINES,R5ORDERLINES
					WHERE IVL_ORDER = ORL_ORDER
					AND IVL_ORDLINE = ORL_ORDLINE
					AND IVL_MATCHED = 'M'
					AND ISNULL(IVL_UDFCHAR02, 'X') <> 'M'
					AND IVL_INVOICE = @vInvCode;
				OPEN cursor_invoice
				FETCH NEXT FROM cursor_invoice
				INTO @vTaxCode,@vIvlOrder,@vOrdline,@vAmount,@vTaxAmount,@vCostcode,@vSegment1,@vSegment2,@vInvLine
				WHILE @@FETCH_STATUS = 0
				BEGIN
						execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
						execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
						INSERT INTO R5GLINTERFACE (
								GLI_TRANSID,
								GLI_RUNID,
								GLI_STATUS,
								GLI_REFERENCE5,
								GLI_ACCOUNTINGDATE,
								GLI_DATECREATED,
								GLI_CREATEDBY,
								GLI_ACTUALFLAG,
								GLI_USERJECATEGORYNAME,
								GLI_USERJESOURCENAME,
								GLI_ENTEREDDR,
								GLI_CURRENCYCODE,
								GLI_TRANSACTIONDATE,
								GLI_ENTRYID,
								GLI_SEQNUM,
								GLI_INVOICEAMOUNT,
								GLI_SEGMENT1,
								GLI_SEGMENT2,
								GLI_SEGMENT3,
								GLI_SEGMENT6,
								GLI_GLNOMACCT,
								GLI_REFERENCE1,
								GLI_REFERENCE2,
								GLI_GROUP,
								GLI_REFERENCE4,
								GLI_PROCESS,
								GLI_CURRENCYCONVERSIONDATE,
								GLI_INVOICEDATE,
								GLI_REFERENCE6,
								GLI_REFERENCE7,
								GLI_CURRENCYCONVERSIONRATE
						)
						VALUES(
								CONVERT(INTEGER, @nGltransid),
								@nRunid,
								'NEW',
								@vLid,
								@vCreatedDate,
								GETDATE(),
								42,
								'D',
								NULL,
								'JBA',
								(-1 *(@vAmount - @vTaxAmount)),
								'AUD',
								@vCreatedDate,
								CONVERT(INTEGER, @nEntryid),
								1,
								(-1 *(@vAmount - @vTaxAmount)),
								@vSegment1,
								@vSegment2,
								@vTaxCode,
								@vSupplier,
								@vCostcode,
								@vType,
								@vInvRef,
								'Invoice',
								@vDesc,
								CONCAT(@vInvCode, '-', @vInvLine),
								@vCreatedDate,
								@vDueDate,
								CONCAT(@vInvCode, '-', @vInvLine),
								@vActPeriod,
								1
						);
						UPDATE R5INVOICELINES SET IVL_UDFCHAR02 = 'M' WHERE IVL_INVLINE = @vInvLine AND IVL_INVOICE = @vInvCode;
						FETCH NEXT FROM cursor_invoice
					INTO @vTaxCode,@vIvlOrder,@vOrdline,@vAmount,@vTaxAmount,@vCostcode,@vSegment1,@vSegment2,@vInvLine
				END;
				CLOSE cursor_invoice
			DEALLOCATE cursor_invoice
		END;
					IF (ISNULL(@vTotTaxAmount, 0) <> 0) 
				BEGIN 
					execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
					execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
							INSERT INTO R5GLINTERFACE (
								GLI_TRANSID,
								GLI_RUNID,
								GLI_STATUS,
								GLI_REFERENCE5,
								GLI_ACCOUNTINGDATE,
								GLI_DATECREATED,
								GLI_CREATEDBY,
								GLI_ACTUALFLAG,
								GLI_USERJECATEGORYNAME,
								GLI_USERJESOURCENAME,
								GLI_ENTEREDDR,
								GLI_CURRENCYCODE,
								GLI_TRANSACTIONDATE,
								GLI_ENTRYID,
								GLI_SEQNUM,
								GLI_INVOICEAMOUNT,
								GLI_SEGMENT1,
								GLI_SEGMENT2,
								GLI_SEGMENT3,
								GLI_SEGMENT6,
								GLI_GLNOMACCT,
								GLI_REFERENCE1,
								GLI_REFERENCE2,
								GLI_GROUP,
								GLI_REFERENCE4,
								GLI_PROCESS,
								GLI_CURRENCYCONVERSIONDATE,
								GLI_INVOICEDATE,
								GLI_REFERENCE6,
								GLI_REFERENCE7,
								GLI_CURRENCYCONVERSIONRATE
							)
							VALUES(
								CONVERT(INTEGER, @nGltransid),
								@nRunid,
								'NEW',
								@vLid,
								@vCreatedDate,
								GETDATE(),
								42,
								'D',
								NULL,
								'JBA',
								(-1 * @vTotTaxAmount),
								'AUD',
								@vCreatedDate,
								CONVERT(INTEGER, @nEntryid),
								1,
								(-1 * @vTotTaxAmount),
								@vSegment1,
								@vSegment2,
								@vTaxCode,
								@vSupplier,
								'0552',
								@vType,
								@vInvRef,
								'Invoice',
								@vDesc,
								@vInvCode,
								@vCreatedDate,
								@vDueDate,
								@vInvCode,
								@vActPeriod,
								1
							)
				END
		execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
		execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
			INSERT INTO R5GLINTERFACE (
					GLI_TRANSID,
					GLI_RUNID,
					GLI_STATUS,
					GLI_REFERENCE5,
					GLI_ACCOUNTINGDATE,
					GLI_DATECREATED,
					GLI_CREATEDBY,
					GLI_ACTUALFLAG,
					GLI_USERJECATEGORYNAME,
					GLI_USERJESOURCENAME,
					GLI_ENTEREDCR,
					GLI_CURRENCYCODE,
					GLI_TRANSACTIONDATE,
					GLI_ENTRYID,
					GLI_SEQNUM,
					GLI_INVOICEAMOUNT,
					GLI_GLNOMACCT,
					GLI_REFERENCE2,
					GLI_REFERENCE4,
					GLI_SEGMENT1,
					GLI_SEGMENT2,
					GLI_SEGMENT3,
					GLI_SEGMENT6,
					GLI_REFERENCE1,
					GLI_PROCESS,
					GLI_CURRENCYCONVERSIONDATE,
					GLI_INVOICEDATE,
					GLI_GROUP,
					GLI_REFERENCE6,
					GLI_REFERENCE7,
					GLI_CURRENCYCONVERSIONRATE
			)
			VALUES(
				CONVERT(INTEGER, @nGltransid),
				@nRunid,
				'NEW',
				@vLid,
				@vCreatedDate,
				GETDATE(),
				42,
				'C',
				NULL,
				'JBA',
				@vTotAmount,
				'AUD',
				@vCreatedDate,
				CONVERT(INTEGER, @nEntryid),
				1,
				@vTotAmount,
				@vSupplier,
				@vInvRef,
				@vDesc,
				@vSegment1,
				@vSegment2,
				@vTaxCode,
				@vSupplier,
				@vType,
				@vInvCode,
				@vCreatedDate,
				@vDueDate,
				'Invoice',
				@vInvCode,
				@vActPeriod,
				1
			)
		UPDATE R5INVOICES SET INV_UDFDATE01 = GETDATE() WHERE INV_CODE = @vInvCode;
		END;
		END;
END;
