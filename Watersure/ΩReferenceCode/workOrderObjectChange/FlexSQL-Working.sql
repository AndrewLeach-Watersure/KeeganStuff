DECLARE
@wo nvarchar(30)
,@obj nvarchar(30)
,@check nvarchar(30)
,@ppm nvarchar(30)
,@ppmStored nvarchar(30);

BEGIN
  SELECT
  @wo = EVT_CODE
  ,@check = EVT_UDFCHAR23
  ,@ppmStored = EVT_UDFCHAR27
  ,@ppm = EVT_PPM
  ,@obj = EVT_OBJECT
  FROM R5EVENTS
  WHERE EVT_SQLIDENTITY = :rowid



  IF (@check = 'Please')
      BEGIN 
        UPDATE R5EVENTS
           SET EVT_UDFCHAR27 = @ppm
          ,EVT_RTYPE = 'JOB'
          ,EVT_TYPE = 'JOB'
          ,EVT_PPM = NULL
          ,EVT_UDFCHAR23 = 'Activated'
      WHERE EVT_CODE = @wo
      END
  IF (@check = 'Done')
      BEGIN
        UPDATE R5EVENTS
           SET EVT_PPM = @ppmStored
          ,EVT_RTYPE = 'PPM'
          ,EVT_TYPE = 'PPM'
          ,EVT_UDFCHAR27 = NULL
          ,EVT_UDFCHAR23 = NULL
          ,EVT_PPOPK = (SELECT TOP 1 PPO_PK FROM R5PPMOBJECTS WHERE PPO_OBJECT = @obj AND PPO_PPM = @ppmStored)
      WHERE EVT_CODE = @wo
      END
END
