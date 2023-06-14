consist report query

select RDATE, cr1 "Car 1", cr2 "Car 2", cr3 "Car 3", cr4 "Car 4",
cr5 "Car 5", cr6 "Car 6", cr7 "Car 7", cr8 "Car 8", cr9 "Car 9",
cr10 "Car 10", 
case when 
LAG(isnull(c1,'x') OVER (ORDER BY RDATE) <> isnull(c1,'x')
or LAG(isnull(c2,'x') OVER (ORDER BY RDATE) <> isnull(c2,'x')
or LAG(isnull(c3,'x') OVER (ORDER BY RDATE) <> isnull(c3,'x')
or LAG(isnull(c4,'x') OVER (ORDER BY RDATE) <> isnull(c4,'x')
or LAG(isnull(c5,'x') OVER (ORDER BY RDATE) <> isnull(c5,'x')
or LAG(isnull(c6,'x') OVER (ORDER BY RDATE) <> isnull(c6,'x')
or LAG(isnull(c7,'x') OVER (ORDER BY RDATE) <> isnull(c7,'x')
or LAG(isnull(c8,'x') OVER (ORDER BY RDATE) <> isnull(c8,'x')
or LAG(isnull(c9,'x') OVER (ORDER BY RDATE) <> isnull(c9,'x')
or LAG(isnull(c10,'x') OVER (ORDER BY RDATE) <> isnull(c10,'x')
then '+' else '-' end cons_changed
from

(select 
RDATE,
c1.arc_car cr1,
c2.arc_car cr2,
c3.arc_car cr3,
c4.arc_car cr4,
c5.arc_car cr5,
c6.arc_car cr6,
c7.arc_car cr7,
c8.arc_car cr8,
c9.arc_car cr9,
c10.arc_car cr10
from 
(select distinct rdate from
(select arc_date RDATE
from U5ARROWCONSIST where dbo.repgetcompdate(arc_date)
between #prompt('SEL_START')# and #prompt('SEL_END')# 
and arc_train = #prompt('SEL_TRAIN')#
union
select max(arc_date)
from U5ARROWCONSIST 
where dbo.repgetcompdate(arc_date) <= #prompt('SEL_START')# 
and arc_train = #prompt('SEL_TRAIN')#
)) m

left outer join U5ARROWCONSIST c1 on RDATE = c1.arc_date and c1.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c2 on RDATE = c2.arc_date and c2.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c3 on RDATE = c3.arc_date and c3.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c4 on RDATE = c4.arc_date and c4.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c5 on RDATE = c5.arc_date and c5.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c6 on RDATE = c6.arc_date and c6.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c7 on RDATE = c7.arc_date and c7.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c8 on RDATE = c8.arc_date and c8.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c9 on RDATE = c9.arc_date and c9.arc_train = #prompt('SEL_TRAIN')#
left outer join U5ARROWCONSIST c10 on RDATE = c10.arc_date and c10.arc_train = #prompt('SEL_TRAIN')#
)z







select RDATE, cr1 "Car 1", cr2 "Car 2", cr3 "Car 3", cr4 "Car 4",
cr5 "Car 5", cr6 "Car 6", cr7 "Car 7", cr8 "Car 8", cr9 "Car 9",
cr10 "Car 10"
, 
case when 
isnull(LAG(cr1) OVER (ORDER BY RDATE),'x') <> isnull(cr1,'x')
or LAG(cr2) OVER (ORDER BY RDATE) <> isnull(cr2,'x')
or LAG(cr3) OVER (ORDER BY RDATE) <> isnull(cr3,'x')
or LAG(cr4) OVER (ORDER BY RDATE) <> isnull(cr4,'x')
or LAG(cr5) OVER (ORDER BY RDATE) <> isnull(cr5,'x')
or LAG(cr6) OVER (ORDER BY RDATE) <> isnull(cr6,'x')
or LAG(cr7) OVER (ORDER BY RDATE) <> isnull(cr7,'x')
or LAG(cr8) OVER (ORDER BY RDATE) <> isnull(cr8,'x')
or LAG(cr9) OVER (ORDER BY RDATE) <> isnull(cr9,'x')
or LAG(cr10) OVER (ORDER BY RDATE) <> isnull(cr10,'x')
then '+' else '-' end cons_changed 
from

(select 
RDATE,
c1.arc_car cr1,
c2.arc_car cr2,
c3.arc_car cr3,
c4.arc_car cr4,
c5.arc_car cr5,
c6.arc_car cr6,
c7.arc_car cr7,
c8.arc_car cr8,
c9.arc_car cr9,
c10.arc_car cr10
from 
(select distinct rdate from
(select arc_date RDATE
from U5ARROWCONSIST where dbo.repgetcompdate(arc_date)
between #prompt('SEL_START')# and #prompt('SEL_END')# 
and arc_train = #prompt('SEL_TRAIN')#
union
select max(arc_date)
from U5ARROWCONSIST 
where dbo.repgetcompdate(arc_date) <= #prompt('SEL_START')# 
and arc_train = #prompt('SEL_TRAIN')#
) m)y

left outer join U5ARROWCONSIST c1 on RDATE = c1.arc_date and c1.arc_train = #prompt('SEL_TRAIN')# and c1.arc_position = 1
left outer join U5ARROWCONSIST c2 on RDATE = c2.arc_date and c2.arc_train = #prompt('SEL_TRAIN')# and c2.arc_position = 2
left outer join U5ARROWCONSIST c3 on RDATE = c3.arc_date and c3.arc_train = #prompt('SEL_TRAIN')# and c3.arc_position = 3
left outer join U5ARROWCONSIST c4 on RDATE = c4.arc_date and c4.arc_train = #prompt('SEL_TRAIN')# and c4.arc_position = 4
left outer join U5ARROWCONSIST c5 on RDATE = c5.arc_date and c5.arc_train = #prompt('SEL_TRAIN')# and c5.arc_position = 5
left outer join U5ARROWCONSIST c6 on RDATE = c6.arc_date and c6.arc_train = #prompt('SEL_TRAIN')# and c6.arc_position = 6
left outer join U5ARROWCONSIST c7 on RDATE = c7.arc_date and c7.arc_train = #prompt('SEL_TRAIN')# and c7.arc_position = 7
left outer join U5ARROWCONSIST c8 on RDATE = c8.arc_date and c8.arc_train = #prompt('SEL_TRAIN')# and c8.arc_position = 8
left outer join U5ARROWCONSIST c9 on RDATE = c9.arc_date and c9.arc_train = #prompt('SEL_TRAIN')# and c9.arc_position = 9
left outer join U5ARROWCONSIST c10 on RDATE = c10.arc_date and c10.arc_train = #prompt('SEL_TRAIN')# and c10.arc_position = 10
)z







USE [AMTRAKSQL01]
GO

INSERT INTO [dbo].[U5ARROWCONSIST]
([ARC_TRAIN],[ARC_CAR],[ARC_POSITION],[ARC_CONDITION],[ARC_ORIGIN],[ARC_DEST],[ARC_LAST],[ARC_DATE],[ARC_DATE_S]
,[ARC_SCHED],[CREATEDBY],[CREATED],[UPDATEDBY],[UPDATED],[UPDATECOUNT])
VALUES('T-171', '83001', 1, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
         
GO




USE [AMTRAKSQL01]
GO

--INSERT INTO [dbo].[U5ARROWCONSIST]
--VALUES('T-171', '83001', 1, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83002', 2, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83003', 3, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83004', 4, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83005', 5, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83006', 6, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83007', 7, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83008', 8, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83009', 9, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83010', 10, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160301 12:35:00', '1603011235', '20160301 12:35:00', 'R5', null, null, null, null)

INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83001', 1, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83002', 2, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83003', 3, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83004', 4, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83005', 5, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83006', 6, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83007', 7, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83008', 8, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83009', 9, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83010', 10, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160302 12:35:00', '1603021235', '20160302 12:35:00', 'R5', null, null, null, null)

INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83001', 1, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83002', 2, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83003', 3, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83004', 4, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83005', 5, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83006', 6, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83007', 7, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83008', 8, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83009', 9, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83010', 10, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160303 12:35:00', '1603031235', '20160303 12:35:00', 'R5', null, null, null, null)

INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83001', 1, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83002', 2, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83003', 3, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83004', 4, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83005', 5, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83012', 6, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83007', 7, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83008', 8, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83009', 9, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
INSERT INTO [dbo].[U5ARROWCONSIST]
VALUES('T-171', '83010', 10, 'ICC', 'NYP-A', 'PHL-A', 'NYP-A', '20160304 12:35:00', '1603041235', '20160304 12:35:00', 'R5', null, null, null, null)
         
GO

