/* 	Post Update 12 
	Post Update 15
	Post Update 20
	Post Update 25
	Post Update 30
	Post Update 50
	Post Update 61
	Post Update 65
	Post Update 70
	Post Update 100
*/	
/* DECLARING */

DECLARE
   @v_id   			integer
  ,@user   			nvarchar(100)
  ,@stsnew   		nvarchar(4)
  ,@stsdesc  		nvarchar(80)
  ,@stsold   		nvarchar(4)
  ,@jbtype   		nvarchar(8)
  ,@changeSts 		nvarchar(30)
  ,@newChangeSts	nvarchar(30)
  ,@wo 				nvarchar(24)
  ,@dept  			nvarchar(8)
  ,@woStart			DATETIME
  ,@completed		DATETIME
  ,@schedstartnew  	DATETIME
  ,@schedstartold  	DATETIME
  ,@duedatenew  	DATETIME
  ,@duedateold  	DATETIME
  ,@syssup			nvarchar(2)
  ,@productionTick	nvarchar(1)
  ,@safetyTick		nvarchar(1)
  ,@criticalTick	nvarchar(1)
  ,@regulartory		nvarchar(3)
  ,@changeReject 	BIT
  ,@action 			nvarchar(8)
  ,@comp 			datetime
  ,@woDesc			nvarchar(80)
  ,@costcode		nvarchar(8)
  ,@pmcode          nvarchar(30)
  ,@parent			nvarchar(8)
  ,@team            nvarchar(30)
  ,@email 			nvarchar(255)
  ,@owner 			nvarchar(10)
  ,@creator 		nvarchar(10) 
;
  



/*Loading Variables*/ 

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

BEGIN
	SELECT 
		@wo = EVT_CODE
	   ,@stsold = EVT_UDFCHAR06
	   ,@jbtype = EVT_JOBTYPE
	   ,@stsnew = EVT_STATUS
	   ,@dept = EVT_MRC
	   ,@schedstartnew = EVT_TARGET
	   ,@schedstartold = EVT_UDFDATE01
	   ,@newChangeSts = null
	   ,@duedatenew = EVT_UDFDATE02
	   ,@duedateold = EVT_UDFDATE03
	   ,@comp = EVT_COMPLETED
	   ,@action = EVT_ACTION
	   ,@costcode = EVT_COSTCODE
	   ,@woDesc = EVT_DESC
	   ,@pmcode = EVT_PPM
	   ,@parent = EVT_PARENT
	   ,@team = EVT_UDFCHAR21
	   ,@woStart = EVT_START
	   ,@owner = EVT_SCHEDGRP
	   ,@creator = EVT_ENTEREDBY
	   
	FROM R5EVENTS 
	WHERE EVT_SQLIDENTITY = :rowid;


	SELECT
		@changeSts = CMF_STATUS
	FROM U5CHMGMT 
	WHERE CMF_EVENT = @wo;

SELECT
	@syssup = isnull(SUBSTRING(OBJ.OBJ_UDFCHAR19,5,2),'00'),
	@productionTick = OBJ.OBJ_PRODUCTION,
	@safetyTick = OBJ.OBJ_SAFETY,
	@criticalTick = OBJ.obj_UDFCHKBOX03, 
	@regulartory = CASE OBJ_UDFCHKBOX02 WHEN '+' THEN 'YES' ELSE 'NO' END
FROM
	R5OBJECTS OBJ 
	,R5EVENTS
WHERE 
	R5EVENTS.EVT_OBJECT = OBJ.OBJ_CODE 
	AND R5EVENTS.EVT_SQLIDENTITY = :ROWID

/* Variable Calculations */

IF (@jbtype = 'CMCH' AND @stsold = 'RQST' AND @stsnew = 'CHRV')
	BEGIN 
		SET @newChangeSts = 'Change Review (4 Pillars)' 
	END
IF (@jbtype = 'CMCH' AND @stsold IN ('CHCD') AND @stsnew = 'CHRV')
	BEGIN
		SET @newChangeSts = 'Concept Review (3 Pillars)';
	END
IF (@jbtype = 'CMCH' AND @stsold IN ('CHDD') AND @stsnew = 'CHRV')
	BEGIN
		SET @newChangeSts = 'Detail Design Review (3 Pillars)';
	END
IF (@jbtype IN  ('EMPM','EMTM') AND @stsold IN ('INPR') AND @stsnew = 'CLOS' AND @changeSts IS NOT NULL)
	BEGIN
	SET @newChangeSts = 'Implementation Sign Off';
	END
