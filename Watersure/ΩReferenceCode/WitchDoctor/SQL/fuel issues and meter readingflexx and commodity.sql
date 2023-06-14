declare

rdate  date;
qty	number(5);
cost	number(3,2);
reading number(12);
diff  number(12);
rate	number(5,4);

begin

for r in (select obj_code, obj_org, oud_totalusage
from r5objusagedefs, r5objects
where oud_object = obj_code
and oud_object_org = obj_org
and oud_uom = 'KM'
and obj_org = 'ORG1' and obj_code in ('12417','12418')
--where obj_class = '';
) loop

rdate := to_date('11/03/2014 08:16', 'MM/DD/YYYY HH24:MI');
reading := r.oud_totalusage;

while rdate <= to_date('11/03/2017 08:16', 'MM/DD/YYYY HH24:MI') loop

cost := 1.2 + round(dbms_random.value(-.1,.1),2);
rate := 
case 
when to_char(rdate, 'YYYY-MM-DD') between '2014-11-04' and '2015-11-03' then 0.125 + round(dbms_random.value(-.005,.005),4)
when to_char(rdate, 'YYYY-MM-DD') between '2015-11-04' and '2016-11-03' then 0.13 + round(dbms_random.value(-.005,.005),4)
when to_char(rdate, 'YYYY-MM-DD') between '2016-11-04' and '2017-11-03' then 0.14 + round(dbms_random.value(-.005,.005),4)
else  0.125 + round(dbms_random.value(-.005,.005),4)
end;

diff := 
case 
when (to_char(rdate, 'MM-DD') between '11-20' and '12-31') or (to_char(rdate, 'MM-DD') between '01-01' and '01-14')
	then  350 + round(dbms_random.value(-20,20),0)
else  300 + round(dbms_random.value(-20,20),0)
end;

qty := round( rate *  diff , 0);

reading := reading + diff;

insert into r5alertdataobj (ado_obj, ado_org, ado_udfchar01, ado_udfchar02, 
ado_udfchar03, ado_udfchar04, ado_udfchar05, ado_udfchar06, ado_udfchar07, 
ado_udfnum01, ado_udfnum02, ado_udfnum03)
values (
r.obj_code,	--Equipment
r.obj_org,	--Org
'FUEL',		--Record Type
'X1',		--Depot
'DIESEL',	--Fuel
'L',		--Qty UOM
'KM',		--Reading UOM
'DIESEL-TRUCK',	--Commodity
to_char( rdate, 'MM/DD/YYYY HH24:MI'),		--Date
qty,		--Qty
cost,		--Cost
reading	--Reading
);


rdate := rdate + 1;

end loop;
end loop;

end;