--Part Price Adjustment
DECLARE @vLid NVARCHAR(2) = 'A',
		@vType NVARCHAR(50) = 'STOCK',
		@vTrlPrice NUMERIC(24, 6),
		@vGLcode NVARCHAR(750),
		@vReference2 NVARCHAR(100),
		@vCurrConversionDate DATETIME,
		@vDateFormat NVARCHAR(300),
		@vReference4 NVARCHAR(300),
		@vCurr NVARCHAR(10) = 'AUD',
		@nReturn INTEGER,
		@nGltransid NVARCHAR(32),
		@vTraCode NVARCHAR(32),
		@nRunid NVARCHAR(32),
		@vPart NVARCHAR(40),
		@vPartOrg NVARCHAR(30),
		@sChk NVARCHAR(8),
		@vActPeriod NVARCHAR(32),
		@nEntryid NVARCHAR(32);
BEGIN
	SELECT 	@vTrlPrice = (TRL_PRICE*TRL_QTY),
			@vTraCode = TRL_TRANS,
			@vReference2 = CONCAT('PARTPRICE:', CONVERT(NVARCHAR(2), TRL_DATE, 101)),
			@vDateFormat = CONCAT(REPLACE(CONVERT(NVARCHAR, TRL_DATE, 5), '-', ''),REPLACE(CONVERT(NVARCHAR, TRL_DATE, 108), ':', '')),
			@vCurrConversionDate = TRL_DATE,
			@vPart = TRL_PART,
			@vPartOrg = TRL_PART_ORG,
			@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2), TRL_DATE, 101),YEAR(TRL_DATE))
		FROM R5TRANSLINES
		WHERE TRL_RTYPE = 'CORR'
			AND TRL_IO = 1
			AND TRL_SQLIDENTITY = :rowid;

	IF @vTraCode IS NOT NULL 
		BEGIN
			SELECT @vGLcode = PAR_UDFCHAR03 FROM R5PARTS WHERE PAR_CODE = @vPart AND PAR_ORG = @vPartOrg;
			SELECT @vCurr = ORG_CURR FROM R5ORGANIZATION WHERE ORG_CODE = @vPartOrg;
			SET @vReference4 = CONCAT(@vPart, '-', @vDateFormat);
				
			IF @vTrlPrice > 0 --Price increase
				BEGIN 
					--SELECT @vExchRate = crr_exch FROM R5EXCHRATES WHERE crr_curr = @vCurr;
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
							GLI_CURRENCYCODE,
							GLI_GLNOMACCT,
							GLI_ENTRYID,
							GLI_SEQNUM,
							GLI_REFERENCE1,
							GLI_REFERENCE3,
							GLI_GROUP,
							GLI_REFERENCE2,
							GLI_PROCESS,
							GLI_REFERENCE4,
							GLI_CURRENCYCONVERSIONDATE,
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
							(-1*@vTrlPrice),
							@vCurrConversionDate,
							@vCurr,
							ISNULL(@vGLcode, '0111'),		
							CONVERT(INTEGER, @nEntryid),
							1,
							@vType,
							@vCurrConversionDate, 
							'PARTPRICE',
							@vReference2,
							@vPart,
							@vDateFormat,
							@vCurrConversionDate, 
							@vActPeriod
						);
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
								GLI_SEGMENT1,
								GLI_REFERENCE3,
								GLI_GROUP,
								GLI_REFERENCE2,
								GLI_PROCESS,
								GLI_REFERENCE4,
								GLI_CURRENCYCONVERSIONDATE,
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
							@vTrlPrice,
							@vCurrConversionDate,
							@vCurr,
							'4051',
							CONVERT(INTEGER, @nEntryid),
							1,
							@vType,
							'ENG',
							@vCurrConversionDate, 
							'PARTPRICE',
							@vReference2,
							@vPart,
							@vReference4,
							@vCurrConversionDate, 
							@vActPeriod
							);
				END;
			IF @vTrlPrice < 0 --Price Decrease
				BEGIN 
					EXECUTE @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT,N'GLR',N'1',@sChk OUTPUT 
					EXECUTE @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
					EXECUTE @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
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
							GLI_REFERENCE3,
							GLI_GROUP,
							GLI_REFERENCE2,
							GLI_PROCESS,
							GLI_REFERENCE4,
							GLI_CURRENCYCONVERSIONDATE,
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
							(-1*@vTrlPrice),
							@vCurrConversionDate,
							@vCurr,
							ISNULL(@vGLcode, '0111'),
							CONVERT(INTEGER, @nEntryid),
							1,
							@vType,
							@vCurrConversionDate, 
							'PARTPRICE',
							@vReference2,
							@vPart,
							@vReference4,
							@vCurrConversionDate, 
							@vActPeriod
						);
					EXECUTE @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
					EXECUTE @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT
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
							GLI_REFERENCE3,
							GLI_GROUP,
							GLI_REFERENCE2,
							GLI_PROCESS,
							GLI_REFERENCE4,
							GLI_CURRENCYCONVERSIONDATE,
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
							@vTrlPrice,
							@vCurrConversionDate,
							@vCurr,
							'4051',
							CONVERT(INTEGER, @nEntryid),
							1,
							@vType,
							'ENG',
							@vCurrConversionDate, 
							'PARTPRICE',
							@vReference2,
							@vPart,
							@vReference4,
							@vCurrConversionDate, 
							@vActPeriod
						);
				END;
		END;
END;
