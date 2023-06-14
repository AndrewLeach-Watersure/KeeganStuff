declare 

cobject VARCHAR2(30); 
cobjectorg VARCHAR2(15) := '01'; 
cmrc VARCHAR2(15) := '*'; 
cstwo VARCHAR2(30) := 'WEVT'; 
ceventno VARCHAR2(30); 
chk VARCHAR2(4); 
FEMA VARCHAR2(4); 
cnt int; 
PRJ VARCHAR2(30); 
PSTAT VARCHAR2(9); 
PCLASS VARCHAR2(20); 

CURSOR C1 IS 
SELECT OBJ_CODE 
FROM R5OBJECTS 
WHERE OBJ_CLASS = 'DISTRICT'; 

begin 

SELECT PRJ_CODE, PRJ_STATUS, PRJ_PRECONSTRUCTIONRISKASMNT 
INTO PRJ, PSTAT, FEMA 
FROM R5PROJECTS 
WHERE PRJ_CLASS = 'INCIDENT' 
AND ROWID = :ROWID; 

SELECT COUNT(*) INTO cnt 
FROM R5PROJBUDCLASSES 
WHERE PCL_PROJECT = PRJ; 

IF cnt = 0 AND PSTAT = 'O' THEN 
INSERT INTO R5PROJBUDCLASSES 
(pcl_project, pcl_projbud, pcl_amount, pcl_desc, pcl_etc ) 
VALUES 
(PRJ, 'EVENT', 1000000000, 'Weather Event',1000000000); 

FOR R IN C1 LOOP 

cobject := R.OBJ_CODE; 
o7crevt5(cobjectorg,'S','S',cobject,cobjectorg,cmrc, null,null,cstwo,null,'R5',ceventno,CHK); 

update r5events set 
evt_PROJECT = PRJ, 
EVT_PROJBUD = 'EVENT' 
where evt_code = ceventno; 

IF FEMA = '+' THEN 
INSERT INTO R5PROPERTYVALUES 
(prv_property, prv_rentity, prv_class, prv_code, prv_seqno, prv_value, prv_class_org) 
VALUES 
'FEMA', 'EVNT', 'WEVT', ceventno, 1, 'YES', '01'); 
END IF; 
END LOOP; 

end if; 

exception when no_data_found then null; 
end;
