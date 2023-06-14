declare

@act	int,
@job	nvarchar(30),
@comp	nvarchar(1),
@class	nvarchar(30),
@equip	nvarchar(30),
@desc	nvarchar(80),
@mail	nvarchar(200),
@nextact	int

begin

select @act = act_act,
@job = act_event,
@comp = act_completed,
@class = evt_class
from r5activities inner join r5events
on evt_code = act_event
where act_sqlidentity = :rowid

if @class in ('x','y' ) and @comp = '+'
and exists 
(select 1 
from r5activities
where act_act < @act
and act_event = @job
and isnull(act_completed,'-') = '-')
raiserror('Prior Activities must be completed first.',16,1)

if @class in ('x','y' ) and @comp = '+'
and exists 
(select 1 
from r5activities
where act_act > @act
and act_event = @job
and isnull(act_completed,'-') = '-'
and exists (select 1 from r5actschedules 
	where acs_activity = act_act
	and acs_event = @job)
)
begin
select @mail = max(per_emailaddress)
from r5actschedules inner join r5personnel
on per_code = acs_responsible
where acs_event = @job
and acs_activity = (select min(act_act)
from r5activity where act_event = @job
and act_act > @act)

INSERT INTO R5MAILEVENTS 
(MAE_TEMPLATE, MAE_DATE, MAE_SEND, MAE_RSTATUS, 
MAE_PARAM1, MAE_PARAM2, MAE_PARAM3,MAE_PARAM4, MAE_PARAM5, MAE_PARAM6)
values
('PREVACT', getdate(), '-','N', @mail, @job, 
@desc, @equip, @act, @nextact)
end

end

