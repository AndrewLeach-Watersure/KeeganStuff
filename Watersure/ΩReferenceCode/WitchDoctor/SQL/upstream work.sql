train screen:  osobjt



query/Inboxes

WORKUPST

select count(*) 
from r5events
        inner join U5ARROWCONSIST on arc_car = evt_object
        and arc_date = (select max(arc_date) from U5ARROWCONSIST
			where arc_car = evt_object)
inner join u5trainstop on tsp_train = arc_car
	and tsp_location = 'PHL-A'
where evt_rstatus = 'R'
and evt_type = 'PPM'



WORKUPSC


select count(*) 
from r5events
        inner join r5eventobjects on eob_event = evt_code
        and eob_obtype = 'T'
and evt_mrc = 'PHL-A'
where evt_rstatus = 'R'
and evt_type = 'JOB'