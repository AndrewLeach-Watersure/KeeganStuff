DECLARE @startOfPrevMonth Date
SELECT
    @startOfPrevMonth = DATEFROMPARTS(
        YEAR(DATEADD(month, -1, GETDATE())),
        MONTH(DATEADD(month, -1, GETDATE())),
        01
    ) DECLARE @startOfCurrMonth Date
SELECT
    @startOfCurrMonth = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 01);

DECLARE @startOfYear Date
SELECT
    @startOfYear = DATEFROMPARTS(YEAR(GETDATE()), 01, 01);

WITH internal_labor AS (
    SELECT
        ISNULL(EVT_PARENT, BOO_EVENT) AS WorkOrder,
        DBO.REPGETDESC(
            'EN',
            'EVNT',
            ISNULL(EVT_PARENT, BOO_EVENT),
            'EVNT',
            NULL
        ) AS WODescription,
        BOO_ACT AS Activity,
        BOO_COST AS Total,
        BOO_RATE AS Price,
        BOO_HOURS AS Qty,
        EVT_COSTCODE AS WOCostCode,
		EVT_MRC as WOCostCentre,
        EVT_COSTCODE AS AltCostCode,
        EVT_OBJECT AS Equipment,
        EVT_PROJECT as Project,
        OBJ_UDFCHAR34 as BudgetClass,
        OBJ_UDFCHAR39 as Strategy,
        CAST(NULL AS NVARCHAR(100)) AS Requisition,
        CAST(NULL AS NVARCHAR(100)) AS ReqLine,
        CAST(NULL AS NVARCHAR(100)) AS PO,
        CAST(NULL AS NVARCHAR(100)) AS POline,
        CAST(BOO_SQLIDENTITY AS NVARCHAR(400)) AS SystemReference,
        BOO_PERSON as WhoReference,
        BOO_ENTERED AS DateEntered,
        CAST(DATEPART(month, BOO_ENTERED) as NVARCHAR(2)) + '-' + CAST(DATEPART(year, BOO_ENTERED) as NVARCHAR(4)) as MontYear,
        CAST(DATEPART(quarter, BOO_ENTERED) as NVARCHAR(2)) + '-' + CAST(DATEPART(year, BOO_ENTERED) as NVARCHAR(4)) as QuartYear,
        BOO_DATE AS RecordDate,
        BOO_DESC AS Description,
        'Labour' AS RType,
        'Internal Labor' AS Type,
        BOO_EVENT AS WODetail
    FROM
        R5BOOKEDHOURS
        LEFT OUTER JOIN R5EVENTS ON EVT_CODE = BOO_EVENT
        LEFT OUTER JOIN R5OBJECTS ON OBJ_CODE = EVT_OBJECT
    WHERE
        BOO_PERSON IS NOT NULL
)
SELECT
    SUM(
        CASE
            WHEN ISNULL(internal_labor.WOCostCentre, '----') = 'MRA' THEN internal_labor.Qty
            ELSE 0
        END
    ) AS 'MRA',
    SUM(
        CASE
            WHEN ISNULL(internal_labor.WOCostCentre, '----') = 'DEF' THEN internal_labor.Qty
            ELSE 0
        END
    ) AS 'Defect',
    SUM (
        CASE
            WHEN ISNULL(internal_labor.WOCostCentre, '----') = 'PRO' THEN internal_labor.Qty
            ELSE 0
        END
    ) AS 'A&O Improvement (8021)',
    SUM(
        CASE
            WHEN ISNULL(internal_labor.WOCostCentre, 'MRA') NOT IN ('MRA','DEF','PRO') THEN internal_labor.Qty
            ELSE 0
        END
    ) AS 'R&M',
    SUM(
        CASE
            WHEN internal_labor.WOCostCentre IS NULL THEN internal_labor.Qty
            ELSE 0
        END
    ) AS 'Missing Cost Code'
FROM
    internal_labor
    LEFT OUTER JOIN R5USERS u ON u.USR_CODE = internal_labor.WhoReference
    RIGHT OUTER JOIN (
        SELECT
            u.USR_CODE AS code
        FROM
            R5PERSONNEL p
            LEFT OUTER JOIN R5USERS u ON u.USR_CODE = p.PER_USER
        WHERE
            u.USR_DESC IS NOT NULL AND (#prompt('Team')# = 'All' AND p.PER_UDFCHAR03 IN ('EI', 'MECH', 'ENG', 'PROJ'))
            OR (#prompt('Team')# = 'Electrical Team' AND p.PER_UDFCHAR03 = 'EI')
            OR (#prompt('Team')# = 'Mechanical Team' AND p.PER_UDFCHAR03 = 'MECH')
    ) team ON team.code = u.USR_CODE
WHERE
    (
        (
            #prompt('Period')# = 'Previous Month' AND internal_labor.RecordDate >= @startOfPrevMonth
            AND internal_labor.RecordDate < @startOfCurrMonth
        )
        OR (
            #prompt('Period')# = 'YTD' AND internal_labor.RecordDate >= @startOfYear AND internal_labor.RecordDate < GETDATE()
        )
        OR (
            #prompt('Period')# = 'Custom' AND internal_labor.RecordDate >= #prompt('CustomPeriodStart')# AND internal_labor.RecordDate < #prompt('CustomPeriodEnd')#
        )
    )
    AND (
        #prompt('Person')# = 'All' OR u.USR_DESC = #prompt('Person')#
    )
ORDER BY
    'MRA'