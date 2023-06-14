declare

o r5objects%rowtype;
chk varchar2(9);
ppopk varchar2(30);
cnewevnt  varchar2(30);


begin
select * into o from r5objects 
where obj_configcode is not null
and obj_obtype = 'I'
and obj_udfchkbox10 = '+'
and obj_class is not null
and rowid = :rowid;

for r in 
(select obj_code obj, obj_org org, obj_obtype otype, obj_obrtype ortype
from r5objects where obj_class = o.obj_class and  obj_udfchkbox10 = '-') 
loop

for p in 
(select egp_ppm ppm, egp_freq freq, egp_perioduom puom, egp_meter meter,  ppm_isstype, ppo_object, oud_totalusage tot, egp_metuom uom
from r5equipconfigpms inner join r5ppms on ppm_code = egp_ppm
left outer join r5ppmobjects on ppo_ppm = ppm_code and ppo_object = r.obj and ppo_object_org = r.org
left outer join r5objusagedefs on oud_object = r.obj and oud_object_org = r.org and oud_uom = egp_metuom
where egp_object = o.obj_code and egp_object_org = o.obj_org) 
loop

if p.ppo_object is null then
r5o7.o7maxseq(ppopk,'PPO','1',chk);
insert into r5ppmobjects
(ppo_pk, ppo_object, ppo_object_org, ppo_ppm, PPO_REVISION, PPO_OBTYPE, 
PPO_OBRTYPE, PPO_DUE, PPO_METUOM, PPO_METERDUE, PPO_FREQ, PPO_METER, 
PPO_ISSTYPE, PPO_FIXED, PPO_ORG, PPO_PERIODUOM, ppo_changed) values
(ppopk, r.obj, r.org, p.ppm, 0, r.otype, r.ortype, trunc(sysdate),
p.uom, decode(p.meter, null, null, p.tot), p.freq, p.meter, p.ppm_isstype,
p.ppm_isstype, r.org, p.puom, '-');

if p.ppm_isstype in ('F','V') then
o7crevt2 ( null, p.ppm, 0, ppopk, 'A', cnewevnt, chk );
end if;
  
end if;
end loop;
end loop;

update r5objects set obj_udfchkbox10 = '-' where rowid = :rowid;
exception
when no_data_found then null;
end;

