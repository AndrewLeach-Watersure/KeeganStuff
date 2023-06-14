declare

begin
for r in
(select distinct ado_obj equip, ado_org org, trunc(ado_udfdate01) day from r5alertdataobj
where ado_udfchar10 = 'Pump Feed'
and nvl(ado_udfchar35,'x') <> '+')
loop

insert into r5alertdataobj(
ado_obj, ado_org, ado_udfchar01, ado_udfdate01, 
ado_udfchar02, ado_udfnum02, ado_udfnum12, ado_udfnum22,
ado_udfchar03, ado_udfnum03, ado_udfnum13, ado_udfnum23,
ado_udfchar04, ado_udfnum04, ado_udfnum14, ado_udfnum24,
ado_udfchar05, ado_udfchar15,
ado_udfchar06, ado_udfchar16)
(select ado_obj, ado_org, 'Pump Feed Summary', r.day,
'Temp', min(ado_udfnum01), max(ado_udfnum01), avg(ado_udfnum01),
'Press', min(ado_udfnum02), max(ado_udfnum02), avg(ado_udfnum02),
'Flow', min(ado_udfnum03), max(ado_udfnum03), avg(ado_udfnum03),
'Segment' , ado_udfchar14,
'Substrate', ado_udfchar15
from r5alertdataobj
where ado_obj = r.equip
and ado_org = r.org
and trunc(ado_udfdate01) = r.day
and ado_udfchar10 = 'Pump Feed'
group by ado_obj, ado_org, ado_udfchar14, ado_udfchar15
);

update r5alertdataobj
set ado_udfchar35 = '+'
where ado_obj = r.equip
and ado_org = r.org
and trunc(ado_udfdate01) = r.day
and ado_udfchar10 = 'Pump Feed'; 

end loop;
end;

