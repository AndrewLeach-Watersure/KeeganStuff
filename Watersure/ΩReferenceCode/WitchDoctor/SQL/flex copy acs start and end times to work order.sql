declare

tstart   varchar2(10);
tend 	varchar2(10);
job 	varchar2(30);

begin

select TO_CHAR(TRUNC(acs_starttime/3600),'FM9900') || ':' ||
TO_CHAR(TRUNC(MOD(acs_starttime,3600)/60),'FM00') ,
TO_CHAR(TRUNC(acs_endtime/3600),'FM9900') || ':' ||
TO_CHAR(TRUNC(MOD(acs_endtime,3600)/60),'FM00') ,
acs_event 
into tstart, tend, job
from r5actschedules
where acs_starttime is not null
and acs_endtime is not null
and rowid = :rowid;

update r5events set evt_udfchar28 = tstart ||' to '||tend
where evt_code = job;

exception
when no_data_found
then null;

end;
    
    





SELECT 
    TO_CHAR(TRUNC(acs_starttime/3600),'FM9900') || ':' ||
    TO_CHAR(TRUNC(MOD(acs_starttime,3600)/60),'FM00') "from",
     TO_CHAR(TRUNC(acs_endtime/3600),'FM9900') || ':' ||
    TO_CHAR(TRUNC(MOD(acs_endtime,3600)/60),'FM00') "to"
    from r5actschedules
    where acs_event = '27983'