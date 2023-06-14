--Supplier Return PO Part Direct material already issued to WO
DECLARE @vLid NVARCHAR(2) = 'A',
		@vAmount NUMERIC(24, 6),
        @vTrlLine NUMERIC,
		@vCurr NVARCHAR(30),
		@vNominalAcct NVARCHAR(750) = '0505',
		@vGliReference1 NVARCHAR(50) = 'EACC',
		@vGliReference2 NVARCHAR(50),
		@vCostcode NVARCHAR(750),
		@vSegment1 NVARCHAR(25),
		@vSegment6 NVARCHAR(25),
		@vSegment2 NVARCHAR(25),
		@vOrder NVARCHAR(30),
		@vCode NVARCHAR(30),
		@vActPeriod NVARCHAR(30),
		@vCurrConversionDate DATETIME,
		@nReturn INTEGER,
		@nGltransid NVARCHAR(32),
		@sChk NVARCHAR(8),
		@nRunid NVARCHAR(32),
		@nEntryid NVARCHAR(32);
BEGIN
	SELECT 	@vCode = TRL_TRANS,
			@vOrder = TRL_ORDER,
			@vCurrConversionDate = TRL_DATE,
			@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2), TRL_DATE, 101),YEAR(TRL_DATE))
	FROM R5TRANSLINES, R5TRANSACTIONS
	WHERE TRL_TRANS = TRA_CODE
		AND TRL_TYPE = 'RETN'
		AND TRA_FROMENTITY = 'EVNT'
		AND TRA_TOENTITY = 'COMP'
		AND TRL_ORDER IS NOT NULL
		AND TRL_ROUTEREC IS NULL
		AND TRA_STATUS = 'A'
		AND TRA_RSTATUS = 'A'
		AND TRA_SQLIDENTITY = :rowid;


	IF (@vCode IS NOT NULL) 
		BEGIN 
		DECLARE cursor_suppreturn CURSOR LOCAL STATIC FOR
		SELECT ORL_COSTCODE,(CASE WHEN TRL_ORIGQTY IS NOT NULL THEN TRL_ORIGQTY * TRL_PRICE ELSE TRL_QTY * TRL_PRICE END),
						ORL_UDFCHAR07,ORL_UDFCHAR09,ORL_SUPPLIER,CONVERT(NVARCHAR, TRL_ACD),ORL_CURR,TRL_LINE 
		FROM R5TRANSLINES,R5ORDERLINES
		WHERE TRL_ORDLINE = ORL_ORDLINE AND TRL_ORDER = ORL_ORDER AND TRL_TRANS = @vCode
		
		OPEN cursor_suppreturn
		FETCH NEXT FROM cursor_suppreturn
		INTO @vCostcode,@vAmount,@vSegment1,@vSegment2,@vSegment6,@vGliReference2,@vCurr,@vTrlLine
	
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
						GLI_TRANSACTIONDATE,
						GLI_GLNOMACCT,
						GLI_ENTRYID,
						GLI_SEQNUM,
						GLI_SEGMENT1,
						GLI_SEGMENT2,
						GLI_SEGMENT6,
						GLI_CURRENCYCONVERSIONDATE,
						GLI_REFERENCE1,
						GLI_REFERENCE2,
						GLI_REFERENCE3,
						GLI_PROCESS,
						GLI_GROUP,
						GLI_CURRENCYCODE,
						GLI_REFERENCE7
					)
				VALUES( --Debit
						CONVERT(INTEGER, @nGltransid),
						@nRunid,
						'NEW',
						@vLid,
						@vCurrConversionDate,
						GETDATE(),
						42,
						'D',
						NULL,
						'JBA',
						(-1 * @vAmount),
						@vCurrConversionDate,
						@vNominalAcct,
						CONVERT(INTEGER, @nEntryid),
						1,
						NULL,
						@vSegment2,
						@vSegment6,
						@vCurrConversionDate,
						@vGliReference1,
						@vGliReference2,
						@vOrder,
						CONCAT(@vCode,'-',@vTrlLine),
						'PO Rev',
						@vCurr,
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
						GLI_TRANSACTIONDATE,
						GLI_GLNOMACCT,
						GLI_ENTRYID,
						GLI_SEQNUM,
						GLI_SEGMENT1,
						GLI_SEGMENT2,
						GLI_SEGMENT6,
						GLI_CURRENCYCONVERSIONDATE,
						GLI_REFERENCE1,
						GLI_REFERENCE2,
						GLI_REFERENCE3,
						GLI_PROCESS,
						GLI_GROUP,
						GLI_CURRENCYCODE,
						GLI_REFERENCE7
					)
				VALUES( --Credit
						CONVERT(INTEGER, @nGltransid),
						@nRunid,
						'NEW',
						@vLid,
						@vCurrConversionDate,
						GETDATE(),
						42,
						'C',
						NULL,
						'JBA',
						@vAmount,
						@vCurrConversionDate,
						@vCostcode,
						CONVERT(INTEGER, @nEntryid),
						1,
						@vSegment1,
						@vSegment2,
						@vSegment6,
						@vCurrConversionDate,
						@vGliReference1,
						@vGliReference2,
						@vOrder,
						CONCAT(@vCode,'-',@vTrlLine),
						'PO Rev',
						@vCurr,
						@vActPeriod
					)
				FETCH NEXT FROM cursor_suppreturn
			INTO @vCostcode,@vAmount,@vSegment1,@vSegment2,@vSegment6,@vGliReference2,@vCurr,@vTrlLine	
			END;
			CLOSE cursor_suppreturn
			DEALLOCATE cursor_suppreturn
	END;
END;

