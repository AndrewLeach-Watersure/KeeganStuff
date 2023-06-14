declare

@sys nvarchar(30),
@compl nvarchar(80),
@udf  nvarchar(80)

begin
select @sys = act_syslevel,
@compl = act_complocation,
@udf = act_udfchar10
from r5activities
where act_sqlidentity = :rowid

if @sys is not null and @compl is not null
and @udf is null
begin
	delete from R5USERDEFINEDFIELDLOVVALS
	where udl_rentity = 'ACT'
	and udl_field = 'udfchar10'

	insert into  R5USERDEFINEDFIELDLOVVALS
	(UDL_RENTITY, UDL_FIELD, UDL_CODE, UDL_DESC)
	(select 'ACT','udfchar10', epa_part, par_desc
	from r5entityparts inner join r5parts
	on par_code = epa_part and par_org = epa_part_org
	where epa_syslevel = @sys 
	and epa_partlocation = @compl)
end

end