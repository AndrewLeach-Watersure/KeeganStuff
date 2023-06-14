
DECLARE

t	r5trackingdata%rowtype;
chk	varchar2(10);
seqno	int;
l1	int;
l2	int;
l3	int;

begin

select * into t
from r5trackingdata
where rowid = :rowid
and tkd_trans = 'LCDS';

select count(*) into l1 from R5CODESTRUCTURE
where CSR_STRLEVEL1 = t.tkd_promptdata1
and CSR_STRLEVEL2 is null
and CSR_RENTITY = 'ACT';

if l1 = 0 then


	r5o7.o7maxseq( seqno, 'CODESTRUCTURE', '1', chk );

	IF t.tkd_promptdata1 is not null then
	INSERT INTO R5CODESTRUCTURE (CSR_CODE, CSR_DESC,CSR_RENTITY,CSR_ENTITY,CSR_STRLEVEL1,
	CSR_STRLEVEL2,CSR_STRLEVEL3,CSR_STRUCTURE)
	(seqno, t.tkd_promptdata2, 'ACT','ACT',t.tkd_promptdata1,
	null,null,t.tkd_promptdata1);

end if;

select count(*) into l2 from R5CODESTRUCTURE
where CSR_STRLEVEL1 = t.tkd_promptdata1
and CSR_STRLEVEL2 = t.tkd_promptdata3
and CSR_STRLEVEL3 is null
and CSR_RENTITY = 'ACT';

if l2 = 0 then


	r5o7.o7maxseq( seqno, 'CODESTRUCTURE', '1', chk );

	INSERT INTO R5CODESTRUCTURE (CSR_CODE, CSR_DESC,CSR_RENTITY,CSR_ENTITY,CSR_STRLEVEL1,
	CSR_STRLEVEL2,CSR_STRLEVEL3,CSR_STRUCTURE)
	(seqno, t.tkd_promptdata4, 'ACT','ACT',t.tkd_promptdata1,
	 t.tkd_promptdata3,null,t.tkd_promptdata1 ||'.'||t.tkd_promptdata3);

end if;

select count(*) into l3 from R5CODESTRUCTURE
where CSR_STRLEVEL1 = t.tkd_promptdata1
and CSR_STRLEVEL2 = t.tkd_promptdata3
and CSR_STRLEVEL3 = t.tkd_promptdata5
and CSR_RENTITY = 'ACT';

if l3 = 0 then


	r5o7.o7maxseq( seqno, 'CODESTRUCTURE', '1', chk );

	INSERT INTO R5CODESTRUCTURE (CSR_CODE, CSR_DESC,CSR_RENTITY,CSR_ENTITY,CSR_STRLEVEL1,
	CSR_STRLEVEL2,CSR_STRLEVEL3,CSR_STRUCTURE)
	(seqno, t.tkd_promptdata6, 'ACT','ACT',t.tkd_promptdata1,
	 t.tkd_promptdata3,t.tkd_promptdata5,t.tkd_promptdata1 ||'.'||t.tkd_promptdata3||'.'||t.tkd_promptdata5);

end if;

delete from r5trackingdata where rowid = :rowid;

EXCEPTION
WHEN NO_DATA_FOUND THEN NULL;
end;