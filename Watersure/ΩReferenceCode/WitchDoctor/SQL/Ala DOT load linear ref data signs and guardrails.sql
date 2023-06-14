declare

t r5trackingdata%rowtype;
user varchar2(30) := 'RICHARD.MOORE2@INFOR.COM';
chk varchar2(9);
lrf int;

begin
select * into t
from r5trackingdata
where rowid = :rowid;

if t.tkd_trans = 'SNGR' then

r5o7.o7maxseq(lrf,'LRF','1',chk);
if chk <> '0' then raise_application_error(-20001, 'LRF '||chk); end if;

if t.tkd_promptdata1 like 'GUARDRAIL%' then 


insert into r5objlinearref
(LRF_ID, LRF_OBJCODE, LRF_OBJORG, LRF_REFRTYPE, LRF_REFTYPE, LRF_REFDESC, 
LRF_FROMPOINT, LRF_TOPOINT, LRF_UPDATECOUNT, LRF_CREATED, LRF_CLASS, LRF_CLASS_ORG,
LRF_DATEEFFECTIVE, LRF_DATEEXPIRED, LRF_CREATEDBY, LRF_LINEAR_REFTYPE, lrf_udfnum01, 
lrf_udfchar02)
(select lrf, obj_code, obj_org, 'LRS','LRS', 
t.tkd_promptdata2||' '||t.tkd_promptdata6 || ' to '||t.tkd_promptdata7,
t.tkd_promptdata6 - obj_udfnum01, t.tkd_promptdata7 - obj_udfnum01,0, sysdate, 
'GRDRAIL', '*', TRUNC(SYSDATE -1), TO_DATE('2099-12-31','yyyy-mm-dd'),
user, 'O', t.tkd_promptdata8, t.tkd_promptdata3  
from r5objects where obj_code = t.tkd_promptdata4||t.tkd_promptdata5
and obj_org = '01');

elsif t.tkd_promptdata1 like 'SIGNS%' then

insert into r5objlinearref
(LRF_ID, LRF_OBJCODE, LRF_OBJORG, LRF_REFRTYPE, LRF_REFTYPE, LRF_REFDESC, 
LRF_FROMPOINT, LRF_TOPOINT, LRF_UPDATECOUNT, LRF_CREATED, LRF_CLASS, LRF_CLASS_ORG,
LRF_DATEEFFECTIVE, LRF_DATEEXPIRED, LRF_CREATEDBY, LRF_LINEAR_REFTYPE, lrf_udfnum01,
lrf_udfchar01, lrf_udfchar02, lrf_udfnum02, lrf_udfnum03, lrf_udfnum04, 
lrf_udfchar03, lrf_udfchar04)
(select lrf, obj_code, obj_org, 'LRS','LRS', 
t.tkd_promptdata12||case when t.tkd_promptdata12 like '%MILE MARKER%' then '' else ' '||t.tkd_promptdata6 end,
t.tkd_promptdata6 - obj_udfnum01, t.tkd_promptdata7 - obj_udfnum01,0, sysdate, 
case 
when t.tkd_promptdata12 like '%COUNTY%' then 'SIGN CNT'
when t.tkd_promptdata12 like '%TYPE%' then 'SIGN TYP'
when t.tkd_promptdata12 like '%MILE MARKER%' then 'SIGN MM'
when t.tkd_promptdata1 like 'SIGNS - OTHER%' then 'SIGN OTH'
when t.tkd_promptdata1 like 'SIGNS - W & R%' then 'SIGN WR'
end,
'*', TRUNC(SYSDATE -1), TO_DATE('2099-12-31','yyyy-mm-dd'),
user, 'O', t.tkd_promptdata8, t.tkd_promptdata2, t.tkd_promptdata3,
t.tkd_promptdata9, t.tkd_promptdata10, t.tkd_promptdata11,  
t.tkd_promptdata13, t.tkd_promptdata14
from r5objects where obj_code = t.tkd_promptdata4||t.tkd_promptdata5
and obj_org = '01');

end if;


delete from r5trackingdata
where rowid = :rowid;

end if;

exception
when no_data_found then null;

end;