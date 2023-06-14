update r5scheduledjobs set scj_active = '+', scj_broken = '-', scj_lastrun = NULL, scj_nextrun = to_date('01/28/2015 14:05', 'MM/DD/YYYY HH24:MI') where scj_code = 36 and scj_jobname='RDRV'
