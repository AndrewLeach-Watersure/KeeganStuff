DECLARE
	@rate numeric(24, 6),
	@trade nvarchar(40),
	@person nvarchar(40),
	@type nvarchar(10),
	@count nvarchar(100),
	@dept nvarchar(10),
	@hrs numeric(24, 6),
	@total numeric(24, 6),
	@dte nvarchar(20);

BEGIN
	SELECT
		@rate   = BOO_RATE,
		@trade	= BOO_TRADE,
		@person = BOO_PERSON,
		@dept   = BOO_MRC,
		@type   = BOO_OCRTYPE,
		@hrs 	= BOO_HOURS,
		@dte 	= BOO_DATE,
		@count 	= NULL
	FROM R5BOOKEDHOURS
	WHERE boo_sqlidentity = :rowid

	IF @person IS NOT NULL
		BEGIN
		(
			SELECT TOP 1  @count = TRR_NTRATE
			FROM R5TRADERATES
			WHERE  TRR_PERSON = @person 
				AND TRR_MRC = @dept 
				AND TRR_OCTYPE = @type 
				AND TRR_START <= @dte 
				AND TRR_END >= @dte
		)
		
		IF @count IS NULL
			BEGIN
				RAISERROR( 'You cannot book hours without a rate setup, see your system administrator Phone Extension 164', 16 , 1)
			END

		SELECT 	@rate = TRR_NTRATE
				,@total = @rate * @hrs
			FROM R5TRADERATES
				WHERE  TRR_PERSON = @person 
					AND TRR_MRC = @dept 
					AND TRR_OCTYPE = @type 
					AND TRR_START <= @dte 
					AND TRR_END >= @dte

		UPDATE R5BOOKEDHOURS
			SET BOO_RATE = @rate
				,BOO_COST = @total
			WHERE BOO_SQLIDENTITY = :rowid

		END
END
