declare
t r5trackingdata%rowtype;
user varchar2(30);
chk varchar2(9);
org	varchar2(15);
otp	varchar2(9);
ortp varchar2(9);
sgn int;
ccnt int;
tn int;
wo varchar2(50);
act int;
tdate date;
avgpr  numeric(26,6);
porg varchar2(15);
split varchar2(1);
obj varchar2(30);
mrc varchar2(30);

begin
select * into t
from r5trackingdata
where rowid = :rowid;

if t.tkd_trans = 'VI' then

select 
substr( t.tkd_promptdata4, 1, instr( t.tkd_promptdata4,'#')-1), 
substr( t.tkd_promptdata4, instr( t.tkd_promptdata4,'#')+1),
to_date(t.tkd_promptdata3,'MM/DD/YYYY'),
decode(t.tkd_promptdata1,'I',1,-1),
decode(t.tkd_promptdata6,'Y','A','N')
into wo, act,tdate,sgn,split
from dual;

user := O7SESS.CUR_USER;

select obj_code, obj_org,obj_obtype,obj_obrtype,obj_mrc 
into obj, org,otp,ortp,mrc	
from r5objects
where obj_code = nvl(t.tkd_promptdata7,t.tkd_promptdata8);

select par_org, par_avgprice into porg, avgpr
from r5parts where par_code = t.tkd_promptdata14;

if wo is null then
r5o7.o7maxseq(wo,'EVENT','1',chk);
if chk <> '0' then raise_application_error(-20001, 'SEQ '||chk); end if;
insert into r5events
(evt_code,evt_desc,evt_type,evt_rtype,evt_date,evt_status,evt_rstatus,
evt_mrc,evt_costcode,evt_obtype,evt_obrtype,evt_object,evt_target,
evt_origin,evt_jobtype,evt_completed,evt_org,evt_object_org,evt_createdby,evt_duration)
values
(wo,obj,'JOB','JOB',tdate,'C','C',mrc,t.tkd_promptdata9,otp,ortp,obj,tdate,
t.tkd_promptdata10,'IS',tdate,org,org,user,1);
o7creob1(wo,'IS',obj,org,otp,ortp,chk );

else 
	select count(*) into ccnt from r5events 
	where evt_parent = wo and evt_object = obj;
	if ccnt = 1 then
	 	select evt_code into wo from r5events 
		where evt_parent = wo and evt_object = obj;
	end if;
end if;

r5o7.o7maxseq(tn,'TRAN','1',chk);
if chk <> '0' then raise_application_error(-20001, 'TRN '||chk); end if;
	
insert into r5transactions
(tra_code,tra_desc,tra_type,tra_rtype,tra_auth,tra_date,tra_status,tra_rstatus,
tra_fromentity,tra_fromrentity,tra_fromtype,tra_fromrtype,tra_fromcode,tra_fromcode_org,
tra_toentity,tra_torentity,tra_totype,tra_tortype,tra_tocode,tra_org,tra_pers)
values
(tn,'I','I','I',user,tdate,'A','A',
'STOR','STOR','*','*',t.tkd_promptdata2,org,
'EVNT','EVNT','*','*',wo,org,t.tkd_promptdata10);

insert into r5translines
(trl_trans,trl_type,trl_rtype,trl_line,trl_date,trl_event,trl_act,trl_part,
trl_price,trl_qty,trl_io,trl_part_org,trl_store,trl_lot,trl_udfchar02,
trl_udfchar01,trl_udfchar03,trl_bin, trl_costcode, trl_splittrans)
values
(tn,'I','I',10,tdate,wo,act,t.tkd_promptdata14,
avgpr,t.tkd_promptdata16 * sgn,-1,porg,t.tkd_promptdata2,'*', t.tkd_promptdata11,
t.tkd_promptdata12,t.tkd_promptdata13,t.tkd_promptdata15, t.tkd_promptdata9, split);
	  
delete
from r5trackingdata
where rowid = :rowid;

end if;

EXCEPTION
WHEN NO_DATA_FOUND
then null;

end;