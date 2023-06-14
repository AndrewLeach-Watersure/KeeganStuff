declare

chk VARCHAR2(4); 
cuser VARCHAR2(30);
ceventno VARCHAR2(30);

cursor c1 is
select epo_object, epo_object_org, epo_event, obj_obtype, obj_obrtype,
obj_mrc, epo_stwo, epo_code
from r5eventpoints inner join r5events on evt_code = epo_event
inner join r5objects on obj_code = epo_object and obj_org = epo_object_org
where epo_job is null 
and epo_create = '+'
and evt_rstatus = 'R'
and epo_stwo is not null
and evt_code > '37000';

begin

select  o7sess.cur_user 
into  cuser
from dual;

for r in c1 loop

o7crevt5( r.epo_object_org, r.obj_obtype, r.obj_obrtype, r.epo_object, r.epo_object_org, r.obj_mrc, null, null, r.epo_stwo,null, cuser, r.epo_code, ceventno,CHK); 
IF CHK<>'0' THEN
RAISE_APPLICATION_ERROR(-20001, CHK);
END IF;
update r5eventpoints set epo_job = ceventno where epo_code = r.epo_code;

end loop;

end;