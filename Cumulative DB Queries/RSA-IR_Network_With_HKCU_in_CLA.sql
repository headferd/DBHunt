--- RSA-IR_Network_With_HKCU_in_CLA --


 --DB Query 
SELECT mn.MachineName, na.FirstConnectionUTC, na.LastConnectionUTC, pn.Filename, sfn.Filename, na.Port, dom.Domain, na.IP, la.LaunchArguments ,na.UserAgent
 
FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
	INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
	INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])
	INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON [la].[PK_LaunchArguments] = [na].[FK_LaunchArguments]
WHERE
	--na.FirstConnectionUTC >= DATEADD(DAY, -3, GETUTCDATE()) AND 			-- Time
	--na.FirstConnectionUTC <= GETUTCDATE()	AND								-- Filter
	la.LaunchArguments LIKE '%HKCU%' AND
	pn.FileName NOT IN ('YoukuMediaCenter.exe', 'CompatTelRunner.exe','E_YATIJ6E.EXE')
ORDER BY
	na.FirstConnectionUTC DESC

 
 
/* IIOC Code
 SELECT DISTINCT
	[na].[FK_Machines] AS [FK_Machines],
	[na].[FK_MachineModulePaths] AS [FK_MachineModulePaths]  
 
FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])	
	INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON ([la].[PK_LaunchArguments] = [na].[FK_LaunchArguments])
	INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
WHERE
	na.FirstConnectionUTC >= DATEADD(DAY, -3, GETUTCDATE()) AND 			-- Time
	na.FirstConnectionUTC <= GETUTCDATE()	AND								-- Filter
	la.LaunchArguments LIKE '%HKCU%' AND
	pn.FileName NOT IN ('YoukuMediaCenter.exe', 'CompatTelRunner.exe','E_YATIJ6E.EXE')
*/