IF (@jbtype = 'CMCH' 
	AND @stsold IN ('INPR','PLAN') 
	AND @stsnew = 'CHRV' 
	AND (@changeSts = 'Engineering Investigation' OR @changeSts = 'Change Request'))
		BEGIN
			SET @newChangeSts = 'Change Review (4 Pillars)'
			SET @changeReject = 1
		END
IF(@stsold='CHWA' AND @stsnew = 'PLAN')
	BEGIN
		IF @owner = 'AM' SET @email = 'GBAUD'
		IF @owner = 'EI' SET @email = 'DFRISWELL'
		IF @owner = 'HSEQ' SET @email = 'ACOCHRANE'
		IF @owner = 'ICT' SET @email = 'CRODRIGUEZ'
		IF @owner = 'MECH' SET @email = 'RKOCH'
		IF @owner = 'OPS' SET @email = 'JTAUVREY'
		IF @owner = 'PLAN' SET @email = 'NULL'
		IF @owner = 'PLANTOPS' SET @email = 'MLAGUITTON'
		IF @owner = 'PROJ' SET @email = 'SSLATTERY'
		IF @owner = 'PROSUPP' SET @email = 'KHARRIS'
		IF @owner = 'SITEOPS' SET @email = 'PRAYNER'
		ELSE SET @email = @owner
	END		
		
/* If Raise Error Statements */

IF (@stsnew in ('C') and @stsold not in ('C') and @action IS NULL and @jbtype NOT like 'MEC') OR
    (@stsnew in ('C') and @stsold not in ('C') and @comp IS NULL and @jbtype NOT like 'MEC')  OR
    (@stsnew in ('C') and @stsold not in ('C') and @schedstartnew IS NULL and @jbtype NOT like 'MEC')
		BEGIN	
		RAISERROR('Required data not provided - reset screen and ensure Action code, Start Date and Completed Date are entered',16,1);
		END

IF (@stsnew != @stsold OR @stsold IS NULL)
    BEGIN
		IF (@jbtype = 'CMCH' 					
					AND @stsnew NOT IN ('CHRV','CHWA','REJ','RQST','Q','CANC','CHCD','CHDD')) 
		OR (@jbtype NOT IN ('CMCH','EMIN')	
					AND @stsnew in ('CHRV','CHWA','CHCD','CHDD')) 
		OR (@jbtype = 'EMIN' 					
					AND @stsnew NOT IN ('PLAN','INPR','CHRV','CLOS','C','HOLD','WACC','WRES'))
			BEGIN
				SELECT 
				@stsdesc = UCO_DESC 
				FROM R5UCODES 
				WHERE UCO_ENTITY = 'EVST' AND UCO_CODE = @stsnew;
				RAISERROR('You may not change the Status to ''%s''', 16, 1, @stsdesc);
			END
    END
	
IF (@dept = '*' AND @jbtype != 'MEC')
	BEGIN
		RAISERROR('You need to select a department.                    Note: Changing the Equipment will cause the department to reset', 16, 1);
	END	
	
IF (@jbtype = 'CMCH' AND @stsnew = 'CHRV' AND @changeSts IS NULL)
	BEGIN
		RAISERROR('No change request form has been entered for this Work Order', 16, 1);
	END
IF (@duedateold IS NOT NULL AND (@duedatenew != @duedateold OR @duedatenew IS NULL))
	BEGIN
		RAISERROR('You cannot update the Work Order Due Date if it has already been populated.', 16, 1);
	END

/*UPDATES*/
/*--------------------------------------------------------------------R5EVENTS------------------------------------------------------------------*/
BEGIN 
		UPDATE R5EVENTS 
		SET EVT_UDFCHAR09 = @syssup 
		,EVT_UDFCHKBOX02 = @productionTick
		,EVT_SAFETY = @safetyTick 
		,EVT_CAMPAIGN_SURVEY = @criticalTick
		,EVT_UDFCHAR25 = @regulartory
		,EVT_UDFCHKBOX03 = CASE WHEN @jbtype ='CMCH' THEN '+' ELSE EVT_UDFCHKBOX03 END 
		,EVT_UDFDATE01 = CASE WHEN (@schedstartnew!=@schedstartold OR @schedstartold IS NULL) THEN @schedstartnew ELSE EVT_UDFDATE01 END
		,EVT_UDFCHAR06 = EVT_STATUS
		WHERE EVT_SQLIDENTITY = :rowid; 
	END
	-----------------------------------MEC Children------------------------------------
IF(@parent IS NULL)
	BEGIN
		UPDATE R5EVENTS SET
				EVT_COSTCODE = @costcode
				,EVT_DESC = @woDesc
				,EVT_MRC = @dept
				,EVT_COMPLETED = @completed
				,EVT_UDFCHAR09 = @syssup
				,EVT_PPM = @pmcode
				,EVT_UDFCHAR21 = @team
				,EVT_START = @woStart
		WHERE EVT_PARENT = @wo AND EVT_JOBTYPE = 'MEC'
	END
	
