DECLARE
@v_id integer,
@user nvarchar(100),
@transcode nvarchar(80),
@promptdata1 nvarchar(80),
@promptdata2 nvarchar(80),
@promptdata3 nvarchar(80),
@promptdata4 nvarchar(80),
@promptdata5 nvarchar(80),
@promptdata6 nvarchar(80),
@promptdata7 nvarchar(80),
@promptdata8 nvarchar(80),
@promptdata9 nvarchar(80),
@promptdata10 nvarchar(80),
@promptdata11 nvarchar(80),
@promptdata12 nvarchar(80),
@promptdata13 nvarchar(80),
@promptdata14 nvarchar(80),
@promptdata15 nvarchar(80),
@promptdata16 nvarchar(80),
@promptdata17 nvarchar(80),
@promptdata18 nvarchar(80),
@promptdata19 nvarchar(80),
@promptdata20 nvarchar(80),
@promptdata21 nvarchar(80),
@promptdata22 nvarchar(80),
@promptdata23 nvarchar(80),
@promptdata24 nvarchar(80),
@promptdata25 nvarchar(80),
@promptdata26 nvarchar(80),
@promptdata27 nvarchar(80),
@promptdata28 nvarchar(80),
@promptdata29 nvarchar(80),
@promptdata30 nvarchar(80),
@promptdata31 nvarchar(80),
@i nvarchar(1);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

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
@promptdata9 = tkd_promptdata9,
@promptdata10 = tkd_promptdata10,
@promptdata11 = tkd_promptdata11,
@promptdata12 = tkd_promptdata12,
@promptdata13 = tkd_promptdata13,
@promptdata14 = tkd_promptdata14,
@promptdata15 = tkd_promptdata15,
@promptdata16 = tkd_promptdata16,
@promptdata17 = tkd_promptdata17,
@promptdata18 = tkd_promptdata18,
@promptdata19 = tkd_promptdata19,
@promptdata20 = tkd_promptdata20,
@promptdata21 = tkd_promptdata21,
@promptdata22 = tkd_promptdata22,
@promptdata23 = tkd_promptdata23,
@promptdata24 = tkd_promptdata24,
@promptdata25 = tkd_promptdata25,
@promptdata26 = tkd_promptdata26,
@promptdata27 = tkd_promptdata27,
@promptdata28 = tkd_promptdata28,
@promptdata29 = tkd_promptdata29,
@promptdata30 = tkd_promptdata30,
@promptdata31 = tkd_promptdata31,
@transcode = tkd_trans
FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' AND tkd_promptdata1 = 'CALIBRATION';

IF (@transcode = 'UPLO' AND @promptdata1 = 'CALIBRATION')
  BEGIN
  SELECT @i = COUNT(*) FROM R5EVTTESTPOINTS WHERE ETP_EVENT = @promptdata2 AND ETP_OBJECT
 = @promptdata3 AND ETP_OBJECT_ORG = @promptdata4 AND ETP_SEQ = @promptdata5

  IF (@i = 1 AND (@promptdata31 <> '+' OR @promptdata31 IS NULL))
      BEGIN
      UPDATE R5EVTTESTPOINTS
      SET ETP_TESTPOINT = @promptdata6,
          ETP_TESTPOINTUOM = @promptdata7,
          ETP_DEVICETOLFROM = @promptdata8,
          ETP_DEVICETOLTO = @promptdata9,
          ETP_STANDARD = @promptdata10,
          ETP_STANDARDUOM = @promptdata11,
          ETP_OUTPUT = @promptdata12,
          ETP_OUTPUTUOM = @promptdata13,
          ETP_DEVICEREADING = @promptdata14,
          ETP_DEVIATION = @promptdata15,
          ETP_STATUS = @promptdata16,
          ETP_DEVICETOLFROMAL = @promptdata17,
          ETP_DEVICETOLTOAL = @promptdata18,
          ETP_STANDARDAL = @promptdata19,
          ETP_STANDARDUOMAL = @promptdata20,
          ETP_OUTPUTAL = @promptdata21,
          ETP_OUTPUTUOMAL = @promptdata22,
          ETP_DEVICEREADINGAL = @promptdata23,
          ETP_DEVIATIONAL = @promptdata24,
          ETP_STATUSAL = @promptdata25,
          ETP_COMMENTS = @promptdata26,
          ETP_NOTUSED = @promptdata27
      WHERE ETP_EVENT = @promptdata2 AND ETP_OBJECT = @promptdata3 AND ETP_OBJECT_ORG = @promptdata4 AND ETP_SEQ = @promptdata5
      END
  IF (@i = 0 AND (@promptdata31 <> '+' OR @promptdata31 IS NULL))
      BEGIN
      INSERT INTO R5EVTTESTPOINTS (ETP_EVENT,ETP_OBJECT,ETP_OBJECT_ORG,ETP_SEQ,ETP_TESTPOINT,ETP_TESTPOINTUOM,ETP_DEVICETOLFROM,ETP_DEVICETOLTO,ETP_STANDARD,ETP_STANDARDUOM,ETP_OUTPUT,ETP_OUTPUTUOM,ETP_DEVICEREADING,ETP_DEVIATION,ETP_STATUS,ETP_DEVICETOLFROMAL,ETP_DEVICETOLTOAL,ETP_STANDARDAL,ETP_STANDARDUOMAL,ETP_OUTPUTAL,ETP_OUTPUTUOMAL,ETP_DEVICEREADINGAL,ETP_DEVIATIONAL,ETP_STATUSAL,ETP_COMMENTS,ETP_NOTUSED,ETP_OUTPUTCALCTYPE)
      values(@promptdata2,@promptdata3,@promptdata4,@promptdata5,@promptdata6,@promptdata7,@promptdata8,@promptdata9,@promptdata10,@promptdata11,@promptdata12,@promptdata13,@promptdata14,@promptdata15,@promptdata16,@promptdata17,@promptdata18,@promptdata19,@promptdata20,@promptdata21,@promptdata22,@promptdata23,@promptdata24,@promptdata25,@promptdata26,@promptdata27,@promptdata30);
      END
  END
  IF (@i = 1 AND @promptdata31 = '+' AND @user IN ('ALEACH','BLEE'))
      BEGIN
      DELETE FROM R5EVTTESTPOINTS
      WHERE ETP_EVENT = @promptdata2 AND ETP_OBJECT = @promptdata3 AND ETP_OBJECT_ORG = @promptdata4 AND ETP_SEQ = @promptdata5
      END


DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 = 'CALIBRATION' ;

END;
