declare
r r5readings%rowtype;
mdue number(24,6);
ppm varchar2(30);
lastdate date;
perday  number(24,6);
duediff number(24,6);
duedays number(24,6);

begin

select * into r
from r5readings
where rowid = :rowid;

select min(ppo_ppm), ppo_meterdue
into ppm, mdue
from r5ppmobjects
where ppo_object = r.rea_object
and ppo_object_org = r.rea_object_org
and ppo_metuom = r.rea_uom
and ppo_meterdue =
(select min(ppo_meterdue)
from r5ppmobjects
where ppo_object = r.rea_object
and ppo_object_org = r.rea_object_org
and ppo_metuom = r.rea_uom)
and ppo_meterdue >= r.rea_reading
group by ppo_meterdue;

select max(rea_date) into lastdate
from r5readings
where rea_object = r.rea_object
and rea_object_org = r.rea_object_org
and rea_uom = r.rea_uom
and rea_date < r.rea_date;

select r.rea_diff/ (r.rea_date - lastdate)
into perday  from dual;

select mdue - r.rea_reading 
into duediff from dual;

select duediff / perday 
into duedays from dual;

update r5objects
set obj_udfchar40 = ppm,
obj_udfdate05 = r.rea_date + duedays
where obj_code = r.rea_object
and obj_org = r.rea_object_org
and duedays is not null;

exception 
when no_data_found
then null;

end;
