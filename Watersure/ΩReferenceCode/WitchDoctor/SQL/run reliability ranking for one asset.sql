declare

obj varchar2(30) := 'CMP-1'  ;
org varchar2(30)  := 'ORG1' ;
stype varchar2(30)  := 'O';
score number;
rrindex  varchar2(100);
message  varchar2(100);
chk  varchar2(30);

begin

o7calcobjrrscore( obj, org, stype, score, rrindex, message, chk);

end;


EAMNA

declare

obj varchar2(30) := 'OP1-2000'  ;
org varchar2(30)  := '450' ;
stype varchar2(30)  := 'O';
score number;
rrindex  varchar2(100);
message  varchar2(100);
chk  varchar2(30);

begin

o7calcobjrrscore( obj, org, stype, score, rrindex, message, chk);

end;




SQL VERSION

declare

@obj nvarchar(30),
@org nvarchar(30),
@stype nvarchar(30),
@score numeric(24,6),
@rrindex  nvarchar(100),
@message  nvarchar(100),
@chk  nvarchar(30)

begin

set @obj = 'OP1-2000'
set @org = '450'
set @stype = 'O'


exec dbo.o7calcobjrrscore @obj, @org, @stype, @score OUTPUT, @rrindex OUTPUT, @message OUTPUT, @chk OUTPUT

end