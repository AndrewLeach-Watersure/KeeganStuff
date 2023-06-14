declare

status varchar2(30);
odate date;
mrc  varchar2(30);

begin

select obj_status, obj_originalinstalldate, obj_mrc 
into status, odate, mrc
from r5objects where rowid =  :rowid;

if status = 'INSR' and odate is null  and mrc = 'GMP8' then
raise_application_error ( -20001, 'Install Date is required for GMP8 assets in this status !');
end if;
end;



select count(*) from r5documents
where doc_expir between
trunc(sysdate) and trunc(sysdate + 30)