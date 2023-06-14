--PO Services Receipt and Correction
DECLARE @vLid NVARCHAR(2) = 'A',
	@vAmount NUMERIC(24, 6),
	@vCurr NVARCHAR(30),
	@vNominalAcct NVARCHAR(750) = '0505',
	@vGliReference1 NVARCHAR(50) = 'EACC',
	@vGliReference2 NVARCHAR(50),
	@vCostcode NVARCHAR(750),
	@vSegment1 NVARCHAR(25),
	@vSegment6 NVARCHAR(25),
	@vSegment2 NVARCHAR(25),
	@vEvtCode NVARCHAR(30),
	@vCode NVARCHAR(30),
	@vOrder NVARCHAR(30),
	@vActPeriod NVARCHAR(30),
	@vCurrConversionDate DATETIME,
	@nReturn INTEGER,
	@nGltransid NVARCHAR(32),
	@sChk NVARCHAR(8),
	@nRunid NVARCHAR(32),
	@nEntryid NVARCHAR(32);
BEGIN
SELECT 	@vEvtCode = boo_event,
		@vCode = boo_code,
		@vAmount = (CASE WHEN boo_orighours IS NOT NULL 
						 THEN boo_rate * boo_orighours
						 ELSE boo_rate * boo_hours END),
		@vOrder = COALESCE(a.orl_order, b.orl_order),
		@vCostcode = COALESCE(a.orl_costcode, b.orl_costcode),
		@vCurr = COALESCE(a.orl_curr, b.orl_curr),
		@vSegment1 = COALESCE(a.orl_udfchar07, b.orl_udfchar07),
		@vSegment2 = COALESCE(a.orl_udfchar09, b.orl_udfchar09),
		@vSegment6 = COALESCE(a.orl_supplier, b.orl_supplier),
		@vGliReference2 = CONVERT(NVARCHAR, boo_acd),
		@vCurrConversionDate = BOO_ENTERED,
		@vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2),BOO_ENTERED,101),YEAR(BOO_ENTERED))
FROM r5bookedhours
	LEFT OUTER JOIN r5orderlines a ON (
		boo_act = a.orl_act
		AND boo_event = a.orl_event
		AND boo_order IS NULL
		AND a.orl_rtype IN ('SF', 'ST')
	) -- Fixed price, Hire labor
	LEFT OUTER JOIN r5orderlines b ON (
		boo_order = b.orl_order
		AND boo_ordline = b.orl_ordline
		AND boo_order IS NOT NULL
		AND b.orl_rtype = 'SH'
	) -- Contractor Hire
	WHERE boo_person IS NULL
		AND boo_routerec IS NULL
		AND boo_udfchar10 IS NULL
		AND boo_sqlidentity = :ROWID;

IF (@vCode IS NOT NULL) 
	BEGIN 
		execute @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT,N'GLR',N'1',@sChk OUTPUT 
		execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT,N'GLI',N'1',@sChk OUTPUT 
		execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT,N'GLE',N'1',@sChk OUTPUT 

	IF @vAmount < 0 
		BEGIN
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
			VALUES(--Debit
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
					(@vAmount),
					@vCurrConversionDate,
					@vNominalAcct,
					CONVERT(INTEGER, @nEntryid),
					1,
					@vSegment1,
					@vSegment2,
					@vSegment6,
					@vCurrConversionDate,
					@vGliReference1,
					@vGliReference2,
					@vOrder,
					@vCode,
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
			VALUES(--Credit
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
					(-1 * @vAmount),
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
					@vCode,
					'PO Rev',
					@vCurr,
					@vActPeriod
				) 
			END
	ELSE 
			BEGIN
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
				VALUES(--Debit
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
						@vCode,
						'PO Receipt',
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
				VALUES(--Credit
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
						@vNominalAcct,
						CONVERT(INTEGER, @nEntryid),
						1,
						@vSegment1,
						@vSegment2,
						@vSegment6,
						@vCurrConversionDate,
						@vGliReference1,
						@vGliReference2,
						@vOrder,
						@vCode,
						'PO Receipt',
						@vCurr,
						@vActPeriod
					)
				END;
	END;
END;


