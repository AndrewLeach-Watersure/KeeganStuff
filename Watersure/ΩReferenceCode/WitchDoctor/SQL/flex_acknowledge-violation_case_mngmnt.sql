csm_object ||' :: '|| r5rep.repgetdesc('EN','OBJ',csm_object,null,null)

csm_location ||' :: '|| r5rep.repgetdesc('EN','OBJ',csm_location, null,null)

r5rep.repgetdesc('EN','UCOD',csm_status, 'CXST',null)

r5rep.repgetdesc('EN','UCOD',csm_casetype, 'CXTP',null)



select      csm_desc csm_desc,csm_created csm_created,csm_responsible_name csm_responsible_name,csm_assignedto_name csm_assignedto_name,csm_wo_desc csm_wo_desc,csm_udfchar05 csm_udfchar05,csm_udfchar06 agency,csm_code csm_code,csm_object ||' :: '|| r5rep.repgetdesc('EN','OBJ',csm_object,null,null) equip,csm_location ||' :: '|| r5rep.repgetdesc('EN','OBJ',csm_location, null,null) location,r5rep.repgetdesc('EN','UCOD',csm_status, 'CXST',null) status,r5rep.repgetdesc('EN','UCOD',csm_casetype, 'CXTP',null) casetype,csm_workorder csm_workorder FROM R5CASEMANAGEMENT,r5events,r5objects WHERE evt_code =  'X'  and

evt_object = obj_code and

(evt_object = csm_object

or ( evt_object &lt;&gt; csm_object and obj_location = csm_location)

) and

csm_rstatus = 'O'



declare

e	r5events%ROWTYPE;
loc	varchar2(30);
cnt	int;

begin
select * into e from r5events where rowid = :rowid;

select nvl(obj_location,'x') into loc
from r5objects where obj_code = e.evt_object;

select count(*) into cnt from r5casemanagement
where csm_rstatus = 'O'
and (e.evt_object = csm_object
	or ( e.evt_object <> csm_object 
	      and loc = nvl(csm_location,'y'))
        or  e.evt_object = nvl(csm_location,'y')
);

if nvl(e.evt_udfchkbox04 ,'-') <> '+'
and cnt > 0 
and e.evt_type = 'JOB' then
raise_application_error(-20001,'This equipment or location has an open violation');
end if;

end;


