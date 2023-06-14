
select equipcnt + partcnt
from
(select count(*) equipcnt
from R5WARCOVERAGES
where WCV_EXPIRATIONDATE between trunc(sysdate) and trunc(sysdate + 60)
and wcv_active = '+') a,

(select count(*) partcnt
from R5WARRANTYPARTS, r5translines
where trl_part = wrp_part
and trl_part_org = wrp_part_org
and trl_date + wrp_wardays between trunc(sysdate) and trunc(sysdate + 60)
and trl_type = 'I') b



select par_code "Part", par_desc "Description", 
case 
when trl_date + wrp_wardays between trunc(sysdate) and trunc(sysdate + 30) then '30 Days'
when trl_date + wrp_wardays between trunc(sysdate) and trunc(sysdate + 60) then '60 Days'
when trl_date + wrp_wardays between trunc(sysdate) and trunc(sysdate + 90) then '90 Days'
when trl_date + wrp_wardays between trunc(sysdate) and trunc(sysdate + 180) then '180 Days'
end "Within",
trl_event "Work Order",
evt_object "Equipment",
trl_date + wrp_wardays "Expiration"
from R5WARRANTYPARTS, r5translines, r5events, r5parts
where trl_part = wrp_part
and trl_part_org = wrp_part_org
and trl_part = par_code
and trl_part_org = par_org
and trl_date + wrp_wardays between trunc(sysdate) and trunc(sysdate + 180)
and trl_type = 'I'
and trl_event = evt_code
and evt_org = #prompt('ORG')#



select 
case 
when WCV_EXPIRATIONDATE between trunc(sysdate) and trunc(sysdate + 30) then '30 Days'
when WCV_EXPIRATIONDATE between trunc(sysdate) and trunc(sysdate + 60) then '60 Days'
when WCV_EXPIRATIONDATE between trunc(sysdate) and trunc(sysdate + 90) then '90 Days'
when WCV_EXPIRATIONDATE between trunc(sysdate) and trunc(sysdate + 180) then '180 Days'
end "Expires Within",
obj_code "Equipment", obj_desc "Description"
from R5WARCOVERAGES inner join r5objects on obj_code = wcv_object and obj_org = wcv_object_org
where WCV_EXPIRATIONDATE between trunc(sysdate) and trunc(sysdate + 180)
and wcv_active = '+'
and obj_org = #prompt('ORG')#