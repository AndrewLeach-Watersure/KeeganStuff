declare

@dfrom	int,
@dto	int,
@ddesc	nvarchar(80),
@cmploc nvarchar(80),
@rfrom	int,
@rto	int,
@obj	nvarchar(30),
@org	nvarchar(30),
@rdesc	nvarchar(80),
@found	int
 
begin

select
@dfrom = cast(cast(cast(WOR_UDFNUM01 as int) as nvarchar) + cast(cast(WOR_UDFNUM02 as int) as nvarchar) as int),
@dto = cast(cast(cast(WOR_UDFNUM03 as int) as nvarchar) + cast(cast(WOR_UDFNUM04 as int) as nvarchar) as int),
@ddesc = dbo.repgetdesc('EN','UCOD', WOR_RPC,'REPC' , null),
@cmploc = isnull(WOR_COMPLOCATION,'x'),
@obj = evt_object,
@org = evt_object_org
from R5WOREPAIRS 
	inner join r5events on evt_code = wor_event
	inner join r5objects on evt_object = obj_code
		and evt_object_org = obj_org
--where wor_pk = 10015
where wor_sqlidentity = :rowid



declare c1 cursor for 
select LRF_REFDESC,
cast( substring(lrf_udfchar11,1,charindex('+',lrf_udfchar11)-1) + substring(lrf_udfchar11,charindex('+',lrf_udfchar11) + 1,2) as int),
cast( substring(lrf_udfchar12,1,charindex('+',lrf_udfchar12)-1) + substring(lrf_udfchar12,charindex('+',lrf_udfchar12) + 1,2) as int)
from R5OBJLINEARREF
where lrf_objcode = @obj
and lrf_objorg = @org

set @found = 0

open c1
fetch next from c1 into @rdesc, @rfrom, @rto

WHILE @@FETCH_STATUS = 0
begin

if (isnull(@dfrom,0) between  @rfrom and @rto
or isnull(@dto,0) between  @rfrom and @rto)
and upper(@rdesc) like 'GAP%'
raiserror('Error! Either the FROM marker or TO marker is in a gap',16,1)


if isnull(@dfrom,0) between  @rfrom and @rto
or isnull(@dto,0) between  @rfrom and @rto
set @found = 1
     

fetch next from c1 into @rdesc, @rfrom, @rto

end

close c1
deallocate c1

if @found <> 1
raiserror('Stimpy, you idiot! Marker not found on the section',16,1)

if @ddesc <> @cmploc
update R5WOREPAIRS set 
WOR_COMPLOCATION = @ddesc
where wor_sqlidentity = :rowid

end