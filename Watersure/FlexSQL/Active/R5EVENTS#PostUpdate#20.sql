DECLARE 
@wo nvarchar(10),
@me nvarchar(2),
@udf07 nvarchar(2),
@ChCount nvarchar(80),
@MECCount nvarchar(80),
@user nvarchar(40);

BEGIN
  SELECT
  @wo = EVT_CODE,
  @me = EVT_MULTIEQUIP,
  @udf07 = EVT_UDFCHKBOX07
  FROM R5EVENTS WHERE EVT_SQLIDENTITY = :rowid AND EVT_TYPE IN ('JOB','PPM') AND EVT_ROUTEPARENT IS NULL AND EVT_PARENT IS NULL

SELECT @ChCount = COUNT(EVT_CODE)  FROM R5EVENTS WHERE EVT_PARENT = @wo AND EVT_JOBTYPE <> 'MEC'
SELECT @MECCount = COUNT(EVT_CODE)  FROM R5EVENTS WHERE EVT_PARENT = @wo AND EVT_JOBTYPE = 'MEC'

  IF(@me = '+' AND @udf07 = '-' AND (@MECCount IS NULL OR @MECCount = 0))
  BEGIN
    UPDATE R5EVENTS
    SET EVT_MULTIEQUIP = '-'
    WHERE EVT_CODE = @wo

    UPDATE R5EVENTS
    SET EVT_MULTIEQUIP = '-',
    EVT_ROUTEPARENT = NULL
    WHERE EVT_PARENT = @wo AND EVT_JOBTYPE <> 'MEC'
  END 

  IF(@me = '-' AND @udf07 = '+')
  BEGIN 
  IF (@ChCount IS NULL or @ChCount < 1)
    BEGIN 
    RAISERROR('No Children to group',16,1);
    END

    IF( (SELECT COUNT(*) FROM (SELECT ACT_ACT FROM R5ACTIVITIES WHERE ACT_EVENT = @wo EXCEPT SELECT ACT_ACT FROM R5ACTIVITIES LEFT OUTER JOIN R5EVENTS ON ACT_EVENT = EVT_CODE WHERE EVT_PARENT = @wo) x) > 0)
    BEGIN 
    RAISERROR('Child Activities do not match parent',16,1);
    END

    UPDATE R5EVENTS
    SET EVT_MULTIEQUIP = '+',
    EVT_JOBTYPE = (SELECT MAX(EVT_JOBTYPE) FROM R5EVENTS WHERE EVT_PARENT = @wo AND EVT_JOBTYPE <> 'MEC')
    WHERE EVT_CODE = @wo

    UPDATE R5EVENTS
    SET EVT_MULTIEQUIP = '-',
    EVT_ROUTEPARENT = @wo
    WHERE EVT_PARENT = @wo AND EVT_JOBTYPE <> 'MEC'
  END
END 
