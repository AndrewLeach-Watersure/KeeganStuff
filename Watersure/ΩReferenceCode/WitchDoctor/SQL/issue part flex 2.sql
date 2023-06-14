declare

s  r5stores%rowtype;
o  r5objects%ROWTYPE;
b  r5objects%ROWTYPE;
ur  varchar2(30);
wo  varchar2(30);
chk  varchar2(30);
tr  varchar2(30);
org   varchar2(30) := 'MT';
avgpr  number(12,2);
acd   int;
err  varchar2(80);
ct  int;
ty  varchar2(30);
ap  varchar2(30);

begin

select * into s from r5stores where str_code = 'ZSTRZ' and str_segmentvalue = 'MT31' and rowid = :rowid;
ap := s.str_enterpriselocation;
select count(*) into ct from r5binstock where bis_part = s.str_udfchar08 and bis_store = s.str_udfchar02 
  and bis_bin = s.str_udfchar11 and ( bis_qty >= s.str_udfchar10 or ( ap is not null and abs(bis_qty) = 1)
or bis_qty < 0);
if ct = 0 then err := 'invalid store or part or bin or qty'; end if;
select count(*) into ct from r5personnel where per_code = s.str_udfchar01 and per_user is not null;
if ct = 0 then err := 'invalid employee (your code)'; end if;
select count(*) into ct from r5personnel where per_code = nvl(s.str_udfchar03,'00');
if ct = 0 then err := 'invalid issue to employee'; end if;
if ap  is not null then
  select count(*) into ct from r5objects where obj_code = ap and obj_org = org
            and obj_part = s.str_udfchar08 and 
            ((obj_bin = s.str_udfchar11 and obj_store = s.str_udfchar02 and s.str_udfchar10 = 1)
            or
            s.str_udfchar10 =  -1);
  if ct = 0 then err := 'invalid asset'; end if;
end if;
select count(*) into ct from r5objects where obj_code = s.str_udfchar05 and obj_org = org;
if ct = 0 then err := 'invalid equipment'; end if;

if err is not null then RAISE_APPLICATION_ERROR(-20001,err); end if;
  
select per_user into ur from r5personnel where per_code = s.str_udfchar01;

select * into o from r5objects where obj_code = s.str_udfchar05 and obj_org = org;
if ap  is not null then
  select * into b from r5objects where obj_code = ap and obj_org = org;
end if;
select PPR_avgprice into avgpr from r5PARTPRICES where PPR_PART = s.str_udfchar08;

r5o7.o7maxseq( wo, 'EVNT', '1', chk);

INSERT INTO r5events 
(evt_code,evt_org,evt_type,evt_rtype,evt_obtype,evt_obrtype,evt_object,evt_object_org,evt_desc,
evt_date,evt_completed,evt_status,evt_rstatus,evt_mrc,evt_duration,evt_fixed,evt_enteredby,
evt_jobtype, evt_costcode)
(select wo,org,'JOB','JOB',o.obj_obtype,o.obj_obrtype,o.obj_code,org,'Issue or Return',
sysdate, sysdate + .0001, 'C','C',o.obj_mrc,1,'V',ur,'IS',o.obj_costcode from dual);

o7creob1(wo,'JOB',o.obj_code,org,o.obj_obtype,o.obj_obrtype,chk);

r5o7.o7maxseq( tr, 'TRAN', '1', chk);

if nvl(s.str_udfchar12,'n') = 'Y' then ty := 'RR'; else ty := 'I'; end if;

INSERT INTO R5TRANSACTIONS
(TRA_CODE,TRA_DESC,TRA_TYPE,TRA_RTYPE,TRA_AUTH,TRA_DATE,TRA_STATUS,TRA_RSTATUS,                    
TRA_FROMENTITY,TRA_FROMRENTITY,TRA_FROMTYPE,TRA_FROMRTYPE,TRA_FROMCODE,TRA_TOENTITY,
TRA_TORENTITY,TRA_TOTYPE,TRA_TORTYPE,TRA_TOCODE,TRA_ORG,TRA_FROMCODE_ORG, tra_pers, tra_advice)
values (tr,'Issue',ty,ty,ur, SYSDATE,'A','A',
'STOR','STOR','*','*',s.str_udfchar02,'EVNT',  
'EVNT','*','*',wo,org,org, s.str_udfchar03, s.str_udfchar04); 

INSERT INTO R5TRANSLINES 
( TRL_TRANS,TRL_TYPE,TRL_RTYPE,TRL_LINE,TRL_DATE,TRL_COSTCODE,TRL_EVENT,TRL_PART,
TRL_LOT, TRL_BIN, TRL_STORE,                   
TRL_PRICE,TRL_QTY,TRL_IO,TRL_PART_ORG, TRL_AVGPRICE, trl_obtype, trl_obrtype, trl_object, trl_object_org, 
trl_attachto, trl_attachto_org, trl_attach)
(select tr,ty,ty,1,SYSDATE,o.obj_costcode,wo,  s.str_udfchar08,
  '*', s.str_udfchar11, s.str_udfchar02,
  avgpr,decode(b.obj_code,null,s.str_udfchar10,1),-1,'*', avgpr, b.obj_obtype, b.obj_obrtype, b.obj_code, b.obj_org, decode(b.obj_code,null,null, o.obj_code),
 decode(b.obj_code,null,null, o.obj_org),decode(b.obj_code,null,null,'+')  from dual);

select trl_acd into acd from r5translines where trl_trans = tr and trl_line = 1;
insert into r5accountdetail (acd_code, acd_accounted, acd_rentity,acd_segment1,acd_segment2)
values ( acd, 'DR', 'TRL',s.str_udfchar06,s.str_printserver);

EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
end;