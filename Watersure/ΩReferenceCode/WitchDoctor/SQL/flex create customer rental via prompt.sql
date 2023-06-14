/*
Prompt 1: Title
Prompt 2: StartDate/Time   MMDDYYHH24MI
Prompt 3: EndDate/Time     MMDDYYHH24MI
Prompt 4: Equipment
Prompt 5: Equipment Org
*/
declare
t r5trackingdata%rowtype;
c_code varchar2(30);
chk varchar2(30);
status varchar2(8) := 'R';
rstatus varchar2(8) := 'R';

begin
select * into t
from r5trackingdata 
where rowid = :rowid
and tkd_trans = 'CRCR';

r5o7.o7maxseq( c_code, 'CRT', '1', chk );

insert into r5customerrentals
(crt_code, crt_org, crt_desc, crt_type, crt_rtype,
crt_status, crt_rstatus, crt_object, crt_object_org,
crt_issuedto,  crt_estimatedissuedate,
crt_estimatedreturndate)
values
(c_code, t.tkd_promptdata5, t.tkd_promptdata1, 'P','P',
status, rstatus, t.tkd_promptdata4, t.tkd_promptdata5, 'JMORTENSEN',
to_date(t.tkd_promptdata2, 'MMDDYYHH24MI'),
 to_date(t.tkd_promptdata3, 'MMDDYYHH24MI'));

exception
when no_data_found then null;
end;
