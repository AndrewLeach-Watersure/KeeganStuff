--Non PO Invoice
DECLARE @vLid NVARCHAR(2) = 'A',
	@vType NVARCHAR(50) = 'EPX',
	@vAmount NUMERIC(24, 6),
	@vRevAmount NUMERIC(24, 6),
	@vTaxAmount NUMERIC(24, 6),
	@vSegment1 NVARCHAR(30),
	@vSegment2 NVARCHAR(30),
	@vSupplier NVARCHAR(60),
	@vInvRef NVARCHAR(50),
	@vDesc NVARCHAR(500),
	@vInvCode NVARCHAR(25),
	@vCurr NVARCHAR(10),
	@vOrlCurr NVARCHAR(10),
	@vTaxCode NVARCHAR(20),
	@vDate DATETIME,
	@vCreatedDate DATETIME,
	@vDueDate DATETIME,
	@nReturn INTEGER,
	@vIvlOrder NVARCHAR(50),
	@nGltransid NVARCHAR(32),
	@sChk NVARCHAR(8),
	@vOrdDesc NVARCHAR(250),
	@vCostcode NVARCHAR(750),
	@vExchRate NUMERIC(24, 12),
	@nRunid NVARCHAR(32),
	@vActPeriod NVARCHAR(30),
	@vTotTaxAmount NUMERIC(24, 6),
	@vTotAmount NUMERIC(24, 6),
	@nEntryid NVARCHAR(32);
BEGIN
	SELECT 	@vInvCode = INV_CODE,
			@vExchRate = INV_EXCH, 
			@vCurr = 'AUD',
			@vSupplier = INV_SUPPLIER,
			@vDesc = INV_DESC,
			@vDate = INV_APPROV,
			@vSegment1 = INV_UDFCHAR02,
			@vSegment2 = INV_UDFCHAR03,
			@vCreatedDate = INV_DATE,
			@vDueDate = INV_PAYDATE,
			@vInvRef = INV_REF,
			@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2), INV_APPROV, 101),YEAR(INV_APPROV))
		FROM R5INVOICES,
			R5INVDISTRIBUTIONS
		WHERE INV_CODE = IVD_INVOICE
			AND INV_TYPE = 'N'
			AND INV_STATUS = 'A'
			AND INV_RSTATUS = 'A'
			AND INV_CODE NOT LIKE 'EPI%'
			AND INV_UDFDATE01 IS NULL
			AND INV_SQLIDENTITY = :rowid;

	SELECT 	@vTotTaxAmount = SUM(IVD_TAXAMOUNT / ISNULL(@vExchRate, 1)),
			@vTotAmount = SUM(((IVD_AMOUNT) +(IVD_TAXAMOUNT)) / ISNULL(@vExchRate, 1))
		FROM R5INVDISTRIBUTIONS
		WHERE IVD_INVOICE = @vInvCode;

	IF @vInvCode IS NOT NULL 
		BEGIN 
			execute @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT,N'GLR',N'1',@sChk OUTPUT 
			BEGIN 
				DECLARE cursor_npoinvoice CURSOR LOCAL STATIC FOR
					SELECT 	IVD_TAX,
							((IVD_AMOUNT) +(IVD_TAXAMOUNT)) / ISNULL(@vExchRate, 1),
							IVD_TAXAMOUNT / ISNULL(@vExchRate, 1),
							GLC_SEGMENT1
						FROM R5INVDISTRIBUTIONS,R5GLCODECOMBINATIONS 
						WHERE IVD_INVOICE = @vInvCode 
							AND IVD_CCID = GLC_CODECOMBINATIONID;
					OPEN cursor_npoinvoice
					FETCH NEXT FROM cursor_npoinvoice
					INTO @vTaxCode,@vAmount,@vTaxAmount,@vCostcode
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
								@vDate,
								GETDATE(),
								42,
								'D',
								NULL,
								'JBA',
								(-1 *(@vAmount - @vTaxAmount)),
								@vCurr,
								@vDate,
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
								'NonPOInvoice',
								@vDesc,
								@vInvCode,
								@vCreatedDate,
								@vDueDate,
								@vInvCode,
								@vActPeriod,
								1
						);
						FETCH NEXT FROM cursor_npoinvoice
						INTO @vTaxCode,@vAmount,@vTaxAmount,@vCostcode
					END;
				CLOSE cursor_npoinvoice
				DEALLOCATE cursor_npoinvoice
			END;
	        BEGIN
				IF ISNULL(@vTotTaxAmount, 0) <> 0 
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
									GLI_REFERENCE2,
									GLI_SEGMENT1,
									GLI_SEGMENT2,
									GLI_SEGMENT3,
									GLI_SEGMENT6,
									GLI_GLNOMACCT,
									GLI_REFERENCE1,
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
								@vDate,
								GETDATE(),
								42,
								'D',
								NULL,
								'JBA',
								(-1 * @vTotTaxAmount),
								@vCurr,
								@vDate,
								CONVERT(INTEGER, @nEntryid),
								1,
								(-1 * @vTotTaxAmount),
								@vInvRef,
								@vSegment1,
								@vSegment2,
								@vTaxCode,
								@vSupplier,
								'0552',
								@vType,
								'NonPOInvoice',
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
							GLI_REFERENCE2,
							GLI_REFERENCE6,
							GLI_REFERENCE7,
							GLI_CURRENCYCONVERSIONRATE
				)
				VALUES(
						CONVERT(INTEGER, @nGltransid),
						@nRunid,
						'NEW',
						@vLid,
						@vDate,
						GETDATE(),
						42,
						'C',
						NULL,
						'JBA',
						@vTotAmount,
						@vCurr,
						@vDate,
						CONVERT(INTEGER, @nEntryid),
						1,
						@vTotAmount,
						@vSupplier,
						@vDesc,
						@vSegment1,
						@vSegment2,
						@vTaxCode,
						@vSupplier,
						@vType,
						@vInvCode,
						@vCreatedDate,
						@vDueDate,
						'NonPOInvoice',
						@vInvRef,
						@vInvCode,
						@vActPeriod,
						1
				)
			END;
			UPDATE R5INVOICES SET INV_UDFDATE01 = GETDATE() WHERE INV_CODE = @vInvCode;
		END;
END;
