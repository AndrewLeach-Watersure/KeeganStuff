declare

e r5events%rowtype;
o r5objects%rowtype;

begin

select * into e
from r5events
where evt_type in ('JOB','PPM')
and rowid = :rowid;

select * into o
from r5objects
where obj_code = e.evt_object
and obj_org = e.evt_object_org;

if nvl(o.obj_udfchar01, 'x')  <> nvl(e.evt_udfchar01, 'x')
or nvl(o.obj_udfchar02, 'x') <> nvl(e.evt_udfchar02, 'x')
then

update r5events set
evt_udfchar01 = o.obj_udfchar01,
evt_udfchar02 = o.obj_udfchar02
where and rowid = :rowid;

end if;


exception
when no_data_found then null;

end;