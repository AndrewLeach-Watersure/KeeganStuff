--r5events
rolldown WOs to car children
insert 511


declare

@type	nvarchar(30),
@train	nvarchar(30),
@class	nvarchar(30),
@job	nvarchar(30),
@obj	nvarchar(30),
@org	nvarchar(30)

begin
select
@type = evt_type,
@class = obj_class,
@job = evt_code,
@train =  obj_code
from r5events inner join r5objects
	on obj_code = evt_object and obj_org = evt_object_org
where evt_sqlidentity = :rowid

if @type in ('JOB','PPM') 
and @class = 'A-TRAIN'
begin
DECLARE c1 CURSOR LOCAL STATIC FOR 
select stc_child, stc_child_org
from r5structures 
where stc_parent = @train
and stc_childtype = 'D'

OPEN c1
FETCH NEXT FROM c1 INTO @obj, @org
WHILE @@FETCH_STATUS = 0
begin
insert into r5eventobjects
(EOB_EVENT, EOB_OBTYPE, EOB_OBRTYPE, EOB_OBJECT
,EOB_LEVEL, EOB_ROLLUP, EOB_DOWNTIME, EOB_OBJECT_ORG)
values
(@job, 'D','A',@obj, 1, '+','+',@org)

FETCH NEXT FROM c1 INTO @obj, @org
end
CLOSE c1
DEALLOCATE c1
end

end

