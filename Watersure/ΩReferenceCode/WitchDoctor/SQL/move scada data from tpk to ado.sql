declare

t  r5trackingdata%rowtype;
a r5alertdataobj%rowtype;
cnt int := 0;

begin

select * into t from r5trackingdata
where rowid = :rowid
and tkd_trans = 'VIBR';

select count(*) into cnt
from r5alertdataobj
where ado_udfchar01 = 'VIBR'
and ado_obj = t.tkd_promptdata2
and ado_org = t.tkd_promptdata1;

if cnt > 0 then
select * into a from r5alertdataobj
where ado_udfchar01 = 'VIBR'
and ado_obj = t.tkd_promptdata2
and ado_org = t.tkd_promptdata1
and ado_udfdate01 = ( select max(ado_udfdate01)
from r5alertdataobj
where ado_udfchar01 = 'VIBR'
and ado_obj = t.tkd_promptdata2
and ado_org = t.tkd_promptdata1);
end if;

insert into r5alertdataobj
(ado_obj, ado_org, ado_udfchar01, ado_udfnum01, ado_udfdate01, ado_udfnum02)
values
(t.tkd_promptdata2, t.tkd_promptdata1, 'VIBR', t.tkd_promptdata3, to_date(t.tkd_promptdata4, 'YYYY-MM-DD'),
nvl((t.tkd_promptdata3 - a.ado_udfnum01) / (to_date(t.tkd_promptdata4, 'YYYY-MM-DD') - a.ado_udfdate01),0)
);

delete from r5trackingdata
where rowid = :rowid;

exception
when no_data_found then null;

end;