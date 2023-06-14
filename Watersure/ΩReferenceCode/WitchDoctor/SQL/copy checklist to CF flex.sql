declare

obj  varchar2(30);
org  varchar2(30);
code  varchar2(30);
nval  number(24,6);
fdesc  varchar2(80);

begin

select 
ack_object,
ack_object_org,
ack_taskchecklistcode,
ack_value,
fnd_desc
into obj, org, code, nval, fdesc
from r5actchecklists 
inner join r5objects on ack_object = obj_code and ack_object_org = obj_org
left outer join r5findings on fnd_code = ack_finding
where r5actchecklists.rowid = :rowid
and obj_class = 'VEG-TREE'
and ack_taskchecklistcode in
('10441','10442','10443')
and (ack_value is not null or ack_finding is not null);

delete from r5propertyvalues
where prv_property =
case code
when '10441' then 'TREEDBH'
when '10442' then 'TREEHIGH'
when '10443' then 'TREECOND'
end
and prv_code = obj||'#'||org;

insert into r5propertyvalues
(prv_property, prv_code, prv_seqno,prv_rentity,
prv_class, prv_class_org,prv_value,prv_nvalue)
values
(case code
when '10441' then 'TREEDBH'
when '10442' then 'TREEHIGH'
when '10443' then 'TREECOND'
end, obj||'#'||org, 1, 'OBJ', 'VEG-TREE', org,
decode(code, '10443',fdesc,null),
decode(code, '10443',null,nval) );

EXCEPTION
when NO_DATA_FOUND
then null;

end;