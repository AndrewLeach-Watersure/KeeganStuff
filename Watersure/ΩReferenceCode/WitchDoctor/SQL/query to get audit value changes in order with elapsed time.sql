******** Oracle version ********

select 
c.ava_primaryid "Work Order", 
r5rep.repgetdesc('EN','UCOD', c.ava_from, 'EVST',null)  "From Status" ,  
( select max(ava_changed) 
  from  r5audvalues p 
  where c.ava_attribute = 1
  and c.ava_table = 'R5EVENTS'
  and c.ava_primaryid = p.ava_primaryid
  and c.ava_from = p.ava_to
  and p.ava_changed < c.ava_changed ) 
"From Date",
r5rep.repgetdesc('EN','UCOD', c.ava_to, 'EVST',null)  "To Status" , 
c.ava_changed "To Date", 
r5rep.repgetdesc('EN','USER',c.ava_modifiedby, null,null) "Modified By"
from r5audvalues c
where c.ava_attribute = 1
and c.ava_table = 'R5EVENTS'
order by ava_primaryid, ava_changed




******** SQL version ********

select 
c.ava_primaryid "Work Order", 
dbo.repgetdesc('EN','UCOD', c.ava_from, 'EVST',null)  "From Status" ,  
( select max(ava_changed) 
  from  r5audvalues p 
  where c.ava_attribute = 1
  and c.ava_table = 'R5EVENTS'
  and c.ava_primaryid = p.ava_primaryid
  and c.ava_from = p.ava_to
  and p.ava_changed < c.ava_changed ) 
"From Date",
dbo.repgetdesc('EN','UCOD', c.ava_to, 'EVST',null)  "To Status" , 
c.ava_changed "To Date", 
dbo.repgetdesc('EN','USER',c.ava_modifiedby, null,null) "Modified By"
from r5audvalues c
where c.ava_attribute = 1
and c.ava_table = 'R5EVENTS'
order by ava_primaryid, ava_changed