
When the “Assigned To” field on the WO Record View is filled out or changed and there is a STD Work Order specified, create a “Scheduled Labor” record on that WO and the first activity.  
The Scheduled Labor record would be for the “Assigned To” employee and first activity on the WO.   
If the Scheduled Labor record already exists for that Employee and Activity update the “Scheduled Date” on the “Scheduled Labor” record for that employee to equal the “Scheduled Start Date” contained in the WO Record view.


--post insert r5activities
declare
e r5events%rowtype;
a r5activities%rowtype;
p r5personnel%rowtype;
user varchar2(30);
chk varchar2(9);
acscode  varchar2(30);

begin
select * into a from r5activities
where rowid = :rowid;
if a.act_act = 1 then
select * into e from r5events 
where evt_code = a.act_event;
if e.evt_standwork is not null and e.evt_person is not null then

select * into p from r5personnel
where per_code = e.evt_person;
user := O7SESS.CUR_USER;
r5o7.o7maxseq(acscode,'ACS','1',chk);
insert into r5actschedules(acs_event, acs_act, acs_responsible, acs_mrc, acs_trade, acs_sched, acs_hours, acs_scheduler, acs_code)
values (a.act_event, a.act_act, p.per_code, p.per_mrc, p.per_trade, e.evt_target, a.act_est, user, acscode );
end if;  --if e.evt_standwork 
end if; --a.act_act = 1
end;


--post update r5events

declare
e r5events%rowtype;
cnt int;
sched date;
acscode  varchar2(30);

begin
select * into e from r5events 
where rowid = :rowid;

if e.evt_standwork is not null and e.evt_person is not null then

select count(*) into cnt from r5actschedules
where acs_event = a.act_event and acs_act = 1
and acs_responsible = e.evt_person;


if cnt > 0 then
select trunc(acs_sched), max(acs_code)into sched, acscode
from r5actschedules 
where acs_event = a.act_event and acs_act = 1
and acs_responsible = e.evt_person
group by trunc(acs_sched);

if sched <>  trunc(e.evt_target) then
update r5actschedules set acs_sched = trunc(e.evt_target)
where acs_code = acscode;

end if; --sched
end if; --cnt = 0
end if;  --if e.evt_standwork 
end;




