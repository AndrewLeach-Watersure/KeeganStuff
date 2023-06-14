/*
In FLEX Business rules add this code as a  POST UPDATE
Check the boxes "Abort on Failure" and "Acive"
Edit the values for the first six variables declared
Make sure the audit trail is on for R5EVENTS, column EVT_STATUS
The parts must be "planned" on the parts tab
*/


declare

app_val  number(24,6) := 1000.0; --amount that must be approved
curr_status	varchar2(8) := 'zz'; -- status code to fire trigger,e.g., 'C'
app_status	varchar2(8) := 'zz'; --approval status
err_mess	varchar2(200) := 'zzz'; --error message
lbr_rate number(24,6):= 999; --blended labor rate
store varchar2(30) := 'zzz'; --store code for part price (store tab on part screen)

e	r5events%rowtype;
val	number(24,6);
app_cnt	int;

begin

--select the work order if it is in the curr_status
select * into e from r5events
where rowid = :rowid
and evt_status = curr_status
and evt_rtype in ('JOB','PPM');

--get the estimated wo cost
select nvl(parts,0) + nvl(labor,0) into val
from dual
left outer join (select sum(act_est * act_persons * lbr_rate) labor
from r5activities where act_event = e.evt_code
) a on 1=1
left outer join (select sum(mlp_qty * sto_avgprice) parts
from r5matlparts 
inner join r5matlists on mtl_code = mlp_matlist
inner join r5stock on sto_part = mlp_part and sto_store = store and sto_part_org = mlp_part_org
where mtl_event = e.evt_code
) b on 1=1;

--get the number of times the WO has been in the app_status
select count(*) into app_cnt
from r5audattribs inner join r5audvalues 
on aat_code = ava_attribute
and ava_table = 'R5EVENTS'
and aat_table = 'R5EVENTS'
and aat_column = 'EVT_STATUS'
and ava_primaryid = e.evt_code
and ava_to = app_status;

--if the estimated cost is greater or equal to amount and the status has not been in  app_status, raise an error
if nvl(app_cnt,0) = 0 and val >= app_val then
raise_application_error (-20001, err_mess);
end if;

exception
when no_data_found then null;
end;