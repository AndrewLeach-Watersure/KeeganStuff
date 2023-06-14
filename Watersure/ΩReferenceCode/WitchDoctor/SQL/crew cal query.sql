select  emp, PDATE, hrs, #prompt('DAYHRS')# - hrs remain  
from 
  ( select cre_person emp, isnull(sum(acs_hours),0) hrs, acs_sched PDATE
from r5crewemployees 
left outer join r5actschedules on acs_responsible = cre_person
where acs_sched between  convert(datetime, #prompt('SEL_START')# , 120) 
and  dateadd(mm,   #prompt('NO_MONTHS')#  + 1, convert(datetime, #prompt('SEL_START')# , 120)  )
and cre_crew = #prompt('CREW')#
and #prompt('SUN')# = '+'
group by cre_person , acs_sched
) a