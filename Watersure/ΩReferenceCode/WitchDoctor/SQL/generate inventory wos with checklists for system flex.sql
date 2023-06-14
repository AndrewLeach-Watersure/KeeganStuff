declare

p	r5projects%rowtype;
rnum	number;
lcnt	int;
its	int;
mmcnt	int;
rval	int;
cstwo VARCHAR2(30) := 'INV COND'; 
ceventno VARCHAR2(30); 
chk VARCHAR2(4);
user  VARCHAR2(30);
mindesc VARCHAR2(80);
fpnt number(24,6);
fdesc VARCHAR2(80);
tpnt number(24,6);
tdesc VARCHAR2(80);

begin
select * into p
from r5projects
where prj_preconstructionriskasmnt = '+'
and prj_class = 'INV COND'
and prj_externalpono is not null
AND ROWID = :ROWID;

select max(prv_nvalue) into rnum 
from r5propertyvalues
where prv_rentity = 'PROJ'
and prv_property = 'NUMRAND '
and prv_code = p.prj_code;

for r in (select *
from r5objects where obj_code in 
(select stc_child from r5structures where stc_parent = p.prj_externalpono)
and obj_code in ('AL0003','AL0005','AL0006','AL0022') )
loop 

select count(*) - 1, min(to_number(substr(lrf_refdesc, 13))) 
 into mmcnt, mindesc from r5objlinearref
where lrf_class = 'SIGN MM'
and lrf_objcode = R.OBJ_code;

lcnt := 1;
its := least(rnum, mmcnt);

while lcnt <= its  loop

select round(dbms_random.value(mmcnt * (lcnt - 1) / its ,(mmcnt * lcnt / its) - 1 ),0) into rval from dual;

user := O7SESS.CUR_USER;
o7crevt5(r.obj_org, 'A','A',r.obj_code,r.obj_org,r.obj_mrc, null,null,cstwo,null,user,null, ceventno,CHK); 

select max(lrf_refdesc),  max(LRF_FROMPOINT) into fdesc, fpnt from R5OBJLINEARREF
where  lrf_class = 'SIGN MM' and lrf_objcode = r.obj_code
and lrf_refdesc = 'MILE MARKER '||(mindesc + rval);

select max(lrf_refdesc),  max(LRF_FROMPOINT) into tdesc, tpnt from R5OBJLINEARREF
where  lrf_class = 'SIGN MM' and lrf_objcode = r.obj_code
and lrf_refdesc = 'MILE MARKER '||(mindesc + rval + 1);

update r5events set 
evt_desc = r.obj_code||' '||evt_desc||' '||fdesc,
evt_fromrefdesc = fdesc,
evt_frompoint = fpnt,
evt_torefdesc = tdesc,
evt_topoint = tpnt,
evt_target = p.prj_eststart,
evt_project = p.prj_code,
evt_projbud = 'INVENTORY'
where evt_code = ceventno;

lcnt := lcnt + 1;

end loop;

end loop;

UPDATE R5PROJECTS SET  prj_preconstructionriskasmnt = '-'
WHERE ROWID = :ROWID;

exception
when no_data_found then null;
end;