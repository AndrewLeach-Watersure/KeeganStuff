declare

t r5trackingdata%rowtype;
user varchar2(30);
chk varchar2(9);
lrf int;

begin
select * into t
from r5trackingdata
where rowid = :rowid;

if t.tkd_trans = 'ASPH' then

r5o7.o7maxseq(lrf,'LRF','1',chk);
if chk <> '0' then raise_application_error(-20001, 'LRF '||chk); end if;

insert into r5objlinearref
(LRF_ID, LRF_OBJCODE, LRF_OBJORG, LRF_REFRTYPE, LRF_REFTYPE, LRF_REFDESC, 
LRF_FROMPOINT, LRF_TOPOINT, LRF_UPDATECOUNT, LRF_CREATED, LRF_CLASS, LRF_CLASS_ORG,
LRF_DATEEFFECTIVE, LRF_DATEEXPIRED, LRF_CREATEDBY, LRF_LINEAR_REFTYPE)
(select lrf, obj_code, obj_org, 'LRS','LRS', 
t.tkd_promptdata4||' Lane '||nvl( ':: '||t.tkd_promptdata5, ''),
t.tkd_promptdata2 - obj_udfnum01, t.tkd_promptdata3 - obj_udfnum01,0, sysdate, 
'ASPHALT', '*', TRUNC(SYSDATE -1), TO_DATE('2099-12-31','yyyy-mm-dd'),
'RICHARD.MOORE2@INFOR.COM', 'O' from r5objects where obj_code = t.tkd_promptdata1
and obj_org = '01');


delete from r5trackingdata
where rowid = :rowid;

end if;

exception
when no_data_found then null;

end;