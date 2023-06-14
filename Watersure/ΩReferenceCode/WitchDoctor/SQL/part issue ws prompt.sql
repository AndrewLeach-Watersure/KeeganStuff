declare

d	r5depots%rowtype;
user varchar2(30);
emp varchar2(30);
chk varchar2(9);
tn int;
avgpr  numeric(26,6);
porg varchar2(15);

begin

select * into d from r5depots where rowid = :rowid 
and dep_code = 'ZZZ' ;

user := O7SESS.CUR_USER;


r5o7.o7maxseq(tn,'TRAN','1',chk);
if chk <> '0' then raise_application_error(-20001, 'TRN '||chk); end if;
	
insert into r5transactions
(tra_code,tra_desc,tra_type,tra_rtype,tra_auth,tra_date,tra_status,tra_rstatus,
tra_fromentity,tra_fromrentity,tra_fromtype,tra_fromrtype,tra_fromcode,tra_fromcode_org,
tra_toentity,tra_torentity,tra_totype,tra_tortype,tra_tocode,tra_org)
values
(tn,'I','I','I',user,TRUNC(SYSDATE),'A','A',
'STOR','STOR','*','*',d.dep_udfchar04,d.dep_org,
'EVNT','EVNT','*','*',d.dep_udfchar02,d.dep_org);

select sto_part_org, nvl(sto_avgprice,1) into porg, avgpr
from r5stock 
where sto_store = d.dep_udfchar04 
and sto_part = d.dep_udfchar05;

insert into r5translines
(trl_trans,trl_type,trl_rtype,trl_line,trl_date,trl_event,trl_act,trl_part,
trl_price,trl_qty,trl_io,trl_part_org,trl_store,trl_lot,
trl_bin)
values
(tn,'I','I',10,sysdate,d.dep_udfchar02,d.dep_udfchar03,
d.dep_udfchar05, avgpr,d.dep_udfchar07,-1,porg,
d.dep_udfchar04,'*', d.dep_udfchar06);

delete from r5depots where rowid = :rowid;

EXCEPTION
WHEN NO_DATA_FOUND THEN NULL;

end;




UUMBP1
Issue Part to Work Order


MBP1ORG

select org_code, org_desc from r5organization order by org_code 

MBP1WO

select evt_code, evt_desc, evt_object from r5events where evt_rstatus = 'R' and evt_org = :101 and evt_code in (select act_event from r5activities) order by evt_code


MBP1ACT

select act_act, act_trade from r5activities where act_event = :102 order by act_act

MBP1STR

select str_code, str_desc from r5stores where str_org = :101 order by str_code

MBP1PRT

select par_code,  par_desc from r5binstock, r5parts where par_code = bis_part and bis_qty > 0 and bis_store = :104 order by par_code

MBP1BIN

select bis_bin,  bis_qty from r5binstock, r5parts where par_code = bis_part and bis_qty > 0 and bis_part = :105 and bis_store = :104 order by par_code


27576

00212504
*
MA-1
