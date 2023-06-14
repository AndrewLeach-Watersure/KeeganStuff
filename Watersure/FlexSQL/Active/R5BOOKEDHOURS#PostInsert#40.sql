--Internal Labour Receipt and Correction
DECLARE 
@vLid   NVARCHAR(2) = 'A',
@vAmount NUMERIC(24, 6),
@vCurr NVARCHAR(30) = 'AUD',
@vNominalAcct NVARCHAR(750) = '0532',
@vGliReference1 NVARCHAR(50) = 'EIL',
@vGliReference2 NVARCHAR(50),
@vCostcode NVARCHAR(750),
@vSegment1  NVARCHAR(25),
@vSegment2  NVARCHAR(25),
@vEvtCode NVARCHAR(30),
@vCode NVARCHAR(30),
@vOrder NVARCHAR(30),
@vActPeriod NVARCHAR(30),
@vCurrConversionDate DATETIME,
@nReturn		INTEGER,
@vAct        INTEGER,
@nGltransid		NVARCHAR(32),
@sChk			NVARCHAR(8),
@nRunid			NVARCHAR(32),
@nEntryid		NVARCHAR(32);
BEGIN
	SELECT @vEvtCode = boo_event,
				 @vAct   = boo_act,
				 @vCode  = boo_code,
				@vAmount = (CASE WHEN boo_orighours IS NOT NULL 
						 THEN boo_rate * boo_orighours
						 ELSE boo_rate * boo_hours END),
				 @vCostcode = per_costcode,
				 @vSegment1 = evt_mrc,
        		 @vSegment2 = evt_udfchar09, 
				 @vGliReference2 = CONCAT('BookLabor:',CONVERT(NVARCHAR,boo_code)),
				 @vCurrConversionDate = BOO_ENTERED,
         @vActPeriod = CONCAT(0,CONVERT(NVARCHAR(2),BOO_ENTERED,101),YEAR(BOO_ENTERED))
	FROM  r5events,r5bookedhours,r5personnel 
	WHERE evt_code = boo_event
		AND boo_person = per_code
       	AND boo_routerec IS NULL
		AND boo_sqlidentity = :ROWID;
        
  IF (@vCode IS NOT NULL)
  BEGIN
		execute @nReturn = R5O7_O7MAXSEQ @nRunid OUTPUT, N'GLR', N'1', @sChk OUTPUT
		execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT, N'GLI', N'1', @sChk OUTPUT
		execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT, N'GLE', N'1', @sChk OUTPUT
		
		IF @vAmount > 0
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
					CONVERT(INTEGER,@nGltransid),
					@nRunid,'NEW',  
					@vLid, 
					@vCurrConversionDate,
					GETDATE(),
					42, 
					'D', 
					NULL, 
					'JBA', 
					(-1*@vAmount),
					@vCurrConversionDate,
					@vCostcode,
					CONVERT(INTEGER,@nEntryid), 
					1,
					@vSegment1, 
					@vSegment2,
					@vCurrConversionDate,
					@vGliReference1,
					@vGliReference2,
					CONCAT(@vEvtCode,'-',CONVERT(NVARCHAR,@vAct)),
					@vEvtCode,
					'BookLabor',
					@vCurr,
					@vActPeriod	
					)			
			execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT, N'GLI', N'1', @sChk OUTPUT
			execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT, N'GLE', N'1', @sChk OUTPUT
			INSERT INTO R5GLINTERFACE 
					( GLI_TRANSID, GLI_RUNID, GLI_STATUS, 
					 GLI_REFERENCE5, GLI_ACCOUNTINGDATE,	GLI_DATECREATED, 
					 GLI_CREATEDBY, GLI_ACTUALFLAG, GLI_USERJECATEGORYNAME,
					 GLI_USERJESOURCENAME, GLI_ENTEREDCR, GLI_TRANSACTIONDATE, 
					 GLI_GLNOMACCT, GLI_ENTRYID, GLI_SEQNUM,
					 GLI_SEGMENT2,GLI_CURRENCYCONVERSIONDATE,
					 GLI_REFERENCE1,GLI_REFERENCE2,GLI_REFERENCE3,
					 GLI_PROCESS,GLI_GROUP,GLI_CURRENCYCODE,GLI_REFERENCE7
					) 
			VALUES(--Credit
					CONVERT(INTEGER,@nGltransid), @nRunid, 'NEW',  
					@vLid, @vCurrConversionDate, GETDATE(),
					42,'C', NULL,
					'JBA',@vAmount, @vCurrConversionDate,
					@vNominalAcct,CONVERT(INTEGER,@nEntryid), 1,
					@vSegment2, @vCurrConversionDate,
					@vGliReference1,@vGliReference2,CONCAT(@vEvtCode,'-',CONVERT(NVARCHAR,@vAct)),
					@vEvtCode,'BookLabor',@vCurr,@vActPeriod
				)
		END
		ELSE
		BEGIN
			INSERT INTO R5GLINTERFACE 
				( 	GLI_TRANSID, GLI_RUNID, GLI_STATUS, 
					GLI_REFERENCE5, GLI_ACCOUNTINGDATE,	GLI_DATECREATED, 
					GLI_CREATEDBY, GLI_ACTUALFLAG, GLI_USERJECATEGORYNAME, 
					GLI_USERJESOURCENAME, GLI_ENTEREDCR, GLI_TRANSACTIONDATE, 
					GLI_GLNOMACCT, GLI_ENTRYID, GLI_SEQNUM,
					GLI_SEGMENT1,GLI_SEGMENT2, GLI_CURRENCYCONVERSIONDATE,
					GLI_REFERENCE1,GLI_REFERENCE2,GLI_REFERENCE3,
					GLI_PROCESS,GLI_GROUP,GLI_CURRENCYCODE,GLI_REFERENCE7
				) 
			VALUES(--Credit
					CONVERT(INTEGER,@nGltransid), @nRunid, 'NEW',  
					@vLid, @vCurrConversionDate, GETDATE(),
					42, 'C', NULL, 
					'JBA', (-1*@vAmount),@vCurrConversionDate,
					@vCostcode,	CONVERT(INTEGER,@nEntryid), 1,
					@vSegment1, @vSegment2, @vCurrConversionDate,
					@vGliReference1,@vGliReference2,CONCAT(@vEvtCode,'-',CONVERT(NVARCHAR,@vAct)),
					@vEvtCode,'BookLabor',@vCurr,@vActPeriod
				)

			execute @nReturn = R5O7_O7MAXSEQ @nGltransid OUTPUT, N'GLI', N'1', @sChk OUTPUT
			execute @nReturn = R5O7_O7MAXSEQ @nEntryid OUTPUT, N'GLE', N'1', @sChk OUTPUT

			INSERT INTO R5GLINTERFACE 
				(GLI_TRANSID, GLI_RUNID, GLI_STATUS, 
				 GLI_REFERENCE5, GLI_ACCOUNTINGDATE,	GLI_DATECREATED, 
				 GLI_CREATEDBY, GLI_ACTUALFLAG, GLI_USERJECATEGORYNAME,
				 GLI_USERJESOURCENAME, GLI_ENTEREDDR, GLI_TRANSACTIONDATE, 
				 GLI_GLNOMACCT, GLI_ENTRYID, GLI_SEQNUM,
				 GLI_SEGMENT2,GLI_CURRENCYCONVERSIONDATE,
				 GLI_REFERENCE1,GLI_REFERENCE2,GLI_REFERENCE3,
				 GLI_PROCESS,GLI_GROUP,GLI_CURRENCYCODE,GLI_REFERENCE7
				) 
			VALUES(--Debit
				CONVERT(INTEGER,@nGltransid), @nRunid, 'NEW',  
				@vLid, @vCurrConversionDate, GETDATE(),
				42,'D', NULL,
				'JBA',@vAmount,@vCurrConversionDate,
				@vNominalAcct,CONVERT(INTEGER,@nEntryid), 1,
				@vSegment2, @vCurrConversionDate,
				@vGliReference1,@vGliReference2,CONCAT(@vEvtCode,'-',CONVERT(NVARCHAR,@vAct)),
				@vEvtCode,'BookLabor',@vCurr,@vActPeriod
			)	
		END;
  END;
END;


