select 
com_code, 
com_desc, 
(select count(*) from r5orders where ord_supplier = com_code) orders,
(select count(*) from r5orders where ord_supplier = com_code and ord_due < 
  (select max(trl_date) from  r5translines where trl_order = ord_code)) late,
case when (select count(*) from r5orders where ord_supplier = com_code)= 0 then 0 else
round(((select count(*) from r5orders
  where ord_supplier = com_code and ord_due < 
  (select max(trl_date) from  r5translines where trl_order = ord_code)) /
  (select count(*) from r5orders where ord_supplier = com_code) ) * 100,0) end perlate,
(select count(*) from r5orderlines where orl_supplier = com_code) items,
(select count(*) from r5orderlines where orl_supplier = com_code and orl_price < (select
  max(trl_price) from r5translines where trl_order = orl_order and trl_ordline = orl_ordline)) itemsover

  
from r5companies