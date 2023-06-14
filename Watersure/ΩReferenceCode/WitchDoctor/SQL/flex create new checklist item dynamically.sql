declare

code varchar2(30);
chk  varchar2(8);
testcode varchar2(30) := '12640';
addcode varchar2(30) := '12641';
c	r5actchecklists%rowtype;


begin
select * into c
from r5actchecklists
where rowid = :rowid;

if c.ack_taskchecklistcode = testcode and c.ack_yes = '+' then 

r5o7.o7maxseq( code, 'TCH', '1', chk );
INSERT INTO r5actchecklists( ack_code, ack_event, ack_act, 
ack_sequence, ack_desc, ack_type, ack_uom, ack_object, 
ack_object_org, ack_taskchecklistcode)
(select code, c.ack_event, c.ack_act,
tch_sequence, tch_desc, tch_type, tch_uom, c.ack_object, 
c.ack_object_org, addcode
from r5taskchecklists where tch_code = addcode);

insert into r5descriptions
(des_entity, des_rentity, des_type, des_rtype, des_code,
des_lang, des_trans, des_text, des_org)
(select 'TCLI','TCLI','*','*', code,
'EN','+',tch_desc, c.ack_object_org
from r5taskchecklists where tch_code = addcode);

end if;
end;