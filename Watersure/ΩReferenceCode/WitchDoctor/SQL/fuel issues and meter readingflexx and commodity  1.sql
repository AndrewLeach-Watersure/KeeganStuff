/*  r5alertdataobj post insert
create fuel issue, meter reading, and commodity usage from upload
Richard Moore 11/2/2017
ado_udfchar01	Record Type	
ado_udfchar02	Depot	
ado_udfchar03	Fuel
ado_udfchar04	Qty UOM
ado_udfchar05	Read UOM
ado_udfchar06	Commodity
ado_udfchar07	Date
ado_udfnum01	Qty
ado_udfnum02	Cost
ado_udfnum03	Reading

ado_udfnum05	Difference or actual usage
ado_udfchar10	Ob type
ado_udfchar11	new pm status
ado_udfchar12	check
ado_udfnum06	last  */


declare

a r5alertdataobj%rowtype;

begin

select * into a from r5alertdataobj
where rowid = :rowid;

if a. ado_udfchar01 = 'FUEL' then

select oud_totalusage, 
a.ado_udfnum03 - oud_totalusage, obj_obtype 
into a.ado_udfnum06, a.ado_udfnum05, a.ado_udfchar10
from r5objusagedefs, r5objects
where oud_object = a.ado_obj
and oud_object_org = a.ado_org
and obj_code = a.ado_obj
and obj_org = a.ado_org
and oud_uom = a.ado_udfchar05;

INSERT INTO r5readings ( rea_date,rea_object,    
rea_object_org, rea_obtype,  rea_obrtype,  rea_reading, 
rea_uom,   rea_calcuom )
values (to_date(a.ado_udfchar07, 'MM/DD/YYYY HH24:MI'),  a.ado_obj, 
a.ado_org, a.ado_udfchar10, a.ado_udfchar10, a.ado_udfnum03,
a.ado_udfchar05, a.ado_udfchar05 );

UPDATE r5objusagedefs SET   
oud_totalusage   = a.ado_udfnum03,
oud_lastreaddate = to_date(a.ado_udfchar07, 'MM/DD/YYYY HH24:MI')
WHERE oud_object = a.ado_obj
AND oud_object_org = a.ado_org
and oud_uom = a.ado_udfchar05;

O7upevt3 (a.ado_udfnum06, a.ado_udfnum03, a.ado_obj, a.ado_org, a.ado_udfchar05, a.ado_udfchar11, a.ado_udfchar12);

INSERT INTO R5FUELISSUES 
( FLI_DEPOT,FLI_DEPOT_ORG,FLI_FUEL,FLI_VEHICLE,
FLI_VEHICLE_ORG,FLI_DATE,FLI_QTY,FLI_PRICE,
FLI_READING,FLI_DIFF,FLI_READING_UOM )
VALUES (a.ado_udfchar02, a.ado_org, a.ado_udfchar03, a.ado_obj,
a.ado_org, to_date(a.ado_udfchar07, 'MM/DD/YYYY HH24:MI'), a.ado_udfnum01, a.ado_udfnum02,
a.ado_udfnum03, a.ado_udfnum05, a.ado_udfchar05 );

insert into R5OBJACTUALCONSUMPTION
(OAC_OBJECT, OAC_OBJECT_ORG, OAC_COMMODITY, OAC_DATE,
OAC_USAGE, OAC_ACTUALCONSUMPTION, OAC_DESIGNUSAGEUOM,
OAC_LOADFACTOR)
values (a.ado_obj, a.ado_org, a.ado_udfchar06, trunc(to_date(a.ado_udfchar07, 'MM/DD/YYYY HH24:MI')),
a.ado_udfnum05, a.ado_udfnum01, a.ado_udfchar05, 100);

delete from r5alertdataobj where rowid = :rowid;

end if;
end;