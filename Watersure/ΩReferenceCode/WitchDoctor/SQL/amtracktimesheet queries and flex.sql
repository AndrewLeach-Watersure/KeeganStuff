select 'WO' LTYPE, ATW_HOURS EMPLHRS, atw_ATW_TIMECODE TIMECODE, ATW_QTY QTY, NULL COMMENTS, ATW_PREMIUM PREMIUM, ATM_PERS, ATM_DATEPK FROM U5AUTSWO
UNION
SELECT 'SITE', ATY_DUR, ATY_TIMEENTCODE, NULL, NULL, NULL, TM_PERS, ATM_DATEPK FROM U5AUTPRP
UNION
SELECT 'PTO', ATP_HOURS, NULL, NULL, NULL, NULL, TM_PERS, ATM_DATEPK FROM U5AUTPTO


USE [AMTRAKSQL01]
GO

/****** Object:  View [dbo].[timesheetgrid]    Script Date: 4/27/2016 10:03:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[timesheetgrid] as
select 'WO' LTYPE, ATW_HOURS EMPLHRS, atw_job "WO", ATW_TIMECODE TIMECODE, ATW_QTY QTY, NULL COMMENTS, ATW_PREMIUM PREMIUM, ATM_PERS, ATM_DATEPK FROM U5AUTSWO
UNION
SELECT 'SITE', ATY_DUR, null,ATY_TIMEENTCODE, NULL, NULL, NULL, ATM_PERS, ATM_DATEPK FROM U5AUTPRP
UNION
SELECT 'PTO', ATP_HOURS, null, NULL, NULL, NULL, NULL, ATM_PERS, ATM_DATEPK FROM U5AUTPTO
GO



select atm_date, atm_pers, atm_name, atm_crew, atm_shift, atm_total, atm_shifthrs, ltype, emplhrs, timecode
from r5autmsh a inner join timesheetgrid b on a.ATM_PERS = b.ATM_PERS and a.ATM_DATEPK = b.ATM_DATEPK and ltype <> 'SITE'
where (#prompt('SEL_PERS')# = '%' OR atm_pers = #prompt('SEL_PERS')# )
and (#prompt('SEL_CREW')# = '%' OR atm_pers = dbo.repgetdesc('EN','CREW', #prompt('SEL_CREW')#, null, null) )
and a.ATM_DATEPK bwteen #prompt('SEL_START')# and #prompt('SEL_END')#


post insert/update
u5autmsh

declare

@USER		nvarchar(30),
@status		nvarchar(30),
@oldstatus	nvarchar(30)


begin

select 
@status = atm_status,
@oldstatus =  atm_oldstatus
from u5autmsh
where sqlidentity = :rowid

EXECUTE O7SESS_CUR_USER @USER OUTPUT

if @status = 'POSTED' and @USER <> 'BGROTH'
raiserror('You are not allowed to post a timesheet.',16,1)

if (@status is not null and @oldstatus is null)
or (@status <> @oldstatus )
update u5autmsh set
atm_oldstatus = @status,
atm_statusby = @USER,
atm_statusdate = getdate()
where sqlidentity = :rowid

end


post insert u5autprp

declare

@dur		nvarchar(5),
@pers		nvarchar(30),
@datepk		nvarchar(10)

begin


select
@dur = format(datediff(hour, aty_clkontime, aty_clkofftime),'00') +':'+
format(datediff(MINUTE, aty_clkontime, aty_clkofftime) - (datediff(hour, aty_clkontime, aty_clkofftime) * 60),'00') ,
@pers = t.atm_pers,
@datepk	= t.atm_datepk
from u5autprp p, u5autmsh t
where p.atm_pers = t.atm_pers
and p.atm_datepk = t.atm_datepk
and p.sqlidentity = :rowid

update u5autprp set
aty_dur = @dur 
where sqlidentity = :rowid

update u5autmsh set
atm_shifthrs = @dur
where atm_pers = @pers
and atm_datepk = @datepk

end

post insert/update u5autpto

declare

@tot		nvarchar(5),
@pers		nvarchar(30),
@datepk		nvarchar(10)

begin

select
@tot = format(cast( thours as int), '00') +':'+ format((thours - cast( thours as int)) * 60 , '00') ,
@pers = ATM_PERS, 
@datepk = ATM_DATEPK
from
(select phrs + isnull(whrs,0) thours, b.ATM_PERS, b.ATM_DATEPK
from
(select sum(ATP_HOURS) phrs, ATM_PERS, ATM_DATEPK
from u5autpto where ATM_PERS+ATM_DATEPK = (select ATM_PERS+ATM_DATEPK
				from u5autpto
				where sqlidentity = :rowid) 
				group by ATM_PERS, ATM_DATEPK
				) b
left outer join
(select sum(ATW_HOURS) whrs, ATM_PERS, ATM_DATEPK
 from U5AUTSWO where ATM_PERS+ATM_DATEPK = (select ATM_PERS+ATM_DATEPK
				from u5autpto
				where sqlidentity = :rowid)
				group by ATM_PERS, ATM_DATEPK) a
on a.ATM_PERS = b.ATM_PERS and  a.ATM_DATEPK = b.ATM_DATEPK)c

update u5autmsh set
atm_total = @tot
where atm_pers = @pers
and atm_datepk = @datepk

end

post insert/update U5AUTSWO

declare

@tot		nvarchar(5),
@pers		nvarchar(30),
@datepk		nvarchar(10)

begin
select
@tot = format(cast( thours as int), '00') +':'+ format((thours - cast( thours as int)) * 60 , '00') ,
@pers = ATM_PERS, 
@datepk = ATM_DATEPK
from
(select whrs + isnull(phrs,0) thours, a.ATM_PERS, a.ATM_DATEPK
from
(select sum(ATW_HOURS) whrs, ATM_PERS, ATM_DATEPK
 from U5AUTSWO where ATM_PERS+ATM_DATEPK = (select ATM_PERS+ATM_DATEPK
				from U5AUTSWO
				where sqlidentity = :rowid)
				group by ATM_PERS, ATM_DATEPK) a
left outer join
(select sum(ATP_HOURS) phrs, ATM_PERS, ATM_DATEPK
from u5autpto where ATM_PERS+ATM_DATEPK = (select ATM_PERS+ATM_DATEPK
				from U5AUTSWO
				where sqlidentity = :rowid) 
				group by ATM_PERS, ATM_DATEPK
				) b
on a.ATM_PERS = b.ATM_PERS and  a.ATM_DATEPK = b.ATM_DATEPK)c

update u5autmsh set
atm_total = @tot
where atm_pers = @pers
and atm_datepk = @datepk

end







select 
atm_date "Date", 
a.atm_pers + ' :: '+ atm_name "Employee", atm_crew "Gang/Crew", atm_shift "Shift", atm_total, atm_shifthrs "On Pem", ltype "Type", emplhrs "Hours", wo "Work Order" ,timecode "Time Code"
from u5autmsh a inner join timesheetgrid b on a.ATM_PERS = b.ATM_PERS and a.ATM_DATEPK = b.ATM_DATEPK and ltype <> 'SITE'
where (#prompt('SEL_PERS')# = '%' OR a.atm_pers = #prompt('SEL_PERS')# )
and (#prompt('SEL_CREW')# = '%' OR a.atm_crew = dbo.repgetdesc('EN','CREW', #prompt('SEL_CREW')#, null, null) )
and a.ATM_DATEPK between #prompt('SEL_START')# and #prompt('SEL_END')#
UNION
atm_date "Date", 
a.atm_pers + ' :: '+ atm_name "Employee", NULL, NULL, NULL, NULL, NULL, SUM(emplhrs) "Hours", wo "Work Order" ,timecode "Time Code"
from u5autmsh a inner join timesheetgrid b on a.ATM_PERS = b.ATM_PERS and a.ATM_DATEPK = b.ATM_DATEPK and ltype <> 'SITE'
where (#prompt('SEL_PERS')# = '%' OR a.atm_pers = #prompt('SEL_PERS')# )
and (#prompt('SEL_CREW')# = '%' OR a.atm_crew = dbo.repgetdesc('EN','CREW', #prompt('SEL_CREW')#, null, null) )
and a.ATM_DATEPK between #prompt('SEL_START')# and #prompt('SEL_END')#


