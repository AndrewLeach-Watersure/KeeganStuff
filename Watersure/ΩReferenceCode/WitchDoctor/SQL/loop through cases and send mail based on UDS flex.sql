declare 
 
cursor c1 is
select distinct 
lus_city city,
lus_dept dept,
csm_responsibile_email email
from U5LUSRFS, 
r5casemanagement
where csm_class = 'MICH'
and csm_responsibile_email is not null
and U5LUSRFS.rowid = :rowid;


begin

for r in c1 loop
 
INSERT INTO R5MAILEVENTS 
(MAE_TEMPLATE, MAE_DATE, MAE_SEND, MAE_RSTATUS, MAE_PARAM1, MAE_PARAM2, 
MAE_PARAM3,MAE_PARAM4, MAE_PARAM5)
VALUES ('MILEASEREQ', SYSDATE, '-','N', r.email, r.city, 
r.dept);

end loop

exception when no_data_found then null; 
end;



This e-mail is being sent to you because you are registered...

For further information, please go to...

Thank you for your interest in...

Robert M. Burns
Director, Real Estate Division
Department of ...