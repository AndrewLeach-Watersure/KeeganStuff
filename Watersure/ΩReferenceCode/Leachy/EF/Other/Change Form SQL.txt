DECLARE
@v_id integer,
@wonum nvarchar(8),
@user nvarchar(30),
@wodesc nvarchar(80),
@owner nvarchar(10),
@eiComOld nvarchar(4000),
@mechComOld nvarchar(4000),
@plopComOld nvarchar(4000),
@hseComOld nvarchar(4000),
@eiComNew nvarchar(4000),
@mechComNew nvarchar(4000),
@plopComNew nvarchar(4000),
@hseComNew nvarchar(4000);
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
    SELECT @eiComOld = CRF_EICOMMCHECK,
                   @mechComOld = CRF_MECHCOMMCHECK,
                   @plopComOld = CRF_PLOPCOMMCHECK,
                   @hseComOld = CRF_HSECOMMCHECK,
                   @eiComNew = CRF_EICOMM,
                   @mechComNew = CRF_MECHCOMM,
                   @plopComNew = CRF_PLOPCOMM,
                   @hseComNew = CRF_HSECOMM,
@wonum = CRF_EVENT,
@wodesc = CRF_DESCRIPTION,
@owner = CRF_ORIGINATOR

                 FROM U5U5EVNTCHANGE
                 WHERE  SQLIDENTITY = :rowid


IF (ISNULL(@eiComNew,'?') <> ISNULL(@eiComOld,'?') AND @user <> 'DFRISWELL')
RAISERROR('Only the Senior Electrical Engineer can update their comments',16,1)
IF (ISNULL(@mechComNew,'?') <> ISNULL(@mechComOld,'?') AND @user <> 'RKOCH')
RAISERROR('Only the Senior Mechanical Engineer can update their comments',16,1)
IF (ISNULL(@plopComNew,'?') <> ISNULL(@plopComOld,'?') AND @user <> 'MLAGUITTON')
RAISERROR('Only the Plant Operations Manager can update their comments',16,1)
IF (ISNULL(@hseComNew,'?') <> ISNULL(@hseComOld,'?') AND @user <> 'TSCOTT')
RAISERROR('Only the HSE Officer can update their comments',16,1)


UPDATE U5U5EVNTCHANGE
SET
CRF_EICOMMCHECK = CRF_EICOMM,
CRF_MECHCOMMCHECK = CRF_MECHCOMM,
CRF_PLOPCOMMCHECK = CRF_PLOPCOMM,
CRF_HSECOMMCHECK = CRF_HSECOMM
WHERE SQLIDENTITY=:rowid

IF @hseComNew IS NOT NULL AND @plopComNew IS NOT NULL AND @mechComNew IS NOT NULL AND @eiComNew IS NOT NULL
BEGIN 
INSERT INTO R5MAILEVENTS 
(MAE_TEMPLATE, MAE_DATE, MAE_SEND, MAE_RSTATUS, MAE_PARAM1, MAE_PARAM2, 
MAE_PARAM3,MAE_PARAM4, MAE_PARAM5, MAE_PARAM6, MAE_PARAM7, MAE_PARAM8,
MAE_PARAM9, MAE_PARAM10, MAE_PARAM11,MAE_PARAM15)
VALUES ('CHAPPROVAL',GETDATE(), '-','N', @wonum, @wodesc, 
@owner,'SBAHUTH', null, null, null, null, null, null, null,':MP5USER');             
END
END