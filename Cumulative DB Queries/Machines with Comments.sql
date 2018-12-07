--These can be useful for building a table for the report at the end for everything you have taged in ECAT


--Machines with Comments or AdminStatus
select mn.MachineName, ADS.Description as 'Admin Status', MAI.Comment  from MachineAdminInfo as MAI
INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [MAI].[FK_Machines]
LEFT JOIN dbo.AdminStatus as ADS WITH(NOLOCK) on ADS.PK_AdminStatus = MAI.FK_AdminStatus
--where comment LIKE '%-%'
where comment != '' OR Description != ''
order by ADS.Description



--MAchines with comments or adminsttaus 
select mn.MachineName, ADS.Description as 'Admin Status', MAI.Comment  from MachineAdminInfo as MAI
INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [MAI].[FK_Machines]
LEFT JOIN dbo.AdminStatus as ADS WITH(NOLOCK) on ADS.PK_AdminStatus = MAI.FK_AdminStatus
--where comment LIKE '%-%'
where 
--comment != '' OR Description != '' 
Description IS NOT NULL
order by Comment DESC


--Machines with Comments or AdminStatus
select mn.MachineName, mn.[LocalIp], ADS.Description as 'Admin Status', MAI.Comment  
from MachineAdminInfo as MAI
INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [MAI].[FK_Machines]
LEFT JOIN dbo.AdminStatus as ADS WITH(NOLOCK) on ADS.PK_AdminStatus = MAI.FK_AdminStatus
where 
Description NOT IN ('Test','Under Investigation') AND
Description IS NOT NULL
order by Comment DESC