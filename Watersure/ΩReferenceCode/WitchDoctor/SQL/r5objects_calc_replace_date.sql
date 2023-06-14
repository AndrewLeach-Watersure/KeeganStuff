declare

o  r5objects%rowtype;
rd  date;

begin

select * into o from r5objects where rowid = :rowid;

if o.obj_obtype = 'B' then
if o.OBJ_FACILITYCONDITIONINDEX is not null
and o.obj_servicelife is not null then
select trunc( Sysdate  +((( o.obj_commiss + (o.obj_servicelife * 365))- sysdate) * (o.obj_facilityconditionindex/100))  ) into rd from dual;
if nvl(o.obj_udfdate04, sysdate) <> rd then
update r5objects set obj_udfdate04 = rd
where rowid = :rowid;
end if;
end if;
end if;
end;

