--Part Issues from Stock to WO
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
		@vCurr NVARCHAR(10) = 'AUD',
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
	SELECT @vAmount = abs(TRL_PRICE * (CASE WHEN TRL_ORIGQTY IS NOT NULL 
							THEN  TRL_ORIGQTY
							ELSE  TRL_QTY END)),
		@vMrc = EVT_MRC,
		@vSegment2 = EVT_UDFCHAR09,
		@vTraCode = TRA_CODE,
		@vEvtCode = EVT_CODE,
		@vReference2 = CONCAT('ISSUE:', CONVERT(NVARCHAR(2), TRL_DATE, 101)),
		@vCurrConversionDate = TRL_DATE,
		@vDateFormat = CONCAT(
			REPLACE(CONVERT(NVARCHAR, TRL_DATE, 5), '-', ''),
			SUBSTRING(CONVERT(NVARCHAR, TRL_DATE, 108), 7, 2),
			SUBSTRING(CONVERT(NVARCHAR, TRL_DATE, 108), 4, 2),
			SUBSTRING(CONVERT(NVARCHAR, TRL_DATE, 108), 1, 2)),
		@vPart = trl_part,
		@vPartOrg = trl_part_org,
		@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2), TRL_DATE, 101),YEAR(TRL_DATE))
	FROM R5TRANSACTIONS, R5TRANSLINES, R5EVENTS
	WHERE ISNULL(TRL_ORIGQTY,TRL_QTY) > 0
		AND TRL_TRANS = TRA_CODE
		AND TRL_EVENT = EVT_CODE
		AND TRL_RTYPE = 'I'
		AND TRA_FROMRENTITY = 'STOR'
		AND TRA_TORENTITY = 'EVNT'
		AND TRL_IO = -1
		AND TRL_ROUTEREC IS NULL
		AND TRL_SQLIDENTITY = :rowid;


	IF @vTraCode IS NOT NULL 
		BEGIN
				SELECT @vCurr = ORG_CURR FROM R5ORGANIZATION WHERE ORG_CODE = @vPartOrg;
				SET @vReference4 = CONCAT(@vEvtCode, '-', @vPart, '-', @vDateFormat)
				SELECT @vGLcode = PAR_UDFCHAR03 FROM R5PARTS WHERE PAR_CODE = @vPart AND PAR_ORG = @vPartOrg
				SELECT @vExchRate = CRR_EXCH FROM R5EXCHRATES WHERE CRR_CURR = @vCurr
				SET @vAmount = (@vAmount * ISNULL(@vExchRate, 1)) 

			execute @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT,N'GLR',N'1',@sChk OUTPUT 
			execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',	N'1',@sChk OUTPUT 
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
					'4011',
					CONVERT(INTEGER, @nEntryid),
					1,
					@vType,
					@vMrc,
					@vSegment2,
					@vDateFormat,
					'WO issue',
					@vReference2,
					@vEvtCode,
					@vReference4,
					@vActPeriod,
					@vCurrConversionDate
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
					GLI_CURRENCYCODE,
					GLI_GLNOMACCT,
					GLI_ENTRYID,
					GLI_SEQNUM,
					GLI_REFERENCE1,
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
					ISNULL(@vGLcode,'0111'),
					CONVERT(INTEGER, @nEntryid),
					1,
					@vType,
					@vSegment2,
					@vDateFormat,
					'WO issue',
					@vReference2,
					@vEvtCode,
					@vReference4,
					@vActPeriod,
					@vCurrConversionDate
				)
		END;
END;
