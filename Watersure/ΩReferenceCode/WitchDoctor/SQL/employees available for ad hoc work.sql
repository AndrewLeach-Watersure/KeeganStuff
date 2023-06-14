select count(*)
from
(select cre_person, evt_location floc, acs_endtime - ( (sysdate - acs_sched) * 86400 ) remaining
from 
r5crewemployees,
r5bookedhours,
r5actschedules,
r5events
where acs_responsible = cre_person
and boo_person =  cre_person
and boo_event = acs_event
and boo_act = evt_code
and boo_act = acs_activity
and trunc(sysdate) = trunc(acs_sched)
and cre_crew = 'CREW1'
and acs_endtime - ( (sysdate - acs_sched) * 86400 ) > 0
) a,

(select evt_location aloc, evt_code, act_act, (act_est * 3600) estsecs
from r5events inner join r5activities on act_event = act_act 
where evt_rstatus = 'R'
and not exists (select 'x' from r5actschedules
where acs_activity = act_act and acs_event = act_event)
and not exists (select 'x' from r5bookedhours
where boo_event = act_event and boo_act = act_act) 
)b

where floc = aloc
and estsecs <= remaining


*********************************

declare

cursor c1 is 
select cre_person, evt_location, earlyjob, 
TRUNC ((remaining/60) / 60) || ':' ||
     MOD   (remaining/60,  60) hrsleft, evt_code newjob, 
TRUNC ((estsecs/60) / 60) || ':' ||
     MOD   (estsecs/60,  60) esthrs
from
(select cre_person, evt_location floc, evt_code earlyjob, acs_endtime - ( (sysdate - acs_sched) * 86400 ) remaining
from 
r5crewemployees,
r5bookedhours,
r5actschedules,
r5events
where acs_responsible = cre_person
and boo_person =  cre_person
and boo_event = acs_event
and boo_act = evt_code
and boo_act = acs_activity
and trunc(sysdate) = trunc(acs_sched)
and cre_crew = 'CREW1'
and acs_endtime - ( (sysdate - acs_sched) * 86400 ) > 0
) a,

(select evt_location aloc, evt_code, act_act, (act_est * 3600) estsecs
from r5events inner join r5activities on act_event = act_act 
where evt_rstatus = 'R'
and not exists (select 'x' from r5actschedules
where acs_activity = act_act and acs_event = act_event)
and not exists (select 'x' from r5bookedhours
where boo_event = act_event and boo_act = act_act) 
)b

where floc = aloc
and estsecs <= remaining;

begin

for r in c1 loop

insert into r5alertdataobj
(ado_obj, ado_org, ado_udfchar01,  ado_udfchar02,  ado_udfchar03,  ado_udfchar04, 
ado_udfchar05,  ado_udfchar06,  ado_udfchar07 )
values
('ANYEQUIP', 'ORG1', 'AVAIL', r.cre_person, r.evt_location, r.earlyjob, 
r. hrsleft, r.newjob, r.esthrs);

end loop;

end;


*************
select count(distinct ado_udfchar02)
from r5alertdataobj
where ado_udfchar01 = 'AVAIL'


*****************

delete from r5alertdataobj where ado_udfchar01 = 'AVAIL'

*****************




evt_code in (select  evt_code
from
(select cre_person, evt_location floc, evt_code earlyjob, acs_endtime - ( (sysdate - acs_sched) * 86400 ) remaining
from 
r5crewemployees,
r5bookedhours,
r5actschedules,
r5events
where acs_responsible = cre_person
and boo_person =  cre_person
and boo_event = acs_event
and boo_act = evt_code
and boo_act = acs_activity
and trunc(sysdate) = trunc(acs_sched)
and cre_crew = 'CREW1'
and acs_endtime - ( (sysdate - acs_sched) * 86400 ) > 0
) a,

(select evt_location aloc, evt_code, act_act, (act_est * 3600) estsecs
from r5events inner join r5activities on act_event = act_act 
where evt_rstatus = 'R'
and not exists (select 'x' from r5actschedules
where acs_activity = act_act and acs_event = act_event)
and not exists (select 'x' from r5bookedhours
where boo_event = act_event and boo_act = act_act) 
)b

where floc = aloc
and estsecs <= remaining)