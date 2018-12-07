-- Tracking count per machine (tracking > 0)
select m.machinename, count(* ) as cnt
From (select * from WinTrackingEvents_P1 union all select * from WinTrackingEvents_p0) as wte
inner join machines as m with(nolock) on (m.pk_machines = wte.fk_machines)
inner join machineonlinestate as mo with(nolock) on (mo.fk_machines = m.pk_machines)

where
	m.MarkedAsDeleted = 0 
	group by m.MachineName
	order by cnt asc
	

-- Tracking count = 0 (List of Systems with no tracking data)
select distinct machinename, mo.connectionUTCtime 
from machines as m with(nolock)
inner join machineonlinestate as mo with(nolock) on (mo.fk_machines = m.pk_machines)

where
	m.MarkedAsDeleted = 0 and
	m.OperatingSystem like 'Microsoft%' and
	m.pk_machines not in (select wte.fk_machines 
						from (select * from WinTrackingEvents_P1 
						union all select * from WinTrackingEvents_p0)wte)
order by m.machinename