DECLARE
	@wssCode	nvarchar(60),
	@wssStatus	nvarchar(4),
	@wssMsg		nvarchar(1000),
	@wssDoc		nvarchar(128),
	@wssContextId nvarchar(128),
	@vErrMsg    nvarchar(4000),
	@vCount		INT;

BEGIN

	BEGIN TRY
	
			SET @vErrMsg = NULL

			SELECT	@wssCode = WSS_CODE,@wssStatus = WSS_REQ_STATUS,
					@wssMsg = SUBSTRING(WSS_REQ_MESSAGE,0,160),@wssDoc = SUBSTRING(WSS_DOCUMENT,0,80),@wssContextId = SUBSTRING(WSS_CONTEXTID,0,80)
			FROM	R5WSMESSAGESTATUS
			WHERE	WSS_SQLIDENTITY = :ROWID

			IF(@wssStatus = 'F')
			BEGIN
				SELECT @vCount = COUNT(1) FROM R5MAILEVENTS WHERE MAE_TEMPLATE = 'TDJV' AND MAE_PARAM1 = @wssCode
				
				IF @vCount = 0				
					INSERT INTO R5MAILEVENTS
						(MAE_TEMPLATE,MAE_DATE,MAE_PARAM1,MAE_PARAM2,MAE_PARAM3,MAE_PARAM4,MAE_PARAM5,MAE_EMAILRECIPIENT)
					VALUES
						('TDJV',GETDATE(),@wssCode,@wssContextId,@wssDoc,
							SUBSTRING(@wssMsg,0,80),SUBSTRING(@wssMsg,81,160),'DG_EAM_Sun_Integration@watersure.com.au')			
			END
	END TRY
	BEGIN CATCH
		SELECT @vErrMsg = ERROR_MESSAGE()
		RAISERROR(@vErrMsg,16,1)
	END CATCH
			
END
