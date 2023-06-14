--Stock Initialisation i.e. stock record created with more than 0 stock
DECLARE @vLid NVARCHAR(2) = 'A',
		@vType NVARCHAR(50) = 'STOCK',
		@vExchRate NUMERIC(24, 12),
		@vGLcode NVARCHAR(750),
		@vEvtCostcode NVARCHAR(750),
		@vMrc NVARCHAR(100),
		@vReference2 NVARCHAR(100),
		@vAmount NUMERIC(24, 6),
		@vCurrConversionDate DATETIME,
		@vDateFormat NVARCHAR(300),
		@vReference4 NVARCHAR(300),
		@vCurr NVARCHAR(10),
		@nReturn INTEGER,
		@nGltransid NVARCHAR(32),
		@vTraFromRentity NVARCHAR(10),
		@vTraToRentity NVARCHAR(10),
		@vTrlRtype NVARCHAR(10),
		@vTrlIO INT,
		@vTraCode NVARCHAR(32),
		@sChk NVARCHAR(8),
		@nRunid NVARCHAR(32),
		@vPart NVARCHAR(40),
		@vPartOrg NVARCHAR(30),
		@vActPeriod NVARCHAR(32),
		@vEvtCode NVARCHAR(30),
		@vSegment2 NVARCHAR(30),
		@nEntryid NVARCHAR(32);
BEGIN
	SELECT 	@vAmount = (round(abs(TRL_PRICE * TRL_QTY), 2)),
			@vTraCode = TRA_CODE,
			@vReference2 = CONCAT('STOCKINIT:', CONVERT(NVARCHAR(2), TRL_DATE, 101)),
			@vCurrConversionDate = TRL_DATE,
			@vDateFormat = CONCAT(REPLACE(CONVERT(NVARCHAR, TRL_DATE, 5), '-', ''),
				SUBSTRING(CONVERT(NVARCHAR, TRL_DATE, 108), 7, 2),
				SUBSTRING(CONVERT(NVARCHAR, TRL_DATE, 108), 4, 2),
				SUBSTRING(CONVERT(NVARCHAR, TRL_DATE, 108), 1, 2)),
			@vPart = TRL_PART,
			@vPartOrg = TRL_PART_ORG,
			@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2), TRL_DATE, 101),YEAR(TRL_DATE))
		FROM R5TRANSACTIONS,R5TRANSLINES
		WHERE TRL_RTYPE = 'RECV'
			AND TRL_IO = 1
			AND TRA_FROMCODE = '*'
			AND TRA_FROMRENTITY = 'COMP'
			AND TRA_TORENTITY = 'STOR'
			AND TRL_TRANS = TRA_CODE
			AND TRL_SQLIDENTITY = :rowid 

	IF @vTraCode IS NOT NULL 
		BEGIN
			SELECT @vGLcode = PAR_UDFCHAR03 FROM R5PARTS WHERE PAR_CODE = @vPart AND PAR_ORG = @vPartOrg;
			SET @vReference4 = CONCAT(@vPart, '-', @vDateFormat)
			SELECT @vCurr = ORG_CURR FROM R5ORGANIZATION WHERE ORG_CODE = @vPartOrg;
			SELECT @vExchRate = CRR_EXCH FROM R5EXCHRATES WHERE CRR_CURR = @vCurr
			SET @vAmount = (@vAmount * ISNULL(@vExchRate, 1)) 
			
			execute @nReturn = R5O7_O7MAXSEQ @nRunid 		OUTPUT,N'GLR',N'1',@sChk OUTPUT 
			execute @nReturn = R5O7_O7MAXSEQ @nGltransid 	OUTPUT,N'GLI',N'1',@sChk OUTPUT 
			execute @nReturn = R5O7_O7MAXSEQ @nEntryid 		OUTPUT,N'GLE',N'1',@sChk OUTPUT
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
						GLI_CURRENCYCODE,
						GLI_GLNOMACCT,
						GLI_ENTRYID,
						GLI_SEQNUM,
						GLI_REFERENCE1,
						GLI_SEGMENT1,
						GLI_SEGMENT2,
						GLI_REFERENCE3,
						GLI_GROUP,
						GLI_REFERENCE2,
						GLI_PROCESS,
						GLI_REFERENCE4,
						GLI_REFERENCE7,
						GLI_CURRENCYCONVERSIONDATE
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
					@vCurr,
					ISNULL(@vGLcode, '0111'),
					CONVERT(INTEGER, @nEntryid),
					1,
					@vType,
					'ENG',
					'00',
					@vDateFormat,
					'stk init',
					@vReference2,
					@vPart,
					@vReference4,
					@vActPeriod,
					@vCurrConversionDate
				) 
				execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,
				N'GLI',
				N'1',
				@sChk OUTPUT 
				execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,
				N'GLE',
				N'1',
				@sChk OUTPUT
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
					GLI_CURRENCYCODE,
					GLI_GLNOMACCT,
					GLI_ENTRYID,
					GLI_SEQNUM,
					GLI_REFERENCE1,
					GLI_SEGMENT1,
					GLI_SEGMENT2,
					GLI_REFERENCE3,
					GLI_GROUP,
					GLI_REFERENCE2,
					GLI_PROCESS,
					GLI_REFERENCE4,
					GLI_REFERENCE7,
					GLI_CURRENCYCONVERSIONDATE
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
					@vCurr,
					'4051',
					CONVERT(INTEGER, @nEntryid),
					1,
					@vType,
					'ENG',
					'00',
					@vDateFormat,
					'stk init',
					@vReference2,
					@vPart,
					@vReference4,
					@vActPeriod,
					@vCurrConversionDate
				)
		END;
END;
