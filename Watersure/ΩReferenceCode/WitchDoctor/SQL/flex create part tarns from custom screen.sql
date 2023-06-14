declare

c u5cntprt%rowtype;
user varchar2(30);
chk varchar2(9);
tn int;
supplier  varchar2(30);
sup_org varchar2(30);
org varchar2(30);
part_org varchar2(30);
tdate  date;

begin

select * into c from u5cntprt
where rowid = :rowid;

select evt_supplier, evt_supplier_org, evt_org, sysdate
into supplier, sup_org, org, tdate
from r5events
where evt_code = c.cnp_job;

select max(par_org) into part_org from r5parts 
where par_code = c.cnp_part;

user := O7SESS.CUR_USER;

r5o7.o7maxseq(tn,'TRAN','1',chk);
if chk <> '0' then raise_application_error(-20001, 'TRN '||chk); end if;
	
insert into r5transactions
(tra_code,tra_desc,tra_type,tra_rtype,tra_auth,tra_date,tra_status,tra_rstatus,
tra_fromentity,tra_fromrentity,tra_fromtype,tra_fromrtype,tra_fromcode,tra_fromcode_org,
tra_toentity,tra_torentity,tra_totype,tra_tortype,tra_tocode,tra_org)
values
(tn,'RECV Contractor Part','RECV','RECV','R5',tdate,'A','A',
'COMP','COMP','*','*',supplier,sup_org,
'EVNT','EVNT','*','*',c.cnp_job,org);

insert into r5translines
(trl_trans,trl_type,trl_rtype,trl_line,trl_date,trl_event,trl_act,trl_part,
trl_price,trl_qty,trl_io,trl_part_org,trl_store,trl_lot)
values
(tn,'RECV','RECV',10,tdate,c.cnp_job,c.cnp_act, c.cnp_part,
nvl(c.cnp_price,c.cnp_avgprice),c.cnp_QTY,0,part_org,'MA-1','*');

exception
when no_data_found then null;

end;

