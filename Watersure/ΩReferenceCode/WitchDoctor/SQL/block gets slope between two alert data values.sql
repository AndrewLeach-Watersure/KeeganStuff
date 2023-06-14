declare

prevdate  date;
prevval    number (24,6);

begin

for r in
(select a.ado_pk, a.ado_obj, a.ado_org, a.ado_udfnum01, a.ado_udfdate01
from r5alertdataobj a
where a.ado_udfchar10 = 'PdMA'
and a.ado_udfchar01 like 'Inductive Imbalance%'
and a.ado_udfnum03 is null
and  a.ado_udfdate01 = 
(select max(b.ado_udfdate01)
from r5alertdataobj b
where  b.ado_udfchar10 = 'PdMA'
and b.ado_udfchar01 like 'Inductive Imbalance%'
and a.ado_obj = b.ado_obj and a.ado_org = b.ado_org)
) loop

select max(ado_udfdate01) into prevdate
from r5alertdataobj
where ado_obj = r.ado_obj and ado_org = r.ado_org
and  ado_udfchar10 = 'PdMA'
and ado_udfchar01 like 'Inductive Imbalance%'
and ado_udfdate01 < r.ado_udfdate01;

select ado_udfnum01 into prevval
from r5alertdataobj
where ado_obj = r.ado_obj and ado_org = r.ado_org
and  ado_udfchar10 = 'PdMA'
and ado_udfchar01 like 'Inductive Imbalance%'
and ado_udfdate01 = prevdate;

update r5alertdataobj set
ado_udfnum02 = prevval,
ado_udfnum03 = (r.ado_udfnum01 - prevval) / (r.ado_udfdate01 - prevdate)
where ado_pk = r.ado_pk;

end loop;

exception
when no_data_found then null;
end;
