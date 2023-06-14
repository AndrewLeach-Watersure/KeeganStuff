




r5alertdataobj post insert
create fuel issue and meter reading from upload

declare
@equip nvarchar(80),
@org nvarchar(80),
@depo nvarchar(80),
@pump nvarchar(80),
@fuel nvarchar(80),
@emp nvarchar(80),
@odouom nvarchar(80),
@fueluom nvarchar(80),
@type nvarchar(80), 
@date datetime,
@qty numeric,
@price numeric,
@distance numeric,
@read numeric,
@newread numeric,
@CHK nvarchar(80),
@uom nvarchar(80),
@cstatus nvarchar(80),
@obtype nvarchar(80)

begin

select @equip = ado_obj,
@org = ado_org,
@depo = ado_udfchar01,
@pump = ado_udfchar02,
@fuel = ado_udfchar03,
@emp = ado_udfchar04,
@odouom = ado_udfchar05,
@type = ado_udfchar06,
@date = ado_udfdate01,
@qty = ado_udfnum01,
@price = ado_udfnum02,
@distance = ado_udfnum03
from r5alertdataobj where ado_sqlidentity = :rowid

if @type = 'FUEL'
begin

select @read = oud_totalusage,
@newread = oud_totalusage + @distance,
@obtype = obj_obtype
from r5objusagedefs, r5objects
where oud_object = @equip
and oud_object_org = @org
and obj_code = @equip
and obj_org = @org
and oud_uom = @odouom

INSERT INTO r5readings ( rea_date,rea_object,    
rea_object_org, rea_obtype,  rea_obrtype,  rea_reading, rea_uom,   rea_calcuom )
values (@date,  @equip, 
@org, @obtype, @obtype, @newread, @odouom, @odouom )

UPDATE r5objusagedefs SET   
oud_totalusage   = @newread,
oud_lastreaddate = @date
WHERE oud_object = @equip
AND oud_object_org = @org
and oud_uom = @odouom

exec dbo.O7upevt3 @read, @newread, @equip, @org, @odouom, @cstatus output, @CHK output

INSERT INTO R5FUELISSUES 
( FLI_DEPOT,FLI_DEPOT_ORG,FLI_PUMP,FLI_FUEL,FLI_VEHICLE,
FLI_VEHICLE_ORG,FLI_DATE,FLI_QTY,FLI_PRICE,FLI_ISSUEDTO,
FLI_READING,FLI_DIFF,FLI_READING_UOM )
VALUES (@depo, @org, @pump, @fuel, @equip,
@org, @date, @qty, @price, @emp,
@read + @distance, @distance,  @odouom )

delete from r5alertdataobj where  ado_sqlidentity = :rowid
end
end