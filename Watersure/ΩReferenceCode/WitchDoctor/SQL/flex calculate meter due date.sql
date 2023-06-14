declare
@obj	nvarchar(30),
@org	nvarchar(30),
@diff	numeric(24,6),
@read	numeric(24,6),
@date	datetime,
@uom	nvarchar(30),
@pdate	datetime
begin

select @obj= rea_object, @org = rea_object_org, @diff = rea_diff,
@read = rea_reading @date = rea_date, @uom = rea_calcuom
from r5readings 
where rea_sqlidentity = :rowid

select @pdate = max(rea_date)
from r5readings 
where rea_object = @obj and rea_object_org = @org
and rea_calcuom = @uom and rea_date < @date

if @pdate is not null
update r5ppmobjects 
set ppo_fromrefdesc = 
convert ( nvarchar, 
dateadd ( dd, (ppo_meterdue - @read) / (@diff / datediff(dd, @pdate, @date)), @date),
101)
where ppo_object = @obj
and ppo_object_org = @org
and ppo_metuom = @uom
and ppo_deactive is null

end 



