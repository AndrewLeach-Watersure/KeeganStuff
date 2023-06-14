DECLARE
@transcode nvarchar(80),
@promptdata1 nvarchar(80),
@promptdata2 nvarchar(80),
@promptdata3 nvarchar(80),
@promptdata4 nvarchar(80),
@promptdata5 nvarchar(80),
@promptdata6 nvarchar(80),
@promptdata7 nvarchar(80),
@promptdata8 nvarchar(80),
@i nvarchar(1);


BEGIN

SELECT
@promptdata1 = tkd_promptdata1,
@promptdata2 = tkd_promptdata2,
@promptdata3 = tkd_promptdata3,
@promptdata4 = tkd_promptdata4,
@promptdata5 = tkd_promptdata5,
@promptdata6 = tkd_promptdata6,
@promptdata7 = tkd_promptdata7,
@promptdata8 = tkd_promptdata8,
@transcode = tkd_trans

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO';

IF (@transcode = 'UPLO' AND @promptdata1 = 'STRAT')
  BEGIN
  SELECT @i = COUNT(*) FROM U5STRATEGY WHERE STR_CODE = @promptdata2
  IF (@i = 1)
      BEGIN
      UPDATE U5STRATEGY
      SET U5STRATEGY.DESCRIPTION = @promptdata3
      ,STR_OOS = @promptdata4
      ,STR_OWNER = @promptdata5
      ,STR_TEAM = @promptdata6
      ,STR_ASSETMAN	= @promptdata7
      ,STR_DELEGATE = @promptdata8
      WHERE STR_CODE = @promptdata2
      END
  IF (@i = 0)
      BEGIN
      INSERT INTO U5STRATEGY (STR_CODE,U5STRATEGY.DESCRIPTION,STR_OOS,STR_OWNER,STR_TEAM,STR_ASSETMAN,STR_DELEGATE)
      values(@promptdata2,@promptdata3,@promptdata4,@promptdata5,@promptdata6,@promptdata7,@promptdata8);
      END
  END

IF (@transcode = 'UPLO' AND @promptdata1 = 'BDG')
BEGIN
SELECT @i = COUNT(*) FROM U5BUDGETCLASS WHERE BCL_CODE = @promptdata2
IF (@i = 1)
    BEGIN
    UPDATE U5BUDGETCLASS
    SET U5BUDGETCLASS.DESCRIPTION = @promptdata3
    ,BCL_STRATEGY = @promptdata4
    ,BCL_OOS = @promptdata5
    WHERE BCL_CODE = @promptdata2
    END
IF (@i = 0)
    BEGIN
    INSERT INTO U5BUDGETCLASS (BCL_CODE,U5BUDGETCLASS.DESCRIPTION,BCL_STRATEGY,BCL_OOS)
    values(@promptdata2,@promptdata3,@promptdata4,@promptdata5);
    END
END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 IN ('BDG','STRAT') ;

END;

