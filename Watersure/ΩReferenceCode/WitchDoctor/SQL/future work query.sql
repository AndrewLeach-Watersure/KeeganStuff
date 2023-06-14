select ppo_ppm, PDATE,  ppo_freq,
ppo_perioduom,  ppo_org, 
ppo_object,
route, mlp_part, par_desc, par_class, mlp_qty, sto_avgprice, routeparent,
obj_class, to_char(PDATE, 'YYYY-MM') SMON, to_char(PDATE, 'Month YYYY') DMON

from 
  ( select ppo_ppm,
case ppo_perioduom 
when 'D' then ppo_due +( tp * ppo_freq) 
when  'M' then add_months(ppo_due, (tp * ppo_freq))
when  'Q' then add_months(ppo_due, (tp * ppo_freq) * 3)
when  'Y' then add_months(ppo_due, (tp * ppo_freq) * 12)
else null end PDATE,  ppo_org, 
ppo_freq,
ppo_perioduom,
ppo_object,
routeparent,
obj_class,
mlp_part, par_desc, par_class, mlp_qty, sto_avgprice
from 
(select ppo_ppm, ppo_due, ppo_freq, ppo_perioduom, ppo_org, ppo_object routeparent, obj_class, ppo_object, null route, mlp_part, par_desc, par_class, mlp_qty, sto_avgprice
from r5ppmobjects inner  join r5ppmacts on ppa_ppm = ppo_ppm and ppo_revision = ppa_revision
inner join r5objects on obj_code = ppo_object and obj_org = ppo_object_org
inner join r5matlparts on mlp_matlist = ppa_matlist
inner join r5parts on par_code = mlp_part and par_org = mlp_part_org
left outer join (select sto_part, max(sto_avgprice) sto_avgprice from r5stock group by sto_part) pz on sto_part = mlp_part
where ppo_route is null
and ppo_deactive is null 

union
select ppo_ppm, ppo_due, ppo_freq, ppo_perioduom, ppo_org, ppo_object, obj_class, rob_object, rob_route,  mlp_part, par_desc, par_class, mlp_qty, sto_avgprice
from r5ppmobjects inner join r5routobjects on rob_route = ppo_route
inner join r5objects on obj_code = ppo_object and obj_org = ppo_object_org
inner join r5ppmacts on ppa_ppm = ppo_ppm and ppo_revision = ppa_revision
inner join r5matlparts on mlp_matlist = ppa_matlist
inner join r5parts on par_code = mlp_part and par_org = mlp_part_org
left outer join (select sto_part, max(sto_avgprice) sto_avgprice from r5stock group by sto_part) pz on sto_part = mlp_part
where  ppo_deactive is null

) a,

(select 0 tp from dual union select 1 from dual union select 2  from dual union select 3  from dual union 
select 4  from dual union select 5  from dual union select 6  from dual union
select 7  from dual union select 8  from dual union select 9  from dual union
select 10  from dual union select 11  from dual union select 12  from dual union
select 13  from dual union select 14  from dual union select 15  from dual union
select 16  from dual union select 17  from dual union select 18  from dual union
select 19  from dual union select 20  from dual union select 21  from dual union 
select 22  from dual union select 23  from dual union select 24  from dual union
select 25  from dual union select 26  from dual union select 27  from dual union
select 28  from dual union select 29  from dual union select 30  from dual union
select 31  from dual union select 32  from dual union select 33  from dual union 
select 34  from dual union select 35  from dual union select 36  from dual union 
select 37  from dual union select 38  from dual union select 39  from dual union 
select 40  from dual union select 41  from dual union select 42  from dual union 
select 43  from dual union select 44  from dual union select 45  from dual union 
select 46  from dual union select 47  from dual union select 48  from dual union 
select 49  from dual union select 50  from dual union select 51  from dual union
select 52  from dual union select 53  from dual union select 54  from dual union
select 55  from dual union select 56  from dual union select 57  from dual union
select 58  from dual union select 59 from dual
 ) b


 )  c   

where r5rep.repgetcompdate(PDATE ) between  #prompt('SEL_START')#  and  #prompt('SEL_END')#  
and ( #prompt('SEL_ORG')# = '%' or ppo_org = #prompt('SEL_ORG')#)