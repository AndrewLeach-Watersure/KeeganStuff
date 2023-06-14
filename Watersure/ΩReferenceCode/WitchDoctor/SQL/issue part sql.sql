declare

@wo  nvarchar(80),
@part nvarchar(80),
@qty nvarchar(80),
@chk nvarchar(80),
@tn int,
@avgpr  numeric(26,6)


begin

select @wo = tkd_promptdata1, @part = tkd_promptdata2,
@qty = tkd_promptdata3 from r5trackingdata
where tkd_sqlidentity = :rowid 
and tkd_trans = 'RIPW'

if @wo is not null
Begin

execute dbo.R5O7_O7MAXSEQ @tn OUTPUT, 'TRAN','1',@chk OUTPUT

	
insert into r5transactions
(tra_code,tra_desc,tra_type,tra_rtype,tra_auth,tra_date,tra_status,tra_rstatus,
tra_fromentity,tra_fromrentity,tra_fromtype,tra_fromrtype,tra_fromcode,tra_fromcode_org,
tra_toentity,tra_torentity,tra_totype,tra_tortype,tra_tocode,tra_org)
values
(@tn,'I','I','I','R5',cast(getdate() As Date),'A','A',
'STOR','STOR','*','*','MA-1','ORG1',
'EVNT','EVNT','*','*',@wo,'ORG1')

select  @avgpr = isnull(sto_avgprice,1)
from r5stock 
where sto_store = 'MA-1' 
and sto_part = @part

insert into r5translines
(trl_trans,trl_type,trl_rtype,trl_line,trl_date,trl_event,trl_act,trl_part,
trl_price,trl_qty,trl_io,trl_part_org,trl_store,trl_lot,
trl_bin)
values
(@tn,'I','I',10,cast(getdate() As Date),@wo,1,
@part, @avgpr,cast(@qty as numeric),-1,'*',
'MA-1','*', '*')

delete from r5trackingdata
where tkd_sqlidentity = :rowid 

end

end