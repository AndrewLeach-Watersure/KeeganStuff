declare

obj		varchar2(30);
org varchar2(30);
obtype varchar2(30);
num05   number;
uom 	VARCHAR(30) := 'FOZ';
thisdate	date;

 
begin

select obj_code, obj_udfnum05, trunc(sysdate, 'MI'), 
obj_obtype, obj_org
into obj, num05, thisdate, obtype, org
from r5objects
where ROWID = :ROWID
and obj_udfnum05 is not null
and obj_primaryuom = uom;

INSERT INTO r5readings 
( rea_date,rea_object, rea_object_org, rea_obtype,  
rea_obrtype, rea_uom,   rea_calcuom, rea_diff)
values (thisdate, obj, org, obtype, 
obtype, uom, uom, num05);

update r5objects
set obj_udfnum05 = null
where ROWID = :ROWID;

EXCEPTION
	WHEN NO_DATA_FOUND THEN NULL;
	
end;