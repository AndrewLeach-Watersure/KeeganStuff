declare

j	r5events%rowtype;
store	varchar2(30) := 'MA-1';
cpiccode	varchar2(30);
cpicstatus	varchar2(30);
chk		varchar2(10);
cuser		varchar2(30);	

cursor c1 (job varchar2) is 
select * from r5activities
where act_event = job
and act_matlist is not null;

cursor c2 (mlist varchar2) is
select * from r5matlparts
where mlp_matlist = mlist;

begin

select * into j from r5events 
where evt_status = 'CPT'
and rowid = :rowid;

select o7sess.cur_user into cuser from dual;

for a in c1 (j.evt_code) loop

r5o7.o7maxseq( cpiccode, 'PICK', '1', chk);

INSERT INTO r5picklists(pic_code,pic_desc,
pic_event,pic_act,pic_object,pic_obtype,
pic_obrtype,pic_object_org,pic_status,
pic_rstatus,pic_required,pic_store,pic_origin)
VALUES(cpiccode,'Parts for WO '||j.evt_code||
'/'||a.act_act,j.evt_code,a.act_act,j.evt_object,
j.evt_obtype,j.evt_obrtype,j.evt_object_org,'R',
'R',greatest(j.evt_target, trunc(sysdate)),store,cuser);

for m in c2 (a.act_matlist) loop

INSERT INTO r5picklistparts( pip_picklist,pip_part,
pip_part_org,pip_qty,pip_issueqty,pip_parprice,
pip_matlist,pip_matline  )
(select cpiccode, m.mlp_part, m.mlp_part_org,
m.mlp_qty,0,nvl(sto_avgprice,0),m.mlp_matlist,m.mlp_line
from r5stock where sto_store = store and sto_part = 
m.mlp_part and sto_part_org = m.mlp_part_org);

end loop;
end loop;

if chk <> '0' then
raise_application_error(-20001, '<<< '||chk||' >>>');
end if;

update r5events set evt_status = 'WIP'
where  rowid = :rowid;

exception
when no_data_found then null;
end;