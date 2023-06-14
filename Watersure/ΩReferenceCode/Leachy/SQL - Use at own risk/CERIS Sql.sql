SELECT #prompt('ORG')# as 'Org.'
,#prompt('PMCrit')# as 'MNT-OD-01'
,(	SELECT COUNT(EVT_CODE) FROM R5EVENTS 
		WHERE (DATEPART(mm, EVT_DUE) = #prompt('Month')# AND DATEPART(yyyy, EVT_DUE) = #prompt('Year')#) 
			AND (DATEPART(mm, EVT_COMPLETED) = #prompt('Month')# AND DATEPART(yyyy, EVT_COMPLETED) = #prompt('Year')#) 
 ) as 'MNT-OD-02'
,(	SELECT COUNT(EVT_CODE) FROM R5EVENTS 
		WHERE (DATEPART(mm, EVT_CREATED) = #prompt('Month')# AND DATEPART(yyyy, EVT_CREATED) = #prompt('Year')#) 
			AND ((DATEPART(mm, EVT_COMPLETED) < #prompt('Month')# AND DATEPART(yyyy, EVT_COMPLETED) < #prompt('Year')#) OR EVT_COMPLETED IS NULL)
) as 'MNT-OD-03'
,(	SELECT COUNT(EVT_CODE) FROM R5EVENTS 
		WHERE (DATEPART(mm, EVT_DUE) = #prompt('Month')# AND DATEPART(yyyy, EVT_DUE) = #prompt('Year')#) 
			AND EVT_PPM IS NOT NULL
) as 'MNT-OD-30'
,(	SELECT COUNT(EVT_CODE) FROM R5EVENTS 
		WHERE (DATEPART(mm, EVT_DUE) = #prompt('Month')# AND DATEPART(yyyy, EVT_DUE) = #prompt('Year')#) 
			AND EVT_PPM IS NOT NULL
) as 'MNT-OD-04'
,(	SELECT COUNT(EVT_CODE) FROM R5EVENTS 
		WHERE (DATEPART(mm, EVT_DUE) = #prompt('Month')# AND DATEPART(yyyy, EVT_DUE) = #prompt('Year')#) 
			AND (DATEPART(mm, EVT_COMPLETED) = #prompt('Month')# AND DATEPART(yyyy, EVT_COMPLETED) = #prompt('Year')#) 
) as 'MNT-OD-05'
,8760 as 'MNT-OD-06'
,8760-(	SELECT COUNT(EVT_CODE) FROM R5EVENTS 
		WHERE (DATEPART(mm, EVT_DUE) = #prompt('Month')# AND DATEPART(yyyy, EVT_DUE) = #prompt('Year')#) 
			AND (DATEPART(mm, EVT_COMPLETED) = #prompt('Month')# AND DATEPART(yyyy, EVT_COMPLETED) = #prompt('Year')#) 
) as 'MNT-OD-05'