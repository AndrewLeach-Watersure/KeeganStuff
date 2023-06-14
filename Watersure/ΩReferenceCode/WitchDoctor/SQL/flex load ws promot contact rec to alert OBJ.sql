declare

r r5contactrecords%rowtype;

begin
select * into r
from r5contactrecords
where rowid = :rowid
and ctr_secondaryfax = '77777';


insert into r5alertdataobj
(ado_obj, ado_org, ado_udfchar01, ado_udfchar02,
ado_udfchar03, ado_udfdate01, ado_udfdate02, ado_udfnum01,
ado_udfnum02)
values
(r.ctr_lastname, r.ctr_org, 'ProjEquipPlan', r.ctr_middlename,
r.ctr_address1, r.ctr_udfdate04, r.ctr_udfdate05, r.ctr_udfnum05,
(r.ctr_udfdate05 - r.ctr_udfdate04) + 1 );

delete from R5CUSTOMERREQUESTHISTORY 
where crh_callcentercode = r.ctr_code;

delete from 
r5contactrecords
where rowid = :rowid;

exception
when no_data_found then null;
end;