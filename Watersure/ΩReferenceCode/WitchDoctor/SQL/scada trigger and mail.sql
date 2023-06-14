declare 


cstwo VARCHAR2(30) := 'SCADA'; 
ceventno VARCHAR2(30); 
chk VARCHAR2(4); 
obj VARCHAR2(80);
sdesc VARCHAR2(80);
o r5objects%rowtype;
email VARCHAR2(255);



begin 

SELECT TKD_PROMPTDATA1, TKD_PROMPTDATA2 
INTO OBJ, SDESC
FROM R5TRACKINGDATA 
WHERE TKD_TRANS = 'SCAD' 
AND ROWID = :ROWID; 

SELECT * INTO o FROM R5OBJECTS
where obj_code = obj and obj_org = 'ORG1';

select PER_EMAILADDRESS into email
from r5personnel
where per_code = o.obj_person;

o7crevt5('ORG1',o.obj_obtype,o.obj_obrtype,obj,'ORG1',o.obj_mrc, null,null,cstwo,sdesc,'R5',ceventno,CHK); 
 

IF email is not null THEN 

INSERT INTO R5MAILEVENTS 
(MAE_TEMPLATE, MAE_DATE, MAE_SEND, MAE_RSTATUS, MAE_PARAM1, MAE_PARAM2, 
MAE_PARAM3,MAE_PARAM4, MAE_PARAM5, MAE_PARAM6, MAE_PARAM7, MAE_PARAM8,
MAE_PARAM9, MAE_PARAM10, MAE_PARAM11)
VALUES ('SCADA01', SYSDATE, '-','N', email, obj||' '||o.obj_desc, 
ceventno, sdesc, null, null, null, null,
null, null, null);
END IF; 

delete from r5trackingdata where  ROWID = :ROWID;

exception when no_data_found then null; 
end;
