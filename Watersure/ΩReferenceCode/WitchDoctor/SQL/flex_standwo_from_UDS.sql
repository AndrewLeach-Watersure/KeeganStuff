declare 

u	u5u5mechmet%rowtype;
o	r5objects%rowtype;

cstwo VARCHAR2(30) := 'ELECINSP'; 
ceventno VARCHAR2(30); 
chk VARCHAR2(4);
tol  numeric(20,4);
comm VARCHAR2(80) := 'Operating Voltage Anomaly Requires Response';
user  VARCHAR2(30);

begin 
select * into u from u5u5mechmet 
where rowid = :rowid;
select * into o from r5objects 
where obj_code = u.umm_object and obj_org = u.umm_org;

tol := (o.OBJ_ELECUSAGETHRESHOLD /100) * o.OBJ_UDFNUM03;

if u.umm_volt is not null
and u.umm_volt not between
o.OBJ_UDFNUM03 - tol and o.OBJ_UDFNUM03 + tol
and o.OBJ_ELECSUBMETERINTERVAL > 0 then

user := O7SESS.CUR_USER;

o7crevt5(o.obj_org,o.obj_obtype,o.obj_obrtype,o.obj_code,o.obj_org,o.obj_mrc, null,null,cstwo,null,user,ceventno,CHK); 

update r5events set 
evt_desc = comm, 
EVT_person = 'MWILSON',
evt_priority = '01'
where evt_code = ceventno; 

update  u5u5mechmet
set umm_event = ceventno
where rowid = :rowid;

end if;

exception when no_data_found then null; 
end;
