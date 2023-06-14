--post insert only

declare

cuser varchar2(30);

begin

select o7sess.cur_user into cuser 
from r5parts
where rowid = :rowid;


update r5parts
set par_udfcharXX = 
r5rep.repgetdesc('EN','USER', cuser,null,null)
where rowid = :rowid;

end;