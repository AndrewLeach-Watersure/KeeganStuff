create view emp_incident as
select convert(datetime, '2011-02-12', 120) c_date, 'Dept. of Motor Vehicles' c_source, 'Lost vehicle operator's license due to violation points lost over 3 year period." c_notes from dual
union select convert(datetime, '2012-07-22', 120), 'Human Resources', 'On the job back injury resulting in 13 days of lost time. Employee failed to use required brace and procedures' from dual
union select convert(datetime, '2012-09-01', 120), 'Dept. of Motor Vehicles', 'Vehicles operator's license provisionally restored.' from dual