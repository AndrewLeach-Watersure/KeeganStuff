--ORG1 only

declare

wo	varchar2(30);
act	int;
part	varchar2(30);
porg	varchar2(30);
uom	varchar2(30);
wstore	varchar2(30);
pstore	varchar2(30);
need	number(26,6);
req	int;
chk	VARCHAR2( 4 );
pers	varchar2(30);
user	varchar2(30);
price	number(26,6);

begin

select
mtl_event,
mtl_act,
mlp_part,
mlp_part_org,
mlp_UOM,
mrc_store,
str_parent,
sto_qty - mlp_qty,
evt_person,
usr_code,
nvl(sto_avgprice,0)
into wo, act, part, porg, uom, wstore, pstore, need, pers, user, price

from
R5MATLPARTS
inner join R5MATLISTS on mtl_code = mlp_matlist
inner join r5events on evt_code = mtl_event
inner join r5mrcs on mrc_code = evt_mrc
inner join r5stores on str_code = mrc_store and str_parent is not null
inner join r5stock on sto_store = mrc_store and sto_part = mlp_part and sto_part_org = mlp_part_org
inner join r5personnel on per_code = evt_person
inner join r5users on usr_code = per_user

where R5MATLPARTS.rowid = :rowid
and mtl_code like 'V-%'
and mtl_org = 'ORG1'
and usr_mobile = '+';
			
if need < 0 then

o7crreq1(   req, pers, 'STOR', pstore, 'ORG1', 'STOR', wstore, null, null, user, chk);

 INSERT INTO r5requislines
     ( rql_reqline, rql_req,      rql_part,      rql_part_org,
       rql_qty,     rql_quotflag, rql_price,     rql_curr,
       rql_exch,    rql_uom,      rql_due,  	rql_type,     
       rql_rtype,   rql_rstatus,   rql_status,  rql_active,   
       rql_inspect, rql_multiply )
   VALUES
     ( 10,req,part,porg,
       abs(need),'0',price, 'AUD',
       1,uom, trunc(sysdate), 'PS',
       'PS', 'U','U','+' ,
       '-',1);
update r5requisitions set req_desc = 'Part No: '||part||' for WO: '||wo||' from '||pstore||' to '||wstore
where req_code = req;
end if;

exception
when no_data_found then null;
end;
