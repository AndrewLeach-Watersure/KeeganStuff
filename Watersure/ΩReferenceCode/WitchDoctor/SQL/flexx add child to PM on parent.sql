declare

e r5events%rowtype;
ceventno VARCHAR2(30); 
chk VARCHAR2(4);

cursor c1 (parent varchar2) is
select stc_childtype cotype , 
stc_child_org cobjectorg,
stc_child cobject,
obj_mrc cmrc, 
'TIRESWAP' cstwo
from r5structures inner join r5objects
on obj_code = stc_child
and stc_childtype = 'A'
and stc_parent = parent
and stc_parenttype = 'P';

begin
select * into e
from r5events
where rowid = :rowid
and EVT_PPM = 'DISTINSSP1';

for r in c1( e.evt_object) loop

o7crevt5(r.cobjectorg, r.cotype, r.cotype, r.cobject, r.cobjectorg, r.cmrc, null,null,r.cstwo,null,'R5',ceventno,CHK); 

update r5events set
evt_parent = e.evt_code,
evt_routeparent = e.evt_code,
evt_jobtype = 'MEC'
where evt_code = ceventno;

end loop;

exception
when no_data_found then null;
end;