/*-----------------------------------------------------------------R5PICKLISTS------------------------------------------------------------------*/
IF (@schedstartnew!=@schedstartold OR @schedstartold IS NULL)
	BEGIN
		UPDATE R5PICKLISTS 
		SET PIC_REQUIRED = @schedstartnew 
		WHERE PIC_EVENT = @wo AND PIC_RSTATUS IN ('U','R');
	END

IF (@duedateold IS NULL AND @duedatenew IS NULL )		--Adds Due Date for PM Generated work orders
	BEGIN
      UPDATE R5EVENTS 
	  SET EVT_UDFDATE02 = EVT_TARGET
	  ,EVT_UDFDATE03 = EVT_TARGET 
	  WHERE EVT_SQLIDENTITY = :rowid AND ([EVT_ROUTEPARENT] IS NOT NULL OR [EVT_PPM] IS NOT NULL) AND EVT_RSTATUS = 'R';
	END

  IF (@duedateold IS NULL AND @duedatenew IS NOT NULL)		--Saves Due date to the Due Date checking field
    BEGIN
         UPDATE R5EVENTS 
		 SET EVT_UDFDATE03 = @duedatenew 
		 WHERE EVT_SQLIDENTITY = :rowid;
    END
	
/*---------------------------------------------------------------------U5CHMGMT----------------------------------------------------------*/
IF (@newChangeSts IS NOT NULL)
	BEGIN
		IF (@changeReject <> 1)
			BEGIN
				UPDATE U5CHMGMT
				SET  CMF_STATUS = @newChangeSts
				WHERE CMF_EVENT = @wo;
			END
		IF (@changeReject = 1)
			BEGIN
				UPDATE U5CHMGMT
				SET  CMF_STATUS = @newChangeSts
				,CMF_EICOMMCHECK = CMF_EICOMM
				,CMF_EICOMM = NULL
				,CMF_MECHCOMMCHECK = CMF_MECHCOMM
				,CMF_MECHCOMM = NULL
				,CMF_PLANTCOMMCHECK = CMF_PLANTCOMM
				,CMF_PLANTCOMM = NULL
				,CMF_SAFECOMMCHECK = CMF_SAFECOMM
				,CMF_SAFECOMM = NULL
				,CMF_MANCOMMCHECK = CMF_MANCOMM
				,CMF_MANCOMM = NULL
				WHERE CMF_EVENT = @wo;
			END

	
	END
END
---------------------------------------------------------------------------Send Email---------------------------------------------------------------------------------------------------
IF(@stsold='CHWA' AND @stsnew = 'PLAN')
	BEGIN 
		INSERT INTO R5MAILEVENTS 
		(MAE_TEMPLATE, MAE_DATE, MAE_SEND, MAE_RSTATUS, MAE_PARAM1, MAE_PARAM2, MAE_PARAM3,MAE_PARAM4, MAE_PARAM5, MAE_PARAM6, MAE_PARAM7, MAE_PARAM8, MAE_PARAM9, MAE_PARAM10, MAE_PARAM11)
		VALUES ('CHOWNER2',GETDATE(),'-','N',@wo,@woDesc,@creator,@email, null, null, null, null, null, null, null);             
	END



---------------------------------------------------------------------------Things to test---------------------------------------------------------------------------------------------------
/*
Things we'll need to test										
Change Request status's										
Change Request		can only be 	Request	Change Review	Change Review.	Rejected	Q	Cancelled	Concept Design	Detail Design
No other types can be			Change Review	Change Review.	Concept Design	Detail Design				
Eng Investigation can only be in 			Planning	In Progress	Change Review	Closed	Cancelled	On Hold	Waiting Access	Waiting Resources
Department can't be * for non MEC work orders										
Work order can't be moved to Change Review if Change Request hasn't been created										
Cannot Change the Due Date										
If Change Request Type the Change tickbox is selected										
Ensure Pick Tickets dates change with Work Order sched start date and UDFDATE01 is updated with Scheduled start date changes…										
Due Date is added for PM Generated work orders										
UDFDATE03 is being populated with Due Date										
Change Mgmt Status's change with work order										
Rejected change request moves comments to CommCheck										
Action code, Start and completed date not entered										
Info copied to MEC Children 			EVT_COSTCODE	EVT_DESC	EVT_MRC	EVT_COMPLETED	EVT_UDFCHAR09	EVT_PPM	EVT_UDFCHAR21	EVT_START
UDFCHAR06 being updated with Status
Email sent to change owner

*/


