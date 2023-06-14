declare
a r5activities%rowtype;
chk VARCHAR2(10);


begin
select * into a from r5activities
where act_udfchar11 is not null
and rowid = :rowid;

o7cract1(a.act_event, null,a.act_udfchar11, null,null,0,
a.act_start,'R','-','-',null,null, a.act_mrc, chk);

update r5activities set act_udfchar11 = null
where rowid = :rowid;

exception
when no_data_found then null;
end;