declare
--r r5readings%rowtype;
@obj nvarchar(30),
@org nvarchar(15),
@uom nvarchar(30),
@read numeric(24,6),
@rdate datetime,
@mdue numeric(24,6),
@ppm nvarchar(30),
@lastdate datetime,
@perday  numeric(24,6),
@duediff numeric(24,6),
@duedays numeric(24,6)

begin

select 
@obj = rea_object,
@org = rea_object_org,
@uom = rea_uom,
@read = rea_reading,
@rdate = rea_date
from r5readings
where rea_sqlidentity = :rowid

DECLARE c1 CURSOR LOCAL STATIC FOR 
select min(ppo_ppm), ppo_meterdue
into @ppm, @mdue
from r5ppmobjects
where ppo_object = @obj
and ppo_object_org = @org
and ppo_metuom = @uom
and ppo_meterdue =
(select min(ppo_meterdue)
from r5ppmobjects
where ppo_object = @obj
and ppo_object_org = @org
and ppo_metuom = @uom)
and ppo_meterdue >= @read
group by ppo_meterdue

select max(rea_date) into @lastdate
from r5readings
where rea_object = @obj
and rea_object_org = @org
and rea_uom = @uom
and rea_date < @rdate

select r.rea_diff/ (@rdate - @lastdate)
into @perday  from dual

select @mdue - @read 
into @duediff from dual

select @duediff / @perday 
into @duedays from dual

update r5objects
set obj_udfchar40 = @ppm,
obj_udfdate05 = @rdate + @duedays
where obj_code = @obj
and obj_org = @org
and @duedays is not null

exception 
when no_data_found
then null

end
