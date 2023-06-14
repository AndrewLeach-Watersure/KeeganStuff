declare

a	r5activities%rowtype;
j 	r5events%rowtype;
store	varchar2(30) := 'MA-1';
cpiccode	varchar2(30);
chk		varchar2(10);
cuser		varchar2(30);	

begin

select * into a from r5activities
where act_udfchar01 is null 
and act_matlist is not null
and act_udfchkbox01 = '+'
and rowid = :rowid;

select * into j from r5events 
where evt_code = a.act_event;

select o7sess.cur_user into cuser from dual;

r5o7.o7maxseq( cpiccode, 'PICK', '1', chk);

INSERT INTO r5picklists(pic_code,pic_desc,
pic_event,pic_act,pic_object,pic_obtype,
pic_obrtype,pic_object_org,pic_status,
pic_rstatus,pic_required,pic_store,pic_origin)
VALUES(cpiccode,'Parts for WO '||a.act_event||
'/'||a.act_act,a.act_event,a.act_act,j.evt_object,
j.evt_obtype,j.evt_obrtype,j.evt_object_org,'R',
'R',greatest(j.evt_target, trunc(sysdate)),store,cuser);

for m in (select * from r5matlparts
where mlp_matlist = a.act_matlist
and mlp_part not in (select trl_part from r5translines
where trl_event = a.act_event and trl_act = a.act_act
and trl_type = 'I')) loop

INSERT INTO r5picklistparts( pip_picklist,pip_part,
pip_part_org,pip_qty,pip_issueqty,pip_parprice,
pip_matlist,pip_matline  )
(select cpiccode, m.mlp_part, m.mlp_part_org,
m.mlp_qty,0,nvl(sto_avgprice,0),m.mlp_matlist,m.mlp_line
from r5stock where sto_store = store and sto_part = 
m.mlp_part and sto_part_org = m.mlp_part_org);

end loop;

if chk <> '0' then
raise_application_error(-20001, '<<< '||chk||' >>>');
end if;

update r5activities set 
act_udfchar01 = a.act_matlist,
act_udfchar02 = 'Awaiting Approval'
where  rowid = :rowid;

exception
when no_data_found then null;
end;


////////////////////////////

declare

job	varchar2(30);
jact	int;
status	varchar2(80);

begin

select pic_event, pic_act, 
r5rep.repgetdesc('EN','UCOD',pic_status, 'PLST',null) 
into job, jact, status
from r5picklists
inner join r5activities
on act_event = pic_event
and act_act = pic_act
where r5picklists.rowid = :rowid
and act_udfchar01 is not null
and act_udfchar02 <> 
r5rep.repgetdesc('EN','UCOD',pic_status, 'PLST',null);

update r5activities set
act_udfchar02 = status
where act_act = jact
and act_event = job;

exception
when no_data_found then null;
end;