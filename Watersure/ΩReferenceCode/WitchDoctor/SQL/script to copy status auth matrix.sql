declare

ugroup varchar2(30) := 'DEMOGIS';
cnt int;

cursor c1 is
select * from r5auth
where aut_group = 'DEMOASE';

begin

for r in c1 loop
  
select count(*) into cnt from r5auth
where aut_group = ugroup
and aut_user = r.aut_user
and aut_entity = r.aut_entity
and aut_rentity =  r.aut_rentity
and aut_status = r.aut_status
and aut_statnew = r.aut_statnew
and aut_type = r.aut_type;

if cnt = 0 then

insert into r5auth
(aut_group, aut_user, aut_entity, aut_rentity, 
aut_status, aut_statnew, aut_type)
values
(ugroup, r.aut_user, r.aut_entity, r.aut_rentity, 
r.aut_status, r.aut_statnew, r.aut_type);

end if;

end loop;

end;



*************SQL****************
declare

@ugrp_to 	nvarchar(30),
@user		nvarchar(30),
@ent		nvarchar(30),
@rent		nvarchar(30),
@status		nvarchar(30),
@statnew	nvarchar(30),
@type		nvarchar(30),			
@cnt int



declare c1 cursor for 
select 
aut_user,
aut_entity,
aut_rentity,
aut_status,
aut_statnew,
aut_type
from r5auth
where aut_group = 'XXX'  --copy from group

begin

set @ugrp_to = 'ZZZ'   --copy to group



open c1
fetch next from c1 into @user, @ent, @rent, @status, @statnew, @type

	begin

	select @cnt = count(*) from r5auth
	where aut_group = @ugrp_to
	and aut_user = @user
	and aut_entity = @ent
	and aut_rentity =  @rent
	and aut_status = @status
	and aut_statnew = @statnew
	and aut_type = @type

	if @cnt = 0 
	insert into r5auth
	(aut_group, aut_user, aut_entity, aut_rentity, 
	aut_status, aut_statnew, aut_type)
	values
	(@ugrp_to, @user, @ent, @rent, 
	@status, @statnew, @type)
	     
	
	fetch next from c1 into @user, @ent, @rent, @status, @statnew, @type

	end

close c1
deallocate c1

end