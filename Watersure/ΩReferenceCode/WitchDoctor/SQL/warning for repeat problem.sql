declare

cb	varchar2(1);
cnt	int;
repeat_prob varchar2(30):= 'EX VIBR';
problem varchar2(30);
equip varchar2(30);

begin
select evt_udfchkbox03, nvl(evt_reqm,'x'), evt_object
into cb, problem, equip
from r5events
where rowid = :rowid;

if problem = repeat_prob and cb = '-' then

	select count(*) 
	into cnt
	from r5events
	where evt_reqm = repeat_prob
	and evt_object = equip
	and evt_target between
	sysdate - 90 and sysdate;
	
	if cnt >= 3 then
	raise_application_error(-20001, 'This defect has appeared 3 or more times in the past 90 days and it needs to be addressed – please acknowledge this message');
	end if;

end if;

end;