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
@transcode = tkd_trans

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO';

IF (@transcode = 'UPLO' AND @promptdata1 = 'KPIHISTORY')
  BEGIN
  SELECT @i = COUNT(*) FROM R5KPIHISTORY WHERE KPH_HOMCODE = @promptdata2 AND FORMAT(KPH_UPDDATE, 'dd/MM/yyyy') = FORMAT(CONVERT(DATETIME,@promptdata4), 'dd/MM/yyyy')
  IF (@i = 1)
      BEGIN
      UPDATE R5KPIHISTORY
      SET KPH_HOMTYPE = @promptdata3
      ,KPH_VALUE = @promptdata5
      ,KPH_NORMSCORE	= @promptdata6
      ,KPH_COMMENT = @promptdata7
      WHERE KPH_HOMCODE = @promptdata2 AND FORMAT(KPH_UPDDATE, 'dd/MM/yyyy') = FORMAT(CONVERT(DATETIME,@promptdata4), 'dd/MM/yyyy')
      END
  IF (@i = 0)
      BEGIN
      INSERT INTO R5KPIHISTORY (KPH_HOMCODE,KPH_HOMTYPE,KPH_UPDDATE,KPH_VALUE,KPH_NORMSCORE,KPH_COMMENT)
      values(@promptdata2,@promptdata3,@promptdata4,@promptdata5,@promptdata6,@promptdata7);
      END
  END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 = 'KPIHISTORY' ;

END;


