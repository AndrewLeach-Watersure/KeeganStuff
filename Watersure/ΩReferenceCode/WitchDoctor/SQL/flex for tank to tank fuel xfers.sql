r5fuelreceipts post-insert

declare
 
r r5fuelreceipts%rowtype;
cnt int;
price number(24,6);

begin

select * into r
from r5fuelreceipts
where rowid = :rowid;

select count(*) into cnt
from r5tanks
where tan_code = r.flr_supplier
and tan_udfchkbox01 = '+';

if cnt > 0 and nvl(r.flr_reference,'z') not like '%<a>%' then
 
select tan_avgprice into price
from r5tanks where tan_code = r.flr_supplier;

insert into r5fuelreceipts
(flr_tank, flr_fuel, flr_date,flr_qty, flr_price, 
flr_supplier, flr_supplier_org, flr_reference, flr_depot,
flr_depot_org)
values
(r.flr_supplier, r.flr_fuel, sysdate,r.flr_qty * -1, price,
r.flr_tank, r.flr_supplier_org, nvl(r.flr_reference,'')||'<a>',
r.flr_depot,r.flr_depot_org);

update r5fuelreceipts set flr_price = price,
flr_reference = nvl(flr_reference,'')||'<a>'
where  rowid = :rowid;

update r5tanks 
set tan_avgprice = price
where tan_code = r.flr_tank;

end if;

end;




r5tanks both insert and update

declare

t r5tanks%rowtype;
cnt int;

begin

select * into t from r5tanks where rowid = :rowid;
select count(*) into cnt
from r5companies 
where com_code = t.tan_code;


if t.tan_udfchkbox01 = '+' 
and cnt = 0 then

insert into r5companies
(com_code, com_org, com_desc, com_curr, com_lang,
com_status, com_purchasesite)
values
(t.tan_code, t.tan_depot_org, t.tan_desc ||' :: '|| t.tan_fuel,
'EUR','EN','APP','+');
 end if;

end;