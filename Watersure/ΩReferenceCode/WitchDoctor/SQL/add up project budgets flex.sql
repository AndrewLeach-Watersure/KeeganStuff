declare

p r5projects%rowtype;
estcost	number(24,2);


begin
select * into p
from r5projects
where rowid = :rowid;

select 
nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0) +
((nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0)) *.1)+
((nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0) +
((nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0)) *.1)) * .05)
into estcost from dual;

if nvl(p.prj_actbud,0) <> estcost then
update r5projects
set prj_estdirm =
(nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0)) *.1,
prj_esttool =
((nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0) +
((nvl(p.prj_estserv,0) +
nvl(p.prj_estlab,0) +
nvl(p.prj_esthirlab,0) +
nvl(p.prj_estmat,0)) *.1)) * .05),
prj_actbud = estcost
where rowid = :rowid;
end if;

end;

