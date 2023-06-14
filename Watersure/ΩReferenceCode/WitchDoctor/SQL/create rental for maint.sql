
declare
e r5events%rowtype;
cnt int;
c_code varchar2(30);
chk varchar2(30);
cuser varchar2(30);

begin
select * into e
from r5events 
where r5events.rowid = :rowid
and evt_type = 'JOB'
and evt_object in (select obj_code from r5objects
where obj_rental = '+');

select count(*) into cnt from
r5customerrentals
where nvl(crt_udfchar10,'x') = e.evt_code;

if cnt = 1 then

update r5customerrentals
set crt_estimatedissuedate = e.evt_target,
crt_estimatedreturndate = e.evt_schedend
where crt_udfchar10 = e.evt_code
and ( crt_estimatedissuedate <> e.evt_target
or crt_estimatedreturndate <> e.evt_schedend);

else

select o7sess.cur_user into cuser from dual;

r5o7.o7maxseq( c_code, 'CRT', '1', chk );

insert into r5customerrentals
(crt_code, crt_org, crt_desc, crt_type, crt_rtype,
crt_status, crt_rstatus, crt_object, crt_object_org,
crt_issuedto, crt_udfchar10, crt_estimatedissuedate,
crt_estimatedreturndate)
values
(c_code, e.evt_org, 'Maintenance Scheduled', 'P','P',
'M','U',e.evt_object, e.evt_object_org, 'JMORTENSEN', e.evt_code,
e.evt_target, e.evt_schedend );

end if;

exception
when no_data_found then null;
end